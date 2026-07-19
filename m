Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A139383334;
	Sun, 19 Jul 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784455087; cv=none; b=OstU4I4dsllB3r92TsV/Wfd9UsW3gcmOw4dU4cT5Gpla77NDLXIGx1myi9MQVDowkrW5T6weWmiWHS7A5QYo9JJhYgFSL4whsNHyuWaBYblwAErpMIjg/kGpSyGTaLeKXfzDVa1sIGay3+EB0o9ePzJe0kJ4flZWqETC0A6RyHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784455087; c=relaxed/simple;
	bh=Gj7n/S2QfIx66mHoxKPusChWLj21TFncZXnJVgixszc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HeB1KO1haMgV2ZQNNb0EarKgwWSAR3MWtOiEJP9wfl7NaoM0SaSRpt6AVzYzYngnYxdHS3JsBenIxRJhcSZ4eV1J68pNx7/hjPSYN+Yrt8hTi2hatMFymz4m50ZbzBwFkiVlK++pGOj5iUyaDmmE1V9z6WasnMSMrSiMMn0cG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=IrnPWclE; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="IrnPWclE"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66J9j2FM1452948;
	Sun, 19 Jul 2026 02:57:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=oQUmuZ8vgQoO5EZyEPoTGXgRDsGUbYaJoS83uh0+Ga4=; b=
	IrnPWclE1varjtv7az1+tzAq9bPC3Z2cJf7dfg6JDUcgwDkBvS1jSYxzQRJGcw2m
	mMKmZDBUIiwxsbHfjoAyfqs65Em0XED8JD4u+yCXSapXup8QDCqoWeC8JjQmykbn
	viXDS7XejAgEaDBVpITLgs0uq5A+3z2qJ9zS76APGsyqmpkfqk5i7IMNnhm6yFsz
	wdLuL6xlM1ahYF5VpQEz2McYT0+jgnTfrY9cy+lCB0wNQeMgoePpBPkQaNQ83vPG
	QyaUGKqHyjLidTSRscbUiwEAHyNNj7/X8lB0mtQ6B4QRCg7f/Sf3rRbJwmjraeJG
	3+/PX37UaX3aBKqKi7bpZg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg90crq9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 19 Jul 2026 02:57:38 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 19 Jul 2026 02:57:37 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 19 Jul 2026 02:57:35 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <hch@lst.de>, <willy@infradead.org>, <akpm@linux-foundation.org>,
        <hwenwur@gmail.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v2 1/2] mm: introduce memalloc_flags_move() for transferring allocation scopes
Date: Sun, 19 Jul 2026 17:57:31 +0800
Message-ID: <20260719095732.1813590-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719095732.1813590-1-yun.zhou@windriver.com>
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: P6ROgF0w3tt5M8s31WRJywK08EBlmBxN
X-Proofpoint-GUID: P6ROgF0w3tt5M8s31WRJywK08EBlmBxN
X-Authority-Analysis: v=2.4 cv=AOkSgtoa c=1 sm=1 tr=0 ts=6a5c9f92 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=XSlvl--5_UpFqNAGFfcA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfXyk8g4f1FGD6j
 bACDveVCAHmlI70LJpjcUGYjdYWCn0J7hOzbFvXQhHwFI26rrFfIfd47bwEGmZ6mbzzvRA2VTT+
 kJhav4UnZhokzEn/r9XnRtG1gf0heudqlVIaN0bZpsOFS7cr7NhK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfX0l0ZJYhAQHve
 KBziywtvvXf0iOONEIBi7yQeLT9UWTqEQ/tfPLdmWogF6kcuHznrqOBaWNCwWWPirtr7xnWlP9X
 IDpDVzmICKpjwZCcNtp53Ks1F0TN52h7apWCcYhPb/bzDkJQOmBFn+KIdYDE6GaNsuSkKgPBaZz
 zcc7Bb5X/8pM6/om+tosO+roGpzrKOujCWVDFV8V+C40R41ThgMf+3gPOr8cdsK1uETJOXQNc7h
 +kwweTswsqRpksZAZGAwMhlS/ws/5LV+Zyl5O+lPS9/07xDReFdSNeG4r1c5DIL19XFxbWX6gBM
 JZObLLV82pk3jw3qWoeu/SHw9DwVi+vTzIecuBDqh3OBhokItK1ttLHDX50ZguMJuY727OGbWyO
 /Od9ztXXYLOM42YNqLUl+mTliAgyHHCAqrrQbVc9odZ1Fey9yDoYlTx8BPcIwuPYg1Qj/17YZN5
 D69QV9zEqbhm9ehe1nA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190107

Add memalloc_flags_move() to transfer a saved memalloc scope from one
tracking variable to another.  The source is zeroed so that a
subsequent memalloc_flags_restore() on it becomes a no-op, effectively
transferring ownership of the scope to the destination.

This is needed when a subsystem hands off an allocation context from
one structure to another (e.g. during transaction rolling in
filesystems), and needs to ensure the scope remains active without an
extra save/restore cycle.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 include/linux/sched/mm.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 95d0040df584..a6de84b70c0a 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -342,6 +342,23 @@ static inline void memalloc_flags_restore(unsigned flags)
 	current->flags &= ~flags;
 }
 
+/**
+ * memalloc_flags_move - transfer a memalloc scope from one tracking
+ * variable to another.
+ * @old_flags: pointer to the source flags (will be zeroed)
+ *
+ * Returns the flags value to store in the destination.  The source is
+ * set to zero so that a subsequent memalloc_flags_restore() on it is
+ * a no-op.
+ */
+static inline unsigned int memalloc_flags_move(unsigned int *old_flags)
+{
+	unsigned int ret = *old_flags;
+
+	*old_flags = 0;
+	return ret;
+}
+
 /**
  * memalloc_noio_save - Marks implicit GFP_NOIO allocation scope.
  *
-- 
2.43.0

