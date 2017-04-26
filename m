Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48350 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1434583AbdDZCAm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 22:00:42 -0400
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
 <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
 <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net>
 <20170426013815.GS28800@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ef444d22-6251-c611-9c1e-106f7bbe4e0f@sandeen.net>
Date: Tue, 25 Apr 2017 21:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <20170426013815.GS28800@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/25/17 8:38 PM, Luis R. Rodriguez wrote:
> On Tue, Apr 25, 2017 at 08:28:23AM -0500, Eric Sandeen wrote:
>> On 4/25/17 2:45 AM, Jan Tulak wrote:
>>> On Tue, Apr 25, 2017 at 5:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>>> On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
>>>>> Merge separate instances of opt_params into one indexable table. Git
>>>>> makes this patch looks a bit more complicated, but it does not change
>>>>> values or structure of anything else. It only moves all the "struct
>>>>> opt_params dopts = {...}", changes indentation for these substructures
>>>>> and replaces their usage (dopts -> opts[OPT_D]).
>>>>>
>>>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>>>> ---
>>>>>  mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
>>>>>  1 file changed, 683 insertions(+), 633 deletions(-)
>>>>>
>>>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>>>> index 7a72b11..513e106 100644
>>>>> --- a/mkfs/xfs_mkfs.c
>>>>> +++ b/mkfs/xfs_mkfs.c
>>>>> @@ -42,6 +42,7 @@ static int  ispow2(unsigned int i);
>>>>>  uint64_t             blocksize;
>>>>>  uint64_t             sectorsize;
>>>>>
>>>>> +#define MAX_OPTS     16
>>>>
>>>> This is fragile, every time a new opt is added this needs to be updated
>>
>> <pedantic>There are only 8 now, so there are still 8 free slots</pedantic>
>>
>>>> and so is the index, and we should be pedantic over not going out of bounds.
>>>> We could instead use a flexible array and compute the max opts at run time
>>>> as a global. This way the max opts is always updated automatically.
>>
>> I don't think it's all that fragile;
> 
> We can avoid such compilation warnings.

Well, post the proposed patch when appropriate, and it can go through review.

...

>> In any case, any changes around this behavior would certainly
>> be part of a different patch, because you'd want to be consistent with all
>> the other structure initializers, and it would be a functionally separate
>> change if it is warranted at all.
> 
> The opt_params are separate today though, this patch folds them in together,
> what I propose is just to use a flexible array to avoid an explicit size
> from the start. Not sure how much more functional of a change that is ?

Because it'd be inconsistent with the other array declarations.

Prior to this patch we had 2 #defines to declare sizes of global
arrays:

#define MAX_SUBOPTS	16
	const char	*subopts[MAX_SUBOPTS];
	}		subopt_params[MAX_SUBOPTS];

#define MAX_CONFLICTS	8
		int		conflicts[MAX_CONFLICTS];

now we add a third:

#define MAX_OPTS	16
} opts[MAX_OPTS] = {

If you're not a fan of #defines to size global arrays that's ok, but
let's be consistent and change them all at once, and not change one
of the 3 as a side-effect of collapsing the separate opts structures
into one.

For now, let's follow the pattern of the existing code, and submit a 
comprehensive functional patch to address this separate change.

Small, reviewable, distinct, functional changes.

Thanks,
-Eric
