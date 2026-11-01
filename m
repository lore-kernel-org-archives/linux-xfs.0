Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550488;
	b=Rt/JFT9lcMDuKS6MNBk8wk07Ihq5M2kVETLGUmVX+g7uRbtUvZZua7hom+I0fYsUn07u
	 FWW2bcimNmIDvDe5VYEKOSu8T2FMPfEXAErcCqIgInJr38Zj43WrfNOOQw4NPsX81u7/k
	 EhWJ7Gz14KOYqDkLqWikzJFaMztM4KYwi5uzu+vbHAGt42h2a/YMIg0ZwCiNZH15S2kpo
	 ACMraVrmMt9CrI6o56imLVbQPcwvbxpcutnd3eORwBxhxRK5HqaGgL8J7I8EBgXbPe/J5
	 S8nVdg8Koo+nQw6l0Vo9I17ZT6juN+oBj4RAvpwHftJfvYWo2nsHaVizY69du0332fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LPcSCcUgApoUmnd2cGqQGwdkL7ZlB6BcE2iNYWpcRCc=;
	b=w2R4v73SU9UEd4qNMcsMIxo0cduuz+w1ljkBpzhCH8bjlywJtYf5xy0whaZ72RTRJnF9
	 5s96hz5AsGb4apjJ5WqQpZyYI3axzPmzalGjOVQNMSMbjx0boSiuSt841zF1KNdx+fOAd
	 02fY2iQ9GPkGsKHaEKoeCwnDbtEzAI0fXV1pPNuLmSr8hpLU++kjXOUVM4qMoN6quQsaZ
	 n9eo0zwfkgLz5YohyLwHtkQa+/FM9PgZL0vqiQXfYkwIXdo3Rx3lSgO/QYhvXtnasBpMA
	 4/heXCPCXLecXgLlKRiCbq+RSNCExwAR99gg1oTQwG/+0EoBPzb0XGwZXIFqAaFVMDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bE2DtvL0;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6536606A329
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6536606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bE2DtvL0
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so23309995e9.3
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550486; x=1794155286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LPcSCcUgApoUmnd2cGqQGwdkL7ZlB6BcE2iNYWpcRCc=;
        b=bE2DtvL0ynh5XVbIJMxQsxBGkCjXUmlJ8xgBkbCfQfsIlRnGLtVUDGH7NgeXs+QcZr
         oUW2oq80Qs8W0JFomvNKFhxmjLchAg5mZH+3m0fuf/w0wYXNeIE53O+kVbCnJ+nSjkiI
         Fp1ldQEkTDA5xd3AzVZJzcOsqeBuVgySX/+wgYlSOFuB/Q47TMbLNFClo1JB8XLze9nD
         nC6Va929QrcU+kQ4xLsNHJaZk5bwWHZ+5bXF+Bk44yeY3JqBbuoTWpmPr1b3rc39Fm3r
         VkQR7yUlbMqSknlcSq/94klxcWaeYFZUoH36hD6YYMGHlwLjvGYt10b065Ndm2y8OCTs
         CGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550486; x=1794155286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LPcSCcUgApoUmnd2cGqQGwdkL7ZlB6BcE2iNYWpcRCc=;
        b=p0A7wgdpGjRHaCzFFR/qQaiFpNZB6pR8/JrLFLBuWV/Jqf2uVfclJXOP+5VHi+MKUT
         f6UpjFrKd3mNDeNj+S+xOuIUhWEVoVjWg+I3Es707M/0XBdmwKJolf/yE6sXO4eu/hVG
         eV/UCg0UJQlR3EpzhOWR25/6ch+jgS6Ov7LPc+ecrtXYVklX7JE4LXcGmlLK3kkiwXXu
         vBkn0fY3Kyj6eLd3lNrrKzqniiE4/zp9Izy40ASYOaFpPYC52iPTTJPpJX7iQ2YmhXlP
         cPtLCabN0F6d5ZIjAfqV/YER5lbmtJ5XyNeS/EaJ8B4zfxt9pym9XDaSfTMonv8d9q+v
         Rx6A==
X-Gm-Message-State: AFq9FYIvsUyeHpSb1nRmmH+2UNH7c3ja0+gALyqrNB34wNGvfgyP9rIi
	Km2kKnwDzXXK/0nSaUQ9slAxp+F78242/NZLWbpHoVCLDb8EUAOfkmtJkSn1
X-Gm-Gg: AYBFou05Q20a7c962UQT0st784bRn9Hk7sCC8oqwbz3i1CenM8bEyofFFJiK5doTk87
	wz4Bdn8Umx7Qg23x6bt7IkEapbNije0G8uZ877ipfOnbLa5pd2XbJumxQUDS9KAApUfYkIG5fh2
	u8ExOGBAulDcaITHOy/09vEKi7UuUxTPTjlRLhMd/07cr6JHhaX4zw0FBYk4MhKcRUU283jWimX
	oIbA33nwhwTJXUjhzgcg7skaQfP8id87f6N8a+C2hfVoDGMSJ7fZtzjA0g7ZhMuwNWI93BIh4Ax
	Tzg25tG7R1e4EuPgU469wog1OPRoiYixrFSHet0+DGHNk94qb7kL1BUKqkekvdi6GF3Umu8+nB1
	DrGdHWvNL5ug0yvLXQPDOIhGcb7M6Qm1KMqQosmM6ItECxLFxqKn/rJU7NQx1Y3tfPPVKK2ED1k
	6MG0n+Dp8qvxhYU/4Kygen/CPC+Ck287DjC09blSWCYs8L7QWeHv0TzvQeDC3Q/ltEudsEtcjWD
	b53jzG06HgZoUPwC/wL1k/wvTQFW2fwXO4hLiCrM0xaAsBUiZuLLU751IpRKQRvJyC3LCKA7IIo
	pF57yy1dP93iSxgTtkjiklPR2Mdi9HEI
X-Received: by 2002:a05:600c:4714:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4ac180f1c7amr181077485e9.12.1793550486129;
        Sun, 01 Nov 2026 08:28:06 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:05 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 1/5] repair: validate MAC label attribute length before stack copy
Date: Sun,  1 Nov 2026 16:27:59 +0000
Message-ID: <20261101162804.1444159-2-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162804.1444159-1-tristan@talencesecurity.com>
References: <20261101162804.1444159-1-tristan@talencesecurity.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

valuecheck() copies on-disk MAC label attribute values into a
stack-allocated xfs_mac_label_t buffer (508 bytes) using memmove()
with the on-disk valuelen field as the copy length.  For leaf-format
attributes, valuelen is a 16-bit value read directly from disk and
can be up to 65535 bytes, overflowing the stack buffer.

The ACL path in the same function already handles this correctly by
using malloc(valuelen) for a heap allocation.  Add a bounds check
for the MAC label path to reject oversized values before the copy.

Found by code audit.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 repair/attr_repair.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 982dc838..876f4240 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -164,6 +164,12 @@ valuecheck(
 			free(valuep);

 	} else if (strncmp(namevalue, SGI_MAC_FILE, SGI_MAC_FILE_SIZE) == 0) {
+		if (valuelen > sizeof(xfs_mac_label_t)) {
+			do_warn(
+	_("entry contains oversized value (%d bytes) in attribute named SGI_MAC_LABEL\n"),
+				valuelen);
+			return 1;
+		}
 		if (value == NULL) {
 			memset(&macl, 0, sizeof(xfs_mac_label_t));
 			memmove(&macl, namevalue+namelen, valuelen);
--
2.53.0

