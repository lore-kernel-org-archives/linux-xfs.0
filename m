Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FED38120A;
	Tue, 16 Apr 2024 23:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713311471; cv=none; b=cs6BkoUJRr9Tobj7OxFSEzpTLhzKK6sXPrAGZcTqxDDYu7EWdqMDlfcE9cI0p0K/E5nQBDh0hmocsfqau3Y4mnMCaoQr4bHnXLe3W5exh3OMvMOhdvTGOztYaigZ9uTGIRzodUqloF84Q1S1W35MtyYqT2+zBVtoG7jSb8WawJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713311471; c=relaxed/simple;
	bh=eIegRAFHlmZkRxQIGXt/J3G954xviKmTwp2pdpZQ2rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TcXu6dlUrT3hr5HE6cmjEEa29c6I8dpy3Ke9bsGgevTbJy5vVLrBJ1E924p1AMVuqUML6MRhkEhWqKDoShvJUsYNswTM+8LS/MS0rizoxDYa38JalU/vMPyrtsKZXkTPguCtnftxvLaOSDlCnQqzHYUfa2nfmkdWniOXdCcuzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4oX3g+hd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4oX3g+hd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7FcGt9uuVL8VUGfLfp4v3yZVKMExWsvnTfXTxHYYots=; b=4oX3g+hdR+qsvw7IDocEo5CrpJ
	AR26SDbha+h5lQDe5bD69IDXQoF5tgFYd0rHm5sgUJ5k6sdNlcT2I2LbMaWVKfqJGrcA0gP41z8zF
	r3SW+Y0/G11CTXQiiOiW4G3wwVoZ7PalO9mEK0KGqtO2cqzgg4rLsDTRB6INhStl4EnFeHfcXE6xT
	R8AuRsvpq+D2xLNQ/Cv2VEiJ1qzb5Ig5onafn4ulvah86Za1yOjrj8cPim/qCQP6KwFdJuPE/ORrJ
	OOv5zn5X49RuHMY+FbBqqFKyVInS2QpE2QScbU/JEZF+88JEhwz3cCsE0D9EqH8TyCG8jTgfxYPBB
	69zHLZJg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwsZx-0000000EEG5-1uD7;
	Tue, 16 Apr 2024 23:51:09 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: kdevops@lists.linux.dev
Cc: linux-xfs@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH kdevops] xfs: add xfs/242 as failing on xfs_reflink_2k
Date: Tue, 16 Apr 2024 16:51:08 -0700
Message-ID: <20240416235108.3391394-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This test is rather simple, and somehow we managed to capture a
non-crash failure. The test was added to fstests via fstests commit
0c95fadc35c8e450 ("expand 252 with more corner case tests") which
essentially does this:

+       $XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
+               -c "pwrite 0 $block_size" $sync_cmd \
+               -c "$zero_cmd 128 128" \
+               -c "$map_cmd -v" $testfile | $filter_cmd

The map_cmd in this case is: 'bmap -p'. So the test does:

a) truncates data to the block size
b) sync
c) zero-fills the the blocksize

The xfs_io bmap displays the block mapping for the current open file.
Since our failed delta is:

-0: [0..7]: data
+0: [0..7]: unwritten

So it would seem we somehow managed to race to write, but it never
went anywhere. I can't reproduce yet, but figured I'd put this out
there to at least acknowledge its seen at least once.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Super rare to trigger this but figured I'd check to see if others have seen
this fail before. This was on vanilla v6.8-rc2. I'm wondering a race is
possible with a guest using sparse files on the host, and the host somehow
incorrectly informing the guest the write is done. btrfs sparse files
were used on the host for the drives used by this guest for scratch drives.

 .../fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt b/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
index f6ea47b0479f..8b4161f3700e 100644
--- a/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
+++ b/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
@@ -19,6 +19,7 @@ xfs/075
 xfs/155
 xfs/168
 xfs/188
+xfs/242 # F:1/2000 non-fatal failure cosmic ray? https://gist.github.com/mcgrof/6ef50311179a65221413a63c0cc8efd1
 xfs/270
 xfs/301
 xfs/502 # F:1/8 korg#218226 xfs assert fs/xfs/xfs_message.c:102
-- 
2.43.0

