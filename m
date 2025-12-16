Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017F328B78;
	Tue, 16 Dec 2025 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909782; cv=none; b=KJ7XmUdXkaR5kQQiJmy6jeWTzK8g/+BTwobthVgAdFSDy4UIE/uI1fKTBzMqurDXTad1Fo6s3KterQ0ZEVqMisEJAgP0EKXoc5IBY3X3Q7OFdOsWIzdePJ61ZAOx311od6fzuGMTsv8Ihb9Zqk2scG7arndoslbEpDmUpCg3YhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909782; c=relaxed/simple;
	bh=ruv2/BI/Gy2hQsXVH6MoVtmXQqND3LA0wptaX/jUCjM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZLH0KIsikeLgjE+gjEfkgav2s0zyz6Ezd8zrzqWBU248lOgEHLZDyBMTKwpZ9DZGtETP9aOmMRT9/6L1Z040VYQTvPbWGl22ENywfEaieuoRkPfpj+LGUl9psz7cYjjvKzUqiyVl3jwNtKZjfH+ROJGZZVphSAO6Dz3F2iHuBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+z80O+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+z80O+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754DCC4CEF1;
	Tue, 16 Dec 2025 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765909781;
	bh=ruv2/BI/Gy2hQsXVH6MoVtmXQqND3LA0wptaX/jUCjM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p+z80O+9Yh9yYQElM5kz8vqrEjvh+u/m1vR4Dkiym4xrxxD8nnsL+Lb10kZSJCabd
	 rOhatJg2waYMVI5enhFhpXY2eCY+iPLY5n2Qf8hT1RIFb0poxTjzhuoJiMZlciNsba
	 QsffjIYkoXLz9W8Fb9Mk9pEhTASnZoArx8qFb+NqNRKxOXMN9mZ1ri7Rtmwkp/Vbuz
	 jBaT7w+RklxZcm60VsmdATWvYkl0B+kkF8mj3UfOmSfrJZ+y6JWnsabibh9gtm9uan
	 YGjolowxouOONFFAWMY/qGtCBkhqEdmckAiqgFjPbyNNsEoRLcJPzWavZYjAWmya3R
	 EtCbpZALrTJ3Q==
Date: Tue, 16 Dec 2025 10:29:41 -0800
Subject: [PATCH 2/3] common/rc: fix _xfs_is_realtime_file for internal rt
 devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176590971755.3745129.1885534255261064844.stgit@frogsfrogsfrogs>
In-Reply-To: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we can have internal realtime devices, it's possible to have a
realtime filesystem without setting USE_EXTERNAL=yes or SCRATCH_RTDEV.
Use the existing _xfs_has_feature helper to figure out if the given path
points to a filesystem with an online realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/xfs b/common/xfs
index ffdb82e6c970ba..8b1b87413659ad 100644
--- a/common/xfs
+++ b/common/xfs
@@ -253,9 +253,9 @@ _xfs_get_dir_blocksize()
 # Decide if this path is a file on the realtime device
 _xfs_is_realtime_file()
 {
-	if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_RTDEV" ]; then
-		return 1
-	fi
+	local mntpt="$(findmnt --target "$1" --noheadings --output TARGET)"
+
+	_xfs_has_feature $mntpt realtime || return 1
 	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
 }
 

