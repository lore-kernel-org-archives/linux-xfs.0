Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFD2B7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:47:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3ECAFAC008
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:47:46 -0700 (PDT)
Received: from autodiscover.rincon.com (smtp.rincon.com [67.128.198.140]) by
	cuda.sgi.com with ESMTP id PcdrxtJtefnsVqU0 for
	<xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:47:44 -0700 (PDT)
Message-ID: <5418BE0F.9040702@rincon.com>
Date: Tue, 16 Sep 2014 15:47:43 -0700
From: Brian Hemme <bmh@rincon.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs fails with raid5 and smaller chunk sizes
References: <5418B39C.2060707@rincon.com> <20140916221738.GO4322@dastard>
In-Reply-To: <20140916221738.GO4322@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/16/2014 03:17 PM, Dave Chinner wrote:
> On Tue, Sep 16, 2014 at 03:03:08PM -0700, Brian Hemme wrote:
>> Hello all,
>>
>> I am having some odd problems with mkfs.xfs when used on a raid 5
>> array.  The array is built from 6 960GB SSDs all connected to SATA
>> ports on the MB and created with mdadm.  If I use a chunk size any
>> smaller then 512K mkfs.xfs just hangs forever.  It continues to use
>> CPU and so does the raid array but never completes.  If the system
>> is just left running for an extended length of time the whole OS
>> eventually locks up.  I have tried this on three different systems
>> with the same results.   I have searched all over for someone with
>> similar issues without success.  I am hoping I am just doing
>> something clearly wrong and you all can set me straight quickly.
>>
>> Some specifics:
>>      Arch linux with 3.14.1 kernel
>>      mkfs.xfs version 3.1.11
>>      mdadm - v3.3 - 3rd September 2013
>>
>> Commands:
>>> mdadm --create /dev/md0 --chunk=64K --level=5 --raid-devices=6
>> /dev/sd[a-f]
>>> mkfs.xfs /dev/md0
>>    ** This command fails and locks up
>>
>> I have tried specifying the arguments to mkfs.xfs with the same
>> results.  Building a 4 drive array seems to require a chunk size of
>> 1M or greater to work.  Same results if I make a partition on the
>> array and make the fs there.
> mkfs.xfs really should only take a couple of seconds to complete.
> Seeing as you are using SSDs, my first suspicion is that md or the
> SSDs are having problems with discard. Hence you should first
> try 'mkfs.xfs -K /dev/md0' and see if that completes quickly.
>
> Otherwise, output of 'echo w>  sysrq-trigger' from dmesg would be a
> good start, as would a 'perf top -G -U' snapshot (run for 30s at
> least a minute after mkfs.xfs starts) to tell us what is burning
> CPU.
>
> Cheers,
>
> Dave.

Thanks for the quick response!

Adding the -K seemed to do the trick.  However, for my education, why is 
this needed in this case?  It seems to work without it for larger chunk 
sizes or for raid 0 instead of 5.  It also worked on our old install 
with a 3.1.6 kernel.  Any why would not using the -K cause enough of a 
problem that the whole machine hangs?  Just trying to understand this 
enough to make sure I don't run into problems down the road.

Thanks again,
Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
