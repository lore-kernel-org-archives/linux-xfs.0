Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 06:27:45 -0700 (PDT)
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7TDRLDW003720
	for <linux-xfs@oss.sgi.com>; Tue, 29 Aug 2006 06:27:22 -0700
Date: Tue, 29 Aug 2006 09:25:47 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <1156794030.5848.3.camel@localhost>
Message-ID: <Pine.LNX.4.64.0608290920010.5262@madrid.max-t.internal>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
 <20060823040218.GC807872@melbourne.sgi.com>  <20060823044829.GD807872@melbourne.sgi.com>
  <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
 <1156360259.5368.7.camel@localhost>  <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
  <20060823040218.GC807872@melbourne.sgi.com>  <20060823044829.GD807872@melbourne.sgi.com>
  <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
 <20060823231429.GF807872@melbourne.sgi.com>  <20060828072343.GJ807872@melbourne.sgi.com>
 <1156794030.5848.3.camel@localhost>
MIME-Version: 1.0
Subject: Re: Infinite loop in xfssyncd on full file system
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463763711-925634831-1156857947=:5262"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Luciano Chavez <lnx1138@us.ibm.com>
Cc: linux-xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463763711-925634831-1156857947=:5262
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 28 Aug 2006, Luciano Chavez wrote:

> On Mon, 2006-08-28 at 17:23 +1000, David Chinner wrote:
>> On Thu, Aug 24, 2006 at 09:14:29AM +1000, David Chinner wrote:
>>> On Wed, Aug 23, 2006 at 11:00:43AM -0400, Stephane Doyon wrote:
>>>> On Wed, 23 Aug 2006, David Chinner wrote:
>>>>
>>>>> On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
>>>>>> On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
>>>>>>> I'm seeing what appears to be an infinite loop in xfssyncd. It is
>>>>>>> triggered when writing to a file system that is full or nearly full=
. I
>>>>>>> have pinpointed the change that introduced this problem: it's
>>>>>>>
>>>>>>>    "TAKE 947395 - Fixing potential deadlock in space allocation and
>>>>>>>    freeing due to ENOSPC"
>>>>>>>
>>>>>>> git commit d210a28cd851082cec9b282443f8cc0e6fc09830.
>>>
>>> .....
>>>
>>>>>> Now we know what patch introduces the problem, we know where to look.
>>>>>> Stay tuned...
>>>>>
>>>>> I've had a quick look at the above commit. I'm not yet certain that
>>>>> everything is correct in terms of the semantics laid down in the
>>>>> change or that enough blocks are reserved for btree splits , but I
>>>>
>>>> I actually tried, naively, to bump up SET_ASIDE_BLOCKS from 8 to 32. I
>>>> won't claim to understand half of what's going on but I wondered wheth=
er
>>>> that might make the problem noticeably harder to reproduce at least, b=
ut
>>>> it had no effect ;-).
>>>
>>> That was going to be my next question. ;)
>>>
>>> At least that rules out a small error in the block reservation decision,
>>> so I'm going to have  analyse all the code paths the mod introduced
>>> and work out what is going wrong.
>>
>> You know, if you had of buumped it up just a bit higher, the problem mig=
ht
>> have gone away. With a fielsystem that only has 8 AGs in it, if you bump=
ed
>> it to 33, then problem would have disappeared....
>>
>> What we have here is a small error in the block reservation code. Basica=
lly,
>> all the logic is correct except for one critical detail - while we need =
to
>> reserve 4 blocks for the AG freelist so a minimum allocation can succeed,
>> we need to reserve 4 blocks in _every AG_ so that when every AG is empty
>> we will fail with ENOSPC instead of trying to allocate a block when we
>> have an AG with less thaan 4 free blocks in it.
>>
>> So, it's not 4 blocks filesystem wide we need to reserve, it's 4 blocks =
per AG
>> we need to reserve.
>>
>> Stephane and Luciano, can you try the patch att=C3=A6ched below - it fix=
es the
>> 100% repeatable test case (while [ 1 ]; dd to enospc; done) on my test
>> machine.
>>
>
> Dave,
>
> The latest patch seems to work for me running bonnie++ on a small 2GB
> XFS filesystem. bonnie++ gets an ENOSPC on a write() and ends plus I
> don't see the softwatchdog timer dump the kernel stack or xfssyncd
> looping. Thanks!

Works here too. Tried on three different file system configurations (sizes=
=20
and numbers of AGs). I ran only simple tests though, but at least it fixes=
=20
the obvious test case. Ideally I'd like to run some stress test involving=
=20
NFS service, but I won't be able to make time for that in the very near=20
future.

Thanks!
---1463763711-925634831-1156857947=:5262--
