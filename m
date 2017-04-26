Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:32986 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1957236AbdDZIxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 04:53:13 -0400
Received: by mail-oi0-f48.google.com with SMTP id y11so168910440oie.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 01:53:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dbdfd755-93df-5d61-ab6b-534a00b365d8@sandeen.net>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-6-jtulak@redhat.com>
 <20170425031326.GI28800@wotan.suse.de> <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
 <20170426011038.GR28800@wotan.suse.de> <dbdfd755-93df-5d61-ab6b-534a00b365d8@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 10:52:52 +0200
Message-ID: <CACj3i70RCEt2hf_CLQFwQmS1epymg=xgVxjZ20AwAxw_n2OjNA@mail.gmail.com>
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 4:50 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/25/17 8:10 PM, Luis R. Rodriguez wrote:
>> On Tue, Apr 25, 2017 at 10:04:39AM +0200, Jan Tulak wrote:
>>> On Tue, Apr 25, 2017 at 5:13 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>>> On Sun, Apr 23, 2017 at 08:54:56PM +0200, Jan Tulak wrote:
>>>>
>>>>> and anything you write here now is
>>>>> + *     overwritten if user specifies the subopt. (If the user input is a string
>>>>> + *     and not a number, this value is set to a positive non-zero number.)
>>>>> + *
>>>>>   * !!! NOTE ==================================================================
>>>>>   *
>>>>>   * If you are adding a new option, or changing an existing one,
>>>>> @@ -152,6 +158,7 @@ struct opt_params {
>>>>>               uint64_t        maxval;
>>>>>               uint64_t        flagval;
>>>>>               const char      *raw_input;
>>>>> +             uint64_t        value;
>>>>>       }               subopt_params[MAX_SUBOPTS];
>>>>>  } opts[MAX_OPTS] = {
>>>>>  #define OPT_B        0
>>>>
>>>> It would seem rather unfair to define this this but not use it in the patch ?
>>>
>>> I'm still trying to find out when exactly should I make something two
>>> patches and when one, and it seems to shift case by case... I tried to
>>> separate the adding of new things and rewriting of the existing code,
>>> but do you think, in this case, the new thing is too trivial to have a
>>> standalone patch?
>>
>> Ah, I see, this was split out to be separate given a slew of subopts in turn
>> later use it. The nasty alternative for review would be to have all subopts
>> converted in one shot. I suppose a middle ground would be to have this patch
>> squashed with just one of the subopt users, and then each other subopt ported
>> atomically. That would make the addition of the value and definition in effect
>> as soon as its added.
>>
>> Just my 0.02 CRC but its up to Eric as this is rather subjective and tree dependent.
>
> I think the way Jan did this is fine.  Ideally the commit would explain a bit more,
> i.e. "This patch simply adds the value field.  Subsequent patches will utilize
> this new field."
>
> Then the reviewers know what to expect from the start, and we avoid the back and
> forth of figuring out why it was done as it was done.  ;)
>
> However, I think 5 & 6 could easily be combined - add the field and the routines
> to manipulate it, /then/ start adding users of that new infrastructure.
>
> I haven't really reviewed from here on out yet, but from a "how should I break
> up patches" point of view, that's my ... $0.02.  :)
>

Yeah, that sounds reasonable, I'm squashing it for the next version
(and adding the notice).

Jan


-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
