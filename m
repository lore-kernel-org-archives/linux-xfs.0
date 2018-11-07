Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36902 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKGPNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 10:13:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id p2-v6so14458699wmc.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 21:44:57 -0800 (PST)
Received: from amb.local ([194.99.105.109])
        by smtp.gmail.com with ESMTPSA id 137-v6sm5830472wmo.43.2018.11.06.21.44.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 21:44:55 -0800 (PST)
Subject: Re: [PATCH 0/7] xfs_repair: scale to 150,000 iops
References: <20181030112043.6034-1-david@fromorbit.com>
From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <d025a410-bd8d-03c7-e738-5da019dfe818@gmail.com>
Date: Wed, 7 Nov 2018 06:44:54 +0100
MIME-Version: 1.0
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 30/10/2018 12:20, Dave Chinner wrote:
> Hi folks,
> 
> This patchset enables me to successfully repair a rather large
> metadump image (~500GB of metadata) that was provided to us because
> it crashed xfs_repair. Darrick and Eric have already posted patches
> to fix the crash bugs, and this series is built on top of them.

I was finally able to repair my big fs using for-next + these patches.

But it wasn't as easy as just running repair.

With default bhash OOM killed repair in ~1/3 of phase6 (128GB of ram +
50GB of ssd swap). bhash=256000 worked.

Sometimes segfault happens but I don't have any stack trace
unfortunately and trying to reproduce on my other test machine
gave me no luck.

One time I got:
xfs_repair: workqueue.c:142: workqueue_add: Assertion `wq->item_count ==
0' failed.

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
