Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q7ERsf105771 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 02:14:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE97E1D6A352
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 00:17:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	euv1YT77WaRNBdiY for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 00:17:29 -0700 (PDT)
Date: Mon, 26 Jul 2010 17:17:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: permanent kernel upgrading (was: bug and fun with XFS: unable
	to handle kernel NULL pointer dereference)
Message-ID: <20100726071726.GG7362@dastard>
References: <201007260019.51568@zmi.at> <20100726001859.GD655@dastard>
	<201007260752.59573@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007260752.59573@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, Jul 26, 2010 at 07:52:54AM +0200, Michael Monnerie wrote:
> This brings me to another question: openSUSE 11.1 is, despite being old, 
> still maintained, so I was under the impression that I'd get updates for 
> problems.

Most subsystems are not directly "maintained" by the distro
maintainers. They _hope_ the upstream developers backport all their
bug fixes to "long term stable" kernels like 2.6.27 and just merge
those backports in. The reality is that after one or two releases,
upstream has moved on and the long-term stable kernels don't see
very many fixes from upstream...

> But I already received "upgrade your kernel" the last time for 
> my openSUSE 11.2 with it's kernel vmlinuz-2.6.31.12, which by the time 
> was the latest release (in the meantime openSUSE 11.3 got released).

Yup, that's the distro maintainer's way of saying "we don't actively
support that subsystem".

> So is this just a generic recommendation of developers who love the 
> bleeding-edge stuff and know how many problems they fixed since 2.6.27 
> ("yak, that old stuff, how could it ever run?"), or is it known that not 
> enough fixes go into "maintained" kernels by distributions?

I think it is more of a reflection on where resources are available.
Most free distros do very little in the way of maintenance except
for security issues because they don't have the knowledge or
resources to triage and fix most subsystems.

However, upstream resources are limited. If we identify a problem as
a fixed bug, then it is up to the distro maintainers to backport it,
not us. Distro maintenance is not our problem or responsisbility
because no upstream developer has the bandwidth to be able to supply
fixes to everyone, nor are they likely to want to beause it's mostly
boring, unrewarding work.

That said, many upstream developers are also distro
maintainers and as a result those distros tend to keep up to date
with all needed fixes for those subsystems.

> I have tons of servers to maintain, and can't compile kernels on my own 
> anymore (I did this when I was younger), so I used openSUSE and I am in 
> the process of replacing servers to SLES, which should receive much 
> better services but still kernel upgrading is not supported on such 
> platforms. So what is the best practice that one should choose when 
> running "long time services" where you can't upgrade all the time?

Purchase a support contract for an enterprise distro that actively
supports the features you require....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
