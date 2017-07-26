Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32916 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdGZN73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2017 09:59:29 -0400
Received: by mail-wr0-f194.google.com with SMTP id y43so22182320wrd.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2017 06:59:28 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
 <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
 <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
 <20170720074706.GA22218@lst.de>
 <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
 <20170720074924.GA22278@lst.de>
 <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
 <20170726130442.GA24681@lst.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <fde0bf1e-5ee6-3671-9cb2-f76b428abb07@gmail.com>
Date: Wed, 26 Jul 2017 16:59:26 +0300
MIME-Version: 1.0
In-Reply-To: <20170726130442.GA24681@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



On 26.07.2017 16:04, Christoph Hellwig wrote:
> But this is just on 4.4 and older, right?  We had issues in the
> allocation path there as well, which should be fixed in 4.11 and later,
> and in recrnt 4.9-stable releases.  Without those the allocation path
> might sometimes lock out of order as well.

I will try to repro on 4.11 WITHOUT your patch just to see that the
issue happens there as well. But if memory serves me right on newer
kernels it was much harder to hit (but not impossible).
