Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA9FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 31 May 2022 15:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343961AbiEaPz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbiEaPz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 11:55:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A9B9527F4
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654012553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RUDXutJ8APH8d/I1GU3fIKEHfTHPOCuxM1ESo7xpfbg=;
        b=ZDa3Hqjg2Z0pWIe8Twxi9sjaCPJGvwa12rhXwKiyFyjSzR4Kj/xGt8XpaPxj2PpldKLHP2
        jsqNsFHPT19COnuviz8Qcj67iFPecD+i0msQyr/HSw66ev4rM9ji24FtJ9NXJViJCtxtY1
        2PGuUc1xEnIIYofaTnCSUNjfReuMn48=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-JCodX-Y8PEmfbTz0CFRzgw-1; Tue, 31 May 2022 11:55:52 -0400
X-MC-Unique: JCodX-Y8PEmfbTz0CFRzgw-1
Received: by mail-qt1-f197.google.com with SMTP id m6-20020ac866c6000000b002f52f9fb4edso12514176qtp.19
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 08:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RUDXutJ8APH8d/I1GU3fIKEHfTHPOCuxM1ESo7xpfbg=;
        b=4CMvhROOo6fQNCuLakCMrF5ZxBm3ZVDDyEkvhuQnwQ5Qdo3AUI3dcOAX6teCi5ekUZ
         kg7BZUSmTlWGmtwL3yzt3n1+orTW+LC5hBfxjn/pq7KaIVLpK1m4sPI3UnIeUZATC5/7
         KzUNCPNJkEydh+xMmHmFWyeoYiWggwUqP0efVoeiMrcyM32PE0LODBMU+oOSUnV7vHzI
         hV+eUZgFOvJtjV5oYJ7PrLr+sMuc1jNpJ+urbHA/8OxkWjfNgRCwdA3scFxATB93DKEI
         4Le+cLhaaC4hPiCpBfage7TvWSjNKexsQYFQu9QT759+WU5XDX4HmTda+YYod7rmICsr
         6Nmw==
X-Gm-Message-State: AOAM532/3C23WjX+epC4s0RtO/1T9+yG68tAHKit5fssp+qwdFPNf8nx
        5Ab0Nt/Hd1FnK7Ps+TDgsPR+7F0jzRLwaLYMynVRd96WLYiechb83sCs1sxZ+iULuY7un4Ebr0E
        e9/eJR29APXDGa6npF499
X-Received: by 2002:ac8:7dd5:0:b0:301:fe8:dedf with SMTP id c21-20020ac87dd5000000b003010fe8dedfmr12294878qte.208.1654012551612;
        Tue, 31 May 2022 08:55:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqcQmgx9tXR2o24ntwL6ngDCf3NND2sIHPiisE0Ubw8vAGzvbIZfHPaGvV07glZd3K8eYdtw==
X-Received: by 2002:ac8:7dd5:0:b0:301:fe8:dedf with SMTP id c21-20020ac87dd5000000b003010fe8dedfmr12294850qte.208.1654012551263;
        Tue, 31 May 2022 08:55:51 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id ew10-20020a05622a514a00b00304b41fa057sm3218562qtb.57.2022.05.31.08.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:55:50 -0700 (PDT)
Date:   Tue, 31 May 2022 11:55:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <YpY6hUknor2S1iMd@bfoster>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster>
 <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster>
 <CAOQ4uxgAiJFSUcEcWZo6qT_Pe84pOQ-B8ZORz_y5TQw4NQMjBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgAiJFSUcEcWZo6qT_Pe84pOQ-B8ZORz_y5TQw4NQMjBA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 28, 2022 at 05:23:19PM +0300, Amir Goldstein wrote:
> On Thu, May 26, 2022 at 10:47 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Thu, May 26, 2022 at 06:28:23PM +0300, Amir Goldstein wrote:
> > > > > Hi Brian,
> > > > >
> > > > > This patch was one of my selected fixes to backport for v5.10.y.
> > > > > It has a very scary looking commit message and the change seems
> > > > > to be independent of any infrastructure changes(?).
> > > > >
> > > > > The problem is that applying this patch to v5.10.y reliably reproduces
> > > > > this buffer corruption assertion [*] with test xfs/076.
> > > > >
> > > > > This happens on the kdevops system that is using loop devices over
> > > > > sparse files inside qemu images. It does not reproduce on my small
> > > > > VM at home.
> > > > >
> > > > > Normally, I would just drop this patch from the stable candidates queue
> > > > > and move on, but I thought you might be interested to investigate this
> > > > > reliable reproducer, because maybe this system exercises an error
> > > > > that is otherwise rare to hit.
> > > > >
> > > > > It seemed weird to me that NOT reusing the extent would result in
> > > > > data corruption, but it could indicate that reusing the extent was masking
> > > > > the assertion and hiding another bug(?).
> > > > >
> > > >
> > > > Indeed, this does seem like an odd failure. The shutdown on transaction
> > > > cancel implies cancellation of a dirty transaction. This is not
> > > > necessarily corruption as much as just being the generic
> > > > naming/messaging related to shutdowns due to unexpected in-core state.
> > > > The patch in question removes some modifications to in-core busy extent
> > > > state during extent allocation that are fundamentally unsafe in
> > > > combination with how allocation works. This change doesn't appear to
> > > > affect any transaction directly, so the correlation may be indirect.
> > > >
> > > > xfs/076 looks like it's a sparse inode allocation test, which certainly
> > > > seems relevant in that it is stressing the ability to allocate inode
> > > > chunks under free space fragmentation. If this patch further restricts
> > > > extent allocation by removing availability of some set of (recently
> > > > freed, busy) extents, then perhaps there is some allocation failure
> > > > sequence that was previously unlikely enough to mask some poor error
> > > > handling logic or transaction handling (like an agfl fixup dirtying a
> > > > transaction followed by an allocation failure, for example) that we're
> > > > now running into.
> > > >
> > > > > Can you think of another reason to explain the regression this fix
> > > > > introduces to 5.10.y?
> > > > >
> > > >
> > > > Not off the top of my head. Something along the lines of the above seems
> > > > plausible, but that's just speculation at this point.
> > > >
> > > > > Do you care to investigate this failure or shall I just move on?
> > > > >
> > > >
> > > > I think it would be good to understand whether there's a regression
> > > > introduced by this patch, a bug somewhere else or just some impedence
> > > > mismatch in logic between the combination of this change and whatever
> > > > else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
> > > > if I pull just this commit back into latest 5.10.y (5.10.118). I've
> > > > tried with a traditional bdev as well as a preallocated and sparse
> > > > loopback scratch dev.
> > >
> > > I also failed to reproduce it on another VM, but it reproduces reliably
> > > on this system. That's why I thought we'd better use this opportunity.
> > > This system has lots of RAM and disk to spare so I have no problem
> > > running this test in a VM in parallel to my work.
> > >
> > > It is not actually my system, it's a system that Luis has setup for
> > > stable XFS testing and gave me access to, so if the need arises
> > > you could get direct access to the system, but for now, I have no
> > > problem running the test for you.
> > >
> > > > Have you tested this patch (backport) in isolation
> > > > in your reproducer env or only in combination with other pending
> > > > backports?
> > > >
> > >
> > > I tested it on top of 5.10.109 + these 5 patches:
> > > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> > >
> > > I can test it in isolation if you like. Let me know if there are
> > > other forensics that you would like me to collect.
> > >
> >
> > Hm. Still no luck if I move to .109 and pull in those few patches. I
> > assume there's nothing else potentially interesting about the test env
> > other than the sparse file scratch dev (i.e., default mkfs options,
> > etc.)? If so and you can reliably reproduce, I suppose it couldn't hurt
> > to try and grab a tracepoint dump of the test when it fails (feel free
> > to send directly or upload somewhere as the list may punt it, and please
> > also include the dmesg output that goes along with it) and I can see if
> > that shows anything helpful.
> >
> > I think what we want to know initially is what error code we're
> > producing (-ENOSPC?) and where it originates, and from there we can
> > probably work out how the transaction might be dirty. I'm not sure a
> > trace dump will express that conclusively. If you wanted to increase the
> > odds of getting some useful information it might be helpful to stick a
> > few trace_printk() calls in the various trans cancel error paths out of
> > xfs_create() to determine whether it's the inode allocation attempt that
> > fails or the subsequent attempt to create the directory entry..
> >
> 
> The error (-ENOSPC) comes from this v5.10 code in xfs_dir_ialloc():
> 
>         if (!ialloc_context && !ip) {
>                 *ipp = NULL;
>                 return -ENOSPC;
>         }
> 
> Which theoretically might trip after xfs_ialloc() has marked the transaction
> dirty(?).
> 

Yeah, I think the first part that might have dirtied the transaction at
this point is fixing up the AGFL on a block allocation attempt. Ideally
the AG selection code would prevent taking this step for an AG that
can't satisfy an allocation, but realistically I'm not sure this
approach will ever work perfectly unless it separates out the extent
search algorithm from the prospect of dirtying the transaction and thus
committing to the allocation. This may not be trivial because the AGFL
fixup can require extent allocation itself.

It's not terribly surprising that limiting reuse of busy extents could
increase the likelihood of allocation failure, though I think most cases
should flush busy extents and retry. I wonder a bit whether changes to
the near mode allocation algorithm may have introduced a potential
regression in that regard.

> This specific code is gone with this cleanup series in v5.11:
> 
> https://lore.kernel.org/linux-xfs/20201209112820.114863-1-hsiangkao@redhat.com/
> 
> When the $SUBJECT patch is applied to v5.11.16 the test xfs/076 does not fail.
> 
> So either the $SUBJECT patch (from 5.12) is incompatible with v5.10 code
> or the cleanup series somehow managed to make my system not reproduce
> the bug anymore.
> 

I thought this was mostly refactoring and reworking the ugly retry
pattern in the former code vs. major functional changes. I think the
fundamental prospect of allocation failure still exists in current code,
but clearly your tests demonstrate some practical difference. Perhaps
there are some subtle logic changes in that rework that help prevent
this problem.

> I will assume the former and drop this patch from v5.10.y candidates.
> If you want me to continue to research the bug on v5.10 let me know
> what else you want me to check.
> 

I think that's reasonable. Realistically the bug fixed by this patch is
so old and long standing (v3.0?) I don't think it's terribly important
to pull it from v5.12 to v5.10.y unless real users started hitting it.
My curiosity around the cause is moreso to identify whether there's a
bug in mainline that needs fixing..

Brian

> Thanks,
> Amir.
> 

