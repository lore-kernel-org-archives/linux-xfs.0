Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7hVUg118045 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:43:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7124113D8320
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:43:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WxY0d2b4yzzboosP for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:43:22 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LnpfK-0004H1-Bp
	for xfs@oss.sgi.com; Sun, 29 Mar 2009 07:42:46 +0000
Date: Sun, 29 Mar 2009 03:42:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: validate quota log items during log recovery
Message-ID: <20090329074246.GA16402@infradead.org>
References: <20090303175427.GA20582@infradead.org>
	<20090316075407.GB19858@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316075407.GB19858@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

ping^2?

On Mon, Mar 16, 2009 at 03:54:07AM -0400, Christoph Hellwig wrote:
> ping?
> 
> On Tue, Mar 03, 2009 at 12:54:27PM -0500, Christoph Hellwig wrote:
> > Arkadiusz has been seeing really strange crashes in xfs_qm_dqcheck that
> > I can only explain by a log item beeing too smal to actually fit the
> > xfs_dqblk_t we're dereferencing all over xfs_qm_dqcheck.  So add
> > graceful checks for NULL or too small quota items to the log recovery
> > code.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: xfs/fs/xfs/xfs_log_recover.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_log_recover.c	2009-03-02 04:15:11.410430892 +0100
> > +++ xfs/fs/xfs/xfs_log_recover.c	2009-03-02 04:16:29.649444226 +0100
> > @@ -1975,16 +1975,26 @@ xlog_recover_do_reg_buffer(
> >  		error = 0;
> >  		if (buf_f->blf_flags &
> >  		   (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
> > +			if (item->ri_buf[i].i_addr == NULL ||
> > +			    item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
> > +				cmn_err(CE_ALERT,
> > +	"XFS: dquot too small (%d) in xlog_recover_do_reg_buffer.",
> > +						item->ri_buf[i].i_len);
> > +				goto next;
> > +			}
> >  			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
> >  					       item->ri_buf[i].i_addr,
> >  					       -1, 0, XFS_QMOPT_DOWARN,
> >  					       "dquot_buf_recover");
> > +			if (error)
> > +				goto next;
> >  		}
> > -		if (!error)
> > -			memcpy(xfs_buf_offset(bp,
> > -				(uint)bit << XFS_BLI_SHIFT),	/* dest */
> > -				item->ri_buf[i].i_addr,		/* source */
> > -				nbits<<XFS_BLI_SHIFT);		/* length */
> > +
> > +		memcpy(xfs_buf_offset(bp,
> > +			(uint)bit << XFS_BLI_SHIFT),	/* dest */
> > +			item->ri_buf[i].i_addr,		/* source */
> > +			nbits<<XFS_BLI_SHIFT);		/* length */
> > + next:
> >  		i++;
> >  		bit += nbits;
> >  	}
> > @@ -2615,7 +2625,15 @@ xlog_recover_do_dquot_trans(
> >  		return (0);
> >  
> >  	recddq = (xfs_disk_dquot_t *)item->ri_buf[1].i_addr;
> > -	ASSERT(recddq);
> > +
> > +	if (item->ri_buf[1].i_addr == NULL ||
> > +	    item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
> > +		cmn_err(CE_ALERT,
> > +	"XFS: dquot too small (%d) in xlog_recover_do_dquot_trans.",
> > +			item->ri_buf[1].i_len);
> > +		return XFS_ERROR(EIO);
> > +	}
> > +
> >  	/*
> >  	 * This type of quotas was turned off, so ignore this record.
> >  	 */
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
