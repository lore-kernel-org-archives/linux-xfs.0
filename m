Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:37252 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdHQKIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 06:08:41 -0400
Received: by mail-wr0-f170.google.com with SMTP id z91so29809667wrc.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 03:08:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170816213812.GC4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com> <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
 <20170816213812.GC4796@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 17 Aug 2017 12:08:19 +0200
Message-ID: <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 16, 2017 at 11:38 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Aug 16, 2017 at 04:13:52PM -0500, Eric Sandeen wrote:
>> On 8/15/17 10:08 AM, Jan Tulak wrote:
>> > This patch adds infrastructure that will be used in subsequent patches.
>> >
>> > The Value field is the actual value used in computations for creating
>> > the filesystem.  This is initialized with sensible default values. If
>> > initialized to 0, the value is considered disabled. User input will
>> > override default values.  If the field is a string and not a number, the
>> > value is set to a positive non-zero number when user input has been
>> > supplied.
>> >
>> > Add functions that can be used to get/set values to opts table.
>>
>> Ok, I need to back up here a bit and look at this conceptually.
>>
>> (Again, though, if this is infra for some other patchset, I'd just send
>> it with /that/ patchset, not this one ...)

Ehh... yes, of course. I moved the patch for which this is
infrastructure to the other set but did not move this one.

>>
>> But anyway, things like this confuse and worry me:
>>
>> > +   case OPT_S:
>> > +           switch (subopt) {
>> > +           case S_LOG:
>> > +           case S_SECTLOG:
>> > +                   set_conf_val(OPT_S, S_LOG, val);
>> > +                   set_conf_val(OPT_D, D_SECTLOG, val);
>> > +                   set_conf_val(OPT_L, L_SECTLOG, val);
>> > +                   set_conf_val(OPT_D, D_SECTSIZE, 1 << val);
>> > +                   set_conf_val(OPT_S, S_SIZE, 1 << val);
>> > +                   set_conf_val(OPT_S, S_SECTSIZE, 1 << val);
>> > +                   set_conf_val(OPT_L, L_SECTLOG, val);
>> > +                   set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
>> > +                   set_conf_val(OPT_L, L_SECTSIZE, val);> +                        break;
>> > +           case S_SIZE:
>> > +           case S_SECTSIZE:
>> > +                   set_conf_val(OPT_S, S_SIZE, val);
>> > +                   set_conf_val(OPT_D, D_SECTSIZE, val);
>> > +                   set_conf_val(OPT_D, D_SECTLOG, libxfs_highbit32(val));
>> > +                   set_conf_val(OPT_S, S_LOG, libxfs_highbit32(val));
>> > +                   set_conf_val(OPT_S, S_SECTLOG, libxfs_highbit32(val));
>> > +                   set_conf_val(OPT_L, L_SECTSIZE, val);
>> > +                   set_conf_val(OPT_L, L_SECTLOG, libxfs_highbit32(val));
>> > +                   break;
>> > +           }
>> > +           break;
>> > +   }
>>
>> Partly because this seems to be going opposite of the simplicity
>> we were aiming for - before all this work, if we set teh data sector size,
>> via any of these options, it got stored in a variable - "sectorsize".
>>
>> Now, if we issue "-s size=4k" the code will calculate and set that same
>> value (or its log) into 7 to (or 9?) different internal variables?
>> Why is that needed?  There is/are only one (or two) sector size(s) in the
>> filesystem, so should there not be one point of truth here?
>>
>> But also because the above is wrong; it is possible for the filesystem data
>> portion and log portion to have different sector sizes, if the log is external. [1]
>> The above would seem to break that, always setting data & log sizes together.

But in the current for-next tree mkfs does set data and log sector
size at the same time,
this patch is not doing anything new:

                                case S_SECTSIZE:
                                        if (lslflag)
                                                conflict('s', subopts,
S_SECTLOG,
                                                         S_SECTSIZE);
                                        sectorsize = getnum(value, &sopts,
                                                            S_SECTSIZE);
                                        lsectorsize = sectorsize;
                                        sectorlog =
                                                libxfs_highbit32(sectorsize);
                                        lsectorlog = sectorlog;
                                        lssflag = ssflag = 1;
                                        break;

The only difference here is that sectorsize was one variable into
which multiple options assigned a value, while now we fill every
related member of the structure with the same value. Which is is
cumbersome, I admit that. I had an idea which could limit this
duplicated assignments, but it has its own disadvantages: if the
values of -d sectlog and sectize and -s size and log options were all
pointers to the same variable, it would be enough to set only one. But
then we are unknowingly modifying the other options whenever we touch
any of those, which is not nice as well. But I will give it another
though, maybe I will came up with an idea...

Anyway, back to the data/log sector size - when I was making this
change, my understanding of the code was that -s size will set both
data and log sector size, and -d/-l sectsize will set only one of
them. If this behaviour is not the desired one, then it needs to be
fixed anyway, no matter if my patch is there or not. But it is perhaps
obscured by the fact that here I'm setting both S_SIZE and D_SECTSIZE,
which adds a noise.

>>
>> On top of that, it's getting so complicated that it seems to be difficult to get
>> right; i.e. this:
>>
>> > +                   set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
>> > +                   set_conf_val(OPT_L, L_SECTSIZE, val);
>>
>> surely isn't correct.  I found that when noticing that 1 block sets 9 vals, while
>> the other only 7, and wondered why.  So that accounts for one.  After another minute
>> of scrutiny I see that OPT_S, S_SECTSIZE isn't set in the 2nd chunk, so that's a bug
>> as well.

Yup, these are bugs.

>>
>> This makes me fear fragility in this approach.
>>
>> One goal of all this work, I thought, was to clearly describe interdependencies between
>> options, but the above seems to add nasty, hidden, implicit, and wrong dependencies
>> between log & data sector sizes (for example).

The fragility is the reason why I moved it out of the main() loop
where these correlated options were set until now into this specific
function, so at least we know what to watch for. But the dependency
between log & data sector sizes was there before. The issue is that
S_SIZE and D_SECTSIZE have the same meaning, but are not automatically
connected.

>
> FWIW I thought all this really did was replace the dozens of local
> variables holding geometry info with a huge nested struct, which is a
> reasonable start on adding support for a config file (where is that,
> anyway?) but didn't make any functional changes.

That is the goal, yes. Any functional changes in this are a bug.

>
> Ofc I didn't realize that xfs/191-input-validation isn't a totally
> thorough exerciser of all the mkfs options.

Missing combinations can be added, but it only tests whether mkfs
accepts or refuses the combination.
I have another test in the making, which really makes the filesystem
and then tests if its geometry and properties are all right,
but I have difficulties with evaluating correct sizes when the test
device can be of any size and have different sector size, so I can't
diff a correct output from xfs_info. The only usable way I found so
far is to limit it to fs images only, where I have some control over
the size.

>
>> If we have several commandline options that all set the same fundamental property,
>> (i.e. data sector size), then it seems that should somehow be stored in one single
>> point of truth within mkfs as it was before.
>>
>> -Eric
>>
>> [1] # mkfs.xfs -dfile,name=fsfile,size=1g,sectsize=4k -lfile,name=logfile,size=512m,sectsize=512
>
> I see -d sectsize is in the --help screen but not the manpage.  Can we
> fix that?

I made it, but Dave would rather see the -d sectsize option removed.
Which I'm not sure about...
See "[PATCH] xfsprogs: add sectsize/sectlog to the man page"

Cheers,
Jan
