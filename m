Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F9318EC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895407; cv=none; b=DeQX1nJdo5QCXgxmc/EuhNpfMWigv8l/owcfIgWJUMH64hntH72iEiR9Uo5CjKLnnaV0Ug8r3YxY78wo2QF9nbnRSqb116aceXAzH6pQ/w5q0K2FGxReQtGC1s/lkdY+P/+hq7Y2AeanyhT5cW8rdau765CLtONYmYfM4kBrX2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895407; c=relaxed/simple;
	bh=lwBh38dN94VCcOWT2NuX0BG0bZ3mWa9eTu715aIh1wA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnXAl+dlVFU+mCheQgePvuHlvpe6C5yv+o70SSBAyAkGOvqUetcpCsCYUqit9Q429gRg1T+wmeYO3X9aZQlDCjQ5+E/Ou5GXdvGpjwSMuMgUI3t4nLKuUY09AkcCR1TWxpUoKQ+8w8Oi7xI0izcsspCprpU07JuqIXLYbToNWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZCk3ZYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZCk3ZYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEA8C2BC9E;
	Thu, 19 Mar 2026 04:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895407;
	bh=lwBh38dN94VCcOWT2NuX0BG0bZ3mWa9eTu715aIh1wA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sZCk3ZYKQtlLaGOC09xUImyPCDnRMzl0/8eJFua+f8VyW2G9Vd3/fA3NdBH2UTuuK
	 WO89N1RUY003PumgFYwjP7fwzY0QN4ARGD/JZEp4H3vy4P0Bk1uRRdMkWSF3Y4pce/
	 qNeHJ64J6Lzv+SmkAWL77Vrn9UBucWYh1yUg1gfFI7UNwDWr3ch5iNsgkfi8gsEz7v
	 G7VNCzDUOUupqD6tjJ5BlYTgVi9KUFHDRClmObT7bnwlVtx8yp5xQkEi24KlGNe6pX
	 1AM4zXif1cLXyk8LFj3uqOxCZHOSVCUIIQqgo0iu2RJWSN3XM1ppik/udRNOxezL78
	 FXX7fgQWeBtOA==
Date: Wed, 18 Mar 2026 21:43:26 -0700
Subject: [PATCH 18/26] xfs_healer: use getmntent to find moved filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506476.3680139.4569078107390853902.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's possible that a mounted filesystem can move mountpoints between the
time of the initial mount (at which point xfs_healer starts) and when
it actually wants to start a repair.  When this happens,
weakhandle::mountpoint becomes obsolete and opening it will either fail
with ENOENT or the handle revalidation will return ESTALE.

However, we do still have a means to find the mounted filesystem -- the
fsname parameter (aka the path to the data device at mount time).  This
is record in /proc/mounts, which means that we can iterate getmntent to
see if we can find the mount elsewhere.

As documented a few patches ago, this would be easier if we had
revocable fds that didn't pin mounts, but that's a very huge ask.

This getmntent code enables xfs_healer to find a filesystem that has
been bind mounted in a new place and the original mountpoint detached:

# mount /dev/sda /mnt
# xfs_healer /mnt &
# mount /mnt /opt --bind
# umount /mnt

The key here is that each bind mount gets a separate struct mount
object.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/weakhandle.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 849aa2882700d4..5df5207514e38e 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -65,10 +65,14 @@ weakhandle_alloc(
 	return -1;
 }
 
-/* Reopen a file handle obtained via weak reference. */
-int
-weakhandle_reopen(
+/*
+ * Reopen a file handle obtained via weak reference, using the given path to a
+ * mount point.
+ */
+static int
+weakhandle_reopen_from(
 	struct weakhandle	*wh,
+	const char		*path,
 	int			*fd)
 {
 	void			*hanp;
@@ -78,7 +82,7 @@ weakhandle_reopen(
 
 	*fd = -1;
 
-	mnt_fd = open(wh->mntpoint, O_RDONLY);
+	mnt_fd = open(path, O_RDONLY);
 	if (mnt_fd < 0)
 		return -1;
 
@@ -102,6 +106,49 @@ weakhandle_reopen(
 	return -1;
 }
 
+/* Reopen a file handle obtained via weak reference. */
+int
+weakhandle_reopen(
+	struct weakhandle	*wh,
+	int			*fd)
+{
+	FILE			*mtab;
+	struct mntent		*mnt;
+	int			ret;
+
+	/* First try reopening using the original mountpoint */
+	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd);
+	if (!ret)
+		return 0;
+
+	/*
+	 * That didn't work, so now walk /proc/mounts to find a mount with the
+	 * same fsname (aka xfs data device path) as when we started.
+	 */
+	mtab = setmntent(_PATH_PROC_MOUNTS, "r");
+	if (!mtab)
+		return -1;
+
+	while ((mnt = getmntent(mtab)) != NULL) {
+		if (strcmp(mnt->mnt_type, "xfs"))
+			continue;
+		if (strcmp(mnt->mnt_fsname, wh->fsname))
+			continue;
+
+		ret = weakhandle_reopen_from(wh, mnt->mnt_dir, fd);
+		if (!ret)
+			break;
+	}
+
+	if (*fd < 0) {
+		errno = ESTALE;
+		ret = -1;
+	}
+
+	endmntent(mtab);
+	return ret;
+}
+
 /* Tear down a weak handle */
 void
 weakhandle_free(

