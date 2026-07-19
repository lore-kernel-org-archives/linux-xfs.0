Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2F91A0728;
	Sun, 19 Jul 2026 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784455089; cv=none; b=Wm8I0nPvLFtE5W8LPsu1zwUfzXMvppsGrmOpccDGjDz2KE35yh4Fvrd9ncnOuscmtfDOhzcOCtOajgnOq9z3MXuTW173nJz2UxYrNsvlfOOKKYeusvsUtT6zMZfyQucn/FX2qty7hCr40fxEQRxs9z/eSY7tXiXe7NjI8qS8yC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784455089; c=relaxed/simple;
	bh=v7QwHJxkW2lkqwocGMfJ3Jc1ZacXwsFlvejtdD5l27E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p2eHxHaaq/qDEJdtX0kQPZ8q4hSzOy5++5Sz3x0SlxlqhLVbrc0nVgMfAt4tZDYnuGtkTzihcSdJHFkdXfTXMQcmh89mMNVbvtLT2b5M4feY5lFCpJD1cPiuaJh+VBskIAIaasAZ19n25V5TIHwJjBjsKm4DHs0QHAGtvCrWC98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mXMxx1WZ; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mXMxx1WZ"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66J9va3W1567742;
	Sun, 19 Jul 2026 02:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=j/7fyGV1Y
	/h6UfX4I3ufCLiT0r5zJexolvp1hA8TyIo=; b=mXMxx1WZ1FXZJCigBgEKd5pQo
	a4idFmcyyFm0jT2+lwzA/ofXGgFuom1KoJa9PcrNPhEZbwlCaVDR7sALHZo0NLU0
	54IO87fELpeUJOv6/bWRlOOOO7tXf0585rQz+ZI4UySFT6YF3rr8c4mA6V96Od0Q
	I90m7kan8UchA9P3cFlIZ1bkMjd6VMys+1b8yHs4I5+P4WNaUiYErRGU4GM/Bbnt
	LieeKsrJlslMJIZWnOCNa0RXhHpAtPgXA8yl6wqMsC5DrADqlGS04DTSAMQ9yReh
	hTAGbAafpFDkN6sIftaNSe1BbJDyIIEVBk6fupZH/UzeJ5OJ6MbebnyujidwA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg4rygvk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 19 Jul 2026 02:57:35 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 19 Jul 2026 02:57:35 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 19 Jul 2026 02:57:32 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <hch@lst.de>, <willy@infradead.org>, <akpm@linux-foundation.org>,
        <hwenwur@gmail.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v2 0/2] xfs: restore nofs context unconditionally in xfs_trans_roll
Date: Sun, 19 Jul 2026 17:57:30 +0800
Message-ID: <20260719095732.1813590-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: GB0u9dgyd0cfj0COpcyixCKbX7-D6DW6
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfX+8VZuzayYh6s
 WvMrdLONrlaZGbqeQx8d5O9HjpEH/ghR3o22Wb5NNnjARaOTnDzIrBBl0I7Nz7szzthMtDEW14C
 FwvZ4a2l95kw0FXZYBXWY3lywmlyQ05szti/1Gb5Ssuv8p+mncvh
X-Proofpoint-ORIG-GUID: GB0u9dgyd0cfj0COpcyixCKbX7-D6DW6
X-Authority-Analysis: v=2.4 cv=CfQ4Irrl c=1 sm=1 tr=0 ts=6a5c9f8f cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=IjBUQV3ypa7U8OipMqsA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfX80dLb7HCJG8Z
 okYueKNOAxNywYtTK8HUEIDD8cNSdM+voCtKFIR+qE7mnX5bXQa+/YoQ4gJM8YyjJfi7S+nBS7y
 q6eAb3SdBMCQJlu1w6iivAVW30WJNstPh14Y4uPkuWeG1YHKjE2R7PmPzv4e9yycOfEgrKD/kcX
 dS6pa4wPnORUiQEL4U3MQ3GqLaVNUV2qFvisEf47AJQqZDD0rE9r09BIB2DkVusCmk+tBXYD/l+
 ycey6xejoEIiz7s67O0qSzu9DWN285cmmgytlBEOWe0IbSCel+5XZeZxjV4thiuv0CaODIC/OYF
 Odg7n1SAI10K2bTi5qsEITReSj3nBlE98luIjWuvb3mVXG/tD19peSyhQLm+55fPNJs/PG+wN8p
 AGSK4HaZ3Qr3Zc581Cntxuu0tAUgCQbWV5Oj1+bkVX5tTy5+Z9eX7cQKoPewUTdy2I8dUJQ3df0
 eZS3b3s8SM7F3D743jg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 phishscore=0 clxscore=1011 malwarescore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607190107

xfs_trans_roll() loses the NOFS allocation context on the error path,
causing a circular lock dependency between xfs_nondir_ilock_class and
fs_reclaim reported by syzbot.  Fix this by transferring the nofs
context from the old transaction to the new one in xfs_trans_dup(),
so it remains active regardless of commit success or failure.

v2:
  - Instead of moving xfs_trans_set_context() before the error check,
    transfer the nofs context in xfs_trans_dup() via a new
    memalloc_flags_move() helper, as suggested by Darrick.
  - Change t_pflags from unsigned long to unsigned int to match mm API.

v1: https://lore.kernel.org/all/20260713035505.1635191-1-yun.zhou@windriver.com/T/

Yun Zhou (2):
  mm: introduce memalloc_flags_move() for transferring allocation scopes
  xfs: restore nofs context unconditionally in xfs_trans_roll

 fs/xfs/xfs_trans.c       |  9 +++------
 fs/xfs/xfs_trans.h       |  2 +-
 include/linux/sched/mm.h | 17 +++++++++++++++++
 3 files changed, 21 insertions(+), 7 deletions(-)

-- 
2.43.0

