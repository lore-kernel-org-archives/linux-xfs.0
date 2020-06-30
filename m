Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE3DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 01:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B5A20780
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 01:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgF3BSa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:18:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6881 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgF3BS3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jun 2020 21:18:29 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0C4E0792D763124CADE7;
        Tue, 30 Jun 2020 09:18:22 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 30 Jun
 2020 09:18:21 +0800
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
To:     Eric Sandeen <sandeen@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>
CC:     <cgroups@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <31275d10-37c3-db32-9d0d-f78f1dd4fe0d@huawei.com>
Date:   Tue, 30 Jun 2020 09:18:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/6/30 3:08, Eric Sandeen wrote:
> f2fs and xfs have both added support for cgroup writeback:
> 
> 578c647 f2fs: implement cgroup writeback support
> adfb5fb xfs: implement cgroup aware writeback
> 
> so add them to the supported list in the docs.

Thanks for the fix.

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,
