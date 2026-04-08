Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1073D75C9;
	Wed,  8 Apr 2026 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673996; cv=none; b=p+fHQpanHV+nj3q/W0PABIxyM0ZDSWc9yYaDDgiuO3zMQem39kujZAqcxrU1lwPIjh7u8yeDWPZ8g9cwMLIRE5hS9t2NibTQGsg5uKGwsdtSTe4KnFgah1TWfQwuq0nl42yERv9dhSGVViNwYi/zPJHXum1AErm0/C8Sn9CY5do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673996; c=relaxed/simple;
	bh=oOduun5eoC64LiZcBKIjrJ2kY+dGIBQALfg8klri3r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htdSAql9G7h56YwMKvNwLTmpd+1PQZSqBVH+xU7P5vUTw2rT1n27ir67qSyr/As2Ht/6KNbFNKs4pDKFLhw12i7MuACR/gOasPU2zj7PI4L0whYXatVSbyXQtI4AZsyZxvHSnkHc5uC/Iz5QOUCv8sUaNl1sHWIFSPKFsVqMd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VenbjJ5c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VenbjJ5c"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386WUw72326341;
	Wed, 8 Apr 2026 18:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MfBhzVEmdDTO9khog
	B+4Xy9fp0weh853fIHPAUsG2nM=; b=VenbjJ5chvFAASuGyTIkrBfCJG2Uy4U4G
	uEGlQJLeYDh+mTES4Hi9Yf+2x70NQ1LEFZKqzdx5quX9gGId4KuR+fn633JAQFHQ
	DgtFcDuimsEXPCmhIl0H3NBpOk/uEWeHJLUyw0U9+DTlWKCnduvy42iRgURkQa6N
	46R2C/rIuvkAyeo7cCMT32L1TPBdd5VsCnRcrcmQ9r5ZQn+A6nsdv4OY3eBGNxda
	3WMMz8OWEJIozsgrM15VvKAK5oyCouBLFl/LqfsTMiQVfmOu4Ri9E7EHatnv16PU
	yUcFbjrJKFu5MgxyU/SFKEJVn95zWfxvIubfdG7pFw9dDOfst/v8Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kgvh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638FwrvX019113;
	Wed, 8 Apr 2026 18:46:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9gm34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkAs146203346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8767A2004E;
	Wed,  8 Apr 2026 18:46:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85F020040;
	Wed,  8 Apr 2026 18:45:56 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:45:56 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Date: Thu,  9 Apr 2026 00:15:42 +0530
Message-ID: <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX9lacaNyd+wCc
 Gpe2sNQr134QkD4u3pLlJCk4V/Ma6q+yCkM9R6rbqJ4vXCcA8BfSXgvcmS65/V31VS8L9UJfxuE
 7Th+zdNSiElxiSmCx2kQxWifz9hW/KtUYF4uHRQ4hQIMweEHu6ftwygZdcx7/xDRoFTpwmOZ+0V
 OSgjpK+v8I3U0Zc3vJvTRXdxI8p4TukKIh+qq56GADWrZAYdibxRt5J5lRqShrlA4uenDhN8CzI
 GKd/mhfJPl+tBJqGyIUYy6e7OoPMdR0tJQeqeF1kRuxJBUF8Wj5SeZ7UDBbKu9RiTql03hupLt+
 rZdSaB4chqZTqNzs8BFrHuo6FIV86d8u2p3KTtT8zle/NjG2OMTzzDiwAtuwX0nMpxO+qpMmId8
 iHcAjI/x/NsPS17V1wAbvFvxFKR/Aa5w8GOs58uJUD6JDsk04PZhaRdNXmenxz6sj1LZQdSxXdB
 Cqm9R0EV7VJ4zeKU8Bg==
X-Proofpoint-ORIG-GUID: IDLTCbjMJD02ckO5zX8Yk3FV6kIhxYo_
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d6a275 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=BWzSRGt6nnUlSqokuEQA:9
X-Proofpoint-GUID: pun6bXvTAKHjjfiNwEHsCXmTH6QMpLDJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170

Add a new __folio_clear_dirty_for_io() helper which takes an extra
parameter to indicate folio_mkclean() is needed. This is in preparation
of buffered writethrough support where we already do folio_mkclean()
before calling into this function.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 mm/page-writeback.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..2f0c6916213d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
  *
  * This incoherency between the folio's dirty flag and xarray tag is
  * unfortunate, but it only exists while the folio is locked.
+ *
+ * For some cases we might not want to do mkclean, eg, if we've already taken
+ * care of it, hence pass the should_mkclean flag to indicate if its needed.
  */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool should_mkclean)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -2885,7 +2888,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
+		if (should_mkclean && folio_mkclean(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * We carefully synchronise fault handlers against
@@ -2908,6 +2911,11 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.53.0

