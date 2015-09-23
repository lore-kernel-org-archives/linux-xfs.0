Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9BD5F7F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 08:22:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BA9A304032
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 06:22:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YfUxqec39ThJdPOw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2015 06:22:02 -0700 (PDT)
Date: Wed, 23 Sep 2015 09:22:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 03/12] libxfs: don't hardcode cycle 1 into unmount op
	header
Message-ID: <20150923132200.GC37210@bfoster.bfoster>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-4-git-send-email-bfoster@redhat.com>
	<20150923034844.GS3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923034844.GS3902@dastard>
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

On Wed, Sep 23, 2015 at 01:48:44PM +1000, Dave Chinner wrote:
> On Fri, Sep 11, 2015 at 02:55:33PM -0400, Brian Foster wrote:
> > The libxfs helper to write a log record after zeroing the log fills much
> > of the record header and unmount record with dummy data. It also
> > hardcodes the cycle number into the transaction oh_tid field as the
> > kernel expects to find the cycle stamped at the top of each block and
> > the original oh_tid value packed into h_cycle_data of the record header.
> > 
> > The log clearing code requires the ability to format the log to an
> > arbitrary cycle number to fix v5 superblock log recovery ordering
> > problems. As a result, the unmount record helper must not hardcode a
> > cycle of 1.
> > 
> > Fix up libxfs_log_header() to pack the unmount record appropriately, as
> > is already done for extra blocks that might exist beyond the record. Use
> > h_cycle_data for the original 32-bit word of the log record data block
> > and stamp the cycle number in its place. This allows unmount_record() to
> > work for arbitrary cycle numbers and libxfs_log_header() to pack a cycle
> > value that matches the lsn used in the record header. Note that this
> > patch does not change behavior as the lsn is still hardcoded to (1:0).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  libxfs/rdwr.c | 23 ++++++++++++++++-------
> >  1 file changed, 16 insertions(+), 7 deletions(-)
> > 
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index bc77699..ef18749 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -122,7 +122,7 @@ static void unmount_record(void *p)
> >  	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
> >  
> >  	memset(p, 0, BBSIZE);
> > -	op->oh_tid = cpu_to_be32(1);
> > +	op->oh_tid = cpu_to_be32(0xb0c0d0d0);
> >  	op->oh_len = cpu_to_be32(sizeof(magic));
> >  	op->oh_clientid = XFS_LOG;
> >  	op->oh_flags = XLOG_UNMOUNT_TRANS;
> > @@ -188,10 +188,6 @@ libxfs_log_header(
> >  
> >  	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
> >  
> > -	/* note that oh_tid actually contains the cycle number
> > -	 * and the tid is stored in h_cycle_data[0] - that's the
> > -	 * way things end up on disk.
> > -	 */
> 
> This note needs to be hoisted up to the  setting of op->oh_tid to
> explain the magic number being used...
> 

This requires that I understand what the magic number being used
actually means. Any ideas? ;)

I just assumed it was a dummy tid value. The comment removed above just
explains why that value is being put where it is (cycle value in oh_tid
and tid value in h_cycle_data) as the original code implicitly
implements the cycle data packing. That is undone by this patch. The
packing is now done explicitly (with its own comments) in the caller and
thus the original comment is irrelevant.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
