Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50C67F9;
	Mon,  1 Jan 2024 01:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgoC9bx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3EBC433C7;
	Mon,  1 Jan 2024 01:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071024;
	bh=Jn8EPPLiIwzwsA/m8ZGWz3YKKTg8B+NLLSD/2m7i0ZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SgoC9bx9lac+zvF0oQIwizJmZJuKQlGE/fa2u2WG3iCz4bll+6dEVzmuzhH45809A
	 XVMAyq1N5YpJhus66Vihv4nC5wNgLqgHLw+pKxeLF1/XiLXWKntJdSWyGbP0+btbFk
	 Bbc3Hin3gXBGgBAljdyuBetvslPICrKHTGiRCA+wu52nTcMF3iMOdBsDu6Pf8Hs4+U
	 K/4LtOIi2xFnZ8CyDi8TeqMHTLXEIkD1Jh9jdFb6tVBY+xkwiDUoDgj/3f4S3xUDNf
	 moK8ARDtzUU9qD9i4n080t1RMQB5jFY6awDWObBQ6ZLs74hE4MtRKYzQxb+LD5Q5J4
	 3C+j4iGdzFCGg==
Date: Sun, 31 Dec 2023 17:03:43 +9900
Subject: [PATCH 9/9] common/xfs: fix _xfs_get_file_block_size when rtinherit
 is set and no rt section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032134.1827358.4148547989863979616.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/common/xfs b/common/xfs
index aab04bfb18..69a0eb620c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -208,6 +208,8 @@ _xfs_get_file_block_size()
 {
 	local path="$1"
 
+	# If rtinherit or realtime are not set on the path, then all files
+	# will be created on the data device.
 	if ! ($XFS_IO_PROG -c "stat -v" "$path" 2>&1 | grep -E -q '(rt-inherit|realtime)'); then
 		_get_block_size "$path"
 		return
@@ -218,6 +220,15 @@ _xfs_get_file_block_size()
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
 

