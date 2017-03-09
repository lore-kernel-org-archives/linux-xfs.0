Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35827 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754526AbdCIPXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 10:23:08 -0500
Received: by mail-io0-f180.google.com with SMTP id z13so30437691iof.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2017 07:22:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8d1ab201-79f1-1311-39f0-24eb994892ab@sandeen.net>
References: <20170303231316.12716-1-mcgrof@kernel.org> <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de> <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <CACj3i73W8=vPZHHUMSvU-V=28NxaUmmn41rbG7bQ0JA+8ZKv8Q@mail.gmail.com> <8d1ab201-79f1-1311-39f0-24eb994892ab@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 9 Mar 2017 16:21:58 +0100
Message-ID: <CACj3i70a9W8ufqVueoG0J3k6mXN805UxctOD9f0bSobw+6Phzg@mail.gmail.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Thu, Mar 9, 2017 at 3:31 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/9/17 4:12 AM, Jan Tulak wrote:
>> Hi,
>>
>> Eric, thanks for pinging me, I wanted to look at this and forgot... :-/
>>
>> First of all, this patchset has a lot of common with my advanced
>> conflict checking patchset. And AFAIK, if my patchset was already in
>> place, this set could be reduced to one new function that loads the
>> file and changes the default values in a structure.
>>
>> See this http://www.spinics.net/lists/linux-xfs/msg02728.html
>
> Still on the todo :( ;)
>
>> I wanted to fix the few mentioned issues I got for that RFC and submit
>> it this week, but with the flu I got, I'm doing things that don't
>> cause me a headache when I spread my mind over too many LOC at once.
>> :-) And now, looking at this, I would like to go through this patchset
>> in more detail and see if you (Luis) got some things better than me
>> before I send it, so it will take some more time.
>>
>> Some other info is bellow between quotes.
>
> ...
>
>>>>> # mkfs.xfs -m crc=1 -m crc=0 -f fsfile
>>>>> -m crc option respecified
>>>>> Usage: mkfs.xfs
>>>>
>>>> This was dealt by enabling the last option taken to override, and
>>>> this mechanism was also taken to enable the config file to take
>>>> the first value but let the command line to override. Refer to
>>>> usage of reset_opt(). Granted I had only done this on B_LOG but
>>>> this can easily be made to enable us to reset for all options.
>>>
>>> Well, the above test was with your full patchset applied,
>>> so my point is that it's not currently working properly as posted...
>>>
>>> But are you proposing adding this reset_opt() to /every/ option?
>>> That would undo all of the respecification checks, which were
>>> put there for a reason (I assume?) ;)  I don't really remember
>>> how all of the respecification and compatibility checking works
>>> tbh, I'd have to dig back into it.  Maybe jtulak can help...
>>>
>>> But it makes little sense to have a framework to prevent
>>> respecification but then render it useless with reset_opt()
>>> after each option gets parsed.  Or do I misunderstand?
>>
>> The reason why respec is forbidden (other than "what the hell the user
>> wants, or is this a typo?" which could be decided as "simply take the
>> last one, it's a feature") is that some options depend on other ones
>> in "must be specified first" way. What should we do if we get -b
>> size=X -d size=1000b -b size=Y? Values are parsed at the time of their
>> occurrence, so suddenly, we have size in blocks but it is not matching
>> the blocksize that would get written to the device...
>>
>> So we need to keep the respec limit in place.
>
> Let me ask you this, is the respec prohibition only for functional
> dependencies (i.e. sizes which depend on previously-specified blocksize)
> or is it also used for conflict checking (i.e. reflink requires crc?)
>

Only functional dependencies, AFAIK. These conflict checks shouldn't
be an issue. In the current code, they are happening without much
logic (wherever someone put them) after all CLI options were parsed.
In my patchset, they are more organised but still are done after all
the values are parsed. Exceptions in the current code can happen,
though these are not a blocker - I think that some options do conflict
checks in the CLI loop that could wait for later and my patchset moves
them.

>>>
>>>> If we don't want to enable subsequent command line entries to
>>>> override (to keep old behaviour) but still allow at least the
>>>> command line to override the config file options, that's also
>>>> doable.
>>>
>>> Well, I'm going to need to refamiliarize myself with how the
>>> conflict checking works, and why respecification is prohibited.
>>> If respecification matters, it matters just as much whether the
>>> first specification came from the config file or from the command
>>> line.
>>>
>>
>> Regarding the last sentence:
>>
>> On a general level, not really, I think. Change from the config file
>> can be seen as a change of defaults. It doesn't matter whether these
>> values were put in during compilation or loaded from a config file.
>
> Actually, I might disagree.  Defaults during compilation are controlled
> and tested by upstream developers, and are guaranteed (?) to be consistent
> and correct.  Defaults from a config file are subject to the whims
> of the config file editor, and may not be consistent at all, and require
> just as much checking as something from the commandline.  Isn't
> this an important difference?

True, I didn't realise this. But still, with my patchset, you can use
the CLI-designated functions, load it into the struct, then run a loop
that will set all .seen = false and voila, you have fully validated
the config file and you are ready to run another round for CLI as if
the values were defaults. So you don't break the respec as it will be
evaluated independently both for the config and CLI.

>
>> Multiple occurrences of the same option on the CLI is the only trouble
>> here because it is at this time when further values are computed and
>> it can go wrong. I didn't read these patches careful enough to answer
>> whether it matters in this specific case, though.
>
> Well, at this point "this specific case" is, I think, "any option can
> be specified in the config file, and will be parsed exactly like any valid
> command line option would be parsed."

I speak about how exactly the code handles it.

>
>> Saying this, putting -d size in blocks into config file maybe could
>> still cause trouble, but this can be solved by limiting what values or
>> options can be in the config file. For example: "all sizes has to be
>> in bytes". And I think that building on my patchset, it should be
>> possible with a reasonable amount of work to get a kind of lazy
>> evaluation. So this issue would disappear because the "1000b" value
>> would remain a string until all entries from CLI are parsed.
>
> So this would be sort of a "collect all options, respecified options
> means last one wins, and all evaluation is done at the end of parsing"
> sort of routine?

Yes, exactly. I can't think a case where this would cause a trouble.

Jan

>
> -Eric
>
>> Cheers,
>> Jan
>>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
