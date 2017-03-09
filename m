Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35678 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752458AbdCIKOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 05:14:04 -0500
Received: by mail-io0-f178.google.com with SMTP id z13so25372528iof.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2017 02:12:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
References: <20170303231316.12716-1-mcgrof@kernel.org> <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de> <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 9 Mar 2017 11:12:04 +0100
Message-ID: <CACj3i73W8=vPZHHUMSvU-V=28NxaUmmn41rbG7bQ0JA+8ZKv8Q@mail.gmail.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

Hi,

Eric, thanks for pinging me, I wanted to look at this and forgot... :-/

First of all, this patchset has a lot of common with my advanced
conflict checking patchset. And AFAIK, if my patchset was already in
place, this set could be reduced to one new function that loads the
file and changes the default values in a structure.

See this http://www.spinics.net/lists/linux-xfs/msg02728.html

I wanted to fix the few mentioned issues I got for that RFC and submit
it this week, but with the flu I got, I'm doing things that don't
cause me a headache when I spread my mind over too many LOC at once.
:-) And now, looking at this, I would like to go through this patchset
in more detail and see if you (Luis) got some things better than me
before I send it, so it will take some more time.

Some other info is bellow between quotes.

On Thu, Mar 9, 2017 at 5:41 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 3/8/17 6:51 PM, Luis R. Rodriguez wrote:
>> On Wed, Mar 08, 2017 at 06:16:57PM -0600, Eric Sandeen wrote:
>>> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
>>>> This series adds mkfs.xfs.conf support, so that options can now be
>>>> shoved into a configuration file. This enables certain defaults to be
>>>> saved for folks sticking to certain values, but more importantly it
>>>> also enables distributions to override certain defaults so that new
>>>> filesystems remain compatible with older distributions.
>>>>
>>>> This has been based on top of xfsprogs-dev v4.9.0-rc1.
>>>>
>>>> Given we already have an existinsg infrastructure to validate argument
>>>> values this reuses that infrastructure by first adding helpers and porting
>>>> over the argument parsing suppor to use these helpers.
>>>
>>> Hm, one functional problem with this, aside from Dave's concerns and
>>> suggestions, is that many options in the config file can't actually
>>> be overridden on the commandline because they are treated as having
>>> been respecified, which is not allowed:
>>>
>>> # mkfs.xfs -m crc=1 -m crc=0 -f fsfile
>>> -m crc option respecified
>>> Usage: mkfs.xfs
>>
>> This was dealt by enabling the last option taken to override, and
>> this mechanism was also taken to enable the config file to take
>> the first value but let the command line to override. Refer to
>> usage of reset_opt(). Granted I had only done this on B_LOG but
>> this can easily be made to enable us to reset for all options.
>
> Well, the above test was with your full patchset applied,
> so my point is that it's not currently working properly as posted...
>
> But are you proposing adding this reset_opt() to /every/ option?
> That would undo all of the respecification checks, which were
> put there for a reason (I assume?) ;)  I don't really remember
> how all of the respecification and compatibility checking works
> tbh, I'd have to dig back into it.  Maybe jtulak can help...
>
> But it makes little sense to have a framework to prevent
> respecification but then render it useless with reset_opt()
> after each option gets parsed.  Or do I misunderstand?

The reason why respec is forbidden (other than "what the hell the user
wants, or is this a typo?" which could be decided as "simply take the
last one, it's a feature") is that some options depend on other ones
in "must be specified first" way. What should we do if we get -b
size=X -d size=1000b -b size=Y? Values are parsed at the time of their
occurrence, so suddenly, we have size in blocks but it is not matching
the blocksize that would get written to the device...

So we need to keep the respec limit in place.

>
>> If we don't want to enable subsequent command line entries to
>> override (to keep old behaviour) but still allow at least the
>> command line to override the config file options, that's also
>> doable.
>
> Well, I'm going to need to refamiliarize myself with how the
> conflict checking works, and why respecification is prohibited.
> If respecification matters, it matters just as much whether the
> first specification came from the config file or from the command
> line.
>

Regarding the last sentence:

On a general level, not really, I think. Change from the config file
can be seen as a change of defaults. It doesn't matter whether these
values were put in during compilation or loaded from a config file.
Multiple occurrences of the same option on the CLI is the only trouble
here because it is at this time when further values are computed and
it can go wrong. I didn't read these patches careful enough to answer
whether it matters in this specific case, though.

Saying this, putting -d size in blocks into config file maybe could
still cause trouble, but this can be solved by limiting what values or
options can be in the config file. For example: "all sizes has to be
in bytes". And I think that building on my patchset, it should be
possible with a reasonable amount of work to get a kind of lazy
evaluation. So this issue would disappear because the "1000b" value
would remain a string until all entries from CLI are parsed.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
