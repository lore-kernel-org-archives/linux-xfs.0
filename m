Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:24521 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751340AbeFNEGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 00:06:31 -0400
Date: Thu, 14 Jun 2018 14:06:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614040628.GJ10363@dastard>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152891829964.3968.4760134019673731615.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 13, 2018 at 12:31:39PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series refactors the build system so that we can generate a mkfs
> configuration file template from the defaults hardwired into the source
> code.  We can ship the template as /etc/xfs/mkfs/default.template and we
> can also put it in the mkfs.xfs manpage.  The series is based off of
> Eric's mkfs-config branch as of 12-June-2018.

Why?

I don't see any advantage in writing a bunch of code to "optimise"
the process of changing a default template file. We don't change
defaults very often, and it only takes a few minutes to do manually.

With this change, we'll have code to maintain it to ensure that the
file gets updated properly, and it will probably take more time and
effort to validate that the generated file is correct (and debug if
it's not!) compared to the 30s it will take to hand edit the
template file to change or add a new default...

Speaking of which, I didn't see any check that tells us the template
was built correctly. Am I expected to have to check the template
file after I've installed the built packages to determine that it
was built correctly by the distro package builder?

I'm also not convinced we should ship a "default.template" file,
either.  I'd much prefer we ship a real config file with all the
options defined but commented out as a "start here template".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
