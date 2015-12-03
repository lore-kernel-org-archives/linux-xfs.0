Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B17C97F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 09:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19EC7AC001
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 07:38:05 -0800 (PST)
Received: from mail-yk0-f173.google.com (mail-yk0-f173.google.com
	[209.85.160.173]) by cuda.sgi.com with ESMTP id
	MSR2MoVcAJdbLvST (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2015 07:38:03 -0800 (PST)
Received: by ykfs79 with SMTP id s79so90416445ykf.1
	for <xfs@oss.sgi.com>; Thu, 03 Dec 2015 07:38:03 -0800 (PST)
Date: Thu, 3 Dec 2015 10:38:00 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: automatic testing of cgroup writeback limiting
Message-ID: <20151203153800.GH27463@mtj.duckdns.org>
References: <5652F311.7000406@5t9.de> <20151125213500.GK26718@dastard>
	<565B70F9.8060707@5t9.de> <1711940.cDn6AztRgi@merkaba>
	<20151201163815.GB12922@mtj.duckdns.org> <565F8A68.9040401@5t9.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565F8A68.9040401@5t9.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello, Lutz.

On Thu, Dec 03, 2015 at 01:18:48AM +0100, Lutz Vieweg wrote:
> On 12/01/2015 05:38 PM, Tejun Heo wrote:
> >As opposed to pages.  cgroup ownership is tracked per inode, not per
> >page, so if multiple cgroups write to the same inode at the same time,
> >some IOs will be incorrectly attributed.
> 
> I can't think of use cases where this could become a problem.
> If more than one user/container/VM is allowed to write to the
> same file at any one time, isolation is probably absent anyway ;-)

Yeap, that's why the trade-off was made.

> >cgroup ownership is per-inode.  IO throttling is per-device, so as
> >long as multiple filesystems map to the same device, they fall under
> >the same limit.
> 
> Good, that's why I assumed it useful to include a scenario with more
> than one filesystem on the same device into the test scenario, just
> to know whether there are unexpected issues if more than one filesystem
> utilizes the same underlying device.

Sure, I'd recommend including multiple writers on a single filesystem
case too as that exposes entanglement in metadata handling.  That
should expose problems in more places.

> I wrote of "evil" processes for simplicity, but 99 out of 100 times
> it's not intentional "evilness" that makes a process exhaust I/O
> bandwidth of some device shared with other users/containers/VMs, it's
> usually just bugs, inconsiderate programming or inappropriate use
> that makes one process write like crazy, making other
> users/containers/VMs suffer.

Right now, what cgroup writeback can control is well-behaving
workloads which aren't dominated by metadata writeback.  We still have
ways to go but it still is a huge leap compared to what we had before.

> Whereever strict service level guarantees are relevant, and
> applications require writing to storage, you currently cannot
> consolidate two or more applications onto the same physical host,
> even if they run under separate users/containers/VMs.

You're right.  It can't do isolation well enough for things like
strict service level guarantee.

> I understand there is no short or medium term solution that
> would allow to isolate processes writing to the same filesytem
> (because of the meta data writing), but is it correct to say
> that at least VMs, which do not allow the virtual guest to
> cause extensive meta data writes on the physical host, only
> writes into pre-allocated image files, can be safely isolated
> by the new "buffered write accounting"?

Sure, that or loop mounts.  Pure data accesses should be fairly well
isolated.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
