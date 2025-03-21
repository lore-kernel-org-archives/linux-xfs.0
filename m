Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559E022AE75;
	Fri, 21 Mar 2025 21:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592478; cv=none; b=oo0VXfSA1HqfA1ZU29tJ5WK/Rshz2BoJCJ29DMAVFflZnRCW2CNpE8KloB1CF5JUk1z1lXWNsNqf3BYwwEHjRqmPAa5WdLBDV1NEHpueluOToyFnVBKxPWxOztFswovMCI+3NqHb/FuzxlOL64Y344KfV3yovz6ABEBvT44aEio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592478; c=relaxed/simple;
	bh=7md1fT4J8la6NB8X5MqoHWWlkWJ5c5EnxluckLLYGjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ck/s3maKhL/O5q4Kj6EI8Nks2tHppd38WOIU9N3ya+01lwqeS6cQHiI7Q8XUnid6cY4xq3W415PtbwZfZh3aZfIwya7gDbMhxhC8UjoCZNkI6bXFqQtMoVUjFKkqEPLsa1C6E3AIF5k++UPfPHPb/34ANbRnysG+tIhsmLZlBBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEgEHLMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEgEHLMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EAAC4CEE3;
	Fri, 21 Mar 2025 21:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592475;
	bh=7md1fT4J8la6NB8X5MqoHWWlkWJ5c5EnxluckLLYGjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TEgEHLMpa2rUGCvY644/EzchzOzWe/zPv2GSSwU2Y/T5Xz0PaAu2sNDoDlQ3hyCtZ
	 5kJH6T7gjveF+ocAjkRBPmmIHgk8EZg/xj29a1oh1xMQ/pybJr4U2xFd3Elg+yHxj7
	 uudmmf4RYGw5goI8spv3a50hXV/yGCIHj8RAs5uNB/kEc/9IewuIHNIz87Znm6PR/J
	 k0S9JzoSuavAuybDhmmQQRnz5nubuvemmzmGuGboGYVFp7U/Isb0TKQ7pjKCxb9bR7
	 MVmXCCvI+28VJKLnNroHC4SIkTHP4p4JjJxExg1QesQChkOGDsmN3uStq8LuXZHI6H
	 59R+GNIVlqb3w==
Date: Fri, 21 Mar 2025 14:27:54 -0700
Subject: [PATCH 2/4] generic/537: disable quota mount options for pre-metadir
 rt filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233999.743619.6582695769493412159.stgit@frogsfrogsfrogs>
In-Reply-To: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this regression in generic/537:

mount: /opt: permission denied.
       dmesg(1) may have more information after failed mount system call.
mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
(see /var/tmp/fstests/generic/537.full for details)

for reasons explained in the giant comment.  TLDR: quota and rt aren't
compatible on older xfs filesystems so we have to work around that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/537 |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/tests/generic/537 b/tests/generic/537
index f57bc1561dd57e..3be743c4133f4f 100755
--- a/tests/generic/537
+++ b/tests/generic/537
@@ -18,6 +18,7 @@ _begin_fstest auto quick trim
 
 # Import common functions.
 . ./common/filter
+. ./common/quota
 
 _require_scratch
 _require_fstrim
@@ -36,6 +37,22 @@ _scratch_mount -o ro >> $seqres.full 2>&1
 $FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
 _scratch_unmount
 
+# As of kernel commit 9f0902091c332b ("xfs: Do not allow norecovery mount with
+# quotacheck"), it is no longer possible to mount with "norecovery" and any
+# quota mount option if the quota mount options would require a metadata update
+# such as quotacheck.  For a pre-metadir XFS filesystem with a realtime volume
+# and quota-enabling options, the first two mount attempts will have succeeded
+# but with quotas disabled.  The mount option parsing for this next mount
+# attempt will see the same quota-enabling options and a lack of qflags in the
+# ondisk metadata and reject the mount because it thinks that will require
+# quotacheck.  Edit out the quota mount options for this specific
+# configuration.
+if [ "$FSTYP" = "xfs" ]; then
+	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
+		_qmount_option ""
+	fi
+fi
+
 echo "fstrim on ro mount with no log replay"
 norecovery="norecovery"
 test $FSTYP = "btrfs" && norecovery=nologreplay

