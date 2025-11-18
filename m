Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8435A3126DB
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 09:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763457704; cv=none; b=UbZ/wiSby7zymS7ZwYS3NzP/w05/Twz4N14OCUxAVOhjZY9TZv8rFQCrNtEU8Il2DGQkaMeeZM2RtXeSXqC8+pJeO3ZmKPUSLbMrrUC5KxdICLum2V2BCdAE/RwBSywea6tK+MS7ZB22V5EDglvaL2ujixYUami9s8UHV85XMFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763457704; c=relaxed/simple;
	bh=6P6XwgdG+CfS/EKD0niKfTRy9COo85Qiyy7QPpLKNn0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iW+sakTtC3YE9UjMtwD8XCIx+sUuewukdVfF0uaU/o4T2gP0E70er33LBDmlr23vP87UiwFBxEita5G4/OSVqIF7i4i8YAfoWmuudSoh8R/P0tWQv2nWWIOxbQa/dpO3/RFm3Li8kOZH/Nf7tJukXzLfRDtR1VArkrTHKgtq/gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Gmd30qEC; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Gmd30qEC"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AI70lYE3176809;
	Tue, 18 Nov 2025 01:21:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=PPS06212021; bh=kxHi/PTIofM1H5yM9Dmr
	tn+16VHNuhiW3kW8bN5Vojw=; b=Gmd30qECT75WE0jH++ZaAFLASTjpdgxNPbhE
	Pa+GutpKl/eYfSdHxs7YF0kHq2qlIZC7I1+gP5+0F/38ZBbBDPE3Db6RySeuJiTN
	Ako0MjcsFciN/BDvlcfGgLTUZPL8zb/GT3l4GqLYcseBi5JY1JntXWXeLS5QWjJA
	zMo5Yeuf6UFYx9Sff22H1+IMlfUl4rFWdYr7NjfZbydS3eVff1s7ceLX4vX0wd9P
	4/tAQn91kE99j2PdilcQiDYDyWoLGCUWfQzesIhrJr9Lnlh6bVzdIlk8+L79RKKc
	RRJdlCUf1iT0wiVE8asrePMqFS69UuhqfO0txHPa2vC+/yhh/Q==
Received: from ala-exchng01.corp.ad.wrs.com ([128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4aeswjb171-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 18 Nov 2025 01:21:14 -0800 (PST)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 18 Nov 2025 01:21:13 -0800
Received: from ala-lpggp9.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 18 Nov 2025 01:21:13 -0800
From: Hongxu Jia <hongxu.jia@windriver.com>
To: <djwong@kernel.org>, <linux-xfs@vger.kernel.org>, <sandeen@sandeen.net>
Subject: [PATCH] doc/man: support reproducible builds
Date: Tue, 18 Nov 2025 01:21:13 -0800
Message-ID: <20251118092113.2265541-1-hongxu.jia@windriver.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=BqiQAIX5 c=1 sm=1 tr=0 ts=691c3a8a cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=t7CeM3EgAAAA:8
 a=5QOhKnVa8oVsQ-MR_YwA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: HrywiPaJI0TxFOVj5csPb7Gq5HI5o55S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE4MDA3MyBTYWx0ZWRfXyMhw9RSThp5K
 i7+ckGzkGOPcDF/1zjsanxkvR1fPjAa6O/wSavFjqDDr9C7m+dIRkvTD7mbe59o+8g9+iFyukhH
 W0jjeV9G1/A+y8Rr8Z/VJva040QyWj+/oWS+RgI1DrkyX5TC7lxrBcVMxFT55sDhSi4iXv8Q/Le
 mcWGIYpZhP7jYrpn3ve5zhMfWLBC8O3pFwKXqQZlASwkkxdRwep/qEOqys0VZnCl2qEeUNO6omk
 U6cp5vowWkF2tWEW6EtAPoH8QP2pb5apKSf3tyK2NHYiKbGzq35OBy/vCnMIDQbSke9NdVtvtmF
 PEn2a5S0jjMd84hHogkR1bzODxANROFEcv+N05+iNuUGwapm3NfPewyZksx884+v4nEJKgIqxU1
 k+ljqlf71X63nePBoCtN788ZDS1kAg==
X-Proofpoint-ORIG-GUID: HrywiPaJI0TxFOVj5csPb7Gq5HI5o55S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511180073

From: Hongxu Jia <hongxu.jia@eng.windriver.com>

When compressing, do not save the original file name and
timestamp by default (gzip -n). Make archives be reproducible
at each build

Signed-off-by: Hongxu Jia <hongxu.jia@eng.windriver.com>
---
 doc/Makefile        | 2 +-
 include/buildmacros | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/doc/Makefile b/doc/Makefile
index 83dfa38b..17b63c85 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -14,7 +14,7 @@ include $(BUILDRULES)
 
 CHANGES.gz:
 	@echo "    [ZIP]    $@"
-	$(Q)$(ZIP) --best -c < CHANGES > $@
+	$(Q)$(ZIP) -n --best -c < CHANGES > $@
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
diff --git a/include/buildmacros b/include/buildmacros
index 9183e5bc..6ba0d515 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -105,7 +105,7 @@ INSTALL_MAN = \
 			t=$(MAN_DEST)/$$m.$(MAN_SECTION); \
 			if $$first; then \
 				if $(HAVE_ZIPPED_MANPAGES); then \
-					$(ZIP) -9 -c $$d > $$d.gz; _sfx=.gz; \
+					$(ZIP) -n -9 -c $$d > $$d.gz; _sfx=.gz; \
 				fi; \
 				u=$$m.$(MAN_SECTION)$$_sfx; \
 				echo $(INSTALL) -m 644 $${d}$$_sfx $${t}$$_sfx;\
@@ -132,6 +132,6 @@ endif
 MAN_MAKERULE = \
 	@for f in *.[12345678] ""; do \
 		if test ! -z "$$f"; then \
-			$(ZIP) --best -c < $$f > $$f.gz; \
+			$(ZIP) -n --best -c < $$f > $$f.gz; \
 		fi; \
 	done
-- 
2.49.0

