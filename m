Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643A8C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 03:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AA76195D
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 03:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC3Dtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3DtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 23:49:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E54AC061762;
        Mon, 29 Mar 2021 20:49:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so6965026pjg.5;
        Mon, 29 Mar 2021 20:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=V8m/um/4qjFcW1pUXm5A1pzJvlUXU4Btq+wdKVMzb+0=;
        b=nMH6z/whDTyjxV/NdgnguKy9/6a5l9iYAfUQ1LfMr4y1hILGkHH237pAaaVFQznRJx
         HSbGN8E7agSkya5CSsFePtpK7BhAPs6LxUUHQe2hwVVcWz/cDKmtwXIGCreCKB12eCxj
         tDoG4GUD/oGbnvzBtCs+qtwvvWpYNNGSD+3edPJvtDg2zQzz0LY4FaHGXUyVt9+m0i5k
         953PPGzZJm/IAjU9+7d3ugx1eWPTebeLV2QdlAJvFMFRgkgc6GjUynfK3AnFrui2ZPr5
         /mbEhQPmlVxXFDN+wvkbAV9TPIETsaDVFvTTl+0kpcPEz5f9FZ/n8VIIK1/Nc/WTGyFd
         5TeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=V8m/um/4qjFcW1pUXm5A1pzJvlUXU4Btq+wdKVMzb+0=;
        b=d6PV4FQqZyYV7lsRhDiYf4TXTZsxENdbCEqRnWvxrIPyCSLiLzJWdz11/3xFe/fuyL
         vI6tOoyF5UY0/myQEu8m1/LcC1NQFX4lNrIwTKHFQ0Z9GrVGfoEJ2oJMAQqxDGNqknB/
         VmvU2AJlY1xPo2naPkOzW9KCv1R9ekFZEraMxC2eSNs68J5qQ69DQL7c3GIduZypp8+A
         4zLWHFXcAkjw0SsMMBPfLlM85i79tBXSDkoDFsnnRCZntccMP2d2rr/ZF8BqKNaW5x/d
         BtwVkgfs/rFSWrhPJBHxxIzr6rpDR6sfDME5SsW4+u8RIuIzMku9Kt8zifIBIGEwIVlC
         hosg==
X-Gm-Message-State: AOAM533EWdc5Uqg0vWCMFpzD7ndhF+tQLmtF0nfi3rDPzHnMed6JpdOG
        5NBm+wASDJ41qLt/XMOk7gfhT3MK51c=
X-Google-Smtp-Source: ABdhPJyaS5XQpSHvt5xbb2BK5TWjkvK9k1wtecCnlbIrMYqJ7n2Zih9ZhTy72yng5uc4y0k47L02Ng==
X-Received: by 2002:a17:90a:9309:: with SMTP id p9mr2377634pjo.174.1617076160064;
        Mon, 29 Mar 2021 20:49:20 -0700 (PDT)
Received: from garuda ([122.172.178.88])
        by smtp.gmail.com with ESMTPSA id u79sm19539371pfc.207.2021.03.29.20.49.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 20:49:19 -0700 (PDT)
References: <20210325140857.7145-1-chandanrlinux@gmail.com> <20210325140857.7145-6-chandanrlinux@gmail.com> <20210329180627.GF4090233@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs/535: Fix test to execute in multi-block directory config
In-reply-to: <20210329180627.GF4090233@magnolia>
Date:   Tue, 30 Mar 2021 09:19:16 +0530
Message-ID: <878s65b8sj.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Mar 2021 at 23:36, Darrick J. Wong wrote:
> On Thu, Mar 25, 2021 at 07:38:57PM +0530, Chandan Babu R wrote:
>> xfs/535 attempts to create $srcfile and $dstfile after reduce_max_iextents
>> error tag is injected. Creation of these files fails when using a multi-block
>> directory test configuration because,
>> 1. A directory can have a pseudo maximum extent count of 10.
>> 2. In the worst case a directory entry creation operation can consume
>>    (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
>>    extents.
>>    With 1k fs block size and 4k directory block size, this evaluates to,
>>    (5 + 1 + 1) * 4
>>    = 7 * 4
>>    = 28
>>    > 10 (Pseudo maximum inode extent count).
>> 
>> This commit fixes the issue by creating $srcfile and $dstfile before injecting
>> reduce_max_iextents error tag.
>> 
>> Reported-by: Darrick J. Wong <djwong@kernel.org>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>
> Now on to the xfs/538 regressions! ;)

Yup, I am working on them.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review! I will fold patches 2 to 6 into a single patch and
repost.

-- 
chandan
