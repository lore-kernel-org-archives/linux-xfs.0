Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:32874 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166083AbdDXH1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2017 03:27:03 -0400
Received: by mail-vk0-f51.google.com with SMTP id j127so34109922vkh.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 00:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424050010.GD28800@wotan.suse.de>
References: <20170303231316.12716-1-mcgrof@kernel.org> <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de> <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard> <20170424050010.GD28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 24 Apr 2017 09:26:41 +0200
Message-ID: <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, lpechacek@suse.com

On Mon, Apr 24, 2017 at 7:00 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, Mar 10, 2017 at 09:34:35AM +1100, Dave Chinner wrote:
>> On Thu, Mar 09, 2017 at 06:57:51PM +0100, Luis R. Rodriguez wrote:
>> > I used reset_opt() and went with "last entry specified wins". From my
>> > review the goal of the respecification was to ensure each opt param
>> > parsed would not reset a prior set param, a paranoid measure, however
>> > this clearly does not work well if we want to allow for "last entry
>> > specified wins", or re-use the validators for a config file parsing
>> > for a first shot a parsing entries.
>>
>> Which is essentially broken, because doing something like:
>>
>> -m crc =1 -m reflink=1 -m crc=0
>>
>> leaves you with an /invalid config/ because of the respecification
>> of -m crc=0 and the order in which options are parsed and verified.
>>
>> Indeed, things like block and sector sizes are particularly nasty in
>> this respect, because other options can be specified in block or
>> sector units. SO things like:
>>
>> -s size=4k -b size=1s -s size=512 -d size=1000000s
>>
>> were considered valid. respecification of options like this is just
>> borken, and even if we take "last specification wins" it still means
>> that the block size specification is ambiguous and potentially
>> incorrect depending on other options. Hence respecification of
>> options is simply not allowed and post-processing of the options
>> doesn't change that.
>
> We have to pick an approach and stick with, the above seems sensible.
>
>> i.e., the biggest issue with reusing the existing parsing code for
>> the "default config" is that is doesn't just set default values - it
>> prevents other options from being used.
>
> Right as per original design.
>
>> IOWs, the config file should
>> set the default values in the option table, not set the options
>> directly as happens on the command line....
>
> As I respin my patches addressing concerns an issue I see with this is current
> semantics for "defaultval" is not that they will be the defaults, but rather
> they will be the defaults *iff* the user did specify the option on the command
> line but did not provide an explicit value. This for example would not allow

Yes, a confusing name. I'm aware of it and have a fix to rename it to .flagval.
It was part of my big set before and now I moved it into the smaller
set I submitted
on this Sunday. The same set adds a new field .value, which can be used to
specify default as in "if the user does not specify this option at all".

Jan

> distributions to disable a feature which perhaps is enabled by default in
> future versions xfsprogs, or enable one which perhaps is by default disabled.
> Even if the config file would have values specified, they will be ignored
> unless the user passed a user input value with no value for it.
>
> If this is fine by everyone then great.
>
>   Luis



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
