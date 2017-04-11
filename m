Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37988 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752776AbdDKWep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 18:34:45 -0400
Date: Wed, 12 Apr 2017 08:34:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170411223405.GC12369@dastard>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411141237.9274-3-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
> A dirty log in an obfuscated dump means that a corruption can happen
> when replaying the log (which contains unobfuscated data). Warn the user
> about this possibility.
> 
> The xlog workaround is copy&paste solution from repair/phase2.c and
> other tools, because the function is not implemented in libxlog.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

I think this is overkill. mdrestore is not the place
to be interpreting the state of the dumped image - it is a basic
"restore the image" program, not a "check the validity of the image"
program.

Secondly, if people are having problems with running log recovery on
a restored obfuscated image and getting corruption and not knowing
why or what to do, then that is a /documentation and training/
problem, not a code problem.

i.e. the problem is that people who aren't developers are trying to
use tools that were written for developers to do forensic analysis
of failures. Don't dumb down the tool for clueless users - point the
users at the documentation that the tool requires to use correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
