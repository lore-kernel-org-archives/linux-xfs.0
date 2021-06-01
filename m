Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B22C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466CE60FDC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhFAKpZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 06:45:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFAKpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 06:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622544222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gCFO8gcPtHJz27r3h4aFIFGTniCzEiYULtEjlLJXhLY=;
        b=dnPPSt/Gd/EYInCgzs7otrvCBXLw4CnbRabNtAePyHG2EmkLW/7YHYyp7hjXKucP5bppEG
        hN8CIqqPyPWMqWzv5YaJ5TmfVAWICcNeEglzXnCoBSEwwpVLay5WQVdl/3ybs9CqT0N2xq
        Cy0neZMJMupOR4X7Go7N92EJelk3ZCs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-eukUHDWTNXWmcSlz9oGT1Q-1; Tue, 01 Jun 2021 06:43:41 -0400
X-MC-Unique: eukUHDWTNXWmcSlz9oGT1Q-1
Received: by mail-wm1-f71.google.com with SMTP id o14-20020a1c4d0e0000b029019a2085ba40so895232wmh.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jun 2021 03:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=gCFO8gcPtHJz27r3h4aFIFGTniCzEiYULtEjlLJXhLY=;
        b=l0Nx0h4s0d0O47W/cQ1M0WX66n7vyTPfWSAHpExnDMt2r0spqsd+C7Dikk3kvN7IIq
         4W0NCayhaz80LO7Wzq2Efe3G7B5uhWJRMRj2aQ8gTQmcAwOkORgloqObnZaK0IlELh4G
         2VDBAT6h/aSPnprRHqN7BFhR9fgd3lpWFG8InxF6fv5Y/1di4CbKzmKmWaE+/FCHEcXg
         uOj+/YXVdmh8PJGM/fVkVOOv22Q87ogZkxcT5PE4uf4R2QwTk32AxWNEDP8rN7ZU+TrY
         pA3Zi4gqZDyeybAUaKH6SFxxHVafXAf4K2MNPAIxtDoaAj/iFG5xVqK8Y8jQ1UGnLXBR
         csyA==
X-Gm-Message-State: AOAM530LLfp6gfg+rzXXPM1WdAsQS6lNm3ph8BKDhh8F36p5uWxc+ezT
        I4OotfeAd2LRxFyezGaoviJ781fvl1O62SLKkoa8aS6yQCzl6vGSVueLDelHT4i6mdeuiBACZCE
        NBqZugoYAA7Ja/t4BrWsn
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr3968962wma.60.1622544219902;
        Tue, 01 Jun 2021 03:43:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyi7CmyeDKnlakRCka8n7ZBmhMpeuApGPsv0ooiSUfPNMYIsEVNQdtylgwqa9ZXC6u2Ajt3Sg==
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr3968950wma.60.1622544219715;
        Tue, 01 Jun 2021 03:43:39 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id b135sm2165317wmb.5.2021.06.01.03.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 03:43:38 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:43:37 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: set ip->i_diflags directly in
 xfs_inode_inherit_flags
Message-ID: <20210601104337.iencg74zgonuzwe4@omega.lan>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        hch@infradead.org
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

I did a quick look into the generated asm code, and although my asm is a bit
rusty, I don't see that much difference between the two versions, at least not
to describe it as much better code. The following is a snippet of the code with
and without the patch, first line is just as a reference guide from where the
ASM starts. Most of the other occurrences using di_flags variable are similar
if not the same:

Without patch applied:

        } else if (S_ISREG(mode)) {
   92473:       66 81 f9 00 80          cmp    $0x8000,%cx
   92478:       0f 84 59 01 00 00       je     925d7 <xfs_dir_ialloc+0x797>
   9248e:       41 8b b5 0c 01 00 00    mov    0x10c(%r13),%esi
   92485:       31 c9                   xor    %ecx,%ecx
   92487:       a8 40                   test   $0x40,%al
   92489:       74 15                   je     924a0 <xfs_dir_ialloc+0x660>
   9248b:       44 8b 1d 00 00 00 00    mov    0x0(%rip),%r11d        # 92492 <xfs_dir_ialloc+0x652>
   92492:       41 89 c8                mov    %ecx,%r8d
   92495:       41 83 c8 40             or     $0x40,%r8d
   92499:       45 85 db                test   %r11d,%r11d
   9249c:       41 0f 45 c8             cmovne %r8d,%ecx
   924a0:       a8 80                   test   $0x80,%al


With patch applied:

        } else if (S_ISREG(mode)) {
   92483:       66 81 fe 00 80          cmp    $0x8000,%si
   92488:       0f 84 94 01 00 00       je     92622 <xfs_dir_ialloc+0x7e2>
   9248e:       41 8b b5 0c 01 00 00    mov    0x10c(%r13),%esi
   92495:       a8 40                   test   $0x40,%al
   92497:       74 20                   je     924b9 <xfs_dir_ialloc+0x679>
   92499:       44 8b 05 00 00 00 00    mov    0x0(%rip),%r8d        # 924a0 <xfs_dir_ialloc+0x660>
   924a0:       45 85 c0                test   %r8d,%r8d
   924a3:       74 14                   je     924b9 <xfs_dir_ialloc+0x679>
   924a5:       83 c9 40                or     $0x40,%ecx
   924a8:       66 41 89 8d 16 01 00    mov    %cx,0x116(%r13)
   924af:       00 
   924b0:       41 0f b7 84 24 16 01    movzwl 0x116(%r12),%eax
   924b7:       00 00 
   924b9:       a8 80                   test   $0x80,%al


Roughly, the main difference here IMHO, is the fact the current code uses xor to
zero out the registers prior test/copying the flags into it, while using the
patch applied, this is replaced by movz instructions since it copies the value's
flag directly from the xfs_inode struct. So, IMHO I don't really see enough
difference to justify dropping this patch.

Anyway, as I mentioned, my ASM is a bit rusty, so take it with a pinch of salt
:), but from my side, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers.

-- 
Carlos

