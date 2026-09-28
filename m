Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA64B828A;
	Mon, 28 Sep 2026 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597054; cv=none; b=DJJRMe0H5+DeDqZ1dEKOJVTyljPb3jfkLjg5zxeVWROKavmSvd5uLZNhRGYba5v2O8RVgYVc9FpyKAu45XqH2WcLQ1esDRASc2JosafFA6F5vdNVQNOkCSVtiQctR7K3/WbbjyjT8udcYb+6I+F3ZqEz/LT8V5Mo7vSGRtDxtQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597054; c=relaxed/simple;
	bh=wo+8wcfTdhpVob1Qq99h6W/qZNLCwC/kLLu6ODAVDHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcnfsLD7FQkLkIl+MbpUh8I5SwsgFSj8HSyibA2+iGYx0a/EwbBlu7GRhGOuBdtUwHeKmCHy5wyKj0MWEvlwamkJjhdYu35aZv9Fj42JKxRTztwyH+l9UEiYvqFsIz0FzXM5gh5o1Fj2v2FVLAldtlfViHAQq/sO8b0pLYe8Ydk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nF08+hDG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nF08+hDG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZWJZ1047068;
	Mon, 28 Sep 2026 12:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uI+Z0hK0OBfp+hyRv
	hDzQTGCIiYiIAwSOozSGuYrXfU=; b=nF08+hDGvQ/yhammcvlFIypVlWkZ++Qge
	7kwt11X9S2V9MfWYl2NPesmXxirgFyMDezLctQLpHEK6zAWtftVgXE/uWmuV4p6V
	nDqg8AVX8+6msF3gw1tCCvpJfwh4EX+pWqtbrpNbpcbf5U760geK+xw/yJYV1BcD
	S6QI5Lvlt6Py9UbKTvmwUQH6nzSHf7QzqkPM0/3b0cSBiHIrgFQKN6iYmgARRaMb
	Wj6xdmGXN7Kj3BtMMnPfaoX6U03ywQXIDhx8uYC+RJobKZIHoDzjG0oVraBlD5c0
	GT8qKBs1k1vpgNnK9tcIYskz+rLLhoKtSOe4XKZaG64dkbr7p/xiw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5165j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHYRK2943219;
	Mon, 28 Sep 2026 12:03:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg4wnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3WG623855644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04CF320043;
	Mon, 28 Sep 2026 12:03:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A13620040;
	Mon, 28 Sep 2026 12:03:26 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:25 +0000 (GMT)
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
Subject: [RFC PATCH v4 02/12] fs: Add counter to track inflight writes that need stable pages
Date: Mon, 28 Sep 2026 17:33:03 +0530
Message-ID: <47a1741edc8db3753d3b555a75a7fd65f2996049.1790596383.git.ojaswin@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX4vMnNb9Gk1iw
 XGdSgpZtcHwgrMsubD+qn5ukuzIpizGZRFWmk/qrs2D/L+5MaJC+YA5sOfWgq2Bt1PiNMQsaWTN
 n7y3JLlCSUsTh7J4zgs0xWFgoidtrzU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXxeM5QY2s8mTq
 iP3T0PRCbtogr1V9YnzN6LbwIzJ3o06Uk1ghV+7bsxm1YhtEBWsrTmoLnPDmGQwQFrqN+RpJZOV
 dlnUCMDBPjh4/96yAdi4/ABHz5yqckmnWoeYHUaR3oF88vFG1QKH+TNXDhQEJ1VaPwfeI5I0ZzR
 lddFuMptipmpv3xxOD11mkj/gAhqWC7ZJb3d8hOWY0zZgFAaMcAZO1b1lJTQNN/yjSnbnHA1n97
 vKPdpdMc/B1bKUpNeiiSptZ0j5gB3YkejIzExkMg6rPUsI/I7oZDMzVDz7ooqsQqlHIPZNC8vn8
 yV8mI7p4LyK6K3Bpq2BAijYXxU/VsBWK/NyW9Jdhm1r/rejiNXHLq8OnuvyVeCvacUBKGNAI4gQ
 6K9gi8Ih1tXYO09a31tguJQ/5r0UpdM77MUcl+mh0rUbT1Yc3sd1bHaOnel7v+6CVWlb9vZXu8r
 RTKDDiQ7FhfkCfx/EhA==
X-Proofpoint-GUID: bHLH0MBQtnRql-B3-nWJvcQeoiUdvUV_
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6aba5797 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=8ZJD85kOQxw6bUDZt3oA:9
X-Proofpoint-ORIG-GUID: DhONHsxxA81g4bm8wfruo0OdmbIyX9sn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280046

The current flag-style stable write implementation uses idempotent set
and clear functions. This is okay because the users for the most part
just want to set or clear it once based on factors like underlying
device support.

However, this scheme doesn't play well when we have parallel users
wanting to temporarily set and unset stable writes. For example, the
upcoming RWF_WRITETHROUGH patches need stable writes to be enabled for
the duration of the IO. The current scheme can lead to bugs like:

RWF_WRITETHROUGH write 1             RWF_WRITETHROUGH write 2

enable stable write		     enable stable write
submit IO
disable stable write   <---- WRONG

                                     submit IO
                                     disable stable write

The 2nd write loses the stable write guarantee midway which is not
correct. Fix this by introducing a new inflight_stable_write counter
which can be used by parallel users safely.

Unfortunately, due to the way the current users are designed, we cannot
directly migrate them to the counter approach hence for now we will
have to keep both methods till all the users adapt to the counters.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 include/linux/fs.h      |  1 +
 include/linux/pagemap.h | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 05d05bb9c951..f196f25255ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -482,6 +482,7 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct rw_semaphore	i_mmap_rwsem;
+	atomic_t		inflight_stable_writes_count;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..59713769f731 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -306,7 +306,8 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
-	return test_bit(AS_STABLE_WRITES, &mapping->flags);
+	return test_bit(AS_STABLE_WRITES, &mapping->flags) ||
+	       atomic_read(&mapping->inflight_stable_writes_count) > 0;
 }
 
 static inline void mapping_set_stable_writes(struct address_space *mapping)
@@ -319,6 +320,17 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 	clear_bit(AS_STABLE_WRITES, &mapping->flags);
 }
 
+static inline void mapping_inc_inflight_stable_writes(struct address_space *mapping)
+{
+	atomic_inc(&mapping->inflight_stable_writes_count);
+}
+
+static inline void mapping_dec_inflight_stable_writes(struct address_space *mapping)
+{
+	WARN_ON_ONCE(atomic_dec_if_positive(
+			     &mapping->inflight_stable_writes_count) < 0);
+}
+
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-- 
2.55.0

