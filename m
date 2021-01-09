Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5E2C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 19:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5622B2399C
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 19:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbhAITBB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 14:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbhAITBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 14:01:00 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3AAC06179F
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 11:00:20 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id x20so31019699lfe.12
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 11:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6Uz/uNKuxv8kpeBK6zjNMwa2VjYpAJbjFDMrzffj6I=;
        b=B5MuZOKUiCj7xkpKI58UwPgj+2Ygq8bPiwFnSM6GgJ3giVH0HlyrHQVOus3hpeAH+e
         ihkFNtQrr7VFzpBW/oNSs7g/4YiRSUG5HnzO4DWt6vSIVmtECXfeVEUA3WxEVCPzhO83
         q5CbQWf/kWSe6EhP4nvdYTWFSoqBeuXlzrhSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6Uz/uNKuxv8kpeBK6zjNMwa2VjYpAJbjFDMrzffj6I=;
        b=MY2x//Aro6FSDnpmilH2eSp5BMn7CdPthOhzyMerEyCQSiDfVS+TmkNnlyjy03M93A
         Sd1kXLouF3ukZXvWT7Bm0KdxUFWne0dXHTlEi2oOCYc4Yj95IO1rS8HdiqO3pKiYtABp
         +bl429Ud3V0gcwPsolLJDTXrAyCHfml+3VCZ8YWGmEZcitwSQIdrKCQXuHa1O6VzBpGm
         5XxoDxxlgrIdXvSQNPmAimGtw4pQk/rr7/5jTaMwCxsUFFpIw+9MZmnoGwWT8blIhAG5
         CP+1koj8kWa29DJQym0+cPi8kvblVZqqWtreXJb6QmhWjRNuuwp38/2mlQU5i4YH/wUJ
         +GOw==
X-Gm-Message-State: AOAM53378oHBzHYMN433ibtIUKDjTw5f9aR3bMPGbldj5Ai+8n+cWLVf
        BLMSbIv8EISHN6+6a+iQgA+b1416ZGo0HA==
X-Google-Smtp-Source: ABdhPJz8ZPgZr/a35LRBIeM/52ccpqcJhk9+AJrj6/giCKLt4uFMpguBOHZ0/kBj7k62bejslniiQg==
X-Received: by 2002:a19:4148:: with SMTP id o69mr3741010lfa.610.1610218818480;
        Sat, 09 Jan 2021 11:00:18 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id f18sm2423340lfh.137.2021.01.09.11.00.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 11:00:17 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id h205so31125047lfd.5
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 11:00:17 -0800 (PST)
X-Received: by 2002:a05:6512:338f:: with SMTP id h15mr3759713lfg.40.1610218817016;
 Sat, 09 Jan 2021 11:00:17 -0800 (PST)
MIME-Version: 1.0
References: <20210109064602.GU6918@magnolia>
In-Reply-To: <20210109064602.GU6918@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 9 Jan 2021 11:00:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wibYWuriC4m-zjU10J65peMDAFTjY2EGjTV=COgg1saPw@mail.gmail.com>
Message-ID: <CAHk-=wibYWuriC4m-zjU10J65peMDAFTjY2EGjTV=COgg1saPw@mail.gmail.com>
Subject: Re: [PATCH] maintainers: update my email address
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 8, 2021 at 10:46 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Change my email contact ahead of a likely painful eleven-month migration
> to a certain cobalt enteprisey groupware cloud product that will totally
> break my workflow.  Some day I may get used to having to email being
> sequestered behind both claret and cerulean oath2+sms 2fa layers, but
> for now I'll stick with keying in one password to receive an email vs.
> the required four.

So I appreciate this email coming from your old email address, but I
also just want to note that as long as you then use the oracle email
address for sending email, commit authorship, and "Signed-off-by:" (or
Acked-by etc) addresses, those tend to be the ones that _primarily_
get used when people then CC you on issues.

Well, at least that's how I work. The MAINTAINERS file tends to be the
secondary one.

But I wish you best of luck with the new email setup ;)

            Linus
