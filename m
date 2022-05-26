Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51895C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 19:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiEZTr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 15:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiEZTr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 15:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31C9384A3E
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 12:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653594475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FbYLrxDY4f3A3AbC7EClTtD82y8VW8bXQYmg/PoqumM=;
        b=Yy8LoIPKFIbXJ5/cwVphE/djDqfzJ3LSwANLeYftCplWwllDy5ZzShbLPg89zlEGgcxlEF
        61ohMA4FXIVYlPJv3V8WYAgBKhnpSoka9zKpHCjd0AGeWajv+RkJReKYOvtmB4SIjbXPTT
        lDoI7duD2NzCqLvRMWKsg4mv3HwFIYI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-wTELrSeTNnaTzriMakLoFg-1; Thu, 26 May 2022 15:47:54 -0400
X-MC-Unique: wTELrSeTNnaTzriMakLoFg-1
Received: by mail-qt1-f198.google.com with SMTP id u17-20020a05622a199100b002fbc827c739so2639713qtc.8
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 12:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FbYLrxDY4f3A3AbC7EClTtD82y8VW8bXQYmg/PoqumM=;
        b=rXTck64xbSKabywz7hnd9a9o1MvSCNyueHVO3bGIJ13kmxHG2v8thERC8g+s/ajQTo
         KlaIQTDQV3PEXwuEzp49UPzdgP1m1YLKu7c2bmoGT4ZGjSZnbcR/0QGB/tMd67tE70I1
         CARj27qHHNft+Vq7CmUg7U+rx+MKEVvHj5Q5l5RwUqQ256IAeWhrgSUMcVF+bbal/Jue
         tlZjASu6lw8CwhreVrKUi39Iu9YdJt2e0o1qIxWYdtbax/grnrkpf9K2tA7Qk8D4SZ8l
         Syge1+u5mHiD/Ws11CWhlHxX3aooHhE5Dwet6hEW6cqH2fXP2AvYRkv9W+7fCkCQPpJF
         4B3w==
X-Gm-Message-State: AOAM530wONy+SAoRh37sskqIlXlsbGVo/oD5gugnY0UbDeOacSMLxtqc
        sjFULysVvJAsB7UM/aifneOlPB55nAINP91iA+iLtpi+CX7AzTiWTGiKZEmpnOOBBusHVPVQ5jt
        PpsBEXkp8lnaLiQsl/xiM
X-Received: by 2002:ac8:58d3:0:b0:2f9:3b39:625c with SMTP id u19-20020ac858d3000000b002f93b39625cmr15824014qta.145.1653594473684;
        Thu, 26 May 2022 12:47:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp+hRovwrgG283zQ1fkY8JVJUPMxuVCcuvjbZ5dZhXL3dbcUY7pC901IZCftTEapKYznJAig==
X-Received: by 2002:ac8:58d3:0:b0:2f9:3b39:625c with SMTP id u19-20020ac858d3000000b002f93b39625cmr15823996qta.145.1653594473421;
        Thu, 26 May 2022 12:47:53 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id d64-20020a37b443000000b006a5d2eb58b2sm166374qkf.33.2022.05.26.12.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 12:47:53 -0700 (PDT)
Date:   Thu, 26 May 2022 15:47:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <Yo/ZZtqa5rkuh7VC@bfoster>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster>
 <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 06:28:23PM +0300, Amir Goldstein wrote:
> > > Hi Brian,
> > >
> > > This patch was one of my selected fixes to backport for v5.10.y.
> > > It has a very scary looking commit message and the change seems
> > > to be independent of any infrastructure changes(?).
> > >
> > > The problem is that applying this patch to v5.10.y reliably reproduces
> > > this buffer corruption assertion [*] with test xfs/076.
> > >
> > > This happens on the kdevops system that is using loop devices over
> > > sparse files inside qemu images. It does not reproduce on my small
> > > VM at home.
> > >
> > > Normally, I would just drop this patch from the stable candidates queue
> > > and move on, but I thought you might be interested to investigate this
> > > reliable reproducer, because maybe this system exercises an error
> > > that is otherwise rare to hit.
> > >
> > > It seemed weird to me that NOT reusing the extent would result in
> > > data corruption, but it could indicate that reusing the extent was masking
> > > the assertion and hiding another bug(?).
> > >
> >
> > Indeed, this does seem like an odd failure. The shutdown on transaction
> > cancel implies cancellation of a dirty transaction. This is not
> > necessarily corruption as much as just being the generic
> > naming/messaging related to shutdowns due to unexpected in-core state.
> > The patch in question removes some modifications to in-core busy extent
> > state during extent allocation that are fundamentally unsafe in
> > combination with how allocation works. This change doesn't appear to
> > affect any transaction directly, so the correlation may be indirect.
> >
> > xfs/076 looks like it's a sparse inode allocation test, which certainly
> > seems relevant in that it is stressing the ability to allocate inode
> > chunks under free space fragmentation. If this patch further restricts
> > extent allocation by removing availability of some set of (recently
> > freed, busy) extents, then perhaps there is some allocation failure
> > sequence that was previously unlikely enough to mask some poor error
> > handling logic or transaction handling (like an agfl fixup dirtying a
> > transaction followed by an allocation failure, for example) that we're
> > now running into.
> >
> > > Can you think of another reason to explain the regression this fix
> > > introduces to 5.10.y?
> > >
> >
> > Not off the top of my head. Something along the lines of the above seems
> > plausible, but that's just speculation at this point.
> >
> > > Do you care to investigate this failure or shall I just move on?
> > >
> >
> > I think it would be good to understand whether there's a regression
> > introduced by this patch, a bug somewhere else or just some impedence
> > mismatch in logic between the combination of this change and whatever
> > else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
> > if I pull just this commit back into latest 5.10.y (5.10.118). I've
> > tried with a traditional bdev as well as a preallocated and sparse
> > loopback scratch dev.
> 
> I also failed to reproduce it on another VM, but it reproduces reliably
> on this system. That's why I thought we'd better use this opportunity.
> This system has lots of RAM and disk to spare so I have no problem
> running this test in a VM in parallel to my work.
> 
> It is not actually my system, it's a system that Luis has setup for
> stable XFS testing and gave me access to, so if the need arises
> you could get direct access to the system, but for now, I have no
> problem running the test for you.
> 
> > Have you tested this patch (backport) in isolation
> > in your reproducer env or only in combination with other pending
> > backports?
> >
> 
> I tested it on top of 5.10.109 + these 5 patches:
> https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> 
> I can test it in isolation if you like. Let me know if there are
> other forensics that you would like me to collect.
> 

Hm. Still no luck if I move to .109 and pull in those few patches. I
assume there's nothing else potentially interesting about the test env
other than the sparse file scratch dev (i.e., default mkfs options,
etc.)? If so and you can reliably reproduce, I suppose it couldn't hurt
to try and grab a tracepoint dump of the test when it fails (feel free
to send directly or upload somewhere as the list may punt it, and please
also include the dmesg output that goes along with it) and I can see if
that shows anything helpful.

I think what we want to know initially is what error code we're
producing (-ENOSPC?) and where it originates, and from there we can
probably work out how the transaction might be dirty. I'm not sure a
trace dump will express that conclusively. If you wanted to increase the
odds of getting some useful information it might be helpful to stick a
few trace_printk() calls in the various trans cancel error paths out of
xfs_create() to determine whether it's the inode allocation attempt that
fails or the subsequent attempt to create the directory entry..

Brian

> Thanks,
> Amir.
> 

