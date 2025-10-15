Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077532EBBA4;
	Wed, 15 Oct 2025 16:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546330; cv=none; b=k1jzr8IQko8bOssAH+GA8yQPXGqikTn9tJ/sGdL+J0IXcREHER2YXkI+ZeU0DL15U188xugk2oL44dUiOf/wuACEsFSbCTLTFKK+jn3KnV69dcBqhOXustIZcwGGIo6uvpDD9pbm+vLu/F9pWSV4yfI3r4n5oP1b3BMKceSmaRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546330; c=relaxed/simple;
	bh=TBtB9SZHlCb6aUdkP28L/XORjmB1SmT8maHpSFesCaY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XQPoBXthogmlUuenCC7fbwcXFzvNpkE6b3SOzFP6OvG4yCmASdx/5FzNJu0VHIhzSmcaFOPxSythMoahURWlkuhkUl9iYG1UDvQAdL+m1F1K+HI76/hAEg9tIOaupEra/DAF9w9slvWVnYoRo01cSHWUUVzNkoE9vU8AWI3Q5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asSosk4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asSosk4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B53C4CEF8;
	Wed, 15 Oct 2025 16:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546328;
	bh=TBtB9SZHlCb6aUdkP28L/XORjmB1SmT8maHpSFesCaY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=asSosk4u9tZ+NJBKR2AqAX9ayKLf69SVzV7vzwI9SCrP5zyRbzlBe7Q9i6Vuf75Kd
	 ueqvNtt538KUzVzynfYKdx6QVBw7aEn35wPz8mpsynSXMdBS70LrOBgIMS41nQeOTR
	 XgDgSLZwMMpxozM0N7lgl5Zu8q0Sv+cDFI22P/hZMzBPudR9E/K4PQxcEUW6X4cR+w
	 5SeZNP3jaYejsUSggFM5sboxob4PdvJKH2ZppcPt4SqN55jvEn1YPdJ0T8R9Qw/LAe
	 1NtmTeMWfHZJYgBv+YmgtU1n1cB8GUBRUNCYIzif4hor229iRzeTqQ5BKs4FhucJi5
	 PGMT3hi7Jmr1A==
Date: Wed, 15 Oct 2025 09:38:48 -0700
Subject: [PATCH 8/8] common: fix _require_xfs_io_command pwrite -A for various
 blocksizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In this predicate, we should test an atomic write of the minimum
supported size, not just 4k.  This fixes a problem where none of the
atomic write tests actually run on a 32k-fsblock xfs because you can't
do a sub-fsblock atomic write.

Cc: <fstests@vger.kernel.org> # v2025.04.13
Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 1b78cd0c358bb9..dcae5bc33b19ce 100644
--- a/common/rc
+++ b/common/rc
@@ -3030,16 +3030,24 @@ _require_xfs_io_command()
 	"pwrite")
 		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
 		local pwrite_opts=" "
+		local write_size="4k"
 		if [ "$param" == "-N" ]; then
 			opts+=" -d"
-			pwrite_opts+="-V 1 -b 4k"
+			pwrite_opts+="-V 1 -b $write_size"
 		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
-			pwrite_opts+="-V 1 -b 4k"
+			# try to write the minimum supported atomic write size
+			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
+				grep atomic_write_unit_min | \
+				grep -o '[0-9]\+')"
+			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
+				write_size="0 --not-supported"
+			fi
+			pwrite_opts+="-V 1 -b $write_size"
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
-		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
+		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
 		;;
 	"scrub"|"repair")

