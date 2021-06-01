Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9036C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 18:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972626136E
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 18:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhFASxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 14:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233397AbhFASxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 14:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B3F610C8;
        Tue,  1 Jun 2021 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622573522;
        bh=LcXcEu6VMGdMq6VGV1JlInJ3Q3I60h6bFb7TLT+iLx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NlxihUxw/6qzbDUcBjkd2lVTdz4dX6RN/Tp0s9efPZZRkPQf1X82+jRdk/XNRMHxR
         U0GNCb3Wxx2uEsRAZdQeWtiuWNc2exxDjMApkwFlOM+TGXJU5mmJA/7GX5BKDRWXpA
         5yc+ypbtM0sghx7Ev8ByC3eflMVfyo2hp4301cL2Pb4ALSAO69Y/qx8Sh0NzYlg7tp
         nERtpYqjj/eG7hzsGxR+RHeWGFrvE2Rt0A7gBwk8Pu4i1YTGV1StGnGmjJEdOVm22J
         L3EARckrtFH9f4OsMa+tJZ8MS8oOgMpXgrOGbm0pFpGMTE4VxxO4RQV6UZX1C9j2gM
         QqZqxR/sks2UA==
Date:   Tue, 1 Jun 2021 11:52:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: set ip->i_diflags directly in
 xfs_inode_inherit_flags
Message-ID: <20210601185202.GA26380@locust>
References: <162250083252.490289.17618066691063888710.stgit@locust>
 <162250083819.490289.18171121927859927558.stgit@locust>
 <20210531233315.GU664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531233315.GU664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 09:33:15AM +1000, Dave Chinner wrote:
> On Mon, May 31, 2021 at 03:40:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Remove the unnecessary convenience variable.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |   25 +++++++++++--------------
> >  1 file changed, 11 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index e4c2da4566f1..1e28997c6f78 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -689,47 +689,44 @@ xfs_inode_inherit_flags(
> >  	struct xfs_inode	*ip,
> >  	const struct xfs_inode	*pip)
> >  {
> > -	unsigned int		di_flags = 0;
> >  	xfs_failaddr_t		failaddr;
> >  	umode_t			mode = VFS_I(ip)->i_mode;
> >  
> >  	if (S_ISDIR(mode)) {
> >  		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
> > -			di_flags |= XFS_DIFLAG_RTINHERIT;
> > +			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;
> >  		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
> > -			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> > +			ip->i_diflags |= XFS_DIFLAG_EXTSZINHERIT;
> >  			ip->i_extsize = pip->i_extsize;
> >  		}
> 
> Hmmmm.
> 
> IIRC, these functions were originally written this way because the
> compiler generated much better code using a local variable than when
> writing directly to the ip->i_d.di_flags. Is this still true now?
> I think it's worth checking, because we have changed the structure
> of the xfs_inode (removed the i_d structure) so maybe this isn't a
> concern anymore?

Before the patch, the extszinherit code emitted on my system (gcc 10.2)
looked like this (0x15c is the offset of i_extsize and 0x166 is the
offset of i_diflags):

699                     if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
   0xffffffffa0375715 <+1909>:  test   $0x10,%ah
   0xffffffffa0375718 <+1912>:  jne    0xffffffffa0375759 <xfs_dir_ialloc+1977>
   0xffffffffa037571a <+1914>:  mov    0x15c(%r13),%esi

700                             di_flags |= XFS_DIFLAG_EXTSZINHERIT;
   0xffffffffa0375759 <+1977>:  mov    0x15c(%r12),%esi
   0xffffffffa0375761 <+1985>:  or     $0x10,%ch

701                             ip->i_extsize = pip->i_extsize;
   0xffffffffa0375764 <+1988>:  mov    %esi,0x15c(%r13)
   0xffffffffa037576b <+1995>:  movzwl 0x166(%r12),%eax
   0xffffffffa0375774 <+2004>:  jmp    0xffffffffa0375721 <xfs_dir_ialloc+1921>

702                     }
703                     if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
   0xffffffffa0375721 <+1921>:  mov    %ecx,%r8d
   0xffffffffa0375724 <+1924>:  or     $0x200,%r8d
   0xffffffffa037572b <+1931>:  test   $0x2,%ah
   0xffffffffa037572e <+1934>:  cmovne %r8d,%ecx
   0xffffffffa0375732 <+1938>:  jmpq   0xffffffffa03755e7 <xfs_dir_ialloc+1607>

704                             di_flags |= XFS_DIFLAG_PROJINHERIT;
705             } else if (S_ISREG(mode)) {

With a snippet at the bottom to copy %cx back to the inode:

730                     di_flags |= XFS_DIFLAG_FILESTREAM;
731
732             ip->i_diflags |= di_flags;
   0xffffffffa0375680 <+1760>:  or     0x166(%r13),%cx
   0xffffffffa0375688 <+1768>:  mov    %cx,0x166(%r13)

With the patch applied, that code becomes:

698                     if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
   0xffffffffa0375751 <+1969>:  test   $0x10,%ah
   0xffffffffa0375754 <+1972>:  jne    0xffffffffa03757d0 <xfs_dir_ialloc+2096>
   0xffffffffa0375756 <+1974>:  mov    0x15c(%r13),%esi

699                             ip->i_diflags |= XFS_DIFLAG_EXTSZINHERIT;
   0xffffffffa03757d0 <+2096>:  or     $0x10,%ch
   0xffffffffa03757d3 <+2099>:  mov    %cx,0x166(%r13)

700                             ip->i_extsize = pip->i_extsize;
   0xffffffffa03757db <+2107>:  mov    0x15c(%r12),%esi
   0xffffffffa03757e3 <+2115>:  mov    %esi,0x15c(%r13)
   0xffffffffa03757ea <+2122>:  movzwl 0x166(%r12),%eax
   0xffffffffa03757f3 <+2131>:  jmpq   0xffffffffa037575d <xfs_dir_ialloc+1981>
   0xffffffffa03757f8 <+2136>:  callq  0xffffffff81713cb0 <__stack_chk_fail>
   0xffffffffa03757fd:  nopl   (%rax)

701                     }
702                     if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
   0xffffffffa037575d <+1981>:  test   $0x2,%ah
   0xffffffffa0375760 <+1984>:  je     0xffffffffa03755f2 <xfs_dir_ialloc+1618>

703                             ip->i_diflags |= XFS_DIFLAG_PROJINHERIT;
   0xffffffffa0375766 <+1990>:  or     $0x2,%ch
   0xffffffffa0375769 <+1993>:  mov    %cx,0x166(%r13)
   0xffffffffa0375771 <+2001>:  movzwl 0x166(%r12),%eax
   0xffffffffa037577a <+2010>:  jmpq   0xffffffffa03755f2 <xfs_dir_ialloc+1618>

704             } else if (S_ISREG(mode)) {

AFAICT the main difference between the two versions now is that the new
version will copy %cx back to ip->i_diflags after every set operation,
and the old version would sometimes use a conditional move to update
%cx instead of a conditional branch.

I suspect the old version /is/ more efficient on x86, but I didn't see
any measurable difference between the two versions.  Hm.  The old code
was 197 bytes vs. 243 for the new one, so fmeh, I'll drop this because
I'd rather move on to the iwalk pre-cleanup cleanup series.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
