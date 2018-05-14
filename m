Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45988 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752115AbeENW5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 18:57:55 -0400
Date: Tue, 15 May 2018 08:57:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reliably measure fs usage with reflinks enabled?
Message-ID: <20180514225751.GB10363@dastard>
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org

On Mon, May 14, 2018 at 05:02:53PM -0500, Eric Sandeen wrote:
> 
> 
> On 5/14/18 3:02 PM, Tarik Ceylan wrote:
> > How can one reliably measure filesystem usage on partitions that were compiled with -m reflink=1 ?
> > Here are some numbers i am measuring with df -h (on different partitions holding the same data):
> > 7.7G of 36G  (-b size=512  -m crc=0 )
> > 8.6G of 36G  (-b size=4096 -m crc=1 )
> 
> 8x larger inodes will take 8x more space, but you didn't say how many
> inodes you have allocated.
> 
> > 11G  of 36G  (-b size=1024 -m crc=1,reflink=1,rmapbt=1 -i sparse=1 )
> > 32G  of 864G (-b size=4096 -m crc=1,reflink=1 )
> 
> In that last case, you have a wildly different total fs size, so probably
> no fair comparison here either.
> 
> The reverse mapping btree also takes up space.  You're turning too many
> knobs at once.  ;)

Also, we reserve a lot of space for reflink/rmapbt metadata that
isn't actually used, so you're not actually using any more space
than the "-b size=4096 -m crc=1" case. I have plans for hiding that
reservation from users so that we don't get questions like this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
