Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759498;
	b=qcckd07B0h2CZjYD1z/0oAUBASrQBICFs0KjQyBDYeOLT3u8BzXTDxpzTGrgRt9iwbVf
	 pLZFNHj1c87Sh9RVBpf++64Td6B1Kasubj16DEPy3Vk8u64z6ZVd1DInz/oqLDqjLcdw0
	 c3gHKjbUwVBVgSK4j7ph+AdYLCapPFreAkA1J2Qd/FEHaJgPqNTNxUaWb+8IkWFR6/Vbb
	 XYFReXbo1Cl1gItXDpHIunUf+2aYDkvmag/udGdhJdSurxMSFDd6UPlJx4A1X0AcH49wc
	 9AQ3iI+JKpCVO5jx8FyFJZdXH1wlnjqcItUf2/bntxi0uxSBUwwKwsqNj77iVkI1RSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759498;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=FwsiwRKiI1Uau+Y+PkzA6OeDUQSFcjgWcDHJQI69nMA=;
	b=t8sBVQ7LY19O0QWld875HvKZO0TV5D5xWI64l2R532w+H+HOlAQrLQPNdWn+EQKNkeCA
	 /2xLC7QDjToQvK5+vDtW404HRpt2uqTP7JC4kuaXmbqjyhhQqqrg4C9ZdXgIaip3M5Jx9
	 b2xS38/FWW0LwBsT6JoxJ563qWOWKY2wiXG3ydXbzgDBBiQiswzn09b2+HB1G2PLZspc4
	 ty7u9QGMlSJV6nhte5s6TkEfMJhsP9BLVGyjgXZU2rHWBtZa4VAfqpEIUwUn6S9puA4z/
	 j49QKBMv3Py6R38TIUGWIFALWCQETCET7AT5HloJ1ctrj1sX+OmKlU9sM4i7kE1WCIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBm9hVmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F28606A31F;
	Fri, 23 Oct 2026 12:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBm9hVmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A4A1F01825;
	Fri, 23 Oct 2026 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759498;
	bh=FwsiwRKiI1Uau+Y+PkzA6OeDUQSFcjgWcDHJQI69nMA=;
	h=From:Subject:Date:To:Cc;
	b=dBm9hVmbTmxT/mZyPVXQ3yWu0AtZ0D4zG2iG/IMEfQ+Lqbh4iycAWhG3LDRbg4a/q
	 alLa5vlpUAVvBLT0KAbuxsAPsfcN6RC7LHa3thjaQPdUFW2iSisZne5MS7u1b1X+LI
	 j3DtDumnjEesTL5+RCebpZ6G56BLMnQQLhmVbYGsg7p8Whh7zKTeZLCoiMN+EWfy79
	 FWPRrZrzmD9nMj1lOVkkVVVYyJwNqFFDgjxBHk0XxbOTBdKDwq8tNVmb45p0bNlUCu
	 kIvZTfGESvh8cK8fpxj+LngmYEoqeP2SMP4p7iASKQyDH7qVz0jGlwDzmq7ZTgJO3f
	 SOvJ8M1UKavug==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] dcache: don't leave negative dentries in casefolded
 directories
Date: Fri, 23 Oct 2026 14:44:21 +0200
Message-Id: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMSw7CMAwFr1J5jaUkiCJxFcQicR0SPgmyy0eqe
 ncSWM7Tm1lAWTIrHIYFhF9Zcy0N7GYASr6cGfPUGJxxozVui+8qV5zIU2IkrxzrbcLoRmd2zDa
 EPTT1IRzz55c9nv6sz3BhmnurP0JTMYgvlPp09zqzwLp+AUZjeLaRAAAA
X-Change-ID: 20261023-work-dcache-casefold-f26205ee1bb7
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, Gabriel Krisman Bertazi <krisman@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2103; i=brauner@kernel.org;
 h=from:subject:message-id; bh=obwKYrdv+CuHpmSgJz0cQ4xOBXMWUIzAFLxt/IHP2aQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdDjvGE+n59XDUZUseP4uX30vFowIbgl9nzFH+phswf
 /LFl5FKHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5o8Lwz3huybO/VRkqGR/l
 n921rmxZ3RM42//il4Jsz+2X89/IaDAybL/gwjf/wow902W8Fp4SqVjwPeBf8yTGCWdjFVvapl2
 cwwwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4, f2fs and tmpfs keep negative dentries out of casefolded
directories. A negative dentry remembers one spelling of the name and
the next create() through it would write that spelling to disk.

So their ->lookup() doesn't cache a miss and their ->unlink() and
->rmdir() call d_invalidate() on the dentry so that d_delete() doesn't
turn it into a negative dentry.

But d_invalidate() is the wrong primitive for that. It's for a name that
went stale. It walks the subtree, prunes it and detaches every mount it
finds, under namespace_sem, and here that runs from inside the
filesystem's own directory operation. ext4_rmdir() does it with the
journal handle still open and ext4_unlink() does it even when the
unlink failed. All anyone wanted is the unhash.

So d_delete() now unhashes the dentry when the parent is casefolded,
next to the dentry-negative sysctl that does the same for every
directory. ext4, f2fs and tmpfs drop their d_invalidate() calls.

xfs's ascii-ci doesn't set S_CASEFOLD and can't so it d_drop()s instead.
I did consider setting S_CASEFOLD on ascii-ci directories and didn't.
overlayfs warns when a layer's casefold flag disagrees with the
superblock having an encoding, and xfs has none.

Nothing changes for userspace. A miss still isn't cached and a removed
name still leaves no negative dentry behind. Verified with the same
create, unlink, create, readdir and stat sequence in a plain and in a
casefolded directory on tmpfs and on ext4, before and after.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      dcache: don't leave negative dentries in casefolded directories
      xfs: unhash a removed name in ascii-ci mode instead of invalidating it

 fs/dcache.c       |  8 +++++++-
 fs/ext4/namei.c   | 18 ------------------
 fs/f2fs/namei.c   |  9 ---------
 fs/xfs/xfs_iops.c |  4 ++--
 mm/shmem.c        |  7 -------
 5 files changed, 9 insertions(+), 37 deletions(-)
---
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
change-id: 20261023-work-dcache-casefold-f26205ee1bb7

