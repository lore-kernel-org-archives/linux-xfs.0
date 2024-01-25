Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFDA135405;
	Thu, 25 Jan 2024 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209455; cv=none; b=HrYSTBQ7fth+p4/TlR+rAzWp4mNZYo6EuTM0+KJztlA82zZh/7dOvphR9XjbQyhsftpvf+ULzCPRCCz3auq3UhBcT8BEuJHymH/Nfi/oAdpXZAErCT+n6t1z+BzfM1XccImrDhD5XAaRgnPfp0JV8J39anrjUn/k+SKeK+dRZBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209455; c=relaxed/simple;
	bh=5AokXJeh3keA1gMhAeE9qrT5mnwtCxg8tC62AA/W9z0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YXuCZ5UcSYqhdEqs3bHjarxSKMwQ0Gf9OGpbHJiDzVPQhmroJ9ecX4tHUIKnPWHiMgstW0qyddPwpV6wZUupDKFteq/VHumhcZzlS4erokd/44M8B1fWXLH1YH3uZog3jDKyT+tatcVFxTvXrEvkxEwkLKmdnhpMYDOkU87uh+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K69CorOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K69CorOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8761DC433F1;
	Thu, 25 Jan 2024 19:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209454;
	bh=5AokXJeh3keA1gMhAeE9qrT5mnwtCxg8tC62AA/W9z0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K69CorOZsYoloRi/nBItTR1XuxCMQ1kmaaTsrn912pUjzEf+K1HkVJZOBwneLNMw0
	 yeymByi9KO9gPEgneA6p+B43io3co+RaecoECxaUvZNCtFXvLJrIR1qVkN4Zm1Al47
	 wmIAVqpxKvkk9yjvK9qB+cICTFKzT1CBcjfGVDlobhtNKAQmUnCA+nJNrr0iMf02SY
	 rJEy4mROwLNn2W/eDQwXCp229i6vrMVa5DhxdWor2Flj5EMmhk4dRkC9+5CqxKpF7R
	 ICS4pR3p6iA7Ay+NyfZja+i0vaETIEBv1YXImx/EqRjlHKvn+UAsEAJp7BK7jK4sPZ
	 2T52Q/1UM6DMg==
Date: Thu, 25 Jan 2024 11:04:14 -0800
Subject: [PATCH 01/10] generic/256: constrain runtime with TIME_FACTOR
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924382.3283496.6995781268514337077.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

This test runs 500 iterations of a "fill the fs and try to punch" test.
Hole punching can be particularly slow if, say, the filesystem is
mounted with -odiscard and the DISCARD operation takes a very long time.
In extreme cases, I can see test runtimes of 4+ hours.

Constrain the runtime of _test_full_fs_punch by establishing a deadline
of (30 seconds * TIME_FACTOR) and breaking out of the for loop if the
test goes beyond the time budget.  This keeps the runtime within the
customary 30 seconds.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/256 |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/tests/generic/256 b/tests/generic/256
index 808a730f3a..ea6cc2938a 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -44,6 +44,8 @@ _test_full_fs_punch()
 	local file_len=$(( $(( $hole_len + $hole_interval )) * $iterations ))
 	local path=`dirname $file_name`
 	local hole_offset=0
+	local start_time
+	local stop_time
 
 	if [ $# -ne 5 ]
 	then
@@ -57,6 +59,9 @@ _test_full_fs_punch()
 		-c "fsync" $file_name &> /dev/null
 	chmod 666 $file_name
 
+	start_time="$(date +%s)"
+	stop_time=$(( start_time + (30 * TIME_FACTOR) ))
+
 	# All files are created as a non root user to prevent reserved blocks
 	# from being consumed.
 	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size 1 \
@@ -64,6 +69,8 @@ _test_full_fs_punch()
 
 	for (( i=0; i<$iterations; i++ ))
 	do
+		test "$(date +%s)" -ge "$stop_time" && break
+
 		# This part must not be done as root in order to
 		# test that reserved blocks are used when needed
 		_user_do "$XFS_IO_PROG -f -c \"fpunch $hole_offset $hole_len\" $file_name"

