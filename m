Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A418C7CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 03:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D878AC001
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 01:57:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6hcOHg9m5lEtZvGU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 01:57:31 -0700 (PDT)
Date: Tue, 28 Jun 2016 10:57:26 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't call xfs_sb_quota_from_disk twice
Message-ID: <20160628085726.GA4397@redhat.com>
References: <13dd3974-956d-c3af-86ed-f6ce5cc1b996@redhat.com>
	<20160627094855.GC29774@redhat.com>
	<5c408cf1-e9fa-8bee-106e-93e553fc98a7@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5c408cf1-e9fa-8bee-106e-93e553fc98a7@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 27, 2016 at 10:34:39AM -0500, Eric Sandeen wrote:
> 
> 
> On 6/27/16 4:48 AM, Carlos Maiolino wrote:
> > On Fri, Jun 24, 2016 at 04:24:58PM -0500, Eric Sandeen wrote:
> >> kernel commit 5ef828c4
> >> xfs: avoid false quotacheck after unclean shutdown
> >>
> >> made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
> >> by default.
> >>
> >> However, when this was merged to libxfs, existing separate
> >> calls to libxfs_sb_quota_from_disk remained, and calling it
> >> twice in a row on a V4 superblock leads to issues, because:
> >>
> >>
> >>         if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> >> ...
> >>                 sbp->sb_pquotino = sbp->sb_gquotino;
> >>                 sbp->sb_gquotino = NULLFSINO;
> >>
> >> and after the second call, we have set both pquotino and gquotino
> >> to NULLFSINO.
> >>
> >> Fix this by making it safe to call twice, and also remove the extra
> >> calls to libxfs_sb_quota_from_disk.
> >>
> >> This is only spotted when running xfstests with "-m crc=0" because
> >> the sb_from_disk change came about after V5 became default, and
> >> the above behavior only exists on a V4 superblock.
> >>
> >> Reported-by: Eryu Guan <eguan@redhat.com>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >>
> >> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> >> index 45db6ae..44f3e3e 100644
> >> --- a/libxfs/xfs_sb.c
> >> +++ b/libxfs/xfs_sb.c
> >> @@ -316,13 +316,16 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> >>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> >>  
> >> -	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> >> +	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> >> +	    sbp->sb_gquotino != NULLFSINO)  {
> > 
> > Although I agree with this check, shouldn't we report some sort of error when it
> > happens? Once, it's not supposed to happen, and, might be a sign of corruption?
> 
> I dunno, it would also happen if it gets called twice, which is intentionally
> made harmless by this change.  We don't warn on free(NULL) for example...
> 

Well, I don't 100% agree with not having a warning here, but it doesn't make the
patch less valuable.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> I don't think it needs a warning.
> 
> -Eric
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
