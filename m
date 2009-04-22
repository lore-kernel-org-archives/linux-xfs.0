Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3M2ZglQ166069 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 21:35:42 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73E0430405F
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 19:35:39 -0700 (PDT)
Message-Id: <53FCDA81-0C62-4B16-AAA7-C2FF03C78D01@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49EE81DB.7040304@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
Date: Tue, 21 Apr 2009 21:35:38 -0500
References: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>	<49B9611F.5040009@sandeen.net>	<58707.24.80.224.145.1236899620.squirrel@squirrel.kevinjamieson.com>
	<53630.24.80.224.145.1240361692.squirrel@squirrel.kevinjamieson.com>
	<49EE7E17.8050006@sandeen.net>
	<B32B0133-B835-4D31-B52A-364F607B9866@sgi.com>
	<49EE81DB.7040304@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Apr 21, 2009, at 9:32 PM, Eric Sandeen wrote:

> Felix Blyakher wrote:
>> On Apr 21, 2009, at 9:16 PM, Eric Sandeen wrote:
>>
>>> Kevin Jamieson wrote:
>>>> On Thu, March 12, 2009 4:13 pm, Kevin Jamieson wrote:
>>>>> On Thu, March 12, 2009 12:23 pm, Eric Sandeen wrote:
>>>>>
>>>>>> For SLES that usually is the best route...
>>>>>>
>>>>>> However, http://oss.sgi.com/archives/xfs/2009-02/msg00220.html
>>>>>> looks
>>>>>> applicable... don't think it ever got merged though.
>>>>>>
>>>>>> perhaps you could test it?
>>>>> Thanks, Eric. I will test Lachlan's patch on our system.
>>>> To follow this up, since applying the patch from the above thread
>>>> there
>>>> have been no re-occurrences of the issue on our test servers over
>>>> the past
>>>> month.
>>> And you hit it pretty reliably before, right?  Sounds like we need  
>>> to
>>> give that a pretty strong eyeball and get it merged, perhaps.
>>
>> I was looking at this patch too.
>> But I could never reproduce the problem, even with Lachlan's test
>> program. Kevin, any idea what kind of io load triggered this problem?
>> The patch looks right, but I really want to prove the problem
>> exists, and the patch addresses it.
>>
>> Felix
>>
>
> FWIW I can't reproduce either, with the stated commandline.
>
> Should try it with a 1k blocksize, though - maybe Lachlan tested 4k on
> 16k page ia64?

That's what I've tested on.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
