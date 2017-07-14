Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdGNTO6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 15:14:58 -0400
Subject: Re: Parent pointers
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
 <20170714190740.GA43494@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <51235072-79ab-05b6-f73a-8945055107d6@sandeen.net>
Date: Fri, 14 Jul 2017 14:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <20170714190740.GA43494@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, cmaiolino@redhat.com, linux-xfs@vger.kernel.org

On 07/14/2017 02:07 PM, Brian Foster wrote:
> On Fri, Jul 14, 2017 at 01:46:27PM -0500, Eric Sandeen wrote:
>> On 07/14/2017 12:44 PM, Allison Henderson wrote:
>>> On 7/14/2017 7:04 AM, Eric Sandeen wrote:
>>>>
>>>>
>>>> On 07/14/2017 03:50 AM, Carlos Maiolino wrote:
>>>>> Hi,
>>>>>
>>>>> On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> I've been doing some digging on adding parent pointers to xfs and wanted to
>>>>>> send a note to folks here to get peoples opinions on it.
>>>>>
>>>>> Are you talking about parent pointers in the BTrees?
>>>>>
>>>>
>>>> No, see [RFC 00/17] RFC parent inode pointers. for example, from long
>>>> ago.
>>>>
>>>> "Parent inode support allow XFS to quickly derive a file name and
>>>> path from the mount point. This can aid in directory/path policies
>>>> and can help relocate items during filesystem shrink."
>>>>
>>>> It has a long and ... difficult history.
>>>>
>>>> -Eric
>>> Right, so to expand on Eric's answer, it looks like Dave and Brian had been working on some improvements based on that set, but it's not quite finished yet.  The idea is that we add an extended attribute to keep track of the parents inode and generation, and also the child entries offset, and filename. So in this solution the EA is name={parent inode #, parent inode generation, dirent offset}, value={dirent filename}.
>>>
>>> My goal at the moment is just to get it compiling again and finish out some of the sub routines that maintain it.  It looks like it hasn't had much attention in a while, so I wanted to let people know the direction I'm planning to move in before I get too far in.
>>
>> If you're forward-porting that 17-patch set from Mark, I'd suggest first reading Dave's
>> response to it - IIRC it amounted to a firm NAK.  it also highlights the complexity
>> of this undertaking, and may explain why nobody has gotten it done (yet) :)
>>
> 
> The patches that came from me (to Allison) were last sent to me directly
> from Dave. 

Oh, ok.  I didn't know we were talking about off-list patches, sorry if I
missed that.  I thought Allison was looking at the 17-patch series on the list,
and wanted to make sure this wouldn't be a false start.  :)

Thanks,
-Eric
