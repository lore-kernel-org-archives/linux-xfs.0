Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D024B95D8;
	Mon, 28 Sep 2026 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597061; cv=none; b=FUjKRUq3+13NkhA3E9chLzBfLlHaa/Fqf6xMdLIWFvsi7esJQpgvOiBk5xD4Qw5xs4ESl6ag/tfB/3HqlP2f23k/n0R2bJJW6BnTs12q0KDyPEh5VKzi3IYyzJWEKcB9dSyuacgB6Nll8T2gyrROOXtxW9BEPAT78fEcBo9Z0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597061; c=relaxed/simple;
	bh=vSzIHLLXRig7Gc+eEd2UKF5AHtG1Qa3qSkDHs2rh1PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rj/PLSv9fLDq0GVgpdMUkiRzY6FDHSkf+liPHlnJOYxqrRB4Jg3JxyLSOFI3dVfTyrMcF86Z4vTy+dGBhmMfSwTMkPun3xEzGvnfmn0HPRb9PIJT5bi0uH6zmHSDm0Hwp/bDS5GWLGtH2QMPSDhLxysn89c4aOQfJ/0GwWFi/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jSYuskKy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jSYuskKy"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZUqi3374967;
	Mon, 28 Sep 2026 12:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RQCcbouV3NVK8Fq18
	0GFDWtpA4XeDMQjNFVf9WeK5RA=; b=jSYuskKyl754ESxGOnp1SHHAjlxLrMkvj
	nc4SNRQJvCmZzdTJTI+LDSAfu+W8Q9oXX0kZxLV3eCa0jCkX1I1jZYtBmsK3hQJZ
	JDXTxq1bSO17L6e0pr7Veesewxcarzda4RLmFL7goFK/er01VsvpaCqCoslCAerp
	Q8FcMgbH2wJPdidU1vt6pKwGynPKObubjFHV/Gd3W8QN3auqZESCHk5S+6XkMzNW
	scnuo/Anhwn5RHpKiH9NYmz94qHBWMO7xuWHNX7tf92Qor5UnsF4Ryntg/CI1Wsu
	nHubqZKfz4tguG4yr4tZ27UlU2V5XByiqjYc219YX7KJhfWI8wKlw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr13mv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHZZ92943242;
	Mon, 28 Sep 2026 12:03:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg4wq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3ibS49873332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26C7820043;
	Mon, 28 Sep 2026 12:03:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0979B20040;
	Mon, 28 Sep 2026 12:03:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:38 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 04/12] iomap: Add helper to revert iomap iter
Date: Mon, 28 Sep 2026 17:33:05 +0530
Message-ID: <3b88efb9351c21d6b7c883b37ab61a291be66e84.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX4bh1I7Kqvsxs
 Y1KiZSxb5+4no1AE/myX05RTnGjhIt0JUgcrIPcmSvf/46xCZVJr/ohPvadw4p/fDoIrdgg765Z
 xuX/ab/A35c5qBSp0H7KKFD2qWo3D48mCoRwJTjzKHnP7kAX02OWb80Ic25IAike0tckNFMK5PE
 y448Kj8Rfv/Lk2ys/53eks9lvIADs0zQBHGgcEimD+HzdtPawaQR3UDqgs72ORdnaGlElEC/HzQ
 5LsRZM+5DEA0V/Vcz1LnUIQluNeNKDwTZx6x+0xQNUEdxLm6N7lWTICiroVSrEYnIvS7ueVZ6jC
 1p6IpCwh0av002t2yuOvIW2IK4FsQTzpwbp+wPdeiNkRvkR20bGD2xbO0OT4CnqBVWY1QhXXF/U
 tSwCJR4/wm5L6he8/kF/sfJl25dtO8B8xmGOmgm3sckAC5Hswbts/LKZRV+iI5U5pN7hWIzFYu7
 /oVHQZHos7HI+jhT5bA==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6aba57a3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=EiUwcbAk3iOqCFawNVEA:9
X-Proofpoint-ORIG-GUID: zuzScbER0FeoT01vL9yakAM8E0YTWvDG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXy6c79dz840E3
 WAUW03F5rKdkMN46LatjXJ2BDc6WfvEibSXM24wrJVKfynhldBluIx4h0qUJjZVwmLMiJp79Ipr
 k1EyvMj6c2ETOgd9bJiEMgoObGmfeXs=
X-Proofpoint-GUID: jv9ioNvqVAIl45HcTGwz4E5RBpi65zPK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046

Add helper to revert back the iomap iter by count bytes. This will be
used by upcoming RWF_WRITETHROUGH feature to revert the state of the
iomap in case an error is encountered.

Writethrough can process and park folios so that they can be batched
together for IO later, this also advances the iomap iter. However if we
encounter any error, we would want to cancel the IO on those processed
folios. In this case, we want to revert the iter back so the upper
layers can know how much we were actually able to write before failure.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/iter.c       | 10 ++++++++++
 include/linux/iomap.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..81af220dca47 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -32,6 +32,16 @@ int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 	return 0;
 }
 
+int iomap_iter_revert(struct iomap_iter *iter, u64 count)
+{
+	if (WARN_ON_ONCE(iter->pos < count ||
+			 iter->pos - count < iter->iter_start_pos))
+		return -EIO;
+	iter->pos -= count;
+	iter->len += count;
+	return 0;
+}
+
 static inline void iomap_iter_done(struct iomap_iter *iter)
 {
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..a9ebf486e7b4 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -275,6 +275,7 @@ struct iomap_iter {
 
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
 int iomap_iter_advance(struct iomap_iter *iter, u64 count);
+int iomap_iter_revert(struct iomap_iter *iter, u64 count);
 
 /**
  * iomap_length_trim - trimmed length of the current iomap iteration
-- 
2.55.0

