Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8621A680E;
	Sun, 19 Jul 2026 15:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473900; cv=none; b=PAzpH6+GimwC1BCYrbjC//Ke11sVWarhi2JlKslyrtpVPUNGPbKz6ZA9/y74YtrSH60zkh92ZdIvOeC4aiAsLvZv//Nm4wkbKELI7jgJta1UoPJOHJu9Ldt6YGzAnteNE0BJqOxgiBa/Q50krJoauyfY4ZyPlIY8m3XCbwZdYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473900; c=relaxed/simple;
	bh=MSH/Yvtw0fWLjP6Gfen7E7bHa7wHQY0yKEqNZyf9Sg4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QNlV1Fy569zlaJzVmUULayHT0gKGCv7XxY6N7ZgmbM6y2fEiW2f3Q3hf6G3iLY6vdye4KurypE/1WJMcjsXVFrb/W2qRnrAsnbcoRHMjnfdiLTJSnKj2/nAjrhWNvsEUsl/Zo+Q9SmhLouGXwnX2mA5Fzpf9RToajDWxHnxT0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=L7+PmRrg; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="L7+PmRrg"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JEGcoG1914021;
	Sun, 19 Jul 2026 08:11:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=c6Ir6At13
	Xk0wYfnrfhAhOOajesYhQEvXY5LPsSYVXI=; b=L7+PmRrgpWmKfNEf+5Y+8/iD1
	bmIbc6RtPYG5+HhuN7Atxzi2WowvkZEJYMkppYYvIxXyH1ISc2B1c2YqroJk0tPQ
	SS3KUME+NFFMD9scDNmyi5yEIipSmgmxRZk2tRm6CZiDsPBccWPMZgCyPb/oW6NB
	Yg3Qhh2kESV0DuHN5Hl3f0N0CYPcTZWRUP4tV7fZJRFDxmX9VEcdoJ20Crpb+9b8
	FnvkZ0cjOR6RgSy9LzkRzKU5xQa9J3Km60MxjnEVA+tsPFcysieD2mXN0dxOtHVX
	048Wf8Ceiho6wJuUOe6iPMe7wPlE7oe3JCyBsUpCJAqKL4pem90PZLe7IgExQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg90crvy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 19 Jul 2026 08:11:27 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 19 Jul 2026 08:11:27 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 19 Jul 2026 08:11:25 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH] xfs: handle NULL b_addr in xfs_buf_free
Date: Sun, 19 Jul 2026 23:11:24 +0800
Message-ID: <20260719151124.3514077-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5DToKcwfMuJjUus_CE_F-2ejOj-57sty
X-Proofpoint-GUID: 5DToKcwfMuJjUus_CE_F-2ejOj-57sty
X-Authority-Analysis: v=2.4 cv=AOkSgtoa c=1 sm=1 tr=0 ts=6a5ce91f cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=zys_yUreW9MGcQrFQ0UA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDE2NyBTYWx0ZWRfXy4Bh27DLkyyt
 2lom7c0UpAjQrjCJ0n6fdfeSFdgg7kQ5sjy/n4fQ7abfwSNV+K1RSpjDtrp6lI8Sqnc4PEElkVY
 g61jjd1cyHqsAc9SqcOEgGczykxbfcqpjtujOqpE3jy/BdREajKH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDE2NyBTYWx0ZWRfX47LYuXPMhmza
 3J1VtcVK85z04I9oe28yzpwlHDHzKNnakeEgaRI9TFWU9xGGy4NNb14yfhOYr2scXtK6Uqvg/ST
 qQxIJ5EYQ1bXg8WGY5ewr/0uAUXoIYUK2L/p4Q34TmM1L/W+hjdE2pUJ/pV6bXEBSIU12ZQdUGI
 /aO1+WSgdW3kBiZskAEEyjTwHsksREwIBHQR6MCvklRjkBKuTdNy3c94tSZZVwun1++P2ZS6Xd9
 +TrqkPsFWMZfTIjG2eoVuSCZNi2cv0cUYZ3x6a3kuhineVu9Uw1so5GAfchtnYYhofopqR8B6u/
 7p8log4y04tEk/uXJq8NXIxb33HEXMpXsjH3BvJx/e6yrAdjfHQyBa1KskPBLj8/t7Q95H3JZnX
 rkMUD5/aNrFXXJoGy9iQjkN3MBZMoopNwi15KNfhIfNRB7Mncq5rBZej5yQ8zUmjiRFmlWCXPDo
 zKgXmNcIBiFAQqedSfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190167

When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
bp->b_addr still NULL.  The code falls through to the folio_put path
which calls virt_to_folio(NULL), dereferencing an invalid address and
causing a kernel crash.

 Call Trace:
  xfs_buf_free+0x25f/0x510
  xfs_buf_alloc+0xc98/0x19b0
  xfs_buf_find_insert+0x55/0x14d0
  xfs_buf_get_map+0x122b/0x17c0
  xfbtree_init_leaf_block+0x11c/0x4a0
  xfbtree_init+0x1bb/0x460
  xrep_rmap_setup_scan+0x100/0x1f0
  xrep_rmapbt+0x41/0xc0

Fix this by skipping folio_put() when bp->b_addr is NULL.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Reported-by: syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94c22d92f72f5a235b7d
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e1465e950acc..48d7dfd3e15f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -114,7 +114,7 @@ xfs_buf_free(
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
-	else
+	else if (bp->b_addr)
 		folio_put(virt_to_folio(bp->b_addr));
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
-- 
2.43.0

