Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 08:57:08 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7BFuwDW032168
	for <linux-xfs@oss.sgi.com>; Fri, 11 Aug 2006 08:56:58 -0700
Received: from [82.41.152.154] (helo=[192.168.10.36])
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1GBZND-0007Mq-SV
	for linux-xfs@oss.sgi.com; Fri, 11 Aug 2006 17:56:36 +0200
Date: Fri, 11 Aug 2006 16:56:30 +0100 (BST)
From: Christian <evilninja@gmx.net>
Subject: Re: mkfs.xfs
In-Reply-To: <684a75330608110447k16c4a079q74ab3d4deac0a273@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0608111651020.7492@prinz64.housecafe.de>
References: <684a75330608110447k16c4a079q74ab3d4deac0a273@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, 11 Aug 2006, Katt wrote:
> It is posibile to recovery a xfs partition after I make only mkfs.xfs?

The only painless way to "recover" from this is to use backups. 
You *could* try to use xfs_repair, but a freshly mkfs'ed xfs should report 
no errors. If it's about plaintext files, you could dd(1) around on the 
block-device and grep for it...no fun for big devices though...

Christian.
-- 
BOFH excuse #68:

only available on a need to know basis
