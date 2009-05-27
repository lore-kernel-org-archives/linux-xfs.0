Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4R9HMCQ185700 for <xfs@oss.sgi.com>; Wed, 27 May 2009 04:17:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C95F2B1550
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 02:17:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id glRPdJpiKqjAgUtq for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 02:17:35 -0700 (PDT)
Date: Wed, 27 May 2009 05:17:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: validate quota log items during log recovery
Message-ID: <20090527091734.GA21958@infradead.org>
References: <20090303175427.GA20582@infradead.org>
	<4A1C13DC.5000605@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1C13DC.5000605@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, May 26, 2009 at 11:07:56AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > Arkadiusz has been seeing really strange crashes in xfs_qm_dqcheck that
> > I can only explain by a log item beeing too smal to actually fit the
>                                  ^^being too small^^

Thanks, corrected.

> > +			if (item->ri_buf[i].i_addr == NULL ||
> > +			    item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
> > +				cmn_err(CE_ALERT,
> > +	"XFS: dquot too small (%d) in xlog_recover_do_reg_buffer.",
> > +						item->ri_buf[i].i_len);
> 
> Shouldn't this differentiate between i_addr == NULL and i_len too small,
> though?  While we're at it anyway...
> 
> Maybe:

I've split both into individual checks and used __func__ to print
the function instead of hardconding it.

> >  			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
> >  					       item->ri_buf[i].i_addr,
> >  					       -1, 0, XFS_QMOPT_DOWARN,
> >  					       "dquot_buf_recover");
> > +			if (error)
> > +				goto next;
> 
> I guess we can't do much else, but what happens in the end, when we skip
> a buffer...

Yeah, same action a a xfs_qm_dqcheck failure.  Error handling here
probably wants to be revisited, but that should be a separate patch.


Updated patch below:


Subject: xfs: validate quota log items during log recovery
From: Christoph Hellwig <hch@lst.de>

Arkadiusz has seen really strange crashes in xfs_qm_dqcheck that
I can only explain by a log item being too smal to actually fit the
xfs_dqblk_t we're dereferencing all over xfs_qm_dqcheck.  So add
graceful checks for NULL or too small quota items to the log recovery
code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-05-27 10:40:03.752821404 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2009-05-27 10:43:23.740939498 +0200
@@ -1975,16 +1975,30 @@ xlog_recover_do_reg_buffer(
 		error = 0;
 		if (buf_f->blf_flags &
 		   (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
+			if (item->ri_buf[i].i_addr == NULL) {
+				cmn_err(CE_ALERT,
+					"XFS: NULL dquot in %s.", __func__);
+				goto next;
+			}
+			if (item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
+				cmn_err(CE_ALERT,
+					"XFS: dquot too small (%d) in %s.",
+					item->ri_buf[i].i_len, __func__);
+				goto next;
+			}
 			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
 					       item->ri_buf[i].i_addr,
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
+			if (error)
+				goto next;
 		}
-		if (!error)
-			memcpy(xfs_buf_offset(bp,
-				(uint)bit << XFS_BLI_SHIFT),	/* dest */
-				item->ri_buf[i].i_addr,		/* source */
-				nbits<<XFS_BLI_SHIFT);		/* length */
+
+		memcpy(xfs_buf_offset(bp,
+			(uint)bit << XFS_BLI_SHIFT),	/* dest */
+			item->ri_buf[i].i_addr,		/* source */
+			nbits<<XFS_BLI_SHIFT);		/* length */
+ next:
 		i++;
 		bit += nbits;
 	}
@@ -2615,7 +2629,19 @@ xlog_recover_do_dquot_trans(
 		return (0);
 
 	recddq = (xfs_disk_dquot_t *)item->ri_buf[1].i_addr;
-	ASSERT(recddq);
+
+	if (item->ri_buf[1].i_addr == NULL) {
+		cmn_err(CE_ALERT,
+			"XFS: NULL dquot in %s.", __func__);
+		return XFS_ERROR(EIO);
+	}
+	if (item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
+		cmn_err(CE_ALERT,
+			"XFS: dquot too small (%d) in %s.",
+			item->ri_buf[1].i_len, __func__);
+		return XFS_ERROR(EIO);
+	}
+
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
