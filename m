Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AE317F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:47:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A93C304039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:47:41 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id BCAyGeQkI9D86iw5 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:47:39 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHS00M9ELFD1100@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 07 Jan 2015 14:47:37 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004801d02670$79bd5bf0$6d3813d0$@samsung.com>
	<20150106181309.GH5874@bfoster.bfoster>
In-reply-to: <20150106181309.GH5874@bfoster.bfoster>
Subject: RE: [PATCH v7 10/11] xfstests: fsstress: Add fallocate insert range
	operation
Date: Wed, 07 Jan 2015 14:47:37 +0900
Message-id: <001801d02a3d$7125aad0$53710070$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> 
> On Fri, Jan 02, 2015 at 06:42:51PM +0900, Namjae Jeon wrote:
> > This commit adds insert operation support for fsstress, which is
> > meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> 
> It might be nice to avoid setting FALLOC_FL_KEEP_SIZE for insert and
> collapse ops alike (see the only use of KEEP_SIZE in fsstress.c) to
> increase the likelihood of valid fallocate() calls. We currently set it
> randomly, but unconditionally across all fallocate ops.
> 
> That could be done in a separate patch, however, and this looks good to
> me:
Thank you! I will share a separate patch.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  ltp/fsstress.c | 19 ++++++++++++++++---
> >  src/global.h   |  4 ++++
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index b56fe5c..aa3e0c3 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -72,6 +72,7 @@ typedef enum {
> >  	OP_PUNCH,
> >  	OP_ZERO,
> >  	OP_COLLAPSE,
> > +	OP_INSERT,
> >  	OP_READ,
> >  	OP_READLINK,
> >  	OP_RENAME,
> > @@ -170,6 +171,7 @@ void	mknod_f(int, long);
> >  void	punch_f(int, long);
> >  void	zero_f(int, long);
> >  void	collapse_f(int, long);
> > +void	insert_f(int, long);
> >  void	read_f(int, long);
> >  void	readlink_f(int, long);
> >  void	rename_f(int, long);
> > @@ -209,6 +211,7 @@ opdesc_t	ops[] = {
> >  	{ OP_PUNCH, "punch", punch_f, 1, 1 },
> >  	{ OP_ZERO, "zero", zero_f, 1, 1 },
> >  	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
> > +	{ OP_INSERT, "insert", insert_f, 1, 1 },
> >  	{ OP_READ, "read", read_f, 1, 0 },
> >  	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
> >  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> > @@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
> >  	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
> >  	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
> >  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
> > +	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
> >  	{ -1, NULL}
> >  };
> >
> > @@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
> >  	off %= maxfsize;
> >  	len = (off64_t)(random() % (1024 * 1024));
> >  	/*
> > -	 * Collapse range requires off and len to be block aligned, make it
> > -	 * more likely to be the case.
> > +	 * Collapse/insert range requires off and len to be block aligned,
> > +	 * make it more likely to be the case.
> >  	 */
> > -	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
> > +	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
> > +		(opno % 2)) {
> >  		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  	}
> > @@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
> >  }
> >
> >  void
> > +insert_f(int opno, long r)
> > +{
> > +#ifdef HAVE_LINUX_FALLOC_H
> > +	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
> > +#endif
> > +}
> > +
> > +void
> >  read_f(int opno, long r)
> >  {
> >  	char		*buf;
> > diff --git a/src/global.h b/src/global.h
> > index 8180f66..f63246b 100644
> > --- a/src/global.h
> > +++ b/src/global.h
> > @@ -172,6 +172,10 @@
> >  #define FALLOC_FL_ZERO_RANGE		0x10
> >  #endif
> >
> > +#ifndef FALLOC_FL_INSERT_RANGE
> > +#define FALLOC_FL_INSERT_RANGE		0x20
> > +#endif
> > +
> >  #endif /* HAVE_LINUX_FALLOC_H */
> >
> >  #endif /* GLOBAL_H */
> > --
> > 1.7.11-rc0
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
