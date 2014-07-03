Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D9417F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 06:53:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B16A8F8052
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:53:00 -0700 (PDT)
Message-ID: <53B544FD.6020406@oracle.com>
Date: Thu, 03 Jul 2014 19:56:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
References: <53A8A0AF.9070009@gmail.com>
	<53A8A578.4070005@sgi.com>	<53A8A676.80305@sgi.com>
	<53A8F1AC.90109@gmail.com>	<20140624040434.GC9508@dastard>
	<53B335D1.2010709@gmail.com>
In-Reply-To: <53B335D1.2010709@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 07/02/2014 06:27 AM, Michael L. Semon wrote:
> On 06/24/2014 12:04 AM, Dave Chinner wrote:
>> On Mon, Jun 23, 2014 at 11:34:04PM -0400, Michael L. Semon wrote:
>>> [ 1068.431391] ------------[ cut here ]------------
>>> [ 1068.431566] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
>>> [ 1068.431596] list_del corruption. prev->next should be db5bf580, but was   (null)
>>
>> Ok, so the current log item points to a log item that has
>> null pointers (i.e. not on the list).
>>

<snip>

>>> [ 1068.433567] ---[ end trace 60289514948e4bd7 ]---
>>> [ 1068.433603] BUG: unable to handle kernel NULL pointer dereference at 0000000c
>>> [ 1068.433795] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0
>>
>> And that's trying to dereference a pointer from an item that is not
>> on the list....
>>
>> So there's linked list corruption occurring here.
>>
>>> I can reproduce the oops in kernel 3.15.0, perhaps with xfs-oss/for-next 
>>> merged, but there's no vmlinux to go with the kernel.  Therefore, I'll have 
>>> to resort to other means (rebuilt kernel with netconsole, re-attaching the 
>>> serial cable, etc.) to get the full crash log.
>>
>> How far back can you reproduce it? If it's a recent occurrence, can
>> you bisect it?
>>
>> Cheers,
>>
>> Dave.
> 
> I've had terrible luck with bisects this week due to PEBKAC errors.  With 3 
> commits left to try--one slow, full build (thanks, ARM!) and hopefully 2 
> minor builds--this commit is staring me in the face:
> 
> commit bba719b5004234e55737e7074b81b337210c511d
> Author: Jie Liu <jeff.liu@oracle.com>
> Date:   Wed Jan 1 19:28:03 2014 +0800
> 
>     xfs: fix off-by-one error in xfs_attr3_rmt_verify
> 
> In particular, one kernel had this as the most recent commit and showed 
> the current problem behavior.
> 
> That is about as far back as I can go before attr3_rmt issues corrupt 
> filesystems and cause a "Structure needs cleaning" message during the setfacl 
> part of the test.  Certianly, Jeff has improved matters with this patch.
> 
> On the normal kernel git, this may correspond to kernel v3.13.0-rc7 or -rc8, 
> certainly no earlier than -rc2.  git was bouncing the version numbers around 
> quite a bit.
> 
> Before Jeff worked his wonders here, efforts to getfacl a directory with max 
> ACLs (on a remounted, corrupt filesystem) ended like this...

Sorry for my late response as I'm working on another thing these days.

I have tried to reproduce this problem on my x86 virtualBox with xfs-next latest
 code via fsstress but no luck. i.e,

fsstress -d $SCRATCH_MNT/test-dir -n 10000 -p 16

Maybe this issue can be triggered via the seed file you provided, however, I
can not download it due to the stupid China great firewall, even if through proxy. :(


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
