Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 17:47:26 -0700 (PDT)
Received: from waldorf.loreland.org (uk.loreland.org [89.16.172.112])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA10lKhO027175
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 17:47:23 -0700
In-Reply-To: <Pine.LNX.4.64.0710310727090.8545@p34.internal.lan>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net> <47267EC7.8000906@sgi.com> <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org> <Pine.LNX.4.64.0710310727090.8545@p34.internal.lan>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0B48CB6B-59DE-4CBE-AEE9-3863C5D784D3@loreland.org>
Content-Transfer-Encoding: 7bit
From: James Braid <jamesb@loreland.org>
Subject: Re: Default mount options (that suck less).
Date: Thu, 1 Nov 2007 00:47:31 +0000
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On 31 Oct 2007, at 11:27, Justin Piszcz wrote:
> Impressive, what architecture do you run? ia64 or x86_64?  What  
> performance differences did you see?

It's all just commodity hardware - HP DL385 x86_64 server with a pile  
of cheap Infortrend RAID arrays. Performance wise we're limited by a  
single HBA to the disks, which is fine for this particular  
application because we saturate the network first.

xfs_repair takes a good 36 hours or so and 16-ish GB of memory to  
run. (we had to run it recently, thanks to a flakey RAID)
