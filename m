Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B645B11CA0;
	Wed,  5 Nov 2025 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762306618; cv=none; b=jM25rCBOAkrRkaPu1RKEI/tTYv9zh/MEMuXf+pj6FmiObaKbG3LFk5csy/RmFHeMR+0h7InEJNKkdkI21n7NfC0hkuaBsSBPGwcyb/0rLNV5NIE50x4qBl4sfDL6nmr1oj4WwB6eq2sfynd7K6RvLFVRedrZCDHZJwGe+iAnazU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762306618; c=relaxed/simple;
	bh=Zmr1S24jxtNLVX86/mcoVAmjox8QTrWXemDVheJp+w8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SFft5hXKDamxoDlygjFDv63C72zWbyS1NoHyRC7uPQe1rUJsCmo/SI8rhwbHfHD5A3JN2WaMOSGR9csts1VWBcQfqg3XmSxDYqItAr9I23xbOorTgAQHfKTTiqFA7mGkF54SvtzUt8OOK7h9PRhm50Z6vqbOGFYTCJds982kPbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EfK6f6j8; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EfK6f6j8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1762306577;
	bh=0E5qZcjEmA8lFzSsFsyjkmXd2NseQSgWn4kErGWNASk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=EfK6f6j8O43lB1+oiM3mwaJxTbSdwMaG5412/CuRAmaktpktEElyRxQxAW7u5fjcF
	 QGkxyAfQDQM5v1z9e6VCfavh5LZGIfG8H7T2w3nyPHMcsYosxPbxPO/8lpyorH/sos
	 7rRPYFJH6pqPlIRTNU9x3JFYbiilU8lv0H5FpKNg=
X-QQ-mid: esmtpsz10t1762306571t1d6cd2c8
X-QQ-Originating-IP: HazuLHtDx2b7PkqXsPkW8u8+Xi2zvjpRe2gqlhncgaQ=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 05 Nov 2025 09:36:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11840787299182823769
EX-QQ-RecipientCnt: 9
From: Gou Hao <gouhao@uniontech.com>
To: cem@kernel.org,
	corbet@lwn.net,
	hch@lst.de,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gouhaojake@163.com,
	guanwentao@uniontech.com
Subject: [PATCH V2] xfs-doc: Fix typo error
Date: Wed,  5 Nov 2025 09:35:06 +0800
Message-Id: <20251105013506.358-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20251104093406.9135-1-gouhao@uniontech.com>
References: <20251104093406.9135-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: NMPWsMKlzMCf6oe819moW3HjByoksuYh6s3w8mzNEBDRN5389lj/a/Ek
	Y348cuBhGgoewekQWSzRfd0VsECgXAPM94bzmt53NrTanzzooHMLXdXJGfTP0uWZ7jY+Tu/
	H7i+x56pz6YW+iOEalu3vwhzuAycSgj9eHsNzxtEFs87Hf2ZrHDDUrOZV7dzLvgUZUT7rim
	BCM9qM5v/nRa1SFySG5JZG8YU4YDKrKJKCj9JswPMUSC+MkMDevSps90dEFzq9FetTp7KB+
	n5qDtHcr06MVAA246R0XV5o33+4wvEJoiKvE7KpFdj3gcQXqBhTcphLZzC9oq+Tfsq54gBU
	FiVbF7HDW1RT+AuiYkxNrzLdZvSHrWvhr0k0SwMImMFv9nRNlptQSIay8CdDx5lg+pyGdqX
	E2H0T7AdkRvgH2yyZHlYoVcq20+C0kFijUiVxqN/RV19GkBqOI7IYThRI4y27jVNQ5/Iab2
	jHxFroxCYzpzOfkSu6otNy7JGD2UQcrjmu2+yxomdPAnEmj07T4kGQvTSmjwt1Y/eawl8iI
	qFkh8p35Xz89xJfoygRHUNrOeCtBHpSl1J+eytt68T5Oy289RfRWa+UBJ5UuH5tAqjd8ZBl
	lyCaAktytLc+e1hh5njBqbaMS+5Cn+d1/QuwzwvsOD4lphASYVF7p4aEUG3UiLZH2EvhWvg
	f6Orsx2crnIg5L7n9/fubGO7xNSj3KRvDx5uNj84Ew3a1fLLhGWrtmGKacd9J5fFfXaSuLV
	/IQt40CoR2gykcMxG02xvWcldfu6xFq0GJEKOQmjt7w7pmq6fmZpYP4Uvao7Gk92Vurrr+E
	G4AQcEkJ87RNfUyjvQg0QSS/KuF7gV36tzeiwY5WKJ0V1VKxON7nTjLWcH7Y+iLQI01Db8f
	egSx4F/EK1A1ikVjf2D8y+ohDUK+bo5cvcXWvWybGZknR9UsgyZN4TiUdACKkggVwugTzWO
	XaEU8CVQEpbkdJkZSSIcAQeuQJ29nNUJBHU4RKu6z//+R/4AZG6Frb14fwapTa8XFw2Cy2h
	x/BxklucoteZ3dbbeLssxI+R/hUPHT3mPZfEqgdZCP+dwMJP3dgfIR+nA7UHnxjAC2TYtSL
	5vvuiqJWRcwrzPgNPkaWl/lD3Me55AAgsUUGb2unGhwi1EgVRqiR5alZBLdu2obAojZWoUK
	BxHdoaysgNzC2+M=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Hi Christoph, Darrick,
Thank you for the reviews. Here is the v2 patch with the commit message fixed as suggested.

Subject: [PATCH V2] xfs-doc: Fix typo error

Online fsck may take longer than offline fsck...

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 8cbcd3c26434..55e727b5f12e 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -249,7 +249,7 @@ sharing and lock acquisition rules as the regular filesystem.
 This means that scrub cannot take *any* shortcuts to save time, because doing
 so could lead to concurrency problems.
 In other words, online fsck is not a complete replacement for offline fsck, and
-a complete run of online fsck may take longer than online fsck.
+a complete run of online fsck may take longer than offline fsck.
 However, both of these limitations are acceptable tradeoffs to satisfy the
 different motivations of online fsck, which are to **minimize system downtime**
 and to **increase predictability of operation**.
-- 
2.20.1

