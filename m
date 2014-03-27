Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED3CE7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 15:57:44 -0500 (CDT)
Message-ID: <533490C9.3010703@sgi.com>
Date: Thu, 27 Mar 2014 15:57:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs errors while unlinking filenames with hash collisions
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<5334241E.9060708@sgi.com>
	<20140327132354.GU29498@order.stressinduktion.org>
	<533428D6.507@sgi.com>
	<20140327140556.GW29498@order.stressinduktion.org>
	<53344075.8050607@sgi.com>
	<20140327152448.GE29498@order.stressinduktion.org>
In-Reply-To: <20140327152448.GE29498@order.stressinduktion.org>
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
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: xfs@oss.sgi.com

On 03/27/14 10:24, Hannes Frederic Sowa wrote:
> On Thu, Mar 27, 2014 at 10:15:01AM -0500, Mark Tinguely wrote:
>> On 03/27/14 09:05, Hannes Frederic Sowa wrote:
>>> On Thu, Mar 27, 2014 at 08:34:14AM -0500, Mark Tinguely wrote:
>>>> On 03/27/14 08:23, Hannes Frederic Sowa wrote:
>>>>> On Thu, Mar 27, 2014 at 08:14:06AM -0500, Mark Tinguely wrote:
>>>>>> Have you tried to run a xfs_repair on the filesystem after the reboot?
>>>>>
>>>>> Yes, I did. I still use the filesystem and it works. As soon as I try to
>>>>> remove the directory again the same splash from above happens again.
>>>>
>>>> Is it the latest xfsprogs' repair?
>>>>
>>>> Do you have the output from the repair still?
>>>
>>> I can easily test this here, so you can throw any commands and tests at
>>> me. ;)
>>>
>>> This is the output:
>>>
>>> (I replayed the journal before that)
>>>
>>> pre-mount:/# xfs_repair -V
>>> xfs_repair version 3.1.11
>>> pre-mount:/# xfs_repair -v /dev/vda1
>>> Phase 1 - find and verify superblock...
>>>          - block cache size set to 372848 entries
>>> Phase 2 - using internal log
>>>          - zero log...
>>> zero_log: head block 5071 tail block 5071
>>>          - scan filesystem freespace and inode maps...
>>>          - found root inode chunk
>>> Phase 3 - for each AG...
>>>          - scan and clear agi unlinked lists...
>>>          - process known inodes and perform inode discovery...
>>>          - agno = 0
>>> bad hash ordering in block 8388739 of directory inode 3543184
>>
>> interesting. I will see if I can recreate it.
>>
>> Are you open to making it an xfstest?
>
> Sure, I'll put it on my todo list for the weekend.
>
> Thanks,
>
>    Hannes

I will bisect to find the introduction. It appears be somewhere between 
Linux 3.9 and 3.10.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
