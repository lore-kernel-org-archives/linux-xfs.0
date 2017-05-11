Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30129 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbdEKXCN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 19:02:13 -0400
Date: Thu, 11 May 2017 16:00:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170511230058.GD4519@birch.djwong.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de>
 <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de>
 <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511224603.GA28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

On Fri, May 12, 2017 at 12:46:03AM +0200, Luis R. Rodriguez wrote:
> On Mon, Apr 24, 2017 at 01:25:03AM -0700, Luis R. Rodriguez wrote:
> > On Mon, Apr 24, 2017 at 12:26 AM, Jan Tulak <jtulak@redhat.com> wrote:
> > > On Mon, Apr 24, 2017 at 7:00 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > >> On Fri, Mar 10, 2017 at 09:34:35AM +1100, Dave Chinner wrote:
> > >>> On Thu, Mar 09, 2017 at 06:57:51PM +0100, Luis R. Rodriguez wrote:
> > >>> > I used reset_opt() and went with "last entry specified wins". From my
> > >>> > review the goal of the respecification was to ensure each opt param
> > >>> > parsed would not reset a prior set param, a paranoid measure, however
> > >>> > this clearly does not work well if we want to allow for "last entry
> > >>> > specified wins", or re-use the validators for a config file parsing
> > >>> > for a first shot a parsing entries.
> > >>>
> > >>> Which is essentially broken, because doing something like:
> > >>>
> > >>> -m crc =1 -m reflink=1 -m crc=0
> > >>>
> > >>> leaves you with an /invalid config/ because of the respecification
> > >>> of -m crc=0 and the order in which options are parsed and verified.
> > >>>
> > >>> Indeed, things like block and sector sizes are particularly nasty in
> > >>> this respect, because other options can be specified in block or
> > >>> sector units. SO things like:
> > >>>
> > >>> -s size=4k -b size=1s -s size=512 -d size=1000000s
> > >>>
> > >>> were considered valid. respecification of options like this is just
> > >>> borken, and even if we take "last specification wins" it still means
> > >>> that the block size specification is ambiguous and potentially
> > >>> incorrect depending on other options. Hence respecification of
> > >>> options is simply not allowed and post-processing of the options
> > >>> doesn't change that.
> > >>
> > >> We have to pick an approach and stick with, the above seems sensible.
> > >>
> > >>> i.e., the biggest issue with reusing the existing parsing code for
> > >>> the "default config" is that is doesn't just set default values - it
> > >>> prevents other options from being used.
> > >>
> > >> Right as per original design.
> > >>
> > >>> IOWs, the config file should
> > >>> set the default values in the option table, not set the options
> > >>> directly as happens on the command line....
> > >>
> > >> As I respin my patches addressing concerns an issue I see with this is current
> > >> semantics for "defaultval" is not that they will be the defaults, but rather
> > >> they will be the defaults *iff* the user did specify the option on the command
> > >> line but did not provide an explicit value. This for example would not allow
> > >
> > > Yes, a confusing name. I'm aware of it and have a fix to rename it to .flagval.
> > > It was part of my big set before and now I moved it into the smaller
> > > set I submitted
> > > on this Sunday. The same set adds a new field .value, which can be used to
> > > specify default as in "if the user does not specify this option at all".
> > 
> > Terrific, thanks will use that.
> 
> FWIW, I've looked at ways to address this without your future work Jan, ie
> backporting this feature, and ultimately have decided to *not* allow any
> command line overwrite for options specified in the configuration file. So
> for the backported versions of this feature a user will only be able to
> overwrite if the config file is commented out or removed.

Waitaminute, config file directives lock out command line options??
I suppose that would make sense if one of the config file options was:

disable_overrides = true

...but I think you're talking about /never/ allowing overrides, right?

I am under the impression that we have (a) mkfs defaults in the source
code that can be overridden in (b) the config file which in turn can be
overridden by the administrator via (c) the command line.

In other words, we (upstream) set whatever defaults we think are sane,
then distros can set the defaults they want to support, and the admin
can change things as they see fit for their site.  If the administrator
wants to use non-default settings, they're welcome to support that
themselves (or hire someone to do it for them).  We don't prhoibit that.

The way I describe is the way that mke2fs works, and afaict most other
programs operate that way too.  mkfs.xfs has a long history of "things
you put on the command line are what you get in the fs", and changing it
now is breaking peoples' mental models of how mkfs.xfs works, and in a
way that runs counter to most other programs.

No thank you to this.

--D

> 
> How we end up doing this upstream may differ given we may have a way to
> properly do sanity checks overall and treat "defaults" as real "defaults".
> But without such mechanisms implementing a sensible way to overwrite things
> in a compatible way was just crap.
> 
> As such for the backported versions of this feature I'll make this big note
> on the man page:
> 
> """
> One  of  the uses of the configuration file is to enable distributions
> to provide mkfs.xfs(8) updates from a base distribution release and enable to
> create filesystems which are sure to remain supported and compatible. As such
> systems with a mkfs.xfs.conf(5) file present have very likely been well thought
> out, and  overriding configuration  file  defaults is discouraged unless you
> know what you are doing and are familiar with the associated risks.  If you
> know what you are doing, wish to waive compatibility, and wish to overwrite the
> configuration file provided the best option is to either remove or uncomment
> the  configuration  file  completely  as options cannot be overwritten on the
> command line.
> """
> 
> Also FWIW, I've been thinking more about the option checks and I think its
> worth clarifying we currently do things one way and if we really wish to
> enable command line overwrites (I'm not sure now its worth it) then we
> should reconsider how we do checks a bit differently.
> 
> I. We currently have a set of options possible, list conflicts to check for
> if this option is set, and set min / max values for it. We also only
> allow setting an option once (respecification check).
> 
> II. As we parse the command line we do sanity checks for respecification,
> conflicts, max/min, in that order.
> 
> III. Once we are done parsing all options we do our own internal checks
> within main() which are beyond the options checks.
> 
> Without considering Jan's work, if we wanted to allow overwrites, one example
> issue is that if you wanted to keep the respecification check is you'd only
> enable overwrites by enabling to disable a feature using the same option.  This
> sort of makes sense as otherwise things may be implicit but from a documentation
> and user experience perspective this seems very odd.
> 
> It seems more sensible for us to:
> 
> I. Use the same options, but extracting system defaults and checking these
> defaults against conflicts checks, min/max checks (It seems Jan's work is
> moving in this direction).
> 
> II. Do a full sanity check to ensure all mix of options makes sense, have
> this as a helper we can re-suse, verify_all_opts() or whatever. This would
> move a lot of checks we have after main() into a helper.
> 
> III. Parse config file and after all options are parsed also verify_all_opts()
> 
> IV. Parse cmd line options and after all options are parsed also verify_all_opts()
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
