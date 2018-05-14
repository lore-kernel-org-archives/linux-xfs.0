Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46908 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbeENWCz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 18:02:55 -0400
Subject: Re: How to reliably measure fs usage with reflinks enabled?
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
Date: Mon, 14 May 2018 17:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org



On 5/14/18 3:02 PM, Tarik Ceylan wrote:
> How can one reliably measure filesystem usage on partitions that were compiled with -m reflink=1 ?
> Here are some numbers i am measuring with df -h (on different partitions holding the same data):
> 7.7G of 36G  (-b size=512  -m crc=0 )
> 8.6G of 36G  (-b size=4096 -m crc=1 )

8x larger inodes will take 8x more space, but you didn't say how many
inodes you have allocated.

> 11G  of 36G  (-b size=1024 -m crc=1,reflink=1,rmapbt=1 -i sparse=1 )
> 32G  of 864G (-b size=4096 -m crc=1,reflink=1 )

In that last case, you have a wildly different total fs size, so probably
no fair comparison here either.

The reverse mapping btree also takes up space.  You're turning too many
knobs at once.  ;)

> I already ruled out fragmentation as a cause. The data does not contain many duplicates (roughly 200mb could be freed by deduplicating). Since measuring fs usage on btrfs also isn't trivial, i would suspect that there are similar problems happening here. But i could not find any information on how to measure fs usage properly when using xfs with reflinks. Kernel in use is 4.14.40.

Perhaps you can change only one variable at a time to make the experiment
more meaningful.

-Eric

> Tarik Ceylan
> 
> (I am not subscribed to this list, i'd be grateful if you could CC me in your reply)
