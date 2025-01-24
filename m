Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797C29A5;
	Fri, 24 Jan 2025 03:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737690350; cv=none; b=VzmvBQs04cJ3K0ZQDTlw3xV7+ZA9lUI6ssqZBI2drGkpPkhh274HvCiGcvpcnnihjq5CdujEUUdkgscbb4UmcKRosIvnpnFq77HAH6DUkG8fKrS9l52pEn/RC4EwSz/VEI4I95KD8yZFDP1ijZlfYnj3Ga4KJlALA8d38/+mkME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737690350; c=relaxed/simple;
	bh=uxo/9/fgtMztGry1fTDswhShRpFNssx5PAayahQIVJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KlY+c0YLJp9i+s59v78nJhVMCkLJCYbE1722M/TzKetQGdk8rNU7FrujWGBHXp+KzhcoPSXGWOrgJzhecwiNbaO83gdgK4VKejQ/4Bz9c38WmbZsxd0U5x7271WiJrioUIyNfrO+eAp+1g/aE3RjRUf+eWoUDRfLY7BWijWNfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [220.197.230.228])
	by APP-01 (Coremail) with SMTP id qwCowAC3vtLkDJNn9uwZCQ--.10404S2;
	Fri, 24 Jan 2025 11:45:43 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Fri, 24 Jan 2025 11:45:09 +0800
Message-ID: <20250124034510.672-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAC3vtLkDJNn9uwZCQ--.10404S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW3Kw4fZF18tw1rWw1kAFb_yoWkZFg_Aa
	10gw10gw1UXr9rCws8Awn0yF1vkw4vkFn3Zr40yFsxt34UJ3Z8Jr4qyFZYkr1kGwn8uF95
	Jr42vrs3tryxAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbV8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUoKZXUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAgMA2eSkhDXDQAAsm

In xfs_inactive(), xfs_reflink_cancel_cow_range() is called
without error handling, risking unnoticed failures and
inconsistent behavior compared to other parts of the code.

Fix this issue by adding an error handling for the
xfs_reflink_cancel_cow_range(), improving code robustness.

Fixes: 6231848c3aa5 ("xfs: check for cow blocks before trying to clear them")
Cc: <stable@vger.kernel.org> # v4.17
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/xfs/xfs_inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8ad2606f928..1ff514b6c035 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1404,8 +1404,11 @@ xfs_inactive(
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
-	if (xfs_inode_has_cow_data(ip))
-		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+	if (xfs_inode_has_cow_data(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+		if (error)
+			goto out;
+	}
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
-- 
2.42.0.windows.2

