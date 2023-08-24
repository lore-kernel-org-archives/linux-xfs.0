Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E28C27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 00:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjHXAIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 20:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbjHXAIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 20:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98075CDA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 17:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBD9638FD
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 00:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F3AC433C7;
        Thu, 24 Aug 2023 00:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692835689;
        bh=CrVjq+R/Mdtucx6DQSxTjEYmpe3eWSE0nrLROshkmCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2bRovsF4ITHhEGEk8jhRosMeSw+EQSzJ7P4xuj5WFbDr7F59VexVqnSJ/IFBjE+j
         voqhyJch9j+Z7djP4S1IpXYyoc7H75UDPJkq5rBqwaoYvqU0Fujic6glxGtAH6JSxJ
         2fMFyAiX4YvOxQi+vZF0wPxIiL5zA0KfrEwR4x2NYAVwsPnOFqBKkoof12YcQqQFWe
         2DjX5L5DJ6b/aOlybnb9fkk3+B0F+6ua7agMAyOhLLHwrEY0cdlzl3Zhl38ExT0YKv
         HFOdlSCGK7S+oyoeym579eEr8HNh4NeNeSrXwVmDL46TE6IQLv/a8qxLQj74vEpAfx
         3lkAUkl82x2EA==
Date:   Wed, 23 Aug 2023 17:08:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] xfsprogs: don't allow udisks to automount XFS
 filesystems with no prompt
Message-ID: <20230824000808.GH11286@frogsfrogsfrogs>
References: <20230823223630.GG11263@frogsfrogsfrogs>
 <ZOabFe7wI/9jH7zw@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOabFe7wI/9jH7zw@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 09:49:41AM +1000, Dave Chinner wrote:
> On Wed, Aug 23, 2023 at 03:36:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The unending stream of syzbot bug reports and overwrought filing of CVEs
> > for corner case handling (i.e. things that distract from actual user
> > complaints) in XFS has generated all sorts of of overheated rhetoric
> > about how every bug is a Serious Security Issue(tm) because anyone can
> > craft a malicious filesystem on a USB stick, insert the stick into a
> > victim machine, and mount will trigger a bug in the kernel driver that
> > leads to some compromise or DoS or something.
> > 
> > I thought that nobody would be foolish enough to automount an XFS
> > filesystem.  What a fool I was!  It turns out that udisks can be told
> > that it's okay to automount things, and then it will.  Including mangled
> > XFS filesystems!
> 
> *nod*
> 
> > <delete angry rant about poor decisionmaking and armchair fs developers
> > blasting us on X while not actually doing any of the work>
> 
> If only I had a dollar for every time I've deleted a similar rant...

I do, and I'm raking in the Benjamins!
https://www.youtube.com/watch?v=qpMvS1Q1sos

> > Turn off /this/ idiocy by adding a udev rule to tell udisks not to
> > automount XFS filesystems.
> >
> > This will not stop a logged in user from unwittingly inserting a
> > malicious storage device and pressing [mount] and getting breached.
> > This is not a substitute for a thorough audit.  This does not solve the
> > general problem of in-kernel fs drivers being a huge attack surface.
> > I just want a vacation from the shitstorm of bad ideas and threat
> > models that I never agreed to support.
> 
> Yup, this seems like a right thing to do given the lack of action
> from the userspace side of the fence.
> 
> [ The argument that "prompting the user to ask if they trust the
> device teaches them to ignore security prompts" is just stupid. We
> have persistent identifiers in filesystems - keep a database of
> known trusted identifiers and only prompt for "is this a trusted
> device" when an unknown device is inserted. Other desktop OS's have
> been doing this for years.... ]

Not to mention that having a prompt at least stops the evil maid from
waking up your laptop, plugging in a usb stick, and being able to mount
crap in your system without even having to unlock it.

But. I'm preaching to the choir here.

> > [Does this actually stop udisks?  I turned off all automounting at the
> > DE level years ago because I'm not that stupid.]
> 
> Yeah, I turned off all the DE level automount stuff years ago, too.
> It's the first thing I do when setting up a new machine for anyone,
> too.
> 
> .....
> 
> > diff --git a/scrub/64-xfs.rules b/scrub/64-xfs.rules
> > new file mode 100644
> > index 00000000000..39f17850097
> > --- /dev/null
> > +++ b/scrub/64-xfs.rules
> > @@ -0,0 +1,10 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +#
> > +# Copyright (C) 2023 Oracle.  All rights reserved.
> > +#
> > +# Author: Darrick J. Wong <djwong@kernel.org>
> > +#
> > +# Don't let udisks automount XFS filesystems without even asking a user.
> > +# This doesn't eliminate filesystems as an attack surface; it only prevents
> > +# evil maid attacks when all sessions are locked.
> > +SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="xfs", ENV{UDISKS_AUTO}="0"
> 
> I think this is correct, but the lack of documentation on how
> udev rules and overrides are supposed to work doesn't help
> me one bit.
> 
> Ok, just tracked it through - only gvfs and clevis actually look at
> udisks_block_get_hint_auto() from udisks, so at least the gnome and
> lxde/lxqt desktop environments will no longer automount XFS
> filesystems.  Who knows what magic is needed for other DEs, but this
> is a good start.

Hah, we could encode that too?

kde5:
[General]
AutomountEnabled=false
AutomountOnPlugin=false
AutomountOnLogin=false
AutomountUnknownDevices=false

gnome3:
[org.gnome.desktop.media-handling]
automount=false
automount-open=false
autorun-never=true

gnome2:
/apps/nautilus/preferences/media_automount	false
/apps/nautilus/preferences/media_autorun_never	true
/apps/nautilus/preferences/media_autorun_never	true
/apps/nautilus/preferences/media_autorun_x_content_open_folder	[]


> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
