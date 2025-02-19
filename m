Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6F9AD21;
	Wed, 19 Feb 2025 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927145; cv=none; b=COAZ7J96IWgC3Ld7dNLQFIzcIFEbwKl6MBUn/2LVu4R3JjlWYw0PQByvcxH1aDdWFo0X1XFjzMBqKSnmfuuMUioQk+WMn6Z35Hx1ufkXJ4VkHkx7BSOv1nWTJMLgiOryN+xT6Wl0P7gVb3Q23r3YFKSdfqQd7PEe7jLGNQt7wiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927145; c=relaxed/simple;
	bh=KmJL6a23nBzXecyC+5PvsCKQ+lzhfnxauKGFBbEGYW4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sL4QASYqjsygv2Tj8jwPV7Pc+Q+S1xJGdV5D+e0i7kwuvvr+vhMnMjp8JmZr9Ys+di/5wlFoCo6mwzC/oHtVPj9NAqq9t8J+2nx3EW4h0mEOkO5lpOeUGRBK03VjZYYNcXZnk40L2Ma6ZlAX2You1L9kEvNKlOImttM9hu0gAmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEn3nKy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEn3nKy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC97C4CEE2;
	Wed, 19 Feb 2025 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927144;
	bh=KmJL6a23nBzXecyC+5PvsCKQ+lzhfnxauKGFBbEGYW4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CEn3nKy789rqndDNcCMqefJlDiz83hOghtltnWj73R3xDADG6aD1jnzw9pNTcuTwE
	 Yc8/o+glfzZI5auSwwN34TuC1C2dlWwdisQLVsWULPrqlqBNg/7XuNEGeS5AMhd8YL
	 xOXZjhoBUGWCMK0bs2eh/246BBQO35CqN6GyY9vhwpjMgahmYHsv+2HFcU6sB9dbTc
	 X18uH550Ei/UN79vne6w9nbJYLiylPvXL16jzIcXi0QJeTi7tPcvFEpCQf3kFWK/Ql
	 SLpJjuNCGNVzKH7vveZPK6DzhlMZ94CvdIVFcB7oPBRYmm4qFP/gIDNHzBwXwyHw9b
	 SBj5FkuMEYRzw==
Date: Tue, 18 Feb 2025 17:05:44 -0800
Subject: [PATCH 08/13] xfs/291: use _scratch_mkfs_sized instead of opencoding
 the logic
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591258.4080556.3753644406313565446.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that _scratch_mkfs_xfs_sized accepts arbitrary mkfs arguments, this
test doesn't need to open-code the helper just to add the dir block and
log size arguments.  Clean this up, which will also help us to avoid
problems with rtrmap if the rt devices is large enough to cause format
failures with the 133M data device size.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/291 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/291 b/tests/xfs/291
index 777968a9240df6..1a8cda4efb3357 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -26,7 +26,7 @@ _xfs_setup_verify_metadump
 
 _require_scratch
 logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=133m)
-_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1
+_scratch_mkfs_sized $((133 * 1048576)) '' -n size=16k -l size=${logblks}b >> $seqres.full 2>&1
 _scratch_mount
 
 # First we cause very badly fragmented freespace, then

