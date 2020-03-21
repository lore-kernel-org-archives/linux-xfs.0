Return-Path: <SRS0=CeSn=5G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276BFC4332B
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Mar 2020 12:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E415920754
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Mar 2020 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584794123;
	bh=Ho5xiQentTMF8j1O7OFWnyyE/gccOsEhErIIgq+EMkc=;
	h=Subject:To:References:Cc:From:Date:In-Reply-To:List-ID:From;
	b=vcTDfjMoaxKcFXDtU03x1ZqcKToOTa3nIgPLI42/i72NBGcmVEGDDojjwrQ3kY2XR
	 PGEoDrdaaeItX8c73dxiZznSS0FzWDmQ4nLHiFG4KnvQdiICsXvDrbWamn3o2rmJOd
	 +5jRrQQTRKTqjog2batryv5KX+jNdZ/8poTSrw2w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCUMfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Mar 2020 08:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgCUMfS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Mar 2020 08:35:18 -0400
Received: from [192.168.0.107] (unknown [49.65.245.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3230620714;
        Sat, 21 Mar 2020 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584794117;
        bh=Ho5xiQentTMF8j1O7OFWnyyE/gccOsEhErIIgq+EMkc=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=mKT+NloeN4Sa8jy9Vl6cFZhl3QnK+0KMK/w4YVGNWuzWvNdWHC8X/exEhDYMi5DSs
         Cr66j2PE2gEIut/Zc7sSyLhYP6VSY4qrgqEPBhx8AbsLg07wL8x4VYbMkuzoOWBkzW
         W3l1GnAMejC3dHLEPW80KdN1/GHxeGydwkt1Jd1k=
Subject: Re: [f2fs-dev] [PATCH v9 23/25] f2fs: Pass the inode to
 f2fs_mpage_readpages
To:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200320142231.2402-1-willy@infradead.org>
 <20200320142231.2402-24-willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, ocfs2-devel@oss.oracle.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
From:   Chao Yu <chao@kernel.org>
Message-ID: <df3cc7a5-bf8b-da53-1dc6-5db185f7a4b3@kernel.org>
Date:   Sat, 21 Mar 2020 20:35:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200320142231.2402-24-willy@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020-3-20 22:22, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> This function now only uses the mapping argument to look up the inode,
> and both callers already have the inode, so just pass the inode instead
> of the mapping.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
