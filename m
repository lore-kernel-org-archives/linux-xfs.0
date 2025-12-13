Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CDF199237
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765598398; cv=none; b=ZCuEdlE3KkSp68gJo1THSrdIlbGvkkvVLMT1EcJjxeV8SSHHsrtaV09CqfVb+k5aLjBwQMzUt1VbJ1npEp89nbmMVoZe0FZVllH1qszMpAdmHdXGn7zH2fsEPvtWtbHi6COK9N/frS5YGiYybFlwMhfRmAHC+9TVdiAaz13bkr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765598398; c=relaxed/simple;
	bh=LUbcrQeLLRTi6qgkLhlW4rbi1/uZtXOjvs+TcveH5hU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pql8yoteO0G4RbPCvid7ffPtVV5JZgJdimr0IeRXIHs2sGY4JZ+kWC9dtz7V/4RHWRI+CMyiJNVagmy6pyArIChQQaMmFQ7da7iZN72Ilf8/v4F2dlIThUHLK45ez9rzFDVO06Ik+tvhhFPAkCJkqMN/DxVEKa1Wl8yBDDmU+70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dSsyt4XR5zYQtqS
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 30D281A06D7
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPi45DxpYwMCAA--.611S4;
	Sat, 13 Dec 2025 11:59:54 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	dchinner@redhat.com
Cc: yebin10@huawei.com
Subject: [PATCH 0/2] Fix two issues about swapext
Date: Sat, 13 Dec 2025 11:59:49 +0800
Message-Id: <20251213035951.2237214-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPi45DxpYwMCAA--.611S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYe7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84
	ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
	x4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14
	v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0E
	wIxGrwCF54CYxVCY1x0262kKe7AKxVWUAVWUtwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU1zuWJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Ye Bin (2):
  xfs: fix checksum error when call xfs_recover_inode_owner_change()
  xfs: fix xfs_recover_inode_owner_change() failed

 fs/xfs/xfs_inode_item.c         | 4 ++--
 fs/xfs/xfs_inode_item_recover.c | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.34.1

