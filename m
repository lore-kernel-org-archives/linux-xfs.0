Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45679 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752628AbdCIWfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 17:35:12 -0500
Date: Fri, 10 Mar 2017 09:34:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170309223435.GT17542@dastard>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170309175750.GE14437@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, Jan Tulak <jtulak@redhat.com>

On Thu, Mar 09, 2017 at 06:57:51PM +0100, Luis R. Rodriguez wrote:
> On Wed, Mar 08, 2017 at 10:41:52PM -0600, Eric Sandeen wrote:
> > But are you proposing adding this reset_opt() to /every/ option?
> > That would undo all of the respecification checks, which were
> > put there for a reason (I assume?) ;)  I don't really remember
> > how all of the respecification and compatibility checking works
> > tbh, I'd have to dig back into it.  Maybe jtulak can help...
> > 
> > But it makes little sense to have a framework to prevent
> > respecification but then render it useless with reset_opt()
> > after each option gets parsed.  Or do I misunderstand?
> 
> I used reset_opt() and went with "last entry specified wins". From my
> review the goal of the respecification was to ensure each opt param
> parsed would not reset a prior set param, a paranoid measure, however
> this clearly does not work well if we want to allow for "last entry
> specified wins", or re-use the validators for a config file parsing
> for a first shot a parsing entries.

Which is essentially broken, because doing something like:

-m crc =1 -m reflink=1 -m crc=0

leaves you with an /invalid config/ because of the respecification
of -m crc=0 and the order in which options are parsed and verified.

Indeed, things like block and sector sizes are particularly nasty in
this respect, because other options can be specified in block or
sector units. SO things like:

-s size=4k -b size=1s -s size=512 -d size=1000000s

were considered valid. respecification of options like this is just
borken, and even if we take "last specification wins" it still means
that the block size specification is ambiguous and potentially
incorrect depending on other options. Hence respecification of
options is simply not allowed and post-processing of the options
doesn't change that.

i.e., the biggest issue with reusing the existing parsing code for
the "default config" is that is doesn't just set default values - it
prevents other options from being used. IOWs, the config file should
set the default values in the option table, not set the options
directly as happens on the command line....

> *Proper validation* is and should be done *after* all parameters are
> set, and it sounds like jtulak's work helps shove this into helpers
> *as should be done* to clear cruft out of main(). Having these params
> in structs should help both efforts.

Right, that was the whole point of the table based option parsing I
started on and Jan has been continuing - factoring the option
parsing code and getting rid of all the whacky variables used to say
"this option is set" and move all the config state into the option
table. Then all the whacky variables can be replaced with option
table lookups, and so if the option has not been set on the command
line, the default value can be picked up from the table (which was
set from the config file).

Only the first step (table based parsing) has been done so
far - there's still plenty of work needed to get the option table
and code to the point where we use it exclusively for config
lookups. Once we get there, then using a config file for default
values is easy to add...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
