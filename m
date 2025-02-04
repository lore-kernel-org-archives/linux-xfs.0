Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB9C207A0C;
	Tue,  4 Feb 2025 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704624; cv=none; b=Wq5zKrhWB3H2wReyFiEBomSJUa4gu566grc4DS32APeisvsTI2nBdNFm56Vls6mJ3O0zCG1Kd3wkZVxA6Sh9oFGD1708glfGbdlvlMU44XrM11Exl4zRbVEkIp0obMp7QwO3hiy+MYLK7/TzRKhmFcaP+NDZrDNHZFTlR3Kx6Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704624; c=relaxed/simple;
	bh=0+pBXU0FxR2q4RrYzpQgZpHremTjy6gV7EKX4NFNVdM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQCsH9AnFiWvR9117vfG9CqTXqsXFTaG4CWNMufhTU5Nwvt+4KM69nugrciOSuMEJYl+5vVtv02REPpsRpuO9vw9uZTqaZek3kBtjApneAliKK8TwJLsZKDw1+D5whWHN03jo4uscXavDx8a6Q32R2D5UJ/1MQTCLdxLCbZ2+gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwujY671; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwujY671"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47AAC4CEDF;
	Tue,  4 Feb 2025 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704624;
	bh=0+pBXU0FxR2q4RrYzpQgZpHremTjy6gV7EKX4NFNVdM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NwujY671adjBMYKOKiRdAEDo9qtASN2c0v87HZ4d9lEQ21PKstwHv6/glgu5cH21j
	 mGgccLXW0SE0646FVDwKnEQNRtLKmD6ZD/zBwMuNWQMrKXDVLG55dVDgKpwwN/P6XV
	 gzilXX6t0nzCKmZyK94YOMVOHI2DoKEwQ0JXrV0MhrQNTqKaRWdutT2PQa30ppTWu6
	 EeSzLKhgDce6aizbbXDTEoyR47RdesgC/1xCz5IW+Kweznzwd+YY23Ao1RfdMXj9fr
	 yTk+AQvBJ4bL/3BjNgZvVwhziYu70h/2hF3H0GD7iNE6oevDsmWQKD2ili6MdWCF7f
	 CIV+uZjeiJPHA==
Date: Tue, 04 Feb 2025 13:30:23 -0800
Subject: [PATCH 31/34] misc: don't put nr_cpus into the fsstress -n argument
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406579.546134.8370679231649475524.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

fsstress -n is the number of fs operations per process, not the total
number of operations.  There's no need to factor nr_cpus into the -n
argument because that causes excess runtime as core count increases.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/476 |    2 +-
 tests/generic/642 |    2 +-
 tests/generic/750 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 4537fcd77d2f07..13979127245c77 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -18,7 +18,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((25000 * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 
diff --git a/tests/generic/642 b/tests/generic/642
index 4b92a9c181d49c..3c418aaa32bd23 100755
--- a/tests/generic/642
+++ b/tests/generic/642
@@ -20,7 +20,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((70000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((70000 * TIME_FACTOR))
 
 args=('-z' '-S' 'c')
 
diff --git a/tests/generic/750 b/tests/generic/750
index 5c54a5c7888f1d..a0828b50f3c7e4 100755
--- a/tests/generic/750
+++ b/tests/generic/750
@@ -37,7 +37,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((25000 * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 

