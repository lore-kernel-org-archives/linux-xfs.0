Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE31C04FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 15:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F896610FC
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 15:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhEXPQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 11:16:08 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55531 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235616AbhEXPLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 11:11:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UZyzSpv_1621868989;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UZyzSpv_1621868989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 May 2021 23:09:50 +0800
Date:   Mon, 24 May 2021 23:09:48 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Subject: Re: [PATCH 1/1] xfs: check free AG space when making per-AG
 reservations
Message-ID: <YKvBvBABUDHfHFux@B-P7TQMD6M-0146.local>
References: <162181808760.203030.18032062235913134439.stgit@locust>
 <162181809311.203030.14398379924057321012.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162181809311.203030.14398379924057321012.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 23, 2021 at 06:01:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The new online shrink code exposed a gap in the per-AG reservation
> code, which is that we only return ENOSPC to callers if the entire fs
> doesn't have enough free blocks.  Except for debugging mode, the
> reservation init code doesn't ever check that there's enough free space
> in that AG to cover the reservation.
> 
> Not having enough space is not considered an immediate fatal error that
> requires filesystem offlining because (a) it's shouldn't be possible to
> wind up in that state through normal file operations and (b) even if
> one did, freeing data blocks would recover the situation.
> 
> However, online shrink now needs to know if shrinking would not leave
> enough space so that it can abort the shrink operation.  Hence we need
> to promote this assertion into an actual error return.
> 
> Observed by running xfs/168 with a 1k block size, though in theory this
> could happen with any configuration.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Many thanks for the fix!

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
