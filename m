Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765D1F26C5;
	Fri,  8 Nov 2024 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731087708; cv=none; b=DUfOVowvwCBA8M8Diy92pa5tNLX1gESUpvudMrQzh3U4UM4W680lDmOQjBYZ3W+rnptvzNSxpcF0MSsMlhdbk5V8nt5tB1Ub6n1Xlc1aKoeTt65TSLHLlYdboNWz8TIPVjB7yhIKb3nRG/XC3W4inKpBwLTSTltqOTMxP5Vo4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731087708; c=relaxed/simple;
	bh=VclaWvdkxpptGDvK2BA0TUVaDNHOuuyZhj4O+cP8jck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpqUKQgRw7ox9In3TRPaPSYLnrOP8PWInnKX+kGzilbI7YDC38ikaH14VO6zPRfmGTETBnCPpNcMwbVzq2N6OAG7NOTnKkYOCqoKT6nCF5gtQrHiWtrr3DKMjFanIbgAfM3/uTHtrSG7n0rlwzFgtkPU7QqSk3lKHiahlB4/59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4XjXrQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4XjXrQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8223EC4CECF;
	Fri,  8 Nov 2024 17:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731087707;
	bh=VclaWvdkxpptGDvK2BA0TUVaDNHOuuyZhj4O+cP8jck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b4XjXrQw2mQcp9/XD6y9UabaISht3Tv2V92FlpABdFqnrBpdxUo8/LZQ4iv++Oghf
	 HkFGfkXgANgE2e2AmrMNQAqyHPkwIS/Z1PImTqdhtwoXwHXw5VZWjPEzKHIyY8aUKU
	 MI/lat8wkE4LyLH5y9Ub1AOXUNfIhxXIYuhO19qh0BGzXq1ih7gHw8Dj8YVuwmL4mi
	 kZPngLTgOd83U9/apLuq492//hRbL/FbsEFaxiT+FqEe5N/LZelfiWGR/QlG2+dhaH
	 dVErdtBM8/ENI4tfymgrxGqhNImTZpSMK2E7/VcxzwfbqNbePygDwAprGJsDE2+zVP
	 UzwDhJXxbTHBw==
Date: Fri, 8 Nov 2024 09:41:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs/273: check thoroughness of the fsmappings
Message-ID: <20241108174146.GA168062@frogsfrogsfrogs>
References: <20241108173907.GB168069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108173907.GB168069@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Enhance this test to make sure that there are no gaps in the fsmap
records, and (especially) that they we report all the way to the end of
the device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/273 |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tests/xfs/273 b/tests/xfs/273
index d7fb80c4033429..ecfe5e7760a092 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -24,6 +24,8 @@ _require_scratch
 _require_populate_commands
 _require_xfs_io_command "fsmap"
 
+_fixed_by_git_commit kernel XXXXXXXXXXXXXX "xfs: fix off-by-one error in fsmap's end_daddr usage"
+
 rm -f "$seqres.full"
 
 echo "Format and mount"
@@ -37,6 +39,51 @@ cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
 
 diff -uw $TEST_DIR/a $TEST_DIR/b
 
+# Do we have mappings for every sector on the device?
+ddev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
+rtdev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtblocks)
+fsblock_bytes=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
+
+ddev_daddrs=$((ddev_fsblocks * fsblock_bytes / 512))
+rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
+
+ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
+if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
+	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
+fi
+
+$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | awk -F ',' \
+	-v data_devno=$ddev_devno \
+	-v rt_devno=$rtdev_devno \
+	-v data_daddrs=$ddev_daddrs \
+	-v rt_daddrs=$rtdev_daddrs \
+'BEGIN {
+	next_daddr[data_devno] = 0;
+	next_daddr[rt_devno] = 0;
+}
+{
+	if ($1 == "EXT")
+		next
+	devno = sprintf("%x:%x", $2, $3);
+	if (devno != data_devno && devno != rt_devno)
+		next
+
+	if (next_daddr[devno] < $4)
+		printf("%sh: expected daddr %d, saw \"%s\"\n", devno,
+				next_daddr[devno], $0);
+		next = $5 + 1;
+		if (next > next_daddr[devno])
+		       next_daddr[devno] = next;
+}
+END {
+	if (data_daddrs != next_daddr[data_devno])
+		printf("%sh: fsmap stops at %d, expected %d\n",
+				data_devno, next_daddr[data_devno], data_daddrs);
+	if (rt_devno != "" && rt_daddrs != next_daddr[rt_devno])
+		printf("%sh: fsmap stops at %d, expected %d\n",
+				rt_devno, next_daddr[rt_devno], rt_daddrs);
+}'
+
 # success, all done
 status=0
 exit
