Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751323AbdELRDa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 13:03:30 -0400
Date: Fri, 12 May 2017 19:03:28 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170512170328.GE28800@wotan.suse.de>
References: <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de>
 <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de>
 <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de>
 <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
 <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
 <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

On Fri, May 12, 2017 at 11:05:13AM -0500, Eric Sandeen wrote:
> On 5/11/17 6:08 PM, Luis R. Rodriguez wrote:
> > On Thu, May 11, 2017 at 3:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >> On 5/11/17 5:46 PM, Luis R. Rodriguez wrote:
> >>
> >>> FWIW, I've looked at ways to address this without your future work Jan, ie
> >>> backporting this feature, and ultimately have decided to *not* allow any
> >>> command line overwrite for options specified in the configuration file. So
> >>> for the backported versions of this feature a user will only be able to
> >>> overwrite if the config file is commented out or removed.
> >>>
> >>> How we end up doing this upstream may differ given we may have a way to
> >>> properly do sanity checks overall and treat "defaults" as real "defaults".
> >>> But without such mechanisms implementing a sensible way to overwrite things
> >>> in a compatible way was just crap.
> >>>
> >>> As such for the backported versions of this feature I'll make this big note
> >>> on the man page:
> >>
> >> I'm a little confused - backported from where to where?  I'm not sure what
> >> a "backport" means in this context, when there is no upstream solution at this
> >> time.
> > 
> > Since we're still waiting for a bit of delta before I can push this
> > work then from my development tree to a stable older release.
> > 
> >>> """
> >>> One  of  the uses of the configuration file is to enable distributions
> >>> to provide mkfs.xfs(8) updates from a base distribution release and enable to
> >>> create filesystems which are sure to remain supported and compatible. As such
> >>> systems with a mkfs.xfs.conf(5) file present have very likely been well thought
> >>> out, and  overriding configuration  file  defaults is discouraged unless you
> >>> know what you are doing and are familiar with the associated risks.  If you
> >>> know what you are doing, wish to waive compatibility, and wish to overwrite the
> >>> configuration file provided the best option is to either remove or uncomment
> >>> the  configuration  file  completely  as options cannot be overwritten on the
> >>> command line.
> >>> """
> >>
> >> So are you planning a forked, non-upstream behavior for your distro?
> > 
> > Right.
> 
> I'm not really in a position to tell a distro what to do, other than out of
> concern for polluting user expectations with non-upstream behaviors.  Which
> /is/ a concern; I'm not looking forward to complaints from your users that
> upstream has "broken" behavior w.r.t. your fork when we (finally...?) ship a
> config-file capable mkfs.xfs.

Its a fair concern, and I will try once more to see if I can figure out a clean
way to enable overwrites without any of Jan's work. The point of my email was
to give a heads up its currently a mess to do properly, if you want to retain
respecification checks, conflict checks, min/max checks. My original reset_opt()
approach which this thread demo'd clearly was not sufficient given the respec/
conflict check issues pointed out.

> i.e. you go that route, your forked behavior will differ from any behavior
> that we ever ship upstream.  Your users will eventually need to adapt to
> considerably different behavior which is unique to your distro, and just to
> be clear: "but we already shipped it!" will not hold any weight whatsoever
> in future upstream behavior discussions...
> 
> If you want to ship newer progs w/ older defaults, I really don't understand
> why you can't just revert the patches that added the new defaults.

Its not that easy, we want the ability to support new features but remain
compatible with a base distribution release. As noted earlier in this thread
currently "defaultval" is a complete misnomer, its the used default value but
only if the user specified the option without a value. If you want to figure
out what the real default is you have to go through the code and figure each
value out.

Another point to my email was to highlight how important Jan's work is to
moving forward with anything sensible.

If I do come up with a sensible way to retain overwrites I'll let you'll know.

  Luis
