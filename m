Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37310 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752528AbdKNUy4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 15:54:56 -0500
Subject: Re: [PATCH v3 2/2] fiemap: Implement ranged query
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
 <1510588073-5665-2-git-send-email-nborisov@suse.com>
 <20171113214457.GX4094@dastard>
 <e97f774f-a3ae-04c0-4b74-6a4f26e72674@suse.com>
 <3491ce98-b744-90de-e01b-83f13abadfa9@sandeen.net>
 <6619a7bc-ecc1-b8aa-82d0-1747ee812463@suse.com>
 <bbfdb7c8-81a7-0a42-ccfc-003f3b89de9b@sandeen.net>
 <20171114205226.GB4094@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <16c5de37-f9ad-a55b-c32d-388bb75a938d@sandeen.net>
Date: Tue, 14 Nov 2017 14:54:54 -0600
MIME-Version: 1.0
In-Reply-To: <20171114205226.GB4094@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com



On 11/14/17 2:52 PM, Dave Chinner wrote:
> On Tue, Nov 14, 2017 at 07:31:34AM -0600, Eric Sandeen wrote:
>>
>>
>> On 11/14/17 12:32 AM, Nikolay Borisov wrote:
>>>
>>>
>>> On 14.11.2017 00:22, Eric Sandeen wrote:
>>>> On 11/13/17 4:05 PM, Nikolay Borisov wrote:
>>
>> ...
>>
>>>>> You are right this is a bit ugly, but it seems more consistend to me,
>>>>> rather than something like
>>>>>
>>>>> xfs_io -c "fiemap -r -n 10 -v 4k 10k" for example. And the reason why
>>>>> I'm using this hackish way and not declaring r as r: in getopt is
>>>>> because getopt doesn't recognise when a parameter takes more than 1
>>>>> argument.
>>>>
>>>> Sorry for chiming in so late after all the go-rounds, but:
>>>>
>>>> Why not just drop -r entirely, and make fiemap go into ranged mode iff a
>>>> range is specified at the end of the command, i.e.:
>>>>
>>>> fiemap [ -alv ] [ -n nx ] [ offset length ]
>>>
>>> V2 was like that but it required some changing to the generic code which
>>> detects the presence of this feature and Dave objected hence v3.
>>
>> Ok, sorry for being so behind and rehashing old discussions.  Let me look
>> at that.
> 
> I suggested "-r" because of the fact that you can't detect optional
> parameters in fstests without jumping through really nasty hoops
> involving regex line noise.

Yeah, but I'd rather have nasty stuff in xfstests than in xfsprogs interfaces.
 
See also my suggestion to try mapping past EOF as a detection method.

-Eric

> Cheers,
> 
> Daves.
> 
