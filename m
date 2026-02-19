Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E512E7162;
	Thu, 19 Feb 2026 06:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481516; cv=none; b=GRETgNuaKxTBg7r3BZcTVFXTHVl7iRoo30mr2S/+PdBg8v8yixXAoEkBTnLlGCpXeb0kdM+dHQIIjw7DocBjlTYChG7YQ4PM1QPZB5YAYPsRxOWMaWcP6R3UTBnaefIqAN5xg5sS7TGM9J5jr9xvOutT/pDIdpEmlMcB1+y3bCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481516; c=relaxed/simple;
	bh=6KcJAGkXxjHWFJurK+YLbbpQy9W3hhWaopfMG2eszfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OFSAFhJ03R7QBL6eHU5J/5kwqv09/8FN/4VZ+wpM7KU0OgLnBkPEIvTsmgHlasJKLRmB0HoCq+XYO0Kkp+cx1Ygba0qapvvEdLcXQhZBwAk6Pj0Bgu6gTLtPowmWlhbF4tUI3PDWSRek6hFgqWdxG4dFvZX3jnZKtlkIDIY1J+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ijN+/iGQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ijN+/iGQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J17QVC3299365;
	Thu, 19 Feb 2026 06:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PcZIAA590gA89D/Se
	hNOXov+oY52gcg8miFzFeHm+bU=; b=ijN+/iGQN3KgHmumYhzy+ptL2XCcOnHhj
	E3Ccu0w3Th2zDIeLyxLz4r3YwMyPbkPehecoyQmLuESpCl81fjFIym2dQlzjXoeN
	cYhXOmvZpDYI1yDyRWzSCbLegjGi7e/marM2PbyEZkPwDietYrvN1CeXp37xNht2
	BhDg+1oILfvo4npTPBgpFIsyHieLlGX7Nw2ZimIOMWuSjgvwFzptfzD2cjhxZeGo
	ileNqVvQBpGLhhfxwyya95ajlAbrGiShYoYb85IsJ+9HMASOKeCjO4pyr1JFQ4k7
	38NWgNvlVHB/iNPVKPok+wF8KUidSSBK/VMkYfDDFBTZnbaZhK2Ng==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64bgvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3L62b011965;
	Thu, 19 Feb 2026 06:11:19 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb2732rb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:19 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BHWn57672062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:17 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B28FD5805E;
	Thu, 19 Feb 2026 06:11:17 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 479FB5805C;
	Thu, 19 Feb 2026 06:11:14 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:13 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Date: Thu, 19 Feb 2026 06:10:48 +0000
Message-Id: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 1gZEa5GJvSrjrVaUI5-_Dg9kDjxmehO7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX+4D3VoPASMFy
 hK1SoUVuym5EkT4itFPgFeYt8rVd9df5Ejd3ggwITAB5/JhP3pn71cFoVnBIs8gevhcUdteOLmO
 tk9SzuDU90/KAKr6EQNfeAV3rmh1dlLGj1bxgZ8+feqtUFImPUGbmByAEn4hrvjZQjC7z9GVK3y
 f2NnsUwNv98Y5C6Pmen3t/5JbdfAm9/27owVVW9qe7OKf5bMhI6xATFuz5DKkIKDONjboPH91lc
 hz/qiBxBXUvG/tD4AcgucmWlQj23jzcrBKg2zUm2y7c4OgAvqqfY8Tn1z2LtqO3YQPyFTF7riNr
 8ipJ04QhkB5CQObAqbCBSdlTtgkqi2GmZtZpS3euwVEQP2rOn2urIeFh3nWtQ2IvlWLRFLXz1pM
 IIat1CqQ9uGQKd4WsZzOGqiehufCS+CFJnLymeH6PFQQXt8SG1UdXRtHxYsCYnhvCIyVpeJxg4b
 1ph78RLGv8lNRi+WOEg==
X-Proofpoint-GUID: i5fphYx-Tq1nVbtcRLcvTtMEOeG5hb8q
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6996a988 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=ro_cQ_przER2xvipTiIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This series adds several tests to validate the XFS realtime fs growth and
shrink functionality.
It begins with the introduction of some preconditions and helper
functions, then some tests that validate realtime group growth, followed
by realtime group shrink/removal tests and ends with a test that
validates both growth and shrink functionality together.
Individual patches have the details.

Nirjhar Roy (IBM) (7):
  xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
  xfs: Introduce helpers to count the number of bitmap and summary
    inodes
  xfs: Add realtime group grow tests
  xfs: Add multi rt group grow + shutdown + recovery tests
  xfs: Add realtime group shrink tests
  xfs: Add multi rt group shrink + shutdown + recovery tests
  xfs: Add parallel back to back grow/shrink tests

 common/xfs        |  65 +++++++++++++++-
 tests/xfs/333     |  95 +++++++++++++++++++++++
 tests/xfs/333.out |   5 ++
 tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/539.out |  19 +++++
 tests/xfs/611     |  97 +++++++++++++++++++++++
 tests/xfs/611.out |   5 ++
 tests/xfs/654     |  90 ++++++++++++++++++++++
 tests/xfs/654.out |   5 ++
 tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
 tests/xfs/655.out |  13 ++++
 11 files changed, 734 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/333
 create mode 100644 tests/xfs/333.out
 create mode 100755 tests/xfs/539
 create mode 100644 tests/xfs/539.out
 create mode 100755 tests/xfs/611
 create mode 100644 tests/xfs/611.out
 create mode 100755 tests/xfs/654
 create mode 100644 tests/xfs/654.out
 create mode 100755 tests/xfs/655
 create mode 100644 tests/xfs/655.out

-- 
2.34.1

