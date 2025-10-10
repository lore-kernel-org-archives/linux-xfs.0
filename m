Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20B1C695;
	Fri, 10 Oct 2025 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760123834; cv=none; b=HwE9Wq3D9lPbiAYc8gL7PtZZTzg2oQxXn/jfjieUIft3bUL3bytDOF+/47Yb+4dpkSY/3GjmryUCtdH0Pa8meVfDg9QbpdjJHl6IpQoZsBsTfDYEeZJQccHCNFyJfWSDCZhzyWKDv+mtC+080dS3O1m21xIcymv1rHjQhSWoYfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760123834; c=relaxed/simple;
	bh=PzknFBQw3perTgK6dg6uLwLby5KLLkm09XKTdUT4Yjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKFKWt+PQ3CnaXXU6oDstZR8DvLxampABTv5m748KyAtfIdSxexO3YPp35OGiLBOaaRRl1yI44pHWTl4xetBb8UlE3n/epNE4mcFMcMqPcABwJQnBIBC0KCUZBfdGlPZMMqqGIBa5t38/EC/nJidMgUePH2kcjQSVyAoWeu51OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGRoH7Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGRoH7Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54894C4CEF1;
	Fri, 10 Oct 2025 19:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760123834;
	bh=PzknFBQw3perTgK6dg6uLwLby5KLLkm09XKTdUT4Yjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OGRoH7XmNqahA2QTYXuASvBVgAJDwshyqDJHHQortVTjZ1pz1NLw8+wgYqB5atpg9
	 wOQkVXO8qzkqVn7xRGKX758Z5whVMpmojSFMyknmLstQ451mYCQLCc/R+1cF5X9bPp
	 5xqtdFsbKGfFVz0qKu0ZwUykf/vL5HpU4XgVDVvqX7gjCgks2J57546k1lhRhGinyV
	 pvx1xcTLydKjrqISGjMyL7T0q39xMeZ4XXhQOEb4zGzOw5opwJGV6bXywVTj0tiIwh
	 6qom2HlXdRowVcLuQjUO0YU5th1KChOMsriVxFUC60/URWCAKRzVw/j1VcFTxKzdWY
	 fkBX1VzV8g5Rw==
Date: Fri, 10 Oct 2025 12:17:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <20251010191713.GE6188@frogsfrogsfrogs>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>

On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
> Hey all -
> 
> this got long, so tl;dr:
> 
> 1) concurrency geometry breaks some xfstests for me
> 2) concurrency behavior is not consistent w/ loopback vs. imagefile
> 3) concurrency defaults to the mkfs machine not the mount machine
> 
> In detail:
> 
> So, I realize I'm late to the game here and didn't review the patches
> before they went in, but it looks like the "concurrency" mkfs.xfs
> arguments and defaults are breaking several xfstests.
> 
> 4738ff0 mkfs: allow sizing realtime allocation groups for concurrency
> c02a1873 mkfs: allow sizing internal logs for concurrency
> 9338bc8b mkfs: allow sizing allocation groups for concurrency
> 
> Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
> on various machines with between 8 and 128 CPUS, due to the
> fundamental change in geometry that results from the new
> concurrency behavior, which makes any consistent golden
> output that involves geometry details quite difficult.

Uggggh.  You're right, I see golden output changes in xfs/078 if I boost
the number of VM CPUs past four:

--- /run/fstests/bin/tests/xfs/078.out  2025-07-15 14:41:40.195202883 -0700
+++ /var/tmp/fstests/xfs/078.out.bad    2025-10-10 11:56:14.040263143 -0700
@@ -188,6 +188,6 @@
 *** mount loop filesystem
 *** grow loop filesystem
 xfs_growfs --BlockSize=4096 --Blocks=268435456
-data blocks changed from 268435456 to 4194304001
+data blocks changed from 268435456 to 4194304000
 *** unmount
 *** all done

Can this happen if RAID stripe parameters also get involved and change
the AG count?  This test could be improved by parsing the block counts
and using _within to get past those kinds of problems, if there's more
than one way to make the golden output wrong despite correct operation.

What do your xfs/21[67] failures look like?

> One option might be to detect whether the "concurrency" args
> exist in mkfs.xfs, and set that back to 4, which is probably likely
> to more or less behave the old way, and match the current golden
> output which was (usually) based on 4 AGs. But that might break
> the purpose of some of the tests, if we're only validating behavior
> when a specific set of arguments is applied.

I think you're really asking to force the old behavior from before the
concurrency options existed, but only if fstests is running.  Or maybe
a little more than that; I'll get to that at the end.

> (for 078, adding -d concurrency=4 seems to fix it. For  216 and 217
> I think I needed -l concurrency=4, but this might depend on nr cpus.)
> 
> So, we could probably fix xfstests to make mkfs.xfs behave the old way,
> with loss of coverage of behavior with current code defaults.

Well yes, you'd be losing test coverage either for configurations that
set concurrency options explicitly, or when the storage are
nonrotational.

> Other concerns, though - I see that we only do this if the storage
> is nonrotational. But in testing, if you set up a loop device, the
> loop dev is nonrotational, and gets the new concurrency behavior,
> while doing a mkfs.xfs directly on the backing file doesn't:
> 
> # losetup /dev/loop4 testfile.img
> 
> # mkfs.xfs -f /dev/loop4 2>&1 | grep agcount
> meta-data=/dev/loop4             isize=512    agcount=6, agsize=11184810 blks
> 
> # mkfs.xfs -f testfile.img 2>&1 | grep agcount
> meta-data=testfile.img           isize=512    agcount=4, agsize=16777216 blks
> 
> so we get different behavior depending on how you access the image file.

What kernel is this?  6.17 sets ROTATIONAL by default and clears it if
the backing bdev (or the bdev backing the file) has ROTATIONAL set.
That might be why you see the discrepancy.  I think that behavior has
been in the kernel since ~6.11 or so.

[Aside: Obviously, checking inode->i_sb->sb_bdev isn't sufficient for
files on a multi-disk filesystem, but it's probably close enough here.]

(But see below)

> And speaking of image files, it's a pretty common use case to use mkfs.xfs
> on image files for deployment elsewhere.  Maybe the good news, even if

Yes, mkfs defaults to assuming rotational (and hence not computing a
concurrency factor) if the BLKROTATIONAL query fails.  So that might
be why you get 4 AGs on a regular file but 6 on a loop device pointing
to the same file.

> accidental, is that if you mkfs the file directly, you don't get system-
> specific "concurrence" geometry. But I am concerned that there is no
> guarantee that the machine performing mkfs is the machine that will mount
> the filesystem, so this seems like a slightly dangerous assumption for 
> default behavior.

What I tell our internal customers is:

1. Defer formatting until deployment whenever possible so that mkfs can
optimize the filesystem for the storage and machine it actually gets.

2. If you can't do that, then try to make the image creator machine
match the deployment hardware as much as possible in terms of
rotationality and CPU count.

3. We shouldn't have a #3 because that's leaving performance on the
table.

They were very happy to see performance gains after adjusting their
WOS generation scripts towards #1.

But I think it's this #3 here that's causing the most concern for you?
I suppose if you really don't know what the deployment hardware is going
to look like then ... falling back to the default calculations (which
are mostly for spinning-rust) at least is familiar.

Would the creation of -[dlr] concurrency=never options to mkfs.xfs
address all of your concerns?

> I understand the desire to DTRT by default, but I am concerned about
> test breakage, loopdev inconsistencies, and too-broad assumptions about
> where the resulting filesystem will actually be used.

That itself is a ... very broad statement considering that this code
landed in 6.8 and this is the first I've heard of complaints. ;)

--D

> Thoughts?
> Thanks,
> -Eric
> 
> 
