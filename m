Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_DBL_ABUSE_MALW autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C608EC33C9E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 08:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97732206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 08:57:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i7vKC3M2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgA3I5R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 03:57:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726865AbgA3I5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 03:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580374636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qsWLoaxkUIcF5kAivWwk37VIzI8qmACwhbfUamdQCIE=;
        b=i7vKC3M277gFWfhtKB7xyD9piTjyEmeJC2vAJjLh7RY8borSMxWXhzXJXkJGut2/BCG6Sv
        KVsPq6IILzJW63x2WdAryIM408nvoPxjWwlxKBK0EEVOkJtZl6YE3ccti8kzV6FTwNK6pT
        5bsVhD+3F6NDbTMljsSITHp7JM/GHXA=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-pmjLx5RsMKef9Sq-28Vwog-1; Thu, 30 Jan 2020 03:57:14 -0500
X-MC-Unique: pmjLx5RsMKef9Sq-28Vwog-1
Received: by mail-vk1-f197.google.com with SMTP id v134so496581vkd.16
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2020 00:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qsWLoaxkUIcF5kAivWwk37VIzI8qmACwhbfUamdQCIE=;
        b=k2LZIhYxBAyM+bg//5MpNU1nS/XxcsE0FIVQ5KmgshlfguCOND3+p0/VjMoqUcC2DY
         0zSIzO5APpCCzbN5LIvHOB+4EqURoUANxNo1/UnmQtN7KDikAKYo5dUTrSv322zzog2i
         tZTZgNeeUQiVmCEYD0P/kmKoWx9SNXf3LUk8xlpcKUHtjzuK8TZdkpVFK+kcUj9wbWiG
         7m41R+ZfYU9H2W0MMNAOqPaTd4wMcfgaAYgxbtp+zrnMjul0YwZlfM1eSMIcOm5wjwdB
         xJ88O/94lRe891FFfV5yqu8pCeUrlRudknsx3qLsU2/81xEjRRfaVV+Cf95XC9EqbVuG
         tWeQ==
X-Gm-Message-State: APjAAAXxFl9wTnHf05x+d9CwY2zd9Q8Vn+8zfzVdY6qijU3VPoqhXC6H
        d9/NMragaplwNGnkmCUqGAO0o3JnMvqzeJLpPUF844z9wOY+OoVGZH4wusDFiW3pzT6NEMLxn9e
        IFLceZ5xK6jecVhg3JwD4vzy+nqMelk/rWQMF
X-Received: by 2002:a67:e954:: with SMTP id p20mr2585413vso.3.1580374633827;
        Thu, 30 Jan 2020 00:57:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxptQK4mMIn45KzWYiIxWhdX4yiUFLpUmcSoZ+C/EDItfeBJ3Fdm+ItCYbLn990hUHFqdBb1WfZ64faHtiMOGA=
X-Received: by 2002:a67:e954:: with SMTP id p20mr2585405vso.3.1580374633598;
 Thu, 30 Jan 2020 00:57:13 -0800 (PST)
MIME-Version: 1.0
References: <20200128145528.2093039-1-preichl@redhat.com> <20200128145528.2093039-5-preichl@redhat.com>
 <20200130074503.GB26672@infradead.org>
In-Reply-To: <20200130074503.GB26672@infradead.org>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 30 Jan 2020 09:57:02 +0100
Message-ID: <CAJc7PzUmpRP0-MG49kO5XqZKfM-o4SpYtUKpXC3LC_3Yi2htZg@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 8:45 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Jan 28, 2020 at 03:55:28PM +0100, Pavel Reichl wrote:
> > Remove mr*() functions as they only wrap the standard kernel functions
> > for kernel manimulation.
>
> I think patches 2, 3 and 4 make more sense if merged into a single
> patch to replace the mrlocks with rw_sempahores.
>

Hello Christoph,

the changes are divided into three patches so the changes are really
obvious and each patch does just one thing...it was actually an extra
effort to separate the changes but if there's an agreement that it
does not add any value then I can squash them into one - no problem
;-)

Bye

