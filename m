Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02EF34D91F;
	Tue, 21 Oct 2025 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072046; cv=none; b=SZRuVzKhJCP6H+9FhX/AvaBp1Wns6oWgNVeuCmGj0FJMu7GewYfAgfhCN7AIO1wxMCv65F2hBfTrVlxa6m2kbha0oi++A6JUkNPxkX2tbr5TrnfBLMVgGiUku6FR7djtRQtRjg+Z34o3W6Ahr8wR0PJNLiUEHjaaRdAi8flDrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072046; c=relaxed/simple;
	bh=sVWJyRd/YBREjiBjyEIxtNumA603YcMjDuyD8UUdyqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+/gdME2b2pw5QibpJwhs63I5CjRHqV6VxHwluta+OBMe2D32L+nBf2Cv9RffEceVUXkoxfQBaYDuHF+wu9lEEqd4BObA02Jf0iEZXwEoj9ug+MmylM+c4cL0SdDfNxKivr+zb9PJrvCbwuMpwsRF5ZLwsCHIWod4Kp7WaahbJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4EdbWvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4EdbWvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D53C4CEF1;
	Tue, 21 Oct 2025 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072046;
	bh=sVWJyRd/YBREjiBjyEIxtNumA603YcMjDuyD8UUdyqI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U4EdbWvud78JfgQKTWiWwk2b+8hZtliGGHjA0GtmghiHSopHawiOTk4G4unVctflC
	 ZVZ6gxZSwT2Tt6xvQA5UUomEQwfVXKsjKMAVuU3iEocnckFPjgrEkakhTnOuoc6+3L
	 gM1dV5Zdcnrajwv8H1ofMlTBwBwuZd0qt3SSQZBL9HaeVsGd06zFnM/Ggwgvc1bW1C
	 p6KtonUCXi9ql6LOf4k36FCUFLbw+oE5baRtrgN9py/9lImytVcvGlnVxEmVErXCVh
	 HATz/WbSjrBmmv5QKsL76eJ9gdllATiRO2w5oNQCfR5WSyFiRCMmllbHAHVc4pDF0S
	 nO0T7VNorLoZQ==
Date: Tue, 21 Oct 2025 11:40:46 -0700
Subject: [PATCH 06/11] common/filter: fix _filter_file_attributes to handle
 src/file_attr.c file flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188777.4163693.5636086769178869317.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, _filter_file_attributes filters ext4 lsattr flags, but it's
only callers (all introduced in 4eb4017) are using it to filter the file
attribute letters from src/file_attr.c.  These correspond to the flags
defined by the new file_getattr system call, so let's rename the helper
to make it clear we're filtering *VFS* attribute characters, and change
the code to filter all known characters from that interface.

While we're at it, make filtering of multiple characters work
consistently whether we're masking specific flags or everything *except*
those flags.

Cc: <fstests@vger.kernel.org> # v2025.10.05
Fixes: 4eb40174d77c1b ("generic: introduce test to test file_getattr/file_setattr syscalls")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/filter     |   33 +++++++++++++++++++++++++--------
 tests/generic/772 |   38 +++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 27 deletions(-)


diff --git a/common/filter b/common/filter
index b330b27827d005..b27ed7eda61a83 100644
--- a/common/filter
+++ b/common/filter
@@ -683,20 +683,37 @@ _filter_sysfs_error()
 	sed 's/.*: \(.*\)$/\1/'
 }
 
-# Filter file attributes (aka lsattr/chattr)
-# To filter X:
-# 	... | _filter_file_attributes X
-# Or to filter all except X
-# 	... | _filter_file_attributes ~X
-_filter_file_attributes()
+# General filter of file attribute characters, do not call directly
+__filter_file_attributes()
 {
+	local filter="$1"
+	shift
+
 	if [[ $1 == ~* ]]; then
-		regex=$(echo "[aAcCdDeEFijmNPsStTuxVX]" | tr -d "$1")
+		regex=$(echo "[${filter}]" | tr -d "$1")
 	else
-		regex="$1"
+		regex="[$1]"
 	fi
 	awk "{ printf \"%s \", gensub(\"$regex\", \"-\", \"g\", \$1) } {print \$2}"
 }
 
+# Filter src/file_attr.c file attribute characters, which for now match the
+# xfs_io lsattr file attribute characters.
+#
+# WARNING: Be careful, this does not filter ext4 lsattr characters!
+#
+# To filter X:
+# 	... | _filter_vfs_file_attributes X
+# To filter X and Y:
+# 	... | _filter_vfs_file_attributes XY
+# Or to filter all except X
+# 	... | _filter_vfs_file_attributes ~X
+# Or to filter all except X and Y
+# 	... | _filter_vfs_file_attributes ~XY
+_filter_vfs_file_attributes()
+{
+	__filter_file_attributes aACdeEfinpPrsStxX "$@"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/772 b/tests/generic/772
index e68a6724654450..cdadf09ff26158 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -59,13 +59,13 @@ file_attr --set --too-small-arg $projectdir ./foo
 file_attr --set --new-fsx-flag $projectdir ./foo
 
 echo "Initial attributes state"
-file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_file_attributes ~d
-file_attr --get $projectdir ./foo | _filter_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
+file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./foo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
 
 echo "Set FS_XFLAG_NODUMP (d)"
 file_attr --set --set-nodump $projectdir
@@ -77,35 +77,35 @@ file_attr --set --set-nodump $projectdir ./foo
 file_attr --set --set-nodump $projectdir ./symlink
 
 echo "Read attributes"
-file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_file_attributes ~d
-file_attr --get $projectdir ./foo | _filter_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
+file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./foo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
 
 echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
 file_attr --set --set-nodump $projectdir ./broken-symlink
 file_attr --get $projectdir ./broken-symlink
 
 file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
-file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
+file_attr --get --no-follow $projectdir ./broken-symlink | _filter_vfs_file_attributes ~d
 
 cd $SCRATCH_MNT
 touch ./foo2
 echo "Initial state of foo2"
-file_attr --get --at-cwd ./foo2 | _filter_file_attributes ~d
+file_attr --get --at-cwd ./foo2 | _filter_vfs_file_attributes ~d
 echo "Set attribute relative to AT_FDCWD"
 file_attr --set --at-cwd --set-nodump ./foo2
-file_attr --get --at-cwd ./foo2 | _filter_file_attributes ~d
+file_attr --get --at-cwd ./foo2 | _filter_vfs_file_attributes ~d
 
 echo "Set attribute on AT_FDCWD"
 mkdir ./bar
-file_attr --get --at-cwd ./bar | _filter_file_attributes ~d
+file_attr --get --at-cwd ./bar | _filter_vfs_file_attributes ~d
 cd ./bar
 file_attr --set --at-cwd --set-nodump ""
-file_attr --get --at-cwd . | _filter_file_attributes ~d
+file_attr --get --at-cwd . | _filter_vfs_file_attributes ~d
 
 # success, all done
 status=0

