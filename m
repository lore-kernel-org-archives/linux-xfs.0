Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE18C3DA6F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 23:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjHWXuI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 19:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbjHWXts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 19:49:48 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760FA10CA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 16:49:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1bee82fad0fso41150475ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 16:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692834586; x=1693439386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a3O95gB/Vg+mbrrvJGs3ohCyF5U2xjy64scwxDnO4GU=;
        b=x7nBSHR5S8MAkxgxc/q1zft+tPwnl0VWDKZZ6DpJlrDneSUxBfg5gHMHWEOTJ9fYsy
         +4aApZn98n8h09cB6TCCnA8ONdo3iq55g5Gb4GtEAmIQ43nK1660eyGxiEXfnRpzqImK
         Qbd203qZX44z8FM8IjXUbRDOJdizk5w6+K7YeqDLUpTc9zomV6FJtxd2aaowEzNCNYoo
         642UAXKHFLADW884bW2IjclPclthLBlIsEg/RtJcdIUK45KiA7z4P56mdS+8B5F0c/xE
         0yB3VdjbAygY9pbswOSXPh5C7x2cblWUoLjAsqo0KTpkpgc5nSERsV9FxcGESpx/fLyx
         QLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692834586; x=1693439386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3O95gB/Vg+mbrrvJGs3ohCyF5U2xjy64scwxDnO4GU=;
        b=VsWt2+qJF6PdtfpAodBl43OKLzATgOsipKJpeB/EpG9Fb33oo16kNDSU4dyxBjTSZd
         +FKP4sXEYtkxNWLSyfidLfJMICCxbEkEcXA97Ic38e7sRHM9x3Xg9wsw0hiofIJLGUPJ
         +vW63jhDdDyHYL6XNl7eRQ1STJOrEvhxcFLtBQJWmVhpkxU11gAaLGMqqPGoYVNmCt/2
         2y+AWyR1rqz4zqTe0oNO0SgFziiRn3jXexUBA8yXODsrRy7A00u8c45jf7ZXlkLwHhs7
         aFye9p2QvGQ22XbMKPfOYMlrcZjXWaaFTDhBNcCXLLyvcCpJt7zFmvizb9Z2+cUPGylM
         Xn6w==
X-Gm-Message-State: AOJu0YySSawhrkQnhT7Yv1N1xD3F/j//UHyIu/jjxGiOsDLuHC4IjfTW
        ryM5oyHurQMvUB9KmfB7nn73vg==
X-Google-Smtp-Source: AGHT+IEzjLO9fyn7/mHphotnpKvdZqB+pvamVjCjex5BrzvTTWqGVOwigH4z6hUbRXmwumNx8Qbhbw==
X-Received: by 2002:a17:903:24f:b0:1b8:1b79:a78c with SMTP id j15-20020a170903024f00b001b81b79a78cmr12873640plh.44.1692834585902;
        Wed, 23 Aug 2023 16:49:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id iz22-20020a170902ef9600b001b9e86e05b7sm11448874plb.0.2023.08.23.16.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 16:49:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qYxbZ-005el1-0s;
        Thu, 24 Aug 2023 09:49:41 +1000
Date:   Thu, 24 Aug 2023 09:49:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] xfsprogs: don't allow udisks to automount XFS
 filesystems with no prompt
Message-ID: <ZOabFe7wI/9jH7zw@dread.disaster.area>
References: <20230823223630.GG11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823223630.GG11263@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 03:36:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The unending stream of syzbot bug reports and overwrought filing of CVEs
> for corner case handling (i.e. things that distract from actual user
> complaints) in XFS has generated all sorts of of overheated rhetoric
> about how every bug is a Serious Security Issue(tm) because anyone can
> craft a malicious filesystem on a USB stick, insert the stick into a
> victim machine, and mount will trigger a bug in the kernel driver that
> leads to some compromise or DoS or something.
> 
> I thought that nobody would be foolish enough to automount an XFS
> filesystem.  What a fool I was!  It turns out that udisks can be told
> that it's okay to automount things, and then it will.  Including mangled
> XFS filesystems!

*nod*

> <delete angry rant about poor decisionmaking and armchair fs developers
> blasting us on X while not actually doing any of the work>

If only I had a dollar for every time I've deleted a similar rant...

> Turn off /this/ idiocy by adding a udev rule to tell udisks not to
> automount XFS filesystems.
>
> This will not stop a logged in user from unwittingly inserting a
> malicious storage device and pressing [mount] and getting breached.
> This is not a substitute for a thorough audit.  This does not solve the
> general problem of in-kernel fs drivers being a huge attack surface.
> I just want a vacation from the shitstorm of bad ideas and threat
> models that I never agreed to support.

Yup, this seems like a right thing to do given the lack of action
from the userspace side of the fence.

[ The argument that "prompting the user to ask if they trust the
device teaches them to ignore security prompts" is just stupid. We
have persistent identifiers in filesystems - keep a database of
known trusted identifiers and only prompt for "is this a trusted
device" when an unknown device is inserted. Other desktop OS's have
been doing this for years.... ]

> [Does this actually stop udisks?  I turned off all automounting at the
> DE level years ago because I'm not that stupid.]

Yeah, I turned off all the DE level automount stuff years ago, too.
It's the first thing I do when setting up a new machine for anyone,
too.

.....

> diff --git a/scrub/64-xfs.rules b/scrub/64-xfs.rules
> new file mode 100644
> index 00000000000..39f17850097
> --- /dev/null
> +++ b/scrub/64-xfs.rules
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# Copyright (C) 2023 Oracle.  All rights reserved.
> +#
> +# Author: Darrick J. Wong <djwong@kernel.org>
> +#
> +# Don't let udisks automount XFS filesystems without even asking a user.
> +# This doesn't eliminate filesystems as an attack surface; it only prevents
> +# evil maid attacks when all sessions are locked.
> +SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="xfs", ENV{UDISKS_AUTO}="0"

I think this is correct, but the lack of documentation on how
udev rules and overrides are supposed to work doesn't help
me one bit.

Ok, just tracked it through - only gvfs and clevis actually look at
udisks_block_get_hint_auto() from udisks, so at least the gnome and
lxde/lxqt desktop environments will no longer automount XFS
filesystems.  Who knows what magic is needed for other DEs, but this
is a good start.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
