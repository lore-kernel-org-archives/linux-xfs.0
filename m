Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61DBE4E
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 01:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SvxYt2FwtzZckQ;
	Wed, 20 Dec 2023 09:58:58 +0800 (CST)
Received: from dggpemd100005.china.huawei.com (unknown [7.185.36.102])
	by mail.maildlp.com (Postfix) with ESMTPS id 1234D1800BB;
	Wed, 20 Dec 2023 09:59:05 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemd100005.china.huawei.com (7.185.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Wed, 20 Dec 2023 09:59:04 +0800
Message-ID: <2a51a8b8-a993-7b15-d86f-8244d1bfce44@huawei.com>
Date: Wed, 20 Dec 2023 09:59:04 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: <shikemeng@huawei.com>, <louhongxiang@huawei.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH]: mkfs.xfs: correct the error prompt in usage()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemd100005.china.huawei.com (7.185.36.102)

According to the man page description, su=value and sunit=value are both
used to specify the unit for a RAID device/logical volume. And swidth and
sw are both used to specify the stripe width.

So in the prompt we need to associate su with sunit and sw with swidth.

Signed-by-off: Wu Guanghao <wuguanghao3@huawei.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd3360dc..c667b904 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -993,7 +993,7 @@ usage( void )
 /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
                            inobtcount=0|1,bigtime=0|1]\n\
 /* data subvol */      [-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
-                           (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
+                           (sunit=value|su=num,swidth=value|sw=num,noalign),\n\
                            sectsize=num\n\
 /* force overwrite */  [-f]\n\
 /* inode size */       [-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
--
2.27.0
