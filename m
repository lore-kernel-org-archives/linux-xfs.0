Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76435C4BA01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0EB20675
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="bBjNplWy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgBYV4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:56:02 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43665 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYV4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 16:56:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id g21so761910qtq.10
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 13:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=C8tXnjBIgXhQmik6V01XoZCiutz1pInKjAZnnialvzs=;
        b=bBjNplWyyCrqAUpuEWmZ2tK7IJIcfZIxvmc9JcrzLs9vOpSuWqAgC3YEhCajpARc9d
         w0AYS2sY0ySMIbmYG26KZHOkre6asZDZzVjvXsCgWGCTHP2GFDUZYmaZH6DleB2x2lyM
         8SAzy/D6s7PhDXPeR78X+egGb+MDrUjHHRBJozSTI8T9iPw5RpYz6mRUvczCMye3Fk08
         pysDv6iXU0lgq2u1duoRF3+J6B4+suUVn/Y2PH07x+XLyI+Cb7kry9j4CywVwTD3eGg9
         fkIDiZ5GM1OdJ8G3JuU/WBR/4FwSZ+5zjPH6k4fgz1w5CjEezPy/6ihhoH4xJnfjtyIB
         /9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=C8tXnjBIgXhQmik6V01XoZCiutz1pInKjAZnnialvzs=;
        b=Xh/A1i/h9Jrj+e675SRGLsgY5IcYHEw2w9colsd9b2wap/l00eOA2MWFsHz7a8x4Ja
         L5VoWzP+JemUrSuLN4H69DJjVdTqFq/0FOkheiqg7MyTweX94BRPBYiBFNTxG7Iyk9C/
         5WT8fZi5+kPqtaampGchFz9eU7N3wZfYm2pjWKtzqSVV+6xUE4MrKC7lqvPTk+8CnslJ
         XwngEvMspUhwODIpvtQV+HrAd36u5gsb2uaisyEccUZtxj5v632SRRhPr/1/oTkexVaP
         7S6h2oi795e5DaCXXu4dTnXRRtvnT/hesco7leqpGMZzNDrmNlJ1bTIMYEuaPQSPB4JU
         TrCQ==
X-Gm-Message-State: APjAAAWWWazChFAE6Rm+4fgBJnf0OCoi0pAAXeXeo/kG/4PUYNEGopfA
        f5AlgNilVHoYbjDGBXWfuW6WlA==
X-Google-Smtp-Source: APXvYqzvjWTHfIbMSPafdGZwfSymc/7EJ4WF17lit6vE8LsmIjAbQXCrFiuwL6xOXZhKvx6VwJzwjg==
X-Received: by 2002:ac8:70d5:: with SMTP id g21mr940800qtp.46.1582667761333;
        Tue, 25 Feb 2020 13:56:01 -0800 (PST)
Received: from ?IPv6:2600:1000:b055:f4c4:c87c:3bb6:b6bc:1aae? ([2600:1000:b055:f4c4:c87c:3bb6:b6bc:1aae])
        by smtp.gmail.com with ESMTPSA id 131sm3148669qkl.86.2020.02.25.13.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:56:00 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] xfs: fix an undefined behaviour in _da3_path_shift
Date:   Tue, 25 Feb 2020 16:55:56 -0500
Message-Id: <F151ED18-55CF-482E-98BE-45A5A4D9A565@lca.pw>
References: <20200225214045.GA14399@infradead.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20200225214045.GA14399@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
X-Mailer: iPhone Mail (17D50)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Feb 25, 2020, at 4:40 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> In xfs_da3_path_shift() blk can be assigned to state->path.blk[-1] if
> state->path.active is 1 (which is a valid state) when it tries to add an
> entry > to a single dir leaf block and then to shift forward to see if
> there's a sibling block that would be a better place to put the new
> entry.  This causes a KASAN warning given

s/KASAN/UBSAN/

> negative array indices are
> undefined behavior in C.  In practice the warning is entirely harmless
> given that blk is never dereference in this case, but it is still better
> to fix up the warning and slightly improve the code.

Agree. This is better.

Darrick, do you need me to send a v3 for it or you could squash this in?
