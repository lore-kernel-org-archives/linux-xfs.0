Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36C2B7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 18:18:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BAE6304053
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 16:18:12 -0800 (PST)
Received: from app1a.xlhost.de (mailout173.xlhost.de [84.200.252.173]) by
	cuda.sgi.com with ESMTP id 2xKQBuwNVrVJrBjA for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 16:18:07 -0800 (PST)
Message-ID: <565F8A68.9040401@5t9.de>
Date: Thu, 03 Dec 2015 01:18:48 +0100
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
Subject: Re: automatic testing of cgroup writeback limiting
References: <5652F311.7000406@5t9.de> <20151125213500.GK26718@dastard>
	<565B70F9.8060707@5t9.de> <1711940.cDn6AztRgi@merkaba>
	<20151201163815.GB12922@mtj.duckdns.org>
In-Reply-To: <20151201163815.GB12922@mtj.duckdns.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>, Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 12/01/2015 05:38 PM, Tejun Heo wrote:
> As opposed to pages.  cgroup ownership is tracked per inode, not per
> page, so if multiple cgroups write to the same inode at the same time,
> some IOs will be incorrectly attributed.

I can't think of use cases where this could become a problem.
If more than one user/container/VM is allowed to write to the
same file at any one time, isolation is probably absent anyway ;-)

> cgroup ownership is per-inode.  IO throttling is per-device, so as
> long as multiple filesystems map to the same device, they fall under
> the same limit.

Good, that's why I assumed it useful to include a scenario with more
than one filesystem on the same device into the test scenario, just
to know whether there are unexpected issues if more than one filesystem
utilizes the same underlying device.

>>>> Metadata IO not throttled - it is owned by the filesystem and hence
>>>> root cgroup.
>>>
>>> Ouch. That kind of defeats the purpose of limiting evil processes'
>>> ability to DOS other processes.
>
> cgroup isn't a security mechanism and has to make active tradeoffs
> between isolation and overhead.  It doesn't provide protection against
> malicious users and in general it's a pretty bad idea to depend on
> cgroup for protection against hostile entities.

I wrote of "evil" processes for simplicity, but 99 out of 100 times
it's not intentional "evilness" that makes a process exhaust I/O
bandwidth of some device shared with other users/containers/VMs, it's
usually just bugs, inconsiderate programming or inappropriate use
that makes one process write like crazy, making other
users/containers/VMs suffer.

Whereever strict service level guarantees are relevant, and
applications require writing to storage, you currently cannot
consolidate two or more applications onto the same physical host,
even if they run under separate users/containers/VMs.

I understand there is no short or medium term solution that
would allow to isolate processes writing to the same filesytem
(because of the meta data writing), but is it correct to say
that at least VMs, which do not allow the virtual guest to
cause extensive meta data writes on the physical host, only
writes into pre-allocated image files, can be safely isolated
by the new "buffered write accounting"?

If so, we'd have stay away from user or container based isolation
of independently SLA'd applications, but could at least resort to VMs
using image files on a shared filesystem.

Regards,

Lutz Vieweg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
