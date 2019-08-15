Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8168C41514
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 21:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B92F320644
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565904837;
	bh=Q3KKgF+ty8JeYJLWsebBHdTZ5ep/QONHohuKsMgV9kI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0ok+6sg8SAGmxCLy/cL++zwpAlL3TKseBVPGI+XHA8CiEH6T2/ETIgRuR5N4w8HEP
	 weWM2dRSHBme1v9C/oZO3PMOpXXGYIdMsXEoNAIIlt2FdYzW0DvVikj/t4Yg89bR0h
	 dgTo6AQeM3m2OZbdIlc+IUhC+JZwrkMbG+EeEMME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfHOVd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 17:33:57 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37040 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731089AbfHOVd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 17:33:57 -0400
Received: by mail-lj1-f195.google.com with SMTP id t14so3500893lji.4
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 14:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNmCV0iorJaJ/4B9x9ItjW/vosEJYPNXmEbrNDaYkR4=;
        b=L+KglY9k08E6DLTAvhzP71uPOvFH0ftX6F+VX6R+6Jsi2p0IcQc8kW9P6CTAdz+ndG
         2kHE25Y449pIcxNGVW2Op3sdiMJJ9RxY3h2rJ0z0jJaXhD3+gB6DpMdtXJ9CF9GYMiqO
         DsQMqEq1Yqt+5nFrJdaikQRam9z2lK0MBPn2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNmCV0iorJaJ/4B9x9ItjW/vosEJYPNXmEbrNDaYkR4=;
        b=QhOUZQP/zm0JSjYUQbk55KJX6Z8YjDhnDDNr/KgRbZSNFedP17gHCDinQZtg9bNPvv
         3TyI2jaM0yEMJCBOpaSy0Mn9mdzXi+ioB8tikhINN9V2gvzmaB+u+Z+GNAEmvqwmr/B+
         rjHSZm2tkxS85rvmunI+D/9izaKHvQN9TRYofhhSs4flYz5jzc3eBu1bKckYorbzxAb8
         1rmm7pt+YBr3zBmEPU8R77r7lOgkwQ5P2iq0F064mIFa7ktVs9J68rklPVbT4lcYnnVh
         5oQ6CLaun5mxbUCxCuky8t+ywOIWJk1XJxHKf/UfRkuc1r7tpI8Clj16q8ipCH0bJR5o
         1Z6A==
X-Gm-Message-State: APjAAAVfntvL670tcrFWqfPHTBMD6ansZm7+NFxw3Zl7SILFiKgIb7yo
        9UXbMhUsOySUyeb3qAJxIFxQyn05x88=
X-Google-Smtp-Source: APXvYqwwVXdjZ93bdA2bF5K5fdUg+zNYFGgToJ/Vr0vQM5m+1LPY3DQ6u1wuX33/MexKBai4IzcPJw==
X-Received: by 2002:a2e:7001:: with SMTP id l1mr3801095ljc.48.1565904834557;
        Thu, 15 Aug 2019 14:33:54 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id o9sm657748ljc.51.2019.08.15.14.33.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 14:33:53 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id f9so3447586ljc.13
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 14:33:53 -0700 (PDT)
X-Received: by 2002:a2e:9702:: with SMTP id r2mr2870914lji.84.1565904833142;
 Thu, 15 Aug 2019 14:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190815171347.GD15186@magnolia> <CAHk-=wiHuHLK49LKQhtERXaq0OYUnug4DJZFLPq9RHEG2Cm+bQ@mail.gmail.com>
 <20190815200534.GF15186@magnolia>
In-Reply-To: <20190815200534.GF15186@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 15 Aug 2019 14:33:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgJm9OEfJ1gL66jzXsavhXxJCmu9g9jWCCeQPcsFVSO7g@mail.gmail.com>
Message-ID: <CAHk-=wgJm9OEfJ1gL66jzXsavhXxJCmu9g9jWCCeQPcsFVSO7g@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for 5.3-rc5
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 1:05 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> FWIW I've wondered off and on if the VFS syscalls should be generating
> some kind of audit trail when something returns an error message to
> userspace?

I don't think it makes sense for any random errors. ENOENT / EPERM /
EACCES / EISDIR etc are generally part of normal operation and
expected.

Things like actual filesystem corruption is different, but we haven't
really had good patterns for it. And I'd hate to add something like a
test for -EFSCORRUPTED when it's so rare. It makes more sense to do
any special handling when that is actually detected (when you might
want to do other things too, like make the filesystem be read-only or
whatever)

             Linus
