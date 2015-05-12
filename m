Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB22A7F3F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 01:36:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0C21304032
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 23:36:36 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id SfgbZpz2wETvVPKS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 23:36:34 -0700 (PDT)
Date: Tue, 12 May 2015 08:36:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] xfs: saner xfs_trans_commit interface
Message-ID: <20150512063632.GA25562@lst.de>
References: <1431285519-7768-1-git-send-email-hch@lst.de>
	<1431285519-7768-4-git-send-email-hch@lst.de>
	<20150511203237.GA59885@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150511203237.GA59885@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, May 11, 2015 at 04:32:37PM -0400, Brian Foster wrote:
> >  	xfs_trans_unreserve_and_mod_dquots(tp);
> >  	if (tp->t_ticket) {
> > +		int			log_flags = 0;
> > +
> > +		if (regrant) {
> > +			ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +			log_flags = XFS_LOG_REL_PERM_RESERV;
> > +		}
> 
> Is the regrant logic here and in xfs_log_commit_cil() backwards or am I
> misreading?

Yes, it's actually wrong, but fixed up by the next patch.

I'll wait for more review feedback and will resend a fixed version.

p.s. can you please properly quote when replying?  I had to trim over 600 lines
to get to your two line comment..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
