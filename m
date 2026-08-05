Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C13A3DD503;
	Wed,  5 Aug 2026 06:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911361; cv=none; b=I27nQDRfWAAaDi98l9JV9wG3bZdrF/XE8/+o673gZhInEvJR4KFoGc879kMT8v7JFxvFMwI69s6CnsFqJwTwl7uuwTfaT/kC1aYKtxUQDLz+Y/398yE0DCla5QcAzyNN72ZGMlEjlv13pM8xba4aWk1bFhoQsJoVLFLE8ibuYpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911361; c=relaxed/simple;
	bh=Sb5ZNhtNCaDmDDu2xPmV2//wfB9VzDdlgQNk2NzW0zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3QRbJ7ZikmIRbSz/7in0ZUtSN4XIx9llCdqOMnJUC8j/7IrD4TyAJcFSspOUmX6bl9Kh67LJPhElZzcl1nu3GCFD6aawoV/XgUY4OvxAK0HTOWqMESk7yWfJeZrjNkFtodNgoYeK8IXpKwxuRppZObzlFob/CijP53evhz9o+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s1jB/175; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s1jB/175"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lvoP1121612;
	Wed, 5 Aug 2026 06:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4gSdh3sr2ycHT3Euk
	mQjBtk1Q919hgqEMrec8njc2Dw=; b=s1jB/175e8VH2EsR9qoQ8dSt6XYww+ZWR
	eOkZJSN45KgYml+6R3cLj4t8dJqIqV0KjSl3M+36YTJS9ZqvCpHi8ouzCGdk0yrG
	RI+7gRuQLYwQ0W3UdAlxxjpHDLj7sNsv0FjcdrE9uP8QAjO8Kob2HTeJmLLBCIpT
	KmgZ5OdVJ45hzK8C69o9ZmDfH4WCqLtNygAi1nsgCPvNEwgo5cq/RT+KgAVZ+0ps
	vJlqRfS6259CU6M3egXpNyyxon8FTHvoW8cYGy3V8W+KcvxMPJnalWdUMl1pBhY9
	0qxi1bxh6uYMFIaWSZsPiWbOHXn/y+eDaIkeSX+ty9ZNFOL77M2Vw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqsj8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QHSD010639;
	Wed, 5 Aug 2026 06:28:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw5ee6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756Sds531457622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F07072004B;
	Wed,  5 Aug 2026 06:28:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D66920040;
	Wed,  5 Aug 2026 06:28:33 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:33 +0000 (GMT)
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
        linux-mm@kvack.org
Subject: [RFC PATCH v3 03/11] iomap: Add helper to revert iomap iter
Date: Wed,  5 Aug 2026 11:58:09 +0530
Message-ID: <c688c9ccbe13fda329d2bfcd423d5d38ec9ac561.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: LonUA8QG8JHck5z9DjLFdbCjPxe3fRjO
X-Proofpoint-ORIG-GUID: HQc6MlCSscsYcwTphpnZSkOKguor5Xs-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX/rVMYMlnGX9p
 nT8eKbRD1ttQw7DughHsM3iPyZLw/hfH+Is0CFRzdoSFJpYpBhK9emmwkrhNhl2nJsN1K759f+z
 Nr+R9Z3JjkQQUm1LgwKRJJnjxSMrnNU=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a72d81b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=EiUwcbAk3iOqCFawNVEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX10VcwEXMqktr
 +S/UFnL70GiUKVXlYY0cCvozuvypPIJgBCHxjhDCDbIZhMm/a93vKQb28I7oPh5tS4SA8f4xH1Q
 DF8f4jd47DRQCLvsAxONfFpKvqjBk/voYjW02yljWfssblg5yXlCrKtP/mcAJnkRWtfRayJsKQs
 vMyPBk+eO9M4DQZoA4EVgThV2/9LPf3bqU9TSOZQ5j/OsTksSexIbXVo9aC80BDfyEvBkUv5AHM
 1lQzlr5ZOhN7b1nV8Bc3nnD7a9Qc0p118sbmxjGk5ovAIZYphtsHxUaW8enkIDq/ljzG9C0Raul
 U24pScs778VG69M4qRq+ftI6voEQ/9T3dyiELKOJUodJvvteISS/I1N9o3gVod+7Daft6QkBl12
 mkP99TM42MUKhQps3TZpLLNlhbMRgq7yZpq0cijN2T7dt33iV7Y61bHCmJLAlEhb82r80+3JqQq
 GqPcb1SB0QR0mNpqJLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047

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
 fs/iomap/iter.c       | 9 +++++++++
 include/linux/iomap.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..8ea849e7ccef 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -32,6 +32,15 @@ int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 	return 0;
 }
 
+int iomap_iter_revert(struct iomap_iter *iter, u64 count)
+{
+	if (WARN_ON_ONCE(count > iter->pos))
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
index 8c754eb974fb..1c8f13948f81 100644
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

