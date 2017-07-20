Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36592 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932661AbdGTHvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 03:51:23 -0400
Received: by mail-wr0-f169.google.com with SMTP id y43so67188179wrd.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 00:51:23 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
 <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
 <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
 <20170720074706.GA22218@lst.de>
 <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
 <20170720074924.GA22278@lst.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <3ad5f00e-dace-c066-c748-468eaf75b0c4@gmail.com>
Date: Thu, 20 Jul 2017 10:51:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170720074924.GA22278@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



On 20.07.2017 10:49, Christoph Hellwig wrote:
>>> Odd.  And the patch to always just process a single extent from
>>> xfs_itruncate_extents fixes the issue for you, right?
>> As far as I remember yes.
> Can you retest it under otherwise identical conditions?
Will report back when I have the results.
