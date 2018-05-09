Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933134AbeEIBdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 21:33:03 -0400
Subject: Re: [PATCH 21/21] xfsprogs: implement the upper half of parent
 pointers
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-22-git-send-email-allison.henderson@oracle.com>
 <f31ce664-7173-7b99-7d65-39abd810a372@sandeen.net>
 <20180508230405.GA11261@magnolia>
 <f2a34921-e4e5-3976-675d-8b9b17429358@oracle.com>
 <20180509012215.GC11261@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7006b87f-ead3-f4d3-15c6-6b56ff5662bd@oracle.com>
Date: Tue, 8 May 2018 18:32:58 -0700
MIME-Version: 1.0
In-Reply-To: <20180509012215.GC11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org



On 05/08/2018 06:22 PM, Darrick J. Wong wrote:
> On Tue, May 08, 2018 at 04:13:49PM -0700, Allison Henderson wrote:
>>
>>
>> On 05/08/2018 04:04 PM, Darrick J. Wong wrote:
>>> On Tue, May 08, 2018 at 03:52:37PM -0500, Eric Sandeen wrote:
>>>> On 5/7/18 11:41 PM, Allison Henderson wrote:
>>>>> From: "Darrick J. Wong" <darrick.wong@oracle.com>
>>>>>
>>>>> Add ioctl definitions to libxfs, build the necessary helpers into
>>>>> libfrog and libhandle to iterate parents (and parent paths), then wire
>>>>> up xfs_scrub to be able to query parent pointers from userspace.  The
>>>>> goal of this patch is to exercise userspace, and is nowhere near a
>>>>> complete solution.  A basic xfs_io parent command implementation
>>>>> replaces ... whatever that is that's there now.
>>>>
>>>> I wonder if it'd be better to send a patch to nuke the current parent code,
>>>> and then another to add back something that works.  Same result in the end,
>>>> but it doesn't look like you're trying to fix old code; the patch itself is
>>>> pretty meaningless since it diffs against nonfunctional(?) code.
>>>
>>> Trouble is, it's exported as a shared library in the xfslibs-dev package
>>> (should that be libxfs-dev?) so depending on how conservative you like
>>> to be we can't just rip it out.
>>>
>>> (Though I suppose even Linus has occasionally allowed people to rip and
>>> replace kernel/user ABIs when they can demonstrate that it was so broken
>>> it never worked for anybody, ever. :P)
>>>
>>>> Not a huge deal, just a thought.
>>>
>>> Yeah, this patch was quite quick and dirty when I wrote it, on the
>>> assumption that tons of other stuff was going to need reorganization by
>>> the time there was a need to land this.
>>>
>>> --D
>>
>> Oh, would you prefer I not include it then?  I do have an xfstest that's
>> using it, but it's not a giant gap to close.  I just assumed you probably
>> had a reason for the api you set up. :-)
> 
> I prefer my new APIs.  None of this parse my way through variable-length
> records in a buffer crap, just call my callback function for every pptr
> you find.  But I might be biased. :)
> 
> Let's have a look at what we'd be killing off:
> 
>> typedef struct parent {
>> 	__u64	p_ino;
>> 	__u32	p_gen;
>> 	__u16	p_reclen;
>> 	char	p_name[1];
>> } parent_t;
>>
>> typedef struct parent_cursor {
>> 	__u32	opaque[4];      /* an opaque cookie */
>> } parent_cursor_t;
>>
>> extern int
>> jdm_parents( jdm_fshandle_t *fshp,
>> 		xfs_bstat_t *statp,
>> 		struct parent *bufp, size_t bufsz,
>> 		unsigned int *count);
>>
>> extern int
>> jdm_parentpaths( jdm_fshandle_t *fshp,
>> 		xfs_bstat_t *statp,
>> 		struct parent *bufp, size_t bufsz,
>> 		unsigned int *count);
> 
> I suppose it wouldn't be hard to emulate these with the other code, but
> do we care?
> 
> --D
Alrighty, I can clean those in the next revision then.

Allison
> 
>>
>>>
>>>> -Eric
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=ZYhT49wgnXi-BAqQb6XvZtIJlZmC9-GTIfYkkgzS3x8&s=oDk5xa1iaNp87c2xfX0TDTQc9Hs9-RraSgWXeoZvQkU&e=
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=ZYhT49wgnXi-BAqQb6XvZtIJlZmC9-GTIfYkkgzS3x8&s=oDk5xa1iaNp87c2xfX0TDTQc9Hs9-RraSgWXeoZvQkU&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=ZYhT49wgnXi-BAqQb6XvZtIJlZmC9-GTIfYkkgzS3x8&s=oDk5xa1iaNp87c2xfX0TDTQc9Hs9-RraSgWXeoZvQkU&e=
> 
