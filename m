Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C321C350D55
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725595; cv=none; b=E+NQTGvciHy/kdDOw5p6JeojAchSRWsQX8NbLsDMDrbRRJf2ZiHeN/vJSC6iQpvnrkK5FYoEtRx4vQMk1iZvHCUFSOrheYRxHkiDKyTSvbEpnUlTthGXBsrhVHfOVcrAWZuCXqCxBJbAvRmdKcbzuyExPud7Yo7zYw6eCAwg+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725595; c=relaxed/simple;
	bh=PHAvl9WpAsfj643mF/0X8OTKAxgzfE58alajDLT1lKE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TPrwb+7GyVbr9Gtm2Qy26etv63SS6khw42hqsDMcBaIk7JCKTUkRWTi3tG8W7k5isO0g3tl585AStHXFJaUV5MTWFmZM82OnD/HBo6FFeOV9uH7N4kG2W6JxBShp9lARP2X3FM26dQBrNRCQco2+B5PPb3WvctwYl5TjQrFTsLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBjEQ7oU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBjEQ7oU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54443C116C6;
	Tue,  6 Jan 2026 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725595;
	bh=PHAvl9WpAsfj643mF/0X8OTKAxgzfE58alajDLT1lKE=;
	h=Date:From:To:Cc:Subject:From;
	b=PBjEQ7oUbL+LAf3mwz5HLsWk5l2u9Mw2kBmuF1jiBd82F7mv+m+8tB2hYC1cLSoN4
	 gDqDmNRvMqPeNUQu6N7kQdXhzQMyDsonVErg45b5i2rIUX0ouKOOH64PZGyqjIwvAi
	 g3ZQi35t+ev5bkJyJ9LMfn9NsXmbnSDLmckRX0guQPTe8r4/2yDTQegcyw6G/jpJ0e
	 0RKD6BXQDMJmGHIozafFzKUgVk4jbSjS01uy1jw3pOU43qkIaNFuMNsTkCkmdvzCQY
	 z5MZg9ujz0yW+2s+151L88X2+pw9yzJ6tt2HHzfDKPDMR3eg+sdAoqkH1ZjXKMOdQY
	 oTuGV3aa8hNig==
Date: Tue, 6 Jan 2026 10:53:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] mkfs: set rtstart from user-specified dblocks
Message-ID: <20260106185314.GJ191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

generic/211 fails to format the disk on a system with an internal zoned
device.  Poking through the shell scripts, it's apparently doing this:

# mkfs.xfs -d size=629145600 -r size=629145600 -b size=4096 -m metadir=1,autofsck=1,uquota,gquota,pquota, -r zoned=1 -d rtinherit=1 /dev/sdd
size 629145600 specified for data subvolume is too large, maximum is 131072 blocks

Strange -- we asked for 629M data and rt sections, the device is 20GB in
size, but it claims insufficient space in the data subvolume.

Further analysis shows that open_devices is setting rtstart to 1% of the
size of the data volume (or no less than 300M) and rounding that up to
the nearest power of two (512M).  Hence the 131072 number.

But wait, we said that we wanted a 629M data section.  Let's set rtstart
to the same value if the user didn't already provide one, instead of
using the default value.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 2e5a737a61d34e ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76df..ab3d74790bbcb8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3720,17 +3720,28 @@ open_devices(
 		zt->rt.zone_capacity = zt->data.zone_capacity;
 		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
 	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
-		/*
-		 * By default reserve at 1% of the total capacity (rounded up to
-		 * the next power of two) for metadata, but match the minimum we
-		 * enforce elsewhere. This matches what SMR HDDs provide.
-		 */
-		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
-					      BTOBB(300 * 1024 * 1024));
+		if (cfg->dblocks) {
+			/*
+			 * If the user specified the size of the data device
+			 * but not the start of the internal rt device, set
+			 * the internal rt volume to start at the end of the
+			 * data device.
+			 */
+			cfg->rtstart = cfg->dblocks << (cfg->blocklog - BBSHIFT);
+		} else {
+			/*
+			 * By default reserve at 1% of the total capacity
+			 * (rounded up to the next power of two) for metadata,
+			 * but match the minimum we enforce elsewhere. This
+			 * matches what SMR HDDs provide.
+			 */
+			uint64_t rt_target_size = max((xi->data.size + 99) / 100,
+						      BTOBB(300 * 1024 * 1024));
 
-		cfg->rtstart = 1;
-		while (cfg->rtstart < rt_target_size)
-			cfg->rtstart <<= 1;
+			cfg->rtstart = 1;
+			while (cfg->rtstart < rt_target_size)
+				cfg->rtstart <<= 1;
+		}
 	}
 
 	if (cfg->rtstart) {
