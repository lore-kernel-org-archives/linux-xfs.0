Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC9B43DA25;
	Tue, 16 Jun 2026 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618981; cv=none; b=IgAMu0Ay6rKvL7KkxD7+eyMRX8f8aph+uZ46mEC78mrEisJpfUkgBV+KY3do+7lTwfoUepeknQL8sxp88EWvSbzB+eyrxtkP4lcIDFYXWa6DA9n1BXtLFfWH8zB5RgMbGy0MrheCSJg8bHsurmsFN0pbV9cvQ1NuzXGYifydFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618981; c=relaxed/simple;
	bh=9HmtDEDStqmbZmIMCUWgddWqXAIThv58DpWYSnfHEN8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thC7A1KwcTmPqlH7YF5Dv/zrLVLnnosxgCxu87zcbJ8kOqj9Mtcw4pJ01te9yGp1FVye3m2nRvFA8uIlnil3jq5VVp9X09+Nz9zQuiP/c4ex33u28muDavtdJL66K2F7pVyST1mUUc7kox1CaZOWPiKqbw48iS8UuUJrDT5q2V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGv1SWC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGv1SWC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDB11F000E9;
	Tue, 16 Jun 2026 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618979;
	bh=rRMc9kMufhtL5v6eg77W3bJ5eLcFDC/5FLFQgRBwgUw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fGv1SWC6fLifdCoGjEb6SbAJe65q/UaRIrA50zk5LlsWkOyH6SSrYS9935kLj3fxJ
	 waRRSXfPj4o4aqawZav1zjhouAaabY0b+APeY3yyL/nHbb3Ul0qYiZUvo2X6+y4AWG
	 qI+5mSwNTdG1AsQvul/ds2mgHaHr8ZAfPCvpXaJBCnLxcrheWDhZB0CNx8PXfVIqUP
	 b45Bugt4XIyBtZKyEnmt7ZLlJIT7cU07X6nEAMkcAYxE0RRWCQ3180uppikYxDuA6A
	 VG6Jw6Rd/c2IK2c/PSP7mnU93etJ9AjGbGiIMtIoERDyv4mFjzZ+CPLbyzivUbkONs
	 YrOKlwiW8iK/A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:33 +0200
Subject: [PATCH RFC v2 17/18] fs: look up the superblock via the device
 table in user_get_super()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3616; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9HmtDEDStqmbZmIMCUWgddWqXAIThv58DpWYSnfHEN8=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGoxWN+g2BMFfjjyx0eEgKp8uxwbtpLCXZ1u++jmYieteacES
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmoxWN8ACgkQkcYbwGV43KKB9gEApvkp
 dtTqpOq8kInsSwhVrk/cmhKt1ogA/Y6whKasJtYBAN3/I0SnAfnUmjGkBjhaY+GrRiNnPZgQ+sC
 FYmb5s2oE
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

user_get_super() still finds the superblock for a device number by
walking the global super_blocks list under sb_lock. Every superblock is
registered in the device table under its s_dev since sget_fc() inserts
it there, including superblocks on anonymous devices, so use the table
instead.

The refcount-pinning cursor helpers super_dev_{get,first,next}() only
touch table state and do not depend on CONFIG_BLOCK, so drop the
CONFIG_BLOCK guard around them: their new caller serves anonymous
devices as well (ustat() on e.g. tmpfs) and is built without
CONFIG_BLOCK. The guard falls in this patch rather than separately
since without this caller the helpers would be unused without
CONFIG_BLOCK.

The pinned entry holds a passive reference on the superblock so
super_lock() can be called directly; once the superblock is locked grab
a passive reference for the caller before dropping the pin.

The device table contains more than the old walk could find: a
superblock is also registered for every additional device it claims
(the xfs log and realtime devices, btrfs member devices, the ext4
external journal, erofs blob devices). Don't filter those out:
specifying any device a filesystem uses now resolves to that
filesystem, so ustat() and quotactl() work on e.g. the xfs log device
or a btrfs member device (the latter used to fail outright as btrfs
superblocks carry an anonymous s_dev that never matches a member
device). When several superblocks share a device (erofs blob devices)
the first live superblock wins.

The cursor also keeps scanning past dying superblocks where the old
walk gave up after the first s_dev match, so a mount racing with the
unmount of the same device (or with the reuse of a recycled anonymous
dev_t) finds the live superblock where the old walk could spuriously
return NULL.

This removes the last s_dev-keyed walk of the super_blocks list and
takes ustat() and quotactl()'s block device lookup off sb_lock
entirely.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2d0a07861bfc..93f24aea75c4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -501,7 +501,6 @@ static int super_dev_register(struct super_block *sb)
 	return err;
 }
 
-#ifdef CONFIG_BLOCK
 static struct super_dev *super_dev_get(struct rhlist_head *pos)
 {
 	struct super_dev *sb_dev;
@@ -535,7 +534,6 @@ static struct super_dev *super_dev_next(struct super_dev *prev)
 	super_dev_put(prev);
 	return sb_dev;
 }
-#endif
 
 static void kill_super_notify(struct super_block *sb)
 {
@@ -1044,29 +1042,19 @@ EXPORT_SYMBOL(iterate_supers_type);
 
 struct super_block *user_get_super(dev_t dev, bool excl)
 {
-	struct super_block *sb;
-
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		bool locked;
+	struct super_dev *sb_dev;
 
-		if (sb->s_dev != dev)
-			continue;
+	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
+		struct super_block *sb = sb_dev->sd_sb;
 
-		if (!refcount_inc_not_zero(&sb->s_passive))
+		if (!super_lock(sb, excl))
 			continue;
 
-		spin_unlock(&sb_lock);
-
-		locked = super_lock(sb, excl);
-		if (locked)
-			return sb;
-
-		put_super(sb);
-		spin_lock(&sb_lock);
-		break;
+		/* The pinned entry holds a passive reference, take our own. */
+		refcount_inc(&sb->s_passive);
+		super_dev_put(sb_dev);
+		return sb;
 	}
-	spin_unlock(&sb_lock);
 	return NULL;
 }
 

-- 
2.47.3

