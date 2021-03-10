Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE759C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D4864F83
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhCJCeM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:34:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232184AbhCJCeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 21:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615343647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8GwwUcOm0gDboHFJnkVDP021OHeO7lY2XNY3kkjyYDQ=;
        b=RIGJwp2jPzFNO2NfLbQnXqy85wBNti34VbBydHWJt1ZPcDLS2Zf1WWErCvkG4adlDkhyHq
        RhzsyWK5AxH5wZBmi2cqfcvRpqpsZ+dO/XjXIa9JcdKzFFRdN6NOSd+901Omi7tU63JaYV
        TMmo1+buDytktbXkPE3JyRSJtFiPAxg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-uchxIUaQPxCwZa4JX5qxYg-1; Tue, 09 Mar 2021 21:34:05 -0500
X-MC-Unique: uchxIUaQPxCwZa4JX5qxYg-1
Received: by mail-pj1-f72.google.com with SMTP id w34so3501912pjj.7
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 18:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8GwwUcOm0gDboHFJnkVDP021OHeO7lY2XNY3kkjyYDQ=;
        b=CmpKQOKtZRDNUqIf1xdWp+g/oY8rAEu5NsUZa9BPnmIGoTVJRPmwRnJUrHiNc54QuB
         D3GxJJas2FMpPfITBLGkXlHhpBaT3nW5SPNJl+Sao2EzaR1UXC42MQKfTtdlw/RG4wmQ
         khreYLGZCP4Uk9wb9Yb50rUqaRYOIqi9iFCxbUELqp6uUsQe1T90KjHJgsPdwbnzak6E
         /J4/agA42zAcFfnYCXDm94vD9cWYGgJMNICxsRB3E6FZ6bUMMgrOIrWPMxMmZKTjNKpd
         Vp3XbU2+Hyx8ZAGeyuEL0mavN84gJiEPKh5F9EgKq1ce5QXjLRppDjDstJEoCIebfW5x
         Mzaw==
X-Gm-Message-State: AOAM5330kNa0KH04rhTWbQvGKe8QFawhip6rrMycTQXf9aYrWZvYtIbC
        NyEiNMwcOTl0m3+ObFyy7/PcVkUk6ZCjWoUPogTB/NWriw0C16sWT2ggKNOogUESvAauLmgLlTL
        CLIgmSOXVH/KhP9Fn6ypr
X-Received: by 2002:a65:430b:: with SMTP id j11mr785262pgq.143.1615343643997;
        Tue, 09 Mar 2021 18:34:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYehmKoPCKeR7JcRYI46t1GlQkbwkAxXBSH0BFvQ0+b+8W0byext3PvqvQUVObbQX200m5Iw==
X-Received: by 2002:a65:430b:: with SMTP id j11mr785228pgq.143.1615343643563;
        Tue, 09 Mar 2021 18:34:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm14383070pfy.55.2021.03.09.18.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 18:34:03 -0800 (PST)
Date:   Wed, 10 Mar 2021 10:33:53 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the
 last AG
Message-ID: <20210310023353.GC4003044@xiangao.remote.csb>
References: <20201028230909.639698-1-hsiangkao@redhat.com>
 <20210310004324.GE3499219@localhost.localdomain>
 <20210310020947.GC3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210310020947.GC3419940@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Mar 09, 2021 at 06:09:47PM -0800, Darrick J. Wong wrote:

...

> > 
> > As Darrick has reviewed, I have one more question. Looks like we can shrink a
> > mounted xfs via giving a smaller size to xfs_growfs.
> > 
> > If xfs_growfs or kernel doesn't support 'shrink', I think the whole test will
> > be failed. So maybe we need a _require_* function to check if current xfs
> > support shrinking feature at first?
> 
> Also, it's time to send the xfs_growfs patches to the list so I can
> replicate the tests on my own test vms.

There was a preliminary version of xfsprogs sent out before to
match this version:
https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
https://lore.kernel.org/linux-xfs/20201028114010.545331-1-hsiangkao@redhat.com/raw

This added a EXPERIMENTAL warning but without a new argument
for shrinking.

Thanks,
Gao Xiang

