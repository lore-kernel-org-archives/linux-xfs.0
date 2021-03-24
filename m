Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A23CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375C6619C7
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhCXOSS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhCXORr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:17:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4BC061763;
        Wed, 24 Mar 2021 07:17:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y5so17437432pfn.1;
        Wed, 24 Mar 2021 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=NLeQ4HSuiDCUGmTCpTA2SuYcqcrhrG+GT1QujWimeH8=;
        b=NIcHKQKqY08wxndE+6mqOVvAPu1waxE34jLNEuq3T0/i1Dy54uHRUNDwRkEYyAULya
         xwMxKILLKtvTY1/n/voOY9PjaVOSzAlCaR4C+9Sge6a+tQT+n6m2PWrUu8AleG3/+BVG
         B3Xqb87VYhvx/8/LaLJ/xdgLUnIjO3x+81Nl+0MCRqVJsPtYUfU77DsFb4TY4ffTthig
         NqgH03xyI5TVpZrkBAOb1Actd7iOttdusW5C7hvYuR6z5vXMd69CpGaTVy8/SQPDZw+d
         1fOHn5o7R3xMWw3BL8LPased98/TYhhCKDdNf3+ATgVX8gm0Gm0EWRn+DheGGDhf7UBJ
         4Waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=NLeQ4HSuiDCUGmTCpTA2SuYcqcrhrG+GT1QujWimeH8=;
        b=dMIw8w3hfZyaJgaQz7IcOPBm/bw+a/oTi3MsrOd00jlGpaG4YC7CenvD0U0n6iMWKD
         ZD5mhZNXoCGUp/BrwrIcUedHLcvoDTIcUnMuJs6qC3IaRTq+zD4YonA+6/o5bWrbl1Cb
         Vg4J/+3VbRCKfu7EJ+DRz3BZCfc++E4CKtQ8+nJpJoGT0daXKzkalcS0OlN33oS91yar
         wV25wbUlIeYgFEOSmau4HcfD3+D8FxYHE6WOofrZyWMHb0TqWQj/n4k0/Bfpmi00cHlk
         J+kIr/6ze4M9pP91cgf8VyNp5tAs32UiHuvOsElxA5TkkM7C22qiOH8xuNUqTZXuqPTu
         mWDA==
X-Gm-Message-State: AOAM532TaI0TG7PgR8hO4MrTxDemJqJ/Gl9UcYwVrM3UH4LsW20795WQ
        MZFRwD0Aov/0VlfcNp2You4UxZtK8I8=
X-Google-Smtp-Source: ABdhPJwl/fnlAGYKtjIOFowIO7y0ztQ7Vn5Il8CHtSA4WkLSl6LYhCLfe8un45DldYDxJVPBK3uC+g==
X-Received: by 2002:a62:2a07:0:b029:214:fd95:7f7 with SMTP id q7-20020a622a070000b0290214fd9507f7mr3452427pfq.60.1616595465267;
        Wed, 24 Mar 2021 07:17:45 -0700 (PDT)
Received: from garuda ([171.61.69.55])
        by smtp.gmail.com with ESMTPSA id u17sm2545631pgl.80.2021.03.24.07.17.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Mar 2021 07:17:44 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-6-chandanrlinux@gmail.com> <20210322175652.GG1670408@magnolia> <87r1k56f7k.fsf@garuda> <20210323205730.GN22100@magnolia> <871rc43k2v.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
In-reply-to: <871rc43k2v.fsf@garuda>
Date:   Wed, 24 Mar 2021 19:47:42 +0530
Message-ID: <87zgys1vqx.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Mar 2021 at 16:16, Chandan Babu R wrote:
> On 24 Mar 2021 at 02:27, Darrick J. Wong wrote:
>> On Tue, Mar 23, 2021 at 09:21:27PM +0530, Chandan Babu R wrote:
>>> On 22 Mar 2021 at 23:26, Darrick J. Wong wrote:
>>> > On Tue, Mar 09, 2021 at 10:31:16AM +0530, Chandan Babu R wrote:
>>> >> Verify that XFS does not cause realtime bitmap/summary inode fork's
>>> >> extent count to overflow when growing the realtime volume associated
>>> >> with a filesystem.
>>> >>
>>> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>> >> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>>> >
>>> > Soo... I discovered that this test doesn't pass with multiblock
>>> > directories:
>>>
>>> Thanks for the bug report and the description of the corresponding solution. I
>>> am fixing the tests and will soon post corresponding patches to the mailing
>>> list.
>>
>> Also, I found a problem with xfs/534 when it does the direct write tests
>> to a pmem volume with DAX enabled:
>>
>> --- /tmp/fstests/tests/xfs/534.out      2021-03-21 11:44:09.384407426 -0700
>> +++ /var/tmp/fstests/xfs/534.out.bad    2021-03-23 13:32:15.898301839 -0700
>> @@ -5,7 +5,4 @@
>>  Fallocate 15 blocks
>>  Buffered write to every other block of fallocated space
>>  Verify $testfile's extent count
>> -* Direct write to unwritten extent
>> -Fallocate 15 blocks
>> -Direct write to every other block of fallocated space
>> -Verify $testfile's extent count
>> +Extent count overflow check failed: nextents = 11
>
> The inode extent overflow reported above was actually due to the buffered
> write operation. But it does occur with direct write operation as well.

I just found out that xfs_direct_write_iomap_ops is used for both buffered and
direct IO w.r.t dax devices. Please ignore the above statement.

--
chandan
