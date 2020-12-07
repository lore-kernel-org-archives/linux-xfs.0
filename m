Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,STOX_REPLY_TYPE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2148C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 10:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8235623120
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 10:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgLGKS6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 05:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgLGKS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 05:18:57 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB85C0613D0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 02:18:17 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id w206so9231268wma.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 02:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:from:to:cc:references:in-reply-to:subject:date
         :mime-version:content-transfer-encoding:importance;
        bh=0+2uuzIC92vBNydm67SsJY9Y4R0KS/9h0nCWTvnN1zs=;
        b=bLF+XuRYc+pmfrwaJH5PTz0TFFJoUqXKku3jJJdGxkO7bGc+OpSYAu3wJtOaXmZE70
         FtZk8i56vSlN0Xo6UcP5ylgow74JGzOqt7x86wdo4/gzcqNgfWhzBjBZAVgj9FiAEFSp
         maUUhwcdyYAfwazPlP3jPNo8ETH2kwKC2xQmH4Tm1DMktnxG1rbNOQo5YimCP6pSt18D
         u7BrFayVY4w2uXKtbeSAUO/WXIf+YhJiIzPSpye5j0vBYj8ZumdiZlh+1laIlYVp0pmg
         s40s+OnTIL2v4+wfpdLbwko0rG4Oqya+e9E+9gF3Slw6opnrXdmdX5/htBDAimBOZ5sR
         5VkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:references:in-reply-to
         :subject:date:mime-version:content-transfer-encoding:importance;
        bh=0+2uuzIC92vBNydm67SsJY9Y4R0KS/9h0nCWTvnN1zs=;
        b=HuZKG9yOEEQ3JbSRQ7rxhgZsO+idZCf79eUSr0l8VQ40Ypi/WPyPwsfxnq91SvYb0Q
         v28V178lgMSS23Cm6TR1WXs5aHScUoirZJtvlgF9paioGBqPDA6j+oMncdtyLmeRcqWU
         3rlA+PEJk92pZSLMcFR7ZDKc43XMMiUCkQC551S//SeoSMs+Lxx4A4DiEJJ9LpUEdOD7
         VZXdt14gi4ADo3OKd3dQ2gvwX5Axzwrab2RdboHrpackYBK4AGQVXPBXq6N6xz8Me/UF
         sOVQ6ariH5iHq3Fu/mAuRlaFULM8xa0Gj+4oCysvE6/RrOQXjFpkLhSzweOuhsCjYmZr
         ewDg==
X-Gm-Message-State: AOAM533ex217vXee+VMOc+rXuQyQ9UIeQPu676BlZ9wClGr9gozvj29H
        n4iMaFXKveVVpqYthW4SMcOltFRRubZyk6Ve
X-Google-Smtp-Source: ABdhPJy9BvtH0FpLHCWLbhVxtXYbsPZbpGgcHS4Py6WTDuRvqTODpWu38UD6kmH+J6aM2KbVI5trhA==
X-Received: by 2002:a7b:c843:: with SMTP id c3mr17563350wml.100.1607336295680;
        Mon, 07 Dec 2020 02:18:15 -0800 (PST)
Received: from alyakaslap ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id l13sm14477431wrm.24.2020.12.07.02.18.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:18:14 -0800 (PST)
Message-ID: <6117EC6AA8F04ECA90EAACF20C4A2A7C@alyakaslap>
From:   "Alex Lyakas" <alex@zadara.com>
To:     "Dave Chinner" <david@fromorbit.com>
Cc:     <linux-xfs@vger.kernel.org>
References: <5582F682900B483C89460123ABE79292@alyakaslap> <20201116213005.GM7391@dread.disaster.area>
In-Reply-To: <20201116213005.GM7391@dread.disaster.area>
Subject: Re: RCU stall in xfs_reclaim_inodes_ag
Date:   Mon, 7 Dec 2020 12:18:13 +0200
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for your response.

We did some more investigations on the issue, and we have the following 
findings:

1) We tracked the max amount of inodes per AG radix tree. We found in our 
tests, that the max amount of inodes per AG radix tree was about 1.5M:
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384662 
reclaimable=58
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384630 
reclaimable=46
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384600 
reclaimable=16
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594500 
reclaimable=75
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594468 
reclaimable=55
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594436 
reclaimable=46
[xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594421 
reclaimable=42
(but the amount of reclaimable inodes is very small, as you can see).

Do you think this number is reasonable per radix tree?

2) This particular XFS instance is total of 500TB. However, the AG size in 
this case is 100GB. This is the AG size that we use, due to issues that we 
reported in https://www.spinics.net/lists/linux-xfs/msg06501.html,
where the "near" allocation algorithm was stuck for a long time scanning the 
free-space btrees. With smaller AG size, we don't see such issues.
But with 500TB filesystem, we now have 5000 AGs. As a result, we suspect 
(due to some instrumentation), that the looping over 5000 AGs in 
xfs_reclaim_inodes_ag() is what is causing the RCU stall for us. Although 
the code has cond_resched() call, but somehow the RCU stall still happens, 
and it always happens in this function, while searching the radix tree.

Thanks,
Alex.



-----Original Message----- 
From: Dave Chinner
Sent: Monday, November 16, 2020 11:30 PM
To: Alex Lyakas
Cc: linux-xfs@vger.kernel.org
Subject: Re: RCU stall in xfs_reclaim_inodes_ag

On Mon, Nov 16, 2020 at 07:45:46PM +0200, Alex Lyakas wrote:
> Greetings XFS community,
>
> We had an RCU stall [1]. According to the code, it happened in
> radix_tree_gang_lookup_tag():
>
> rcu_read_lock();
> nr_found = radix_tree_gang_lookup_tag(
>        &pag->pag_ici_root,
>        (void **)batch, first_index,
>        XFS_LOOKUP_BATCH,
>        XFS_ICI_RECLAIM_TAG);
>
>
> This XFS system has over 100M files. So perhaps looping inside the radix
> tree took too long, and it was happening in RCU read-side critical 
> seciton.
> This is one of the possible causes for RCU stall.

Doubt it. According to the trace it was stalled for 60s, and a
radix tree walk of 100M entries only takes a second or two.

Further, unless you are using inode32, the inodes will be spread
across multiple radix trees and that makes the radix trees much
smaller and even less likely to take this long to run a traversal.

This could be made a little more efficient by adding a "last index"
parameter to tell the search where to stop (i.e. if the batch count
has not yet been reached), but in general that makes little
difference to the search because the radix tree walk finds the next
inodes in a few pointer chases...

> This happened in kernel 4.14.99, but looking at latest mainline code, code
> is still the same.

These inode radix trees have been used in XFS since 2008, and this
is the first time anyone has reported a stall like this, so I'm
doubtful that there is actually a general bug. My suspicion for such
a rare occurrence would be memory corruption of some kind or a
leaked atomic/rcu state in some other code on that CPU....

> Can anyone please advise how to address that? It is not possible to put
> cond_resched() inside the radix tree code, because it can be used with
> spinlocks, and perhaps other contexts where sleeping is not allowed.

I don't think there is a solution to this problem - it just
shouldn't happen in when everything is operating normally as it's
just a tag search on an indexed tree.

Hence even if there was a hack to stop stall warnings, it won't fix
whatever problem is leading to the rcu stall. The system will then
just spin burning CPU, and eventually something else will fail.

IOWs, unless you can reproduce this stall and find out what is wrong
in the radix tree that is leading to it looping forever, there's
likely nothing we can do to avoid this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

