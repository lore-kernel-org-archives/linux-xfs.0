Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5670722071;
	Wed,  4 Dec 2024 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283950; cv=none; b=pVA+xLM8rgw2dkkVhdSgpS8xKi/0+hCuToA3qDTELMzmaxawuXdTIyNa15b371SeyOcyRYNf+3uk/UZzUg+dT8siYaQPD9PMVjs54DnFEkhM56KmosnFwcLmklKRTss6BA1H/mxsq3+DdgEoZLoh7URpMJAFJXC9crNNss4emqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283950; c=relaxed/simple;
	bh=gRD0JUF7LSfr82pRe9JnQ/VRD+uQICG/NoGzyOTO6Cc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axKRS2IQ7Hrfc4MlyBhx+ZMXsAZhfJlwlDgybSAgfRw45/KOG/T3fmqG7F1I7+MF9Wa36CnubtZL1Ctpz9hX+911DvwWgPPGHYimfxD7R5CaUE33PnBVkcUsBD0wgcKWHqWwKhkoFqfyWDVdW3moFtTYCmomQxwQPQ7Xo0oaJSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuzY8l6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuzY8l6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1449C4CED1;
	Wed,  4 Dec 2024 03:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733283949;
	bh=gRD0JUF7LSfr82pRe9JnQ/VRD+uQICG/NoGzyOTO6Cc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HuzY8l6GQmfl88JfZ+ooOt93n2qFjPPrO3mdSHyBAsEbDe/uMfTARHwZ1QkctUUsb
	 l8r03dC9Qb/UPFKod1V78CzducWKB2dwVfp1VnP0c42Pzi19cjSyEiD/faIF2sPmEu
	 6X50zrr22ANGsHkrVvJ94ukAeCR2WcIqULTDE3313jj2XDz28ULqaODufwkXA7K8tI
	 LePADmve13Vj0ALWRtFNBREIi+F+gF7ywkEoTwFYTZWxL+gDkS1a1CqFmboP6XA7JO
	 5NePwVECGnYg4Va66wUtI7c3/tS4M9+OLU/C1ted2ODlysBQEKt7JgOiTHVGM5MeuT
	 1bAXx8K1ISVhA==
Date: Tue, 03 Dec 2024 19:45:49 -0800
Subject: [PATCH 1/2] xfs/032: try running on blocksize > pagesize filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173328390001.1190210.8027443083835172014.stgit@frogsfrogsfrogs>
In-Reply-To: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we're no longer limited to blocksize <= pagesize, let's make
sure that mkfs, fsstress, and copy work on such things.  This is also a
subtle way to get more people running at least one test with that
config.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/032 |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/tests/xfs/032 b/tests/xfs/032
index 75edf0e9c7268d..52d66ea182d47e 100755
--- a/tests/xfs/032
+++ b/tests/xfs/032
@@ -25,6 +25,17 @@ IMGFILE=$TEST_DIR/${seq}_copy.img
 
 echo "Silence is golden."
 
+# Can we mount blocksize > pagesize filesystems?
+for ((blocksize = PAGESIZE; blocksize <= 65536; blocksize *= 2)); do
+	_scratch_mkfs -b size=$blocksize -d size=1g >> $seqres.full 2>&1 || \
+		continue
+
+	_try_scratch_mount || continue
+	mounted_blocksize="$(stat -f -c '%S' $SCRATCH_MNT)"
+	_scratch_unmount
+	test "$blocksize" -eq "$mounted_blocksize" && PAGESIZE=$blocksize
+done
+
 do_copy()
 {
 	local opts="$*"

