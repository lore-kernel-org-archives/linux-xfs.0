Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BDEB66E;
	Wed, 19 Feb 2025 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927332; cv=none; b=sK5h1FjGqW8GdHdp4fLcqQHSF8dO+BX8RqQH1geLQP+2ay0+xDaaYV/Jws1zudDrYbTZt8RBMOHPZFeLZG0AZYhVLDuW4Ka5LN3ATW4aH89OvTbiTK54EPYDkusmJP8wS6mIZGpBT2Yx4WZe9fOr87XYb7J4dwDjuThy21zKMSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927332; c=relaxed/simple;
	bh=S83/2f717kMztXnWsP+oWvLR9dhDhECpLs7pWaIgOv4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYAYGi34MUAPlDmdw6SaS6k0uqNBkB/a7Wd6Oo65CfkqgOLIkA7+7rF6WQMXVAC/pinCd666I6dFmv5gcfQqWH6iNvX+zuNcPGvaQ8yMdRGPkcph9/GfR/VpVoT1qe2xrWNxrOBOobaE0GurMetYUJXISc9Uqh8UVnVaJl2QoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OImfHHLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OImfHHLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3A8C4CEE2;
	Wed, 19 Feb 2025 01:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927332;
	bh=S83/2f717kMztXnWsP+oWvLR9dhDhECpLs7pWaIgOv4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OImfHHLjK4D+Aml6wvLWsUDKEdpfUfiXWH5IQ5ZmZkBRfogH8Vd41tsh9RVAKazqf
	 cw+XqW4l5ELN/XkefsjqLAAyNPjUN5paC3SPbI5ZM5pgk9qylatR9kor8w4KPjDNCb
	 +YvPeFnoK/Ie8oYYrRPqx9YTwP+NBoJySP1Eh1A8FSODTLE9gku4F/yqhJqIRu9xs0
	 SjlSaJfT+NeouPaLBtT7GUy74DOuH6RoYPe5cBh3DZ8qIa5x2OqnfSDHsk4vVpRZpj
	 Xl5xwWI3QDlNRLi1dDm7bbNjqKJdjwaT8fvbiYXQr8MJkdPfp7bYaDyMyV73MpVjmv
	 uBKUzR+KmLmZA==
Date: Tue, 18 Feb 2025 17:08:51 -0800
Subject: [PATCH 7/7] common/xfs: fix _xfs_get_file_block_size when rtinherit
 is set and no rt section
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591882.4081089.18268850968814879942.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's possible for the sysadmin to set rtinherit on the directory tree
even if there isn't a realtime section attached to the filesystem.  When
this is the case, the realtime flag is /not/ passed to new files, and
file data is written to the data device.  The file allocation unit for
the file is the fs blocksize, and it is not correct to use the rt
extent.

fstests can be fooled into doing the incorrect thing if test runner puts
'-d rtinherit=1 -r extsize=28k' into MKFS_OPTIONS without configuring a
realtime device.  This causes many tests to do the wrong thing because
they think they must operate on units of 28k (and not 4k).  Fix this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/common/xfs b/common/xfs
index 2c903d71c9170b..93260fdb4599e2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -213,6 +213,8 @@ _xfs_get_file_block_size()
 {
 	local path="$1"
 
+	# If rtinherit or realtime are not set on the path, then all files
+	# will be created on the data device.
 	if ! ($XFS_IO_PROG -c "stat -v" "$path" 2>&1 | grep -E -q '(rt-inherit|realtime)'); then
 		_get_block_size "$path"
 		return
@@ -223,6 +225,15 @@ _xfs_get_file_block_size()
 	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
 		path="$(dirname "$path")"
 	done
+
+	# If there's no realtime section, the rtinherit and rextsize settings
+	# are irrelevant -- all files are created on the data device.
+	if $XFS_INFO_PROG "$path" | grep -q 'realtime =none'; then
+		_get_block_size "$path"
+		return
+	fi
+
+	# Otherwise, report the rt extent size.
 	_xfs_get_rtextsize "$path"
 }
 

