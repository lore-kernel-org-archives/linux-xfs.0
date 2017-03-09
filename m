Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754526AbdCIR5y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 12:57:54 -0500
Date: Thu, 9 Mar 2017 18:57:51 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170309175750.GE14437@wotan.suse.de>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, Jan Tulak <jtulak@redhat.com>

On Wed, Mar 08, 2017 at 10:41:52PM -0600, Eric Sandeen wrote:
> 
> On 3/8/17 6:51 PM, Luis R. Rodriguez wrote:
> > On Wed, Mar 08, 2017 at 06:16:57PM -0600, Eric Sandeen wrote:
> >> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
> >>> This series adds mkfs.xfs.conf support, so that options can now be
> >>> shoved into a configuration file. This enables certain defaults to be
> >>> saved for folks sticking to certain values, but more importantly it
> >>> also enables distributions to override certain defaults so that new
> >>> filesystems remain compatible with older distributions.
> >>>
> >>> This has been based on top of xfsprogs-dev v4.9.0-rc1.
> >>>
> >>> Given we already have an existinsg infrastructure to validate argument
> >>> values this reuses that infrastructure by first adding helpers and porting
> >>> over the argument parsing suppor to use these helpers.
> >>
> >> Hm, one functional problem with this, aside from Dave's concerns and
> >> suggestions, is that many options in the config file can't actually
> >> be overridden on the commandline because they are treated as having
> >> been respecified, which is not allowed:
> >>
> >> # mkfs.xfs -m crc=1 -m crc=0 -f fsfile
> >> -m crc option respecified
> >> Usage: mkfs.xfs
> > 
> > This was dealt by enabling the last option taken to override, and
> > this mechanism was also taken to enable the config file to take
> > the first value but let the command line to override. Refer to
> > usage of reset_opt(). Granted I had only done this on B_LOG but
> > this can easily be made to enable us to reset for all options.
> 
> Well, the above test was with your full patchset applied,
> so my point is that it's not currently working properly as posted...

Sorry yes I failed to reset_opt() for each config entry on the config
file. I had meant to move reset_opt() generically on parse_subopts()
so that "last entry specified wins" always. I had only added this
for B_LOG.

> But are you proposing adding this reset_opt() to /every/ option?
> That would undo all of the respecification checks, which were
> put there for a reason (I assume?) ;)  I don't really remember
> how all of the respecification and compatibility checking works
> tbh, I'd have to dig back into it.  Maybe jtulak can help...
> 
> But it makes little sense to have a framework to prevent
> respecification but then render it useless with reset_opt()
> after each option gets parsed.  Or do I misunderstand?

I used reset_opt() and went with "last entry specified wins". From my
review the goal of the respecification was to ensure each opt param
parsed would not reset a prior set param, a paranoid measure, however
this clearly does not work well if we want to allow for "last entry
specified wins", or re-use the validators for a config file parsing
for a first shot a parsing entries.

*Proper validation* is and should be done *after* all parameters are
set, and it sounds like jtulak's work helps shove this into helpers
*as should be done* to clear cruft out of main(). Having these params
in structs should help both efforts.

> > If we don't want to enable subsequent command line entries to
> > override (to keep old behaviour) but still allow at least the
> > command line to override the config file options, that's also
> > doable.
> 
> Well, I'm going to need to refamiliarize myself with how the
> conflict checking works, and why respecification is prohibited.
> If respecification matters, it matters just as much whether the
> first specification came from the config file or from the command
> line.

Agreed. The above is what I concluded based on my inspection of the
code. It would be of course great to get more eyeballs on it.

  Luis
