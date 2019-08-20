Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A8EC3A59E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 08:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6DB22DBF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 08:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZLISa7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfHTIx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 04:53:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34576 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfHTIx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 04:53:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so2842748pgc.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 01:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TzkSkNqOG78BC857zWzhfYDhyncf52u77BaZph1mfUI=;
        b=hZLISa7I5pPY49oG+cUSv6hpHzQKG4Sn8AnnvHv7YUhhnxmzXOa4fdEMcrqhqsLlj8
         5NCuvv0tWUx6eSINFDMShJvySkjOWmC5ijUMjtAA+RcvNQt57hPIKdH58HBRMsE6NXZQ
         V371MwTvEWO/WBhERqEv70BH+r0Cm3tXGGgEcSYazd45Eifp8Q6DofiL9PhkiugjtQ/K
         V4LZIcMnJkdqjVG5Az9kZZZ5AeqzawxCKb8E7atAHedRDUGw3PmyLRzBt5GI8LBfepFC
         X5gATY9bFEaOT6ohb6VXFwFk1xlKZDdMhi0TVhJpEaT05CSl/GIOZlOgtFl1Gf4XHjFS
         3tOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TzkSkNqOG78BC857zWzhfYDhyncf52u77BaZph1mfUI=;
        b=NrLZtiCMAcleMPj61BbMbSa9UzLss0AKhNJsrT4uj3oCnmURxr1BZ9vw3pt0Y29TgZ
         IOpDFpt8qDlNjWnWu4g0grxj0uyrKz4424mx8csWd38QEWvcUK5G9Sx2yDufOxh2+b4m
         UA7/K2+hOJq6Oe5Uftdk1Qz2/umhHSjknuB0oALlbMkYDkZCj+XfnyOYCCHo0sqL25Mn
         Wnqu9bnFijfKvfWdUlr8Yc5lVeN09hdgTJq1Oseh7kzdkRE5b3CSokWi9S6UzPpFW6Nz
         XxULJwbkInNnZBX+s2waQhiC8zFW96mD9NDxnxfwZEBxv3g2J7p34wzqzVXWvnOItxYs
         6W8A==
X-Gm-Message-State: APjAAAV3hJJWo/Z4B5nj78WoEVHv8lbeNO5wAM8eqxkrUwldWsuZsAD/
        gUYOFxxZGeoID+f8tYkpJg==
X-Google-Smtp-Source: APXvYqwPAiV3l8H43gRpQLwoe+Ef/87CknyxWeX4P+6xmOJYSbzRTeya6JwedzSRvTvNDeTksbxung==
X-Received: by 2002:a17:90a:eb05:: with SMTP id j5mr25525861pjz.102.1566291208818;
        Tue, 20 Aug 2019 01:53:28 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id d12sm18080140pfn.11.2019.08.20.01.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 01:53:28 -0700 (PDT)
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
 <20190820080741.GE1119@dread.disaster.area>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
Date:   Tue, 20 Aug 2019 16:53:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820080741.GE1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/20 16:07, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 02:45:36PM +0800, kaixuxia wrote:
>> On 2019/8/19 23:13, Brian Foster wrote:
>>> 	/* error checks before we dirty the transaction */
>>> 	if (!target_ip && !spaceres) {
>>> 		error = xfs_dir_canenter();
>>> 		...
>>> 	} else if (S_ISDIR() && !(empty || nlink > 2))
>>> 		error = -EEXIST;
>>> 		...
>>> 	}
>>>
>>> 	if (wip) {
>>> 		...
>>> 		xfs_iunlink_remove();
>>> 	}
>>>
>>> 	if (!target_ip) {
>>> 		xfs_dir_create();
>>> 		...
>>> 	} else {
>>> 		xfs_dir_replace();
>>> 		...
>>> 	}
>>>
>>> ... but that may not be any cleaner..? It could also be done as a
>>> followup cleanup patch as well.
>>
>> Yep, it is cleaner that making the whole check before the transaction
>> becomes dirty, just return the error code if check failed and
>> the filesystem is clean.
> 
> *nod*
> 
>> Dave gave another solution in the other subthread that using
>> XFS_DIR3_FT_WHT, it's a bit more work for this bug, include
>> refactoring the xfs_rename() and xfs_lookup(), not sure whether
>> it's worth the complex changes for this bug.
> 
> It's not necessary to fix the bug, but it's somethign we should
> be looking to do because it makes whiteout handling a lot more
> efficient - it's just dirent modifications at that point, no inodes
> are necessary.
> 
> This is how I always intended to handle whiteouts - it's just
> another thing on the "we need to fix" list....

Right, it is more efficient because there is no need to store it on disk,
and it will improve performance just like the async deferred operations.
Maybe it is on the roadmap, so I'm not sure whether I should send the V3
patch to address Brian's comments. Maybe we can choose the V3 patch first,
and then the whiteout improvement could be done as the followup patch
in future...

> 
> Cheers,
> 
> Dave.
> 

-- 
kaixuxia
