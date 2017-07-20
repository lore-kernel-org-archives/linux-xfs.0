Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35680 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdGTHrx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 03:47:53 -0400
Received: by mail-wm0-f50.google.com with SMTP id w126so17027581wme.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 00:47:53 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
 <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
 <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
 <20170720074706.GA22218@lst.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
Date: Thu, 20 Jul 2017 10:47:50 +0300
MIME-Version: 1.0
In-Reply-To: <20170720074706.GA22218@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



On 20.07.2017 10:47, Christoph Hellwig wrote:
> Odd.  And the patch to always just process a single extent from
> xfs_itruncate_extents fixes the issue for you, right?

As far as I remember yes.
