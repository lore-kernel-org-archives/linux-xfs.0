Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36790 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953698AbdDZNUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 09:20:34 -0400
Received: by mail-vk0-f53.google.com with SMTP id q78so71001056vke.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 06:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <733e160e-3556-44f6-b4b9-5413851e9591@sandeen.net>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-3-jtulak@redhat.com>
 <cbd1b9d4-9675-6cd8-7c39-e60758c63a06@sandeen.net> <CACj3i709VGwk94VjywbaUBkug_CvdqSP2TmbS9t_3te7LxFhyg@mail.gmail.com>
 <733e160e-3556-44f6-b4b9-5413851e9591@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 15:20:12 +0200
Message-ID: <CACj3i72Ts17WsP=UPtOXMj+7Mo=Wj2DwnO=0S7+B4JkWWubDWQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] mkfs: rename defaultval to flagval in opts
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 3:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/26/17 2:30 AM, Jan Tulak wrote:
>> On Tue, Apr 25, 2017 at 6:52 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>
>>> i.e. I'd argue that a bare boolean flag specification should /always/
>>> enable the feature.  At that point, you can say within your code
>>> "if min = 0 and max = 1, this is a boolean, and the flag may be specified
>>> without a value, in which case the value is set to 1, and the feature
>>> is enabled."
>>>
>>> At that point you don't need this extra structure member, and you won't
>>> have to re-state it 56 times, thus simplifying the code.
>>>
>>> What do you think?  I'd happily review and merge 2 patches, which:
>>>
>>> 1) Makes rmapbt and reflink behave like every other boolean flag, and
>>>
>> This sounds reasonable.
>>
>>> 2) Removes "defaultval" altogether, and uses min=0/max=1 as a sign that
>>>    the option is a boolean, with a bare flag name allowed to enable it.
>>>
>> I wonder if a .is_flag = true (and no other min/max/defaultval...)
>> wouldn't be better solution. the min=0/max=1 detection is a bit
>> implicit and may not be apparent in the future. If we limit flags to
>> 0/1 values, then defaultval can be removed either way, but it is clear
>> on the first glance what the option does.
>
> Well, yes, it is implicit - but an option with a minimum 0 and maximum 1
> can be interpreted no other way, IMHO.  You could document it as such
> for clarity.  But I can see the value in a single "is_flag" marker
> I suppose.
>
> If you want to start typing options, you may want to consider also
> adding .is_string, and then check the option against these
> rules in getnum and getstr - i.e. if is_flag or is_string are set,
> then minval, maxval, is_power_2 must not not set, etc, so the
> developer can't get it wrong.
>
> We'd end up with something like this:
>
>                 { .index = D_FILE,
>                   .conflicts = { LAST_CONFLICT },
>                   .is_flag = 1,
>                 },
>                 { .index = D_NAME,
>                   .conflicts = { LAST_CONFLICT },
>                   .is_string = true,
>                 },
>
> which seems reasonable to me.
>

Well, the actual code will be something like this:

                { .index = D_FILE,
                  .conflicts = { LAST_CONFLICT },
                  .type = BOOL,
                },
                { .index = D_NAME,
                  .conflicts = { LAST_CONFLICT },
                  .type = STRING,
                },

because I already have patches that adds type (if you remember the
union stuff from my last big set). I just didn't realised I have this
code just waiting for some rebase and fixes when I wrote the reply.

So for now, I will keep this as it is and once the type is introduced,
the defaultval can be removed.

Cheers,
Jan

> Thanks,
> -Eric



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
