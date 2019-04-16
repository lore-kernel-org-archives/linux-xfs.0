Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52464 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfDPBdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 21:33:54 -0400
Subject: Re: [PATCH 1/9] xfs: Remove all strlen in all xfs_attr_* functions
 for attr names.
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-2-allison.henderson@oracle.com>
 <20190414230259.GE29573@dread.disaster.area>
 <c2ef788f-223c-a31d-566b-f3c185ff0a06@oracle.com>
 <20190415211851.GF29573@dread.disaster.area>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <da0b34c1-cc7c-dd9a-81b3-667e61c2de1c@oracle.com>
Date: Mon, 15 Apr 2019 18:33:48 -0700
MIME-Version: 1.0
In-Reply-To: <20190415211851.GF29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 4/15/19 2:18 PM, Dave Chinner wrote:
> On Mon, Apr 15, 2019 at 01:08:50PM -0700, Allison Henderson wrote:
>> On 4/14/19 4:02 PM, Dave Chinner wrote:
>>> On Fri, Apr 12, 2019 at 03:50:28PM -0700, Allison Henderson wrote:
>>>> This helps to pre-simplify the extra handling of the null terminator in
>>>> delayed operations which use memcpy rather than strlen.  Later
>>>> when we introduce parent pointers, attribute names will become binary,
>>>> so strlen will not work at all.  Removing uses of strlen now will
>>>> help reduce complexities later
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Hmmm. If we are going to pass name/namelen pairs around everywhere,
>>> can we convert these to a struct xfs_name?
>>>
>>> I also wonder where we should convert the name/namelen pairs in the
>>> attr args struct to an xfs_name, too, then we can just do:
>>>
>>> 	args->name = *name;
>>>
>>> to copy in the string pointer and the name length in one go.
>>>
>>> And we might even be able to put the attribute flags (e.g.
>>> ATTR_ROOT) in the name.type field, and get rid of that parameter
>>> being passed around, too...
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> I think a new struct xfs_name is reasonable.  Or maybe a general purpose
>> xfs_array?  The value/valuelen parameters have a similar relation that could
>> make use of that too.  How would people feel about something like this:
>>
>> struct xfs_array {
>> 	unsigned char *bytes;
>> 	size_t		len;
>> }
>>
>> struct xfs_attribute {
>> 	struct xfs_array	name;
>> 	int			flags;
>> }
> 
> Hmmm. I think that's overkill - we really don't need that much
> abstraction and it makes the code more complex rather than
> simplifies it. i.e. args->name.name.bytes isn't really a
> simplification...
> 
> Also the above means we have to discard the const part of the names
> we are passed because this construction doesn't appear to be
> intended for read only strings. i.e.:
> 
>> We could add the value member in here too.
> 
> Which is something that isn't const. :)
> 
>> It tends to get passed around
>> just as much with the exception of attr remove operations which only need
>> the name.  I think changing the actual members of xfs_da_args should be
>> another patch though, since that's a bigger change that affects a wider
>> scope of code.  I can look into it though.
> 
> I don't think we want anything more complex or to extent it to
> include other parts of the attr API - that just means we have a
> special snowflake for the API rather than a generic way of encoding
> a name string across all the internal interfaces that space a name/len
> pair...
> 
> Really, I was just suggesting using the struct xfs_name because
> it already exists and encodes/documents exactly what we are passing
> here, hence getting rid of some of the mess around passing the attr
> names around.

Oh I see.  I thought you were suggesting a new struct, I didnt realize 
it was already there.  That makes sense then.  :-)

> 
>> Also, do I still keep the old reviewed-by on the patch if the patch is still
>> going through changes?  I have a few signed-off patches in the parent
>> pointer set that have changed quite a bit since we've started too.
> 
> If the changes are significant, then it needs review again and so
> you should drop it.
> 
> But I'd do the name/len -> xfsname conversion as a separate patch,
> so this patch doesn't need changing.

Alrighty, I will add in another patch that does that then.

Thanks!
Allison

> 
> Cheers,
> 
> Dave.
> 
