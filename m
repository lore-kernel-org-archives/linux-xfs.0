Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5A2D9EE2;
	Wed, 15 Oct 2025 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546313; cv=none; b=C2X0vVlopf9YprUiZIPWTIqOB4Hylq+BoISFH15nKNIuizdOSfyVkdSnhIrDYQiYh+Sygw1HN+1yWooK+Gkcft/0+O4hOxhA/O7KFBCE5g2TtN/x4fyZO0cQ6hgXIrE7fZsLCAHNHHRD0gUNDi+3p5tlISM6KJXSeP4h7CpT/7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546313; c=relaxed/simple;
	bh=UyX/qgLmWrnPCJe0sRviI4pxWefDLymn4HyNL43UPKc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMbjsieD5W7TqRig/oGNyh8rtb+hukOjYsuQgGwZ6vakpWSQkuq5Decti45VcEeEjceW03669lIfvw7Wn1tKoYE5228Pc4996bJqic3q1ZEejJ8OzCVTKmln1QJo83SWJxI6+5W1DboHjW0PgvAvrIJwY3HbJiHt1h+bcqI+YWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9n+boQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9n+boQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE6C4CEF9;
	Wed, 15 Oct 2025 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546313;
	bh=UyX/qgLmWrnPCJe0sRviI4pxWefDLymn4HyNL43UPKc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q9n+boQjk20nifqUVQ3E+jrJBTE+91DKW0Z2NNBaEujxgCriaHH3Gq2lNPN1OsvQ7
	 2/xPeGJFA49gJJaJB/6k3lLA2xQV7mgN15kr9ZeK+xGc02nlOOg3lChoJtJqdRqwHx
	 uAI5tZ0/Mn1kTXdfsM13U3Z5pNnTLtoV9/lKmdtzEt22SeYElWwJuAWcumofD/Z7aD
	 9VxixRxvh6yiG3IXaHdYz119q8OOE2hwR4D4Yn4R7uu2rwD4Dv8bmPxAKChPMqzR32
	 alcLdf1WJoJkiwciBYLgCOPYJ2TdJoX7tBuQ29s6DoOZGq4REAb0SY/h4i0mPHHkaj
	 16YEDsI9l1k7w==
Date: Wed, 15 Oct 2025 09:38:32 -0700
Subject: [PATCH 7/8] common/attr: fix _require_noattr2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
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

attr2/noattr2 doesn't do anything anymore and aren't reported in
/proc/mounts, so we need to check /proc/mounts and _notrun as a result.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/attr |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/attr b/common/attr
index 1c1de63e9d5465..35e0bee4e3aa53 100644
--- a/common/attr
+++ b/common/attr
@@ -241,7 +241,11 @@ _require_noattr2()
 		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
 	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
 		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
+	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
+	local res=${PIPESTATUS[2]}
 	_scratch_unmount
+	test $res -eq 0 \
+		|| _notrun "noattr2 mount option no longer functional"
 }
 
 # getfattr -R returns info in readdir order which varies from fs to fs.

