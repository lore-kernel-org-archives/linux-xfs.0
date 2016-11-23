Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43528 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755351AbcKWCLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:11:03 -0500
Date: Tue, 22 Nov 2016 21:02:10 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123020210.GW21290@hungrycats.org>
References: <cover.1479427384.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M9bFcvWzl0n6AFYF"
Content-Disposition: inline
In-Reply-To: <cover.1479427384.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com


--M9bFcvWzl0n6AFYF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
>    implicit EOF gets around this in the existing XFS implementation. I
>    copied this for the Btrfs implementation.

Somewhat tangential to this patch, but on the dedup topic:  Can we raise
or drop that 16MB limit?

The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
behavior for a 128MB extent is to generate 8x16MB shared extent references
with different extent offsets to a single 128MB physical extent.
These references no longer look like the original 128MB extent to a
userspace dedup tool.  That raises the difficulty level substantially
for a userspace dedup tool when it tries to figure out which extents to
keep and which to discard or rewrite.

XFS may not have this problem--I haven't checked.  On btrfs it's
definitely not as simple as "bang two inode/offset/length pairs together
with dedup and disk space will be freed automagically."  If dedup is
done incorrectly on btrfs, it can end up just making the filesystem slow
without freeing any space.

The 16MB limit doesn't seem to be useful in practice.  The two useful
effects of the limit seem to be DoS mitigation.  There is no checking of
the RAM usage that I can find (i.e. if you fire off 16 dedup threads,
they want 256MB of RAM; put another way, if you want to tie up 16GB of
kernel RAM, all you have to do is create 1024 dedup threads), so it's
not an effective DoS mitigation feature.  Internally dedup could verify
blocks in batches of 16MB and check for signals/release and reacquire
locks in between, so it wouldn't tie up the kernel or the two inodes
for excessively long periods.

Even if we want to keep the 16MB limit, there's also no way to query the
kernel from userspace to find out what the limit is, other than by trial
and error.  It's not even in a header file, userspace just has to *know*.


--M9bFcvWzl0n6AFYF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg0+KIACgkQgfmLGlazG5xfjwCfYt6xjzJMNDrkiQKM/ta1nGX5
LJMAmgINVIKzLlIElYh/fCJIn1p8OZ3I
=Kgyt
-----END PGP SIGNATURE-----

--M9bFcvWzl0n6AFYF--
