Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3480A321F3A
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417349; cv=none; b=rK/U+6mOjL4uvJoi3aMRNEXbyiTJNSoYcGDroiqDSjuG/CalbSUjc1m37c+i5fUGPlUoJ6uc7skMV72TbD53HwINlmz/ebs0f6/FKm7UqpR1OXsm5rGQEVpEsP8lNljr9m39sfW6hMt6UzaXamgX1gMyRjSb+Q0KKta4x4xBU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417349; c=relaxed/simple;
	bh=bXbs9pH6hxU1oG6tjWntTOdw20ojcZIQNkLd9Ua4vSM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=ZcvX53QP83hG4cpJm+KhCnk21u6dcOBKLitha8eucyMCzYZStQCEwachOoN/U3hxN4LFU5+kq8KOir+Qs9kIzZLXKSDx9M2Fogom/lMxGSfkJC5HqwqVcDm6UNDsVtxgfqT6MO9tjiFpiAx9NbUuwYfXBn1SgK6Lh/zKLo2+6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cLhR62bBFz14MqQ;
	Tue,  9 Sep 2025 19:28:50 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C2CC180485;
	Tue,  9 Sep 2025 19:29:03 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 19:29:02 +0800
Message-ID: <6fb6fa53-a1e4-19f0-87e9-443975d2961c@huawei.com>
Date: Tue, 9 Sep 2025 19:29:02 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] libfrog: obtain the actual available device when the root
 device is /dev/root
To: <aalbersh@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <yangyun50@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj500016.china.huawei.com (7.202.194.46)

When starting a Fedora virtual machine using QEMU, if the device corresponding
to the root directory is the entire disk or a disk partition, the device
recorded in /proc/self/mounts will be /dev/root instead of the true device.

This can lead to the failure of executing commands such as xfs_growfs/xfs_info.

$ cat /proc/self/mounts
/dev/root / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
devtmpfs /dev devtmpfs rw,seclabel,relatime,size=4065432k,nr_inodes=1016358,mode=755 0 0
...

$ mount
/dev/sda3 on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
devtmpfs on /dev type devtmpfs (rw,relatime,seclabel,size=4065432k,nr_inodes=1016358,mode=755)
...

$ xfs_growfs /
xfs_growfs: / is not a mounted XFS filesystem

$ xfs_growfs /dev/sda3
xfs_growfs: /dev/sda3 is not a mounted XFS filesystem

$ xfs_info /
/: cannot find mount point.#

So, if the root device is found to be /dev/root, we need to obtain the
corresponding real device first.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 libfrog/paths.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/libfrog/paths.c b/libfrog/paths.c
index a5dfab48..6ff649b8 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -352,6 +352,38 @@ out_nomem:
 	return ENOMEM;
 }

+static char *get_real_root_device(struct mntent *mnt)
+{
+	struct stat st;
+	char path[PATH_MAX], linkpath[PATH_MAX];
+	ssize_t len;
+	char *fake_root_device = "/dev/root";
+	/*
+	 * The /dev/root does not point to a real root device, we need to obtain the
+	 * real device.
+	 */
+	if (strlen(mnt->mnt_fsname) != strlen(fake_root_device) ||
+	    strcmp(mnt->mnt_fsname, fake_root_device))
+		return NULL;
+
+	if (stat(mnt->mnt_dir, &st) < 0)
+		return NULL;
+
+	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d", major(st.st_dev), minor(st.st_dev));
+	len = readlink(path, linkpath, sizeof(linkpath) - 1);
+	if (len < 0 || len >= PATH_MAX)
+		return NULL;
+
+	linkpath[len] = '\0';
+
+	char *p = strrchr(linkpath, '/');
+	if (!p || strlen(p) <= 1)
+		return NULL;
+
+	snprintf(path, sizeof(path), "/dev/%s", p + 1);
+	return strdup(path);
+}
+
 /*
  * If *path is NULL, initialize the fs table with all xfs mount points in mtab
  * If *path is specified, search for that path in mtab
@@ -359,6 +391,7 @@ out_nomem:
  * Everything - path, devices, and mountpoints - are boiled down to realpath()
  * for comparison, but fs_table is populated with what comes from getmntent.
  */
+
 static int
 fs_table_initialise_mounts(
 	char		*path)
@@ -368,6 +401,8 @@ fs_table_initialise_mounts(
 	char		*fslog, *fsrt;
 	int		error, found;
 	char		rpath[PATH_MAX], rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
+	bool		change_device = false;
+	char		*fsname = NULL;

 	error = found = 0;
 	fslog = fsrt = NULL;
@@ -391,6 +426,13 @@ fs_table_initialise_mounts(
 			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
+
+		fsname = get_real_root_device(mnt);
+		if (fsname) {
+			change_device = true;
+			mnt->mnt_fsname = fsname;
+		}
+
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
 			continue;

@@ -402,6 +444,12 @@ fs_table_initialise_mounts(
 			continue;
 		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
 					mnt->mnt_fsname, fslog, fsrt);
+
+		if (change_device) {
+			free(fsname);
+			change_device = false;
+		}
+
 		if (path) {
 			found = 1;
 			break;
-- 
2.51.0

