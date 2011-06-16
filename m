Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GGkFBC046741 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 11:46:16 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70AF5171D9E8
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 09:46:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wQ94eSAqZIpPmZLp for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2011 09:46:14 -0700 (PDT)
Message-ID: <4DFA301C.3050307@redhat.com>
Date: Thu, 16 Jun 2011 11:32:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests test case 032 fails for wrong reason
References: <1308185652.7661.492.camel@chandra-lucid.beaverton.ibm.com>	
	<4DF955CE.6090108@redhat.com>
	<1308241896.5505.0.camel@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <1308241896.5505.0.camel@chandra-lucid.beaverton.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 6/16/11 11:31 AM, Chandra Seetharaman wrote:
> On Wed, 2011-06-15 at 20:01 -0500, Eric Sandeen wrote:
>> On 6/15/11 7:54 PM, Chandra Seetharaman wrote:
>>> Hello All,
>>>
>>> xfstests test case 032 creates different filesystems on the scratch
>>> partition and tries mkfs.xfs on the same filesystem expecting it to
>>> fail.
>>>
>>> In my system, for whatever reason, mkfs of btrfs fails which leads to
>>> the test case failure like this:
>>> ----------------
>>> FSTYP         -- xfs (non-debug)
>>> PLATFORM      -- Linux/x86_64 elm3c201 2.6.39-rc4-xfs.git.p2+
>>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
>>> MOUNT_OPTIONS -- -o
>>> context=system_u:object_r:nfs_t:s0 /dev/sdd2 /mnt/xfsScratchMntPt
>>>
>>> 032 20s ... - output mismatch (see 032.out.bad)
>>> --- 032.out	2011-06-10 17:25:22.000000000 -0700
>>> +++ 032.out.bad	2011-06-15 17:47:23.000000000 -0700
>>> @@ -1,2 +1,3 @@
>>>  QA output created by 032
>>>  Silence is golden.
>>> +Failed - overwrote fs type btrfs!
>>> Ran: 032
>>> Failures: 032
>>> Failed 1 of 1 tests
>>> ---------------------
>>>
>>> which is incorrect. I am thinking of submitting the following change (to
>>> run mkfs.xfs only if the preceding mkfs.$fs succeeds). Anybody has any
>>> opinions or better suggestions ?
>>
>> Sounds like the right approach.  Would be good to know why mkfs.btrfs
>> failed too, though, just for informational reasons :)
> 
> It is saved in $seq.full. Is that sufficient ?

sure.  Why -did- it fail, out of curiosity?

-Eric

>>
>> -Eric
>>
>>> ---------------
>>> diff --git a/032 b/032
>>> index 839b913..4261ca2 100755
>>> --- a/032
>>> +++ b/032
>>> @@ -75,11 +75,15 @@ do
>>>         echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seq.full
>>>         eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seq.full 2>&1
>>>  
>>> -       # next, ensure we don't overwrite it
>>> -       echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
>>> -       /sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
>>> +       if [ $? -eq 0 ] ; then
>>> +               # next, ensure we don't overwrite it
>>> +               echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
>>> +               /sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
>>>  
>>> -       [ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
>>> +               [ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
>>> +       else
>>> +               echo "mkfs of type ${fs} failed" >>$seq.full
>>> +       fi
>>> ------------------
>>>
>>> regards,
>>>
>>> chandra
>>>
>>
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
