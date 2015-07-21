Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 144367F92
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 11:54:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9192BAC00D
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 09:54:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PXi0uRTMsSx0vQus (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 09:54:21 -0700 (PDT)
Date: Tue, 21 Jul 2015 12:13:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: checksum log record ext headers based on record size
Message-ID: <20150721161319.GH23013@bfoster.bfoster>
References: <1437413288-29329-1-git-send-email-bfoster@redhat.com>
	<20150720230219.GW7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150720230219.GW7943@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 21, 2015 at 09:02:19AM +1000, Dave Chinner wrote:
> On Mon, Jul 20, 2015 at 01:28:08PM -0400, Brian Foster wrote:
> > The first 4 bytes of every basic block in the physical log is stamped
> > with the current lsn. To support this mechanism, the log record header
> > (first block of each new log record) contains space for the original
> > first byte of each log record block before it is replaced with the lsn.
> > The log record header has space for 32k worth of blocks. The version 2
> > log adds new extended record headers for each additional 32k worth of
> > blocks beyond what is supported by the record header.
> > 
> > The log record checksum incorporates the log record header, the extended
> > headers and the record payload. xlog_cksum() checksums the extended
> > headers based on log->l_iclog_heads, which specifies the number of
> > extended headers in a log record based on the log buffer size mount
> > option. The log buffer size is variable, however, and thus means the
> > checksum can be calculated differently based on how a filesystem is
> > mounted. This is problematic if a filesystem crashes and recovery occurs
> > on a subsequent mount using a different log buffer size. For example,
> > crash an active filesystem that is mounted with the default (32k)
> > logbsize, attempt remount/recovery using '-o logbsize=64k' and the mount
> > fails on or warns about log checksum failures.
> > 
> > To avoid this problem, update xlog_cksum() to calculate the checksum
> > based on the size of the log buffer according to the log record. The
> > size is already included in the h_size field of the log record header
> > and thus is available at log recovery time. Extended log record headers
> > are also only written when the log record is large enough to require
> > them. This makes checksum calculation of log records consistent with the
> > extended record header mechanism as well as how on-disk records are
> > checksummed with various log buffer size mount options.
> 
> Hmmm - I thought that case was handled, but I guess not...
> 
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1652,8 +1652,13 @@ xlog_cksum(
> >  	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> >  		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
> >  		int		i;
> > +		int		xheads;
> >  
> > -		for (i = 1; i < log->l_iclog_heads; i++) {
> > +		xheads = size / XLOG_HEADER_CYCLE_SIZE;
> > +		if (size % XLOG_HEADER_CYCLE_SIZE)
> > +			xheads++;
> > +
> > +		for (i = 1; i < xheads; i++) {
> >  			crc = crc32c(crc, &xhdr[i].hic_xheader,
> >  				     sizeof(struct xlog_rec_ext_header));
> >  		}
> 
> rhead->h_len is an untrusted value during log recovery. i.e. at this
> point we haven't validated that the record size is within the sane
> range. See xlog_valid_rec_header() - it only checks that 0 <
> rhead->h_len < INT_MAX. Realistically, this should be checking that
> it is no more than:
> 
> 	(XLOG_MAX_RECORD_BSIZE / XLOG_HEADER_CYCLE_SIZE) + 1
> 
> as it is now being used as an array index into a dynamically
> allocated buffer....
> 

Indeed, this looks unsafe. Note that h_len is already being used as an
index into the record data buffer for the payload crc check and data
unpack, so I don't think this patch necessarily introduces the problem.

Given that the problem already exists, we probably want to protect
access to both the record header and data buffers, and we also don't
seem to validate h_size anywhere, I'll try to address this in a separate
patch. I think I have a way to handle this in xlog_valid_rec_header()...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
