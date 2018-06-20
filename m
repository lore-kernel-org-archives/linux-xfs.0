Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47062 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754385AbeFTXSw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 19:18:52 -0400
Date: Thu, 21 Jun 2018 09:18:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] mkfs: add mkfs config version specifier for the
 config file
Message-ID: <20180620231850.GO19934@dastard>
References: <20180618180520.22146-1-mcgrof@kernel.org>
 <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
 <20180619205710.GH7508@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619205710.GH7508@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jun 19, 2018 at 10:57:10PM +0200, Luis R. Rodriguez wrote:
> On Tue, Jun 19, 2018 at 02:53:28PM -0500, Eric Sandeen wrote:
> > Soo.... 
> > 
> > I'm really on the fence about versioning at all, because we have yet to
> > identify any concrete scenario in which we'd need to bump the version;
> > we haven't even defined what exactly the "version" implies.
> 
> Right.
> 
> > So unless anyone has a concrete example of how a version would be needed,
> > functional, reliably-parsed, and well-defined I'm inclined to leave this out.
> 
> Dave asked for it, so I would imagine he could make a better case for it.

I ask for things so that people think about the problem, not
necessarily because I want something to be done. Please don't
conflate "Dave says X" with "we must implement X" because I am often
wrong and/or playing the Devil's Advocate role.

I try to look outside the box for potential issues, so if I see a
potential issue I'll say /something/ just to get people to discuss
that aspect of the problem and come up with a reasonable solution. I
don't have the time to solve every problem we have, I don't
/want/ to solve every problem, but I want to make sure we solve
the problems we have in the right way the first time.

In reality, I don't care either way if we have a version symbol in
the config file, and if it is decided that it is a good thing how it
will be implemented. What I care about is that we've thought about
supporting config files over their entire lifetime, not just
considered what is needed in the near term to solve the immediate
problem.

IOWs, my comments about treating a config file like any other
long term persistent structure were intended to shift the focus of
the discussion from implementation minutae to the bigger, long term
picture details that needed to be thrashed out. Work out the big
picture first, the small details will fall naturally from that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
