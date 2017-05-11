Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdEKXUo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 19:20:44 -0400
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com [209.85.161.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC4B62399C
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 23:20:25 +0000 (UTC)
Received: by mail-yw0-f170.google.com with SMTP id b68so3712026ywe.3
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 16:20:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170511230058.GD4519@birch.djwong.org>
References: <20170303231316.12716-1-mcgrof@kernel.org> <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de> <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de> <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de> <20170511230058.GD4519@birch.djwong.org>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Thu, 11 May 2017 16:19:51 -0700
Message-ID: <CAB=NE6XdeKG8_G9FO+yHHswsP_uLPqMZW_YDHthGObvY2kqrbw@mail.gmail.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

On Thu, May 11, 2017 at 4:00 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, May 12, 2017 at 12:46:03AM +0200, Luis R. Rodriguez wrote:
>> On Mon, Apr 24, 2017 at 01:25:03AM -0700, Luis R. Rodriguez wrote:
>> > On Mon, Apr 24, 2017 at 12:26 AM, Jan Tulak <jtulak@redhat.com> wrote:
>> > > On Mon, Apr 24, 2017 at 7:00 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > >> On Fri, Mar 10, 2017 at 09:34:35AM +1100, Dave Chinner wrote:
>> > >>> On Thu, Mar 09, 2017 at 06:57:51PM +0100, Luis R. Rodriguez wrote:
>> > >>> > I used reset_opt() and went with "last entry specified wins". From my
>> > >>> > review the goal of the respecification was to ensure each opt param
>> > >>> > parsed would not reset a prior set param, a paranoid measure, however
>> > >>> > this clearly does not work well if we want to allow for "last entry
>> > >>> > specified wins", or re-use the validators for a config file parsing
>> > >>> > for a first shot a parsing entries.
>> > >>>
>> > >>> Which is essentially broken, because doing something like:
>> > >>>
>> > >>> -m crc =1 -m reflink=1 -m crc=0
>> > >>>
>> > >>> leaves you with an /invalid config/ because of the respecification
>> > >>> of -m crc=0 and the order in which options are parsed and verified.
>> > >>>
>> > >>> Indeed, things like block and sector sizes are particularly nasty in
>> > >>> this respect, because other options can be specified in block or
>> > >>> sector units. SO things like:
>> > >>>
>> > >>> -s size=4k -b size=1s -s size=512 -d size=1000000s
>> > >>>
>> > >>> were considered valid. respecification of options like this is just
>> > >>> borken, and even if we take "last specification wins" it still means
>> > >>> that the block size specification is ambiguous and potentially
>> > >>> incorrect depending on other options. Hence respecification of
>> > >>> options is simply not allowed and post-processing of the options
>> > >>> doesn't change that.
>> > >>
>> > >> We have to pick an approach and stick with, the above seems sensible.
>> > >>
>> > >>> i.e., the biggest issue with reusing the existing parsing code for
>> > >>> the "default config" is that is doesn't just set default values - it
>> > >>> prevents other options from being used.
>> > >>
>> > >> Right as per original design.
>> > >>
>> > >>> IOWs, the config file should
>> > >>> set the default values in the option table, not set the options
>> > >>> directly as happens on the command line....
>> > >>
>> > >> As I respin my patches addressing concerns an issue I see with this is current
>> > >> semantics for "defaultval" is not that they will be the defaults, but rather
>> > >> they will be the defaults *iff* the user did specify the option on the command
>> > >> line but did not provide an explicit value. This for example would not allow
>> > >
>> > > Yes, a confusing name. I'm aware of it and have a fix to rename it to .flagval.
>> > > It was part of my big set before and now I moved it into the smaller
>> > > set I submitted
>> > > on this Sunday. The same set adds a new field .value, which can be used to
>> > > specify default as in "if the user does not specify this option at all".
>> >
>> > Terrific, thanks will use that.
>>
>> FWIW, I've looked at ways to address this without your future work Jan, ie
>> backporting this feature, and ultimately have decided to *not* allow any
>> command line overwrite for options specified in the configuration file. So
>> for the backported versions of this feature a user will only be able to
>> overwrite if the config file is commented out or removed.
>
> Waitaminute, config file directives lock out command line options??

Not for upstream, IMHO command line should always be able to overwrite
a config file as is traditionally done.

> I suppose that would make sense if one of the config file options was:
>
> disable_overrides = true
>
> ...but I think you're talking about /never/ allowing overrides, right?

Not for upstream, the question is how to backport this feature without
Jan's big replacement of the kitchen sink, and bathroom decor going
on.

> I am under the impression that we have (a) mkfs defaults in the source
> code that can be overridden in

Not clearly, the variables on the struct are actually "defaults if the
user supplies an argument but does not specify a value"! Without an
command line argument specified its actually a bit tricky to decipher
what is the default option used for a parameter.

With Jan's work this should be clearer later upstream, buts coming in
after the bathroom decor gets a facelift. Without Jan's work this is a
code mystery.

> (b) the config file

Only once the bathroom decor goes in.

>  which in turn can be overridden by the administrator via (c) the command line.

Sure, that should be the case upstream later. Modulo I think we some
additional checks typically done today only after main() should be
done after each (a), (b) and (c).

> In other words, we (upstream) set whatever defaults we think are sane,
> then distros can set the defaults they want to support, and the admin
> can change things as they see fit for their site.

Right, upstream-wise I agree.

> If the administrator
> wants to use non-default settings, they're welcome to support that
> themselves (or hire someone to do it for them).  We don't prohibit that.

Sure.

> The way I describe is the way that mke2fs works, and afaict most other
> programs operate that way too.  mkfs.xfs has a long history of "things
> you put on the command line are what you get in the fs", and changing it
> now is breaking peoples' mental models of how mkfs.xfs works, and in a
> way that runs counter to most other programs.

Sure, we don't want to change that.

 Luis
