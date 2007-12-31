Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 07:01:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVF1VVo000837
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 07:01:32 -0800
Received: from gaimboi.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DFF5BD40C3
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 07:01:41 -0800 (PST)
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246]) by cuda.sgi.com with ESMTP id gJqrHtWb8I2qtaXt for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 07:01:41 -0800 (PST)
Message-ID: <4779094D.8050002@tmr.com>
Date: Mon, 31 Dec 2007 10:22:53 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: New XFS benchmarks using David Chinner's recommendations for
 XFS-based optimizations.
References: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
> Dave's original e-mail:
>
>> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d 
>> agcount=4 <dev>
>> # mount -o logbsize=256k <dev> <mtpt>
>
>> And if you don't care about filsystem corruption on power loss:
>
>> # mount -o logbsize=256k,nobarrier <dev> <mtpt>
>
>> Those mkfs values (except for log size) will be hte defaults in the next
>> release of xfsprogs.
>
>> Cheers,
>
>> Dave.
>> -- 
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>
> ---------
>
> I used his mkfs.xfs options verbatim but I use my own mount options:
> noatime,nodiratime,logbufs=8,logbsize=26214
>
> Here are the results, the results of 3 bonnie++ averaged together for 
> each test:
> http://home.comcast.net/~jpiszcz/xfs1/result.html
>
> Thanks Dave, this looks nice--the more optimizations the better!
>
> -----------
>
> I also find it rather pecuilar that in some of my (other) benchmarks 
> my RAID 5 is just as fast as RAID 0 for extracting large files 
> (uncompressed) files:
>
> RAID 5 (1024k CHUNK)
> 26.95user 6.72system 0:37.89elapsed 88%CPU (0avgtext+0avgdata 
> 0maxresident)k0inputs+0outputs (6major+526minor)pagefaults 0swaps
>
> Compare with RAID 0 for the same operation:
>
> (as with RAID5, it appears 256k-1024k..2048k possibly) is the sweet spot.
>
> Why does mdadm still use 64k for the default chunk size?

Write performance with small files, I would think. There is some 
information in old posts, but I don't seem to find them as quickly as I 
would like.
>
> And another quick question, would there be any benefit to use (if it 
> were possible) a block size of > 4096 bytes with XFS (I assume only 
> IA64/similar arch can support it), e.g. x86_64 cannot because the 
> page_size is 4096.
>
> [ 8265.407137] XFS: only pagesize (4096) or less will currently work.


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 
