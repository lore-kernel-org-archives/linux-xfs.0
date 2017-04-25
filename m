Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34785 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938509AbdDYJjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 05:39:22 -0400
Received: by mail-vk0-f53.google.com with SMTP id k4so49524132vki.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2017 02:39:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-6-jtulak@redhat.com>
 <20170425031326.GI28800@wotan.suse.de> <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 25 Apr 2017 11:39:00 +0200
Message-ID: <CACj3i71JaxqjZ_qUvZSOu6gTeZhjm86VfA2asNZNppV2t6_wDA@mail.gmail.com>
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

v

On Tue, Apr 25, 2017 at 10:04 AM, Jan Tulak <jtulak@redhat.com> wrote:
> On Tue, Apr 25, 2017 at 5:13 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> On Sun, Apr 23, 2017 at 08:54:56PM +0200, Jan Tulak wrote:
>>> Add a new field int opt_params - value,
>>
>> Agreed.
>>
>>> which is filled with user input.
>>
>> It sounds to me its more than that, its the default value which will be used should
>> not user input for the option be specified, and if user input value is provided it
>> will be the passed user input value. If the final value for the respective option.
>>
>> ?
>
> Yes. I see I should make the description better, both here in commit
> message and in the code too. It is the same logic as it was for the
> old variables like agcount in main(). Initialize it with whatever you
> want as the default for pure "mkfs.xfs /some/dev", but if the users
> give us the specific option, we are going to overwrite it with their
> value.
>
> I don't see any use for remembering the defaults once it is clear that
> user wants to use custom values instead. And copying the defaults from
> some other field "if the user said nothing" sounds like a recipe for
> bugs...
>

And rather than submitting repeatedly new versions of the whole
patch... how about this?

 *
 *   value OPTIONAL
 *     The actual value used in computations and for creating the filesystem.
 *     It is filled with user input and anything you write here now is
 *     overwritten if the user specifies the subopt. But he does not,
then whatever
 *     you put there is used as the default. Can be omitted if the default
 *     is 0.
 *     (If the field is a string and not a number, this value is set to
 *     a positive non-zero number on an user input.)

And for the commit message, a bit shortened version:

Add a new field int opt_params - value - which is the actual value
used in computations and for creating the filesystem. It is filled
with user input if the user specifies the subopt. But he does not,
then whatever you put there is used as the default.

Sounds better?

>>
>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>> ---
>>>  mkfs/xfs_mkfs.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 513e106..c2ffd91 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -128,6 +128,12 @@ uint64_t         sectorsize;
>>>   *     Filled raw string from the user, so we never lose that information e.g.
>>>   *     to print it back in case of an issue.
>>>   *
>>> + *   value OPTIONAL
>>> + *     The value that is to be used if the given subopt is not specified at all.
>>
>> It seems to be more than that ?
>>
>>> + *     This is filled with user input
>>
>> This is a bit confusing, isn't it first the default value should no user input
>> value be passed ? And finally if user input value is passed only then will this
>> be that value ?
>>
>>> and anything you write here now is
>>> + *     overwritten if user specifies the subopt. (If the user input is a string
>>> + *     and not a number, this value is set to a positive non-zero number.)
>>> + *
>>>   * !!! NOTE ==================================================================
>>>   *
>>>   * If you are adding a new option, or changing an existing one,
>>> @@ -152,6 +158,7 @@ struct opt_params {
>>>               uint64_t        maxval;
>>>               uint64_t        flagval;
>>>               const char      *raw_input;
>>> +             uint64_t        value;
>>>       }               subopt_params[MAX_SUBOPTS];
>>>  } opts[MAX_OPTS] = {
>>>  #define OPT_B        0
>>
>> It would seem rather unfair to define this this but not use it in the patch ?
>
> I'm still trying to find out when exactly should I make something two
> patches and when one, and it seems to shift case by case... I tried to
> separate the adding of new things and rewriting of the existing code,
> but do you think, in this case, the new thing is too trivial to have a
> standalone patch?
>
> Jan
>
>>
>>   Luis
>
>
>
> --
> Jan Tulak
> jtulak@redhat.com / jan@tulak.me



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
