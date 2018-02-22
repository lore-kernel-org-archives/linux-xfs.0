Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933376AbeBVRRy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 12:17:54 -0500
Date: Thu, 22 Feb 2018 09:15:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] misc: enable retpolines across all xfsprogs utilities
Message-ID: <20180222171529.GC9827@magnolia>
References: <20180222021625.GA9827@magnolia>
 <20180222150922.GA26282@infradead.org>
 <4d78832f-4148-d0d9-e2f2-ee8e02a44e97@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d78832f-4148-d0d9-e2f2-ee8e02a44e97@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 09:31:41AM -0600, Eric Sandeen wrote:
> On 2/22/18 9:09 AM, Christoph Hellwig wrote:
> > On Wed, Feb 21, 2018 at 06:16:25PM -0800, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Detect and enable retpolines for all code, to mitigate Spectre v2
> >> (branch target injection) on x86.
> > 
> > The mechanics look ok, but why do we really care for xfsprogs?
> > fs utilities seem like a lesser target and should just be covered

They're a smaller target than the kernel, for sure, but the scary part
about spectre is that unprivileged programs running on the same core as
a privileged xfs_repair can then use branch predictor poisoning to cause
problems with the xfs_repair.

> > by hopefully sane compiler defaults, shouldn't they?

I would have thought so, but look at the gcc manpage:

-mindirect-branch=choice
	Convert indirect call and jump with choice.  The default is
	keep, which keeps indirect call and jump unmodified.  thunk

Unmodified, as in don't provide spectre mitigations...

	converts indirect call and jump to call and return thunk.
	thunk-inline converts indirect call and jump to inlined call and
	return thunk.  thunk-extern converts indirect call and jump to
	external call and return thunk provided in a separate object
	file.  You can control this behavior for a specific function by
	using the function attribute "indirect_branch".

	Note that -mcmodel=large is incompatible with
	-mindirect-branch=thunk nor -mindirect-branch=thunk-extern since
	the thunk function may not be reachable in large code model.

So, gcc defaults to unprotected.

> That's my feeling as well - does manually fixing one utility out of
> hundreds on the system help anything? Shouldn't this be done via toolchain
> or distro-package-build defaults?

Maybe they will someday, but right now:

$ dpkg-buildflags --get CFLAGS
-g -O2 -fdebug-prefix-map=/home/djwong=. -fstack-protector-strong -Wformat -Werror=format-security

It's not clear to me if Debian plans to adopt the per-platform spectre
mitigations distro-wide or just for specific packages, or what?  So far
it looks like Ubuntu is only doing it for their browser packages.  libc
hasn't been rebuilt, which limits the effectiveness of turning it on for
xfsprogs, but otoh we could still protect the bits we control.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
