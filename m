Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0A937CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 03:31:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 925EF8F8050
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 01:31:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xHuixOf8rHB1ytqf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2016 01:30:59 -0700 (PDT)
Date: Wed, 29 Jun 2016 10:30:51 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't call xfs_sb_quota_from_disk twice
Message-ID: <20160629083051.GC22634@redhat.com>
References: <13dd3974-956d-c3af-86ed-f6ce5cc1b996@redhat.com>
	<20160627094855.GC29774@redhat.com>
	<5c408cf1-e9fa-8bee-106e-93e553fc98a7@sandeen.net>
	<20160628085726.GA4397@redhat.com>
	<c72e1f9a-0f83-aa2b-48f1-bc6deccc6315@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c72e1f9a-0f83-aa2b-48f1-bc6deccc6315@sandeen.net>
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

On Tue, Jun 28, 2016 at 10:40:31AM -0500, Eric Sandeen wrote:
> 
> 
> On 6/28/16 3:57 AM, Carlos Maiolino wrote:
> > On Mon, Jun 27, 2016 at 10:34:39AM -0500, Eric Sandeen wrote:
> >>
> >>
> >> On 6/27/16 4:48 AM, Carlos Maiolino wrote:
> >>> On Fri, Jun 24, 2016 at 04:24:58PM -0500, Eric Sandeen wrote:
> >>>> kernel commit 5ef828c4
> >>>> xfs: avoid false quotacheck after unclean shutdown
> >>>>
> >>>> made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
> >>>> by default.
> >>>>
> >>>> However, when this was merged to libxfs, existing separate
> >>>> calls to libxfs_sb_quota_from_disk remained, and calling it
> >>>> twice in a row on a V4 superblock leads to issues, because:
> >>>>
> >>>>
> >>>>         if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> >>>> ...
> >>>>                 sbp->sb_pquotino = sbp->sb_gquotino;
> >>>>                 sbp->sb_gquotino = NULLFSINO;
> >>>>
> >>>> and after the second call, we have set both pquotino and gquotino
> >>>> to NULLFSINO.
> >>>>
> >>>> Fix this by making it safe to call twice, and also remove the extra
> >>>> calls to libxfs_sb_quota_from_disk.
> >>>>
> >>>> This is only spotted when running xfstests with "-m crc=0" because
> >>>> the sb_from_disk change came about after V5 became default, and
> >>>> the above behavior only exists on a V4 superblock.
> >>>>
> >>>> Reported-by: Eryu Guan <eguan@redhat.com>
> >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>>> ---
> >>>>
> >>>>
> >>>> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> >>>> index 45db6ae..44f3e3e 100644
> >>>> --- a/libxfs/xfs_sb.c
> >>>> +++ b/libxfs/xfs_sb.c
> >>>> @@ -316,13 +316,16 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >>>>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> >>>>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> >>>>  
> >>>> -	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> >>>> +	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> >>>> +	    sbp->sb_gquotino != NULLFSINO)  {
> >>>
> >>> Although I agree with this check, shouldn't we report some sort of error when it
> >>> happens? Once, it's not supposed to happen, and, might be a sign of corruption?
> >>
> >> I dunno, it would also happen if it gets called twice, which is intentionally
> >> made harmless by this change.  We don't warn on free(NULL) for example...
> >>
> > 
> > Well, I don't 100% agree with not having a warning here, but it doesn't make the
> > patch less valuable.
> 
> Thanks Carlos - 
> 
> Maybe I don't understand what you want to warn about.
> 
> If we get here with:
> 
> 	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> 	    sbp->sb_gquotino != NULLFSINO)  {
> 
> that means we have an on-disk super without the pquotino field,
> the XFS_PQUOTA_ACCT flag is set, and so the gquotino field was
> used for the project quota; this is valid, and there is
> nothing to warn about in this case.
> 
> If we get here with:
> 
> 	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> 	    sbp->sb_gquotino == NULLFSINO)  {
> 
> that means we have an on-disk super without the pquotino field,
> the XFS_PQUOTA_ACCT flag is set, and the gquotino was not set
> to a valid value.  This could happen either from a bad on-disk
> value, or it could mean that we called the function twice in a
> row.  Without maintaining more state, we can't know which, and
> warning the user about a programming error wouldn't be helpful.
> 
> Actually, repair already handles this case elsewhere:
> 
> quota_sb_check(xfs_mount_t *mp)
> {
>         /*
>          * if the sb says we have quotas and we lost both,
>          * signal a superblock downgrade.  that will cause
>          * the quota flags to get zeroed.  (if we only lost
>          * one quota inode, do nothing and complain later.)
>          *
>          * if the sb says we have quotas but we didn't start out
>          * with any quota inodes, signal a superblock downgrade.
> 
> In the case where quota flags are on but all quota inodes are
> zero, it silently clears the quota flags.  Whether or not that
> should be silent I'm not sure, but I think that is separate
> from this patch.
> 
> Thanks,
> -Eric

Thanks for the great and detailed explanation Eric, I think I was just being too
careful about not having a warning there, without completely understand why a
warning isn't not necessary there. :)

> 
> 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
