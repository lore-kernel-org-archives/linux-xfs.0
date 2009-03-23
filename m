Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2NFa1vo166268
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 10:36:22 -0500
Received: from partygirl.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 991CE13BEEAD
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 08:35:27 -0700 (PDT)
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246]) by
	cuda.sgi.com with ESMTP id ohkuR7nCDbmT4D2G for
	<linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 08:35:27 -0700 (PDT)
Message-ID: <49C7AC2C.9090307@tmr.com>
Date: Mon, 23 Mar 2009 11:35:08 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: How to configure 36 disks ?
References: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
In-Reply-To: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Raz <raziebe@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org

Raz wrote:
> Hello
> I need to configure 3xDAS'es, each with 12 disks.
> All three DAS'es are connected to a single machine.
> I have the following requirements (in this order of importance)
> from the storage:
>
> 1. redundancy.
>    having two disks failing in one raid5 breaks the entire raid. when
> you have 30TB storage
>    it is a disaster.
>
> 2. performance.
>    My code eliminates Linux raid5/6 write penalty. I managed to do by
>    manipulating xfs and patching linux raid5 a bit.
>
> 3. modularity ( a "grow" and it will be nice to have "shrink" )
>    file system and volume must be able to grow. shrinking is possible
> by unifying multiple file systems
>    under unionfs or aufs.
>
> 4. Utilize storage size.
>
> I assume each disk is 1TB.
>
>   
___ snip ___

> Any other ideas ?

Yes, you have the whole solution rotated 90 degrees. Consider your 
original solution #2 below... You have no redundancy if one whole DAS 
box fails, which is certainly a possible failure mode. If you put the 
RAID0 horizontally, two arrays size six in each DAS, then RAID6 
vertically, if one DAS fails completely you still have a functioning 
system, and the failure results for individual drives remains about the 
same, while the rebuild time will be longer.

Solution #2
			     raid0
 DAS1: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |
   			      |
 DAS2: raid6: D,D,D,D,D,D     | xfs.
       raid6: D,D,D,D,D,D     |
                              |
 DAS3: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |


In addition, you can expand this configuration by adding more DAS units. 
This addresses several of your goals.

In practice, just to get faster rebuild as the array gets larger, I 
suspect you would find it was worth making the horizontal arrays RAID5 
instead of RAID0, just to minimize time to full performance.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
