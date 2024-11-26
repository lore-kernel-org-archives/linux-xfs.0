Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0689193419;
	Tue, 26 Nov 2024 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732652850; cv=none; b=XSVuJZEq9X6PWBrjrOE+mxRE8UQ6YGtLBC1X5Po+hJV8kHRB+LWY+bHP+ClEPsXBaUEw2CXsMnhvsDm6/9HAvWRqFq/sHoRDQbQuLO5W/NI2+o+U35WcP1yQblWexkT4WKAHFD/y4Tf4KT1Hjj8SnZ91t2aE2Mk9PZ8d6ClgDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732652850; c=relaxed/simple;
	bh=TYTTEcADoj0P4RwbnNGjWDRcHXFtfoVsq0hH5omAcuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Doijpd0HW0b3xcGLhNJhDaxKkeh4WPe/hEHeZCvgsdQRfM4rzEQR80DBvH1XK5xDqcvBRWGcLwkUSeoNGiddGbHth3/xDY59IFwQnLMGM8cVjpUzAUkDXhOtUHFrJ4u/bd5b17Za5dwenbgQ65ild91EJKBwS4ZlFeY0gfFflMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9ursXUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9ursXUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446DFC4CECF;
	Tue, 26 Nov 2024 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732652850;
	bh=TYTTEcADoj0P4RwbnNGjWDRcHXFtfoVsq0hH5omAcuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k9ursXURTUEReE0n5dqp+zjj2+4ENLdNB9yv2RC4OrNDHQkiDYjAc4tR17qb+oTQk
	 pdfwKjZPJiCLlBoOaExaJPBSb4y08VRFbrkPVtK/xiUdge/5ZkUKQeP6Rc4xSPBVV+
	 2sczYkKnqTcFsxZRPhBCs61OW5W/ww5yVF/mg2MqkYZpD10RPOBWBw0fK2LkvD84+r
	 sAkkbYuoCHQ/A7wL2xgaVC8XwptlpY9lFucA3fwZm/jCWb3SOIVoJOrvQl53xif2B/
	 stzS4mUktk6FqklbX+M38JekD6c94dAVL7qqnvrx0AnpM/KTtAzDfufQrEywPe76CA
	 OxXlXv74wlRug==
Date: Tue, 26 Nov 2024 12:27:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 17/16] generic/459: prevent collisions between test VMs
 backed by a shared disk pool
Message-ID: <20241126202729.GP9438@frogsfrogsfrogs>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

If you happen to be running fstests on a bunch of VMs and the VMs all
have access to a shared disk pool, then it's possible that two VMs could
be running generic/459 at exactly the same time.  In that case, it's a
VERY bad thing to have two nodes trying to create an LVM volume group
named "vg_459" because one node will succeed, after which the other node
will see the vg_459 volume group that it didn't create:

  A volume group called vg_459 already exists.
  Logical volume pool_459 already exists in Volume group vg_459.
  Logical Volume "lv_459" already exists in volume group "vg_459"

But then, because this is bash, we don't abort the test script and
continue executing.  If we're lucky this fails when /dev/vg_459/lv_459
disappears before mkfs can run:

  Error accessing specified device /dev/mapper/vg_459-lv_459: No such file or directory
  Usage: mkfs.xfs

But in the bad case both nodes write filesystems to the same device and
then they trample all over each other.  Fix this by adding the hostname
and pid to all the LVM names so that they won't collide.

Fixes: 461dad511f6b91 ("generic: Test filesystem lockup on full overprovisioned dm-thin")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/459 |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tests/generic/459 b/tests/generic/459
index 98177f6b5ef8fb..32ee899f929819 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -47,10 +47,17 @@ _require_command "$THIN_CHECK_PROG" thin_check
 _require_freeze
 _require_odirect
 
-vgname=vg_$seq
-lvname=lv_$seq
-poolname=pool_$seq
-snapname=snap_$seq
+# Create all the LVM names with the hostname and pid so that we don't have any
+# collisions between VMs running from a shared pool of disks.  Hyphens become
+# underscores because LVM turns those into double hyphens, which messes with
+# accessing /dev/mapper/$vg-$lv (which you're not supposed to do but this test
+# does anyway).
+lvmsuffix="${seq}_$(hostname -s | tr '-' '_')_$$"
+
+vgname=vg_$lvmsuffix
+lvname=lv_$lvmsuffix
+poolname=pool_$lvmsuffix
+snapname=snap_$lvmsuffix
 origpsize=200
 virtsize=300
 newpsize=300
