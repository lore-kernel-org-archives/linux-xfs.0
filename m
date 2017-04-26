Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49292 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3000006AbdDZNCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 09:02:46 -0400
Subject: Re: [PATCH 02/12] mkfs: rename defaultval to flagval in opts
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-3-jtulak@redhat.com>
 <cbd1b9d4-9675-6cd8-7c39-e60758c63a06@sandeen.net>
 <CACj3i709VGwk94VjywbaUBkug_CvdqSP2TmbS9t_3te7LxFhyg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <733e160e-3556-44f6-b4b9-5413851e9591@sandeen.net>
Date: Wed, 26 Apr 2017 08:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i709VGwk94VjywbaUBkug_CvdqSP2TmbS9t_3te7LxFhyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/26/17 2:30 AM, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 6:52 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 4/23/17 1:54 PM, Jan Tulak wrote:
>>> The old name 'defaultval' was misleading - it is not the default value,
>>> but the value the option has when used as a flag by an user.
>>
>> The value should only ever be 0 or 1, correct?
> 
> Not necessarily. I think we are not using anything else, but
> technically, it is possible to have any number here. I admit it is
> hard to came up with any useful case for what we have in mkfs, though.

Then let's just declare it to be so.  ;)
 
>>
>> Ok, so I see something interesting here:
>>
>> # grep "flagval = " mkfs/xfs_mkfs.c | sort | uniq -c
>>       1                           .flagval = 0,
>>       1                         .flagval = 0,
>>      14                           .flagval = 1,
>>      40                           .flagval = SUBOPT_NEEDS_VAL,
>>
>> of the 56 subopts, only 16 are treated as a flag, and only 2 default
>> to 0, while the rest default to 1.
>>
>> Those 2 seem like outliers: -m rmapbt and -m reflink.  What's
>> going on there?
>>
>> In every other case where there is a subopt which is actually a
>> boolean flag, a bare specification without a value means "enable
>> the feature."
>>
>> It seems very unintuitive to have:
>>
>> -X THING1 -> THING1 is enabled 14 times, but
>> -X THING12 - THING2 is still /disabled/ in only 2 cases
>>
>> I'd argue that "-m rmapbt" and "-m reflink" leaving those features
>> /disabled/ is a bug, due to misunderstanding of what "defaultval"
>> means, and that they should be fixed to behave like the other 14
>> boolean flags.
> 
> I agree. It looks this way...
> 
>>
>> i.e. I'd argue that a bare boolean flag specification should /always/
>> enable the feature.  At that point, you can say within your code
>> "if min = 0 and max = 1, this is a boolean, and the flag may be specified
>> without a value, in which case the value is set to 1, and the feature
>> is enabled."
>>
>> At that point you don't need this extra structure member, and you won't
>> have to re-state it 56 times, thus simplifying the code.
>>
>> What do you think?  I'd happily review and merge 2 patches, which:
>>
>> 1) Makes rmapbt and reflink behave like every other boolean flag, and
>>
> This sounds reasonable.
> 
>> 2) Removes "defaultval" altogether, and uses min=0/max=1 as a sign that
>>    the option is a boolean, with a bare flag name allowed to enable it.
>>
> I wonder if a .is_flag = true (and no other min/max/defaultval...)
> wouldn't be better solution. the min=0/max=1 detection is a bit
> implicit and may not be apparent in the future. If we limit flags to
> 0/1 values, then defaultval can be removed either way, but it is clear
> on the first glance what the option does.

Well, yes, it is implicit - but an option with a minimum 0 and maximum 1
can be interpreted no other way, IMHO.  You could document it as such
for clarity.  But I can see the value in a single "is_flag" marker
I suppose.

If you want to start typing options, you may want to consider also
adding .is_string, and then check the option against these
rules in getnum and getstr - i.e. if is_flag or is_string are set,
then minval, maxval, is_power_2 must not not set, etc, so the
developer can't get it wrong.

We'd end up with something like this:

                { .index = D_FILE,
                  .conflicts = { LAST_CONFLICT },
                  .is_flag = 1,
                },
                { .index = D_NAME,
                  .conflicts = { LAST_CONFLICT },
                  .is_string = true,
                },

which seems reasonable to me.

Thanks,
-Eric
