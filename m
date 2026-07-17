Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B3374A06
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 03:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258468; cv=pass; b=qdj8JBXatwFrjiAxeDjyGzWJFy9ejvcMuX6Bpxyge911O/jOu+V3jbw5wg6fg6uNSy9usPGJAnb8H0XQrHQjIhA9a0Y7t/sFXQkXfhOBST2ih8Gdgf1NhHDQR3FAK72fp8dVKkThWTmJD6AQcnYkJFk8k6rpydvfo2HINpndLZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258468; c=relaxed/simple;
	bh=usCms6HFsqslX7H5/CJoC44qOxf3skUlrSgpikVpEf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHr7wwzZHnlXp7YwRAq0+W8BGlOXbzAtMXpbtzAwcq/hD2QYFlFZkx2tticHve5VGOIjLiNmYH5ij9cWS2WcgjkKM4J0DjLK4UEapqkYH2Qz4S3Is5AO1jsqzhSjpNrlgrkMtUBn/67Z+7ZlxMF02293Zv0jiNWjbKaHcryyZvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/7NeKqe; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/7NeKqe"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c1670dad7a8so540502666b.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 20:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784258463; cv=none;
        d=google.com; s=arc-20260327;
        b=oVm/34rDMKahwgzYBGgzkrGZny+9ZnOjd8UMs4yOdjcqjvnIBS9g32DFXANxPvFP9S
         Ben3JVGBfrQ6a7XHdJUdoeyOnjcjQAFXcYT+qeXu2DRV5JV43oWIwVBvvx9pGIEZl6Xp
         NQPSRfNk1Jx3FTAWj6mVepZQwP1Tm98mKeT9/C5UuHtr2O0TRBCDBYDmf2ILjRgcWNCy
         ZubGKBq0RqCUEaS7X5V9TjgRS5cffxdny9Lv9GDfWQBBz3xgmcq9wd9dqaqxxXn/Fb4K
         8fh/LM6hgR89oHYSjCJtNvrGSmT46nkWRh2VhnqXuHymp+JDsXPWL40qM5ZdAUaYzGRF
         FHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wk3lS/5z7nIGLi1N0bsa6IGd3pVlr+OoSMsYzN7yd9U=;
        fh=Ch+rVJSHYspE3pxGPO87TbDsk7QAQH7DIXPurBtoXs0=;
        b=FFLlsK6elxXNO7r8I8rL5ipiQePU0jsDQNkPodnMkxxZeAg6/DTSh+aqjvCDJnw1db
         svS2wJlwmctTlI8Y8IiWT9DqaiSnaA84L7jPHz/Za4dJ9WOr8OuvMyKX/TILyUsjkvfx
         HerSPnvpRw6VyEDU/TdGO05EW/rGZqncnHeI93/f/eu6VO9sDr9Hzz8jUlkLnASmNgN/
         gpcFLJzqGdlcPqvHnqcpWBlgvB7orQbps47qnuXE90RZ3uF/DZjiWw9ocVs6q3FwIcg+
         U8KOjYemr4QgisOlduL3rbSC4qP0Ihbb2A3Aj9s0Ppd/1MFA0Jj0Pm6zImyoX6nXDbG7
         qIfg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784258463; x=1784863263; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wk3lS/5z7nIGLi1N0bsa6IGd3pVlr+OoSMsYzN7yd9U=;
        b=H/7NeKqeYgGdmKEvG87aNRE2RwpjVYIHm7j0aUDRqLDA+hAtjg4+SccR6M1imWhC3E
         cZiZGEuNrya1iDVnIJMw2kZw9WG4+fYxDBVtqB2i7NeCsRSSBl8UOUbtVRcYnQ3ZZN8G
         md5F96pvaruug1IdGWKFmuKsrrfWQU+pi/gZn6zJ9eeiKkdYJYL/RzjUUKiE0ikf6MJG
         mIUMxdRI55KoZkIVedQ2YlgrUI6+75DFfNSSKv7Khx6Mzs49Jovfu3h9/fIGnOEWeKPN
         sewTD50YP0B2mvYOKB8Xb1Jd2SEy5wAXMDADM2QmodriEWxbS4dFbB4cs6uc3sTJ/2Jv
         Q0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784258463; x=1784863263;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wk3lS/5z7nIGLi1N0bsa6IGd3pVlr+OoSMsYzN7yd9U=;
        b=CbyvLWJsgfnzYDCHksGAVmrIZk1raysEKG6ewyL/Br75cLMyfcmDc5VhFFqN83a2E2
         mMnXSwdiPDDzw9s2veNS3rPRMVlThrNXjAuo2JP/nt7h6RpB6lUzIlciWRX0DuO/mDlp
         T0SvdOuL6Yp2eUelEGr91tqZseQQFg8CCRS4ucp/JXFnDc7fi0Ou7hr1IO2NSo4eAE5P
         3rsk8EPf+A/A30UbNQ/L9WJRY2LplTjhyC7oZjF/GicXC78Lj0lLIFQzokc7uaxfpi6Z
         j6fjW6rfje5EpugrOfXa23bjGbdR0ldMsc/XNi/4RndApXPFRC9dIFfmm7S5SVyTnitM
         M6zA==
X-Forwarded-Encrypted: i=1; AHgh+Rpz0ea3mmglpNDuckeQDSCFognhoVVWvJhNtemjsLXTdDyPIWzuqtyt5HOAereY4Zc+HY9e0fsSmuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoAoDBdfAn2o+9BRg44DKezk3CAu6O0kOJQxnHE2acTUMnXEZu
	e2nivvrVLUzgBkDUwP1h8SgUrXxXdwb+5lr7C1u1wRE/V9JXbU5C7i/M+Cl+CHrhSlB+1OF9fEU
	QAg98pmFxqv6X+IQEfoGgZh5WJfUuvco=
X-Gm-Gg: AfdE7clcHQq35gYlgLEhTfMidahSP696oE+fozhqyMjxTM2ANGgM5XA0ySUh5yvmQGQ
	yxK1ZMKIzSEYuhCV9F2CoWdcohWbyW6c8/KDWemRoN1E03XvOPibgcsC5xbZq4v9ZrP2qzHnLzF
	3i20OEpUNKLoimrzPO9qpt2QdsPGFuug9e8IYa9mA1umzPSFbGQp7WmOx/GJhEftv/3INq/waJO
	UTLWeJfjL2fwndXWeRVJ2Mu5/TXv5gK1E5aIhCFGmZxOgy0TE4K5xgirhwr/B+e5LSvRppKbcdd
	6Vs03I7+LcId/9l7WA==
X-Received: by 2002:a17:907:6d09:b0:c15:fc9d:cf3c with SMTP id
 a640c23a62f3a-c16b48c1139mr21555466b.42.1784258463163; Thu, 16 Jul 2026
 20:21:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716174813.3627911-1-bestswngs@gmail.com> <allVuuJJjZb1jfBJ@dread>
In-Reply-To: <allVuuJJjZb1jfBJ@dread>
From: Weiming Shi <bestswngs@gmail.com>
Date: Fri, 17 Jul 2026 11:20:24 +0800
X-Gm-Features: AUfX_myh44fmYwHHqBN82C2XRrmYQBIofatqe4QE7uTSWGUC81vUYsyAobxwgJ8
Message-ID: <CANgPUi17gbj6nh9Brsq4G9BqD6=-nvQX0MR6YXN4TCLELyVYCg@mail.gmail.com>
Subject: Re: [PATCH] xfs: validate inode log item regions during recovery
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xmei5@asu.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <dgc@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=94 06:05=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jul 16, 2026 at 10:48:12AM -0700, Weiming Shi wrote:
> > xlog_recover_inode_commit_pass2() replays an XFS_LI_INODE item straight
> > out of the log: it dereferences ri_buf[1] as the log dinode and copies =
the
> > data and attr forks from ri_buf[2]/ri_buf[attr_index], but never checks
> > that those regions were logged or that the dinode geometry agrees with =
the
> > mount. ri_buf is sized by the item's ilf_size, bounded only to
> > [1, XLOG_MAX_REGIONS_IN_ITEM]; the number of regions actually filled in
> > (ri_cnt) and the fork copies are guarded only by ASSERT()s, which compi=
le
> > out in production.
> >
> > A crafted image mounted for log recovery can thus hit a NULL dereferenc=
e of
> > an absent region, an out-of-bounds read from a di_version or di_forkoff
> > that disagrees with the mount, or an overflow of the inode fork by an
> > oversized local or extent region. An item declaring a second region tha=
t
> > is never logged faults on the log dinode:
> >
> >  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> >  RIP: xlog_recover_inode_commit_pass2 (fs/xfs/xfs_inode_item_recover.c:=
370)
> >  Call Trace:
> >   xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:2011)
> >   xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2078)
> >   xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2328)
> >   xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2502)
> >   xlog_recover (fs/xfs/xfs_log_recover.c:3486)
> >   xfs_log_mount (fs/xfs/xfs_log.c:667)
> >   xfs_mountfs (fs/xfs/xfs_mount.c:1039)
> >   xfs_fs_fill_super (fs/xfs/xfs_super.c:1965)
> >   get_tree_bdev_flags (fs/super.c:1680)
> >   vfs_get_tree (fs/super.c:1803)
> >   __x64_sys_mount (fs/namespace.c:4433)
> >
> > Validate the regions before use: require ri_cnt to cover the regions
> > ilf_fields implies, the log dinode to be present and at least a log din=
ode
> > in size, and di_version to match the mount. Replace the di_forkoff chec=
k,
> > which can never fire (di_forkoff is a u8 of 8-byte units, sb_inodesize =
a
> > byte count of at least 256), with xfs_dinode_verify_forkoff() (exported
> > here), and bound the local and extent fork copies against the destinati=
on
> > fork. The btree-root formats are logged in their larger in-core form an=
d
> > converted on the way in, so they are not bounded by the on-disk fork si=
ze.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c   |  2 +-
> >  fs/xfs/libxfs/xfs_inode_buf.h   |  2 ++
> >  fs/xfs/xfs_inode_item_recover.c | 59 ++++++++++++++++++++++++---------
> >  3 files changed, 47 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_bu=
f.c
> > index 336ef843f2fe..71311c4fc2ed 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -479,7 +479,7 @@ xfs_dinode_verify_fork(
> >       return NULL;
> >  }
> >
> > -static xfs_failaddr_t
> > +xfs_failaddr_t
> >  xfs_dinode_verify_forkoff(
> >       struct xfs_dinode       *dip,
> >       struct xfs_mount        *mp)
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_bu=
f.h
> > index f3624532b023..d120675f6c07 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > @@ -27,6 +27,8 @@ int xfs_inode_from_disk(struct xfs_inode *ip, struct =
xfs_dinode *from);
> >
> >  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
> >                          struct xfs_dinode *dip);
> > +xfs_failaddr_t xfs_dinode_verify_forkoff(struct xfs_dinode *dip,
> > +                        struct xfs_mount *mp);
> >  xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
> >               struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
> >               uint64_t flags2);
> > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_re=
cover.c
> > index 169a8fe3bf0a..8ebc8eaf9e03 100644
> > --- a/fs/xfs/xfs_inode_item_recover.c
> > +++ b/fs/xfs/xfs_inode_item_recover.c
> > @@ -366,6 +366,13 @@ xlog_recover_inode_commit_pass2(
> >               error =3D -EFSCORRUPTED;
> >               goto out_release;
> >       }
> > +     /* ri_buf[1] may be absent or shorter than a log dinode */
> > +     if (XFS_IS_CORRUPT(mp, item->ri_cnt < 2) ||
> > +         XFS_IS_CORRUPT(mp,
> > +                        item->ri_buf[1].iov_len < xfs_log_dinode_size(=
mp))) {
> > +             error =3D -EFSCORRUPTED;
> > +             goto out_release;
> > +     }
>
> I'm going to push back on this sort of piece-meal validation - this
> is not the place to be doing random "is the log item valid" checks.
> All it does is make the code harder for humans to read and
> understand.
>
> It is inconsistent, it is not applied to all log items, the checks
> are randomly distributed through the decoding and replay logic, and
> it's impossible to tell what checks might still be missing.
>
> We have a solid metadata verifier architecture for a reason: it
> centralises all the metadata verification for an object in a central
> place, and it always gets run when the object is first read from
> disk before we try to do anything with it. The verification is in
> one place, and it is easy to audit to determine what parts of the
> structure we aren't actually verifying.
>
> That means when we actually got to do an operation, we already know
> the structures are valid and do not contain corruptions. Issues like
> the log format structure not having enough regions is not an inode
> log format problem - it is a generic log format structure problem.
>
> Addressing these issues piece meal in each log item decode in pass 2 -
> after we've already parsed them in pass 1 and for readahead purposes
> - is too late and too random.
>
> Use your AI tokens to do something properly useful - add an object
> verifier layer to the journal recovery code that robustly verifies
> objects before we perform decoding. We already have type abstraction
> for items in log recovery (i.e. struct xlog_recover_item_ops) and we
> already have two passes over the journal (XLOG_RECOVER_PASS1/2), and
> pass 1 is used to set up state needed for the actual recovery in
> pass 2. IOWs, we should be using pass 1 as a full object verifier
> pass in addition to checking CRC.
>
> This would allows a clean separation between validation and decoding
> of log items and their formatted structures, and allow the recovery
> logic to be simplified because it is no longer mixing recovery with
> validation.
>
> This will allow us to add full, robust validation for all log items,
> and do it in a way that is easy to audit and identify parts of
> structres taht we haven't verified or are unable to verify easily.
>
> This is the sort of thing you should be using the power of the LLM
> agents to do - it's a waste of tokens to be trying to find and fix
> issues hidden in the code. Build the infrastructure that makes
> verification -robust-, and that will almost entirely eliminate this
> class of bug from log recovery.
>
> Use the power of the LLMs to address the underlying problem, don't
> waste time and tokens getting it to apply bandaids that don't
> actually help address the underlying issue.
>
> -Dave.
> --
> Dave Chinner
> dgc@kernel.org

Hi Dave,

Thanks for the review. I'll drop the per-item checks and rework it
into the pass1 object verifier
pass you described, keeping the validation separate from the decode
and replay code.

 Thanks,
 Weiming Shi
