Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1667347B420
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 23:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207835; cv=none; b=jETzk2k4wbq1zoo7Kz/RW3m82vge9cUnpYSaP+0P/IaeffjNjfOphHUaldNX5pnMEafVtR/UQfagYt25/1xsKwF5fC8IdGKWcWpKOIYudBmYIuem1YUSFs9aH5tnSLmIpV0/IZmIC4LXlBRx0KknpgruJLVEtCyYbbRLnzjaQI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207835; c=relaxed/simple;
	bh=eekIRUkO6xctJzh0LDxpTW7f45r0xCkvZKYTjeZsvDw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JI+NjxtyXSDZjiuV47pZ2lpQa3G2m5/YfPPIbsCkB9fsJzNMmodinHw8lpa7RA2pF97XTwJItA5CDccBnTwzulXKXb/GIAJ0ybnXSV0LfAjnWgShM8ZliEpp7qGKMmUHKavlkLOUUfk54Ein3L7gSua/TVGgve/com2hK6KTqqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ZqFevxwT; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=j/LlkV3F; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ZqFevxwT";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="j/LlkV3F"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NNCP1b2170287
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0qoQ
	93CRiLkSb7/te8GPJ2ac6VSP9fU3H03z6ipMMtI=; b=ZqFevxwTcBbyDpOcLaW4
	mO9UrX57vPQn2xrd0XPJ9Z/fmWZjTyXImQ4f0RMylBH3owoB63T3ReRghrAXhmvK
	pAJY+eZBp8Rh+Kf/7wzUt9i/X66+G+8FlSwTlXdV0uPNGgzqQ6bpRkqskKxvvLHg
	heXoLcS7GBtoeGRJkCLUjYhnFscr5J1x830G6jjBOhPWGeQ0oZux1U5m7CSmLce5
	hnKa61pnOiJNKXrbWkDcqVl6ujHfk9URZOe2bPrl/8epw/fLUmbgNULiLIJ7KjdP
	Gpe+rzcR5FYW+2i8fTaU4WiLldSMiLNo6wVrF+hFoSd37ZNgMaAX5wIoR5fukObL
	sQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gvmrat1k4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:06 -0400 (EDT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so2232320a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790207826; x=1790812626; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0qoQ93CRiLkSb7/te8GPJ2ac6VSP9fU3H03z6ipMMtI=;
        b=j/LlkV3FNwHLasYq2Udu/KizgIKx0yBKNowUPtf4pozk3shlQV8b2j9AzrIDzcDxLd
         0kB8mqDthQpQvjiFz/5MpUdLUXKsY10RRnsqRnAo7oTbO7Gcr2HniyZJI1HdNsqIcSWx
         DU88bCD+i0TlWZ6CcK4NZe7p1XxQcKpgaZmSKKZxv4e5SYmtjlaode2aYycLt/fgiQGu
         lj1fmh4VqYJR+PWgzXySpPQHd+QZsIo+3+FIfeMxk3eEy3AieBCE5nV4Rf4HEsv2aQLb
         Sc46DLEC1E89Ch8BpFWDlaj4MmSo/2SSC6hZ+VUm4078+Vv1kS30YkzBo8XpvrxSuaa9
         b/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207826; x=1790812626;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0qoQ93CRiLkSb7/te8GPJ2ac6VSP9fU3H03z6ipMMtI=;
        b=D0Hz/FltkTP2xfB+aPHQ/pG/bGkkRgzfh26MYq0AVOvpc3PidCjaXq59vR5A8iOyfj
         XGGP+hXwtlPwvI12EchaV+zoixKmN6AvriQOTowSoVJefT1Ula+Nsqd18A8rxa6I9zwI
         CM3rL5jeql9rYHPD7Ry8ABfAiALLM/LSfUfZ7G+XWfHmJPlWoFzE0FuEtJhRTbe6RqkP
         OthX1JRKq3B0Eqvz0rIPmhlRRaURIVTh0oKaff3Ju4MunWVOYNlP19r2PUbJT70v3q/0
         j0BTDLXZvvE1ReWV+4X9+e440zVe76sZlbVAh/gx9YVSDcYpgLc+dkaEDv6E+JzcABhH
         7FVg==
X-Forwarded-Encrypted: i=1; AKwUvBwJBCy1c0zAJGtBDFIY9YDx2tEHlUiKq9/ghqUEP1IyS0cSSWq0p9Dk8wgc+p2OnWPF0Q0Szi9T+0U=@vger.kernel.org
X-Gm-Message-State: AFuF++mSah5TRG+qQ/+ZfXz9PnaGLRjUYiUkmOLTqSQKeEK+Rtb/+2aX
	mcpF/5e/IgG+G8W+4Ql+WoLVVqyIxAVhhDaYga+fqc0j1U/0kycoG/XIqvwOs/mXqDS25UMxsvR
	ogJ4pFjApgN0x/qWpzFgKvP4EXQWUXYQhTfgts+6U4rsA/CJZjI7fTTiEz+TBFXe08g==
X-Gm-Gg: AYBFou0QCZ4ka0Xo0Pre+lI0vepOZJ9NJ/MH5ZIf4CcMl2ciEK6TZUGF+iLJf5Nnz+T
	nc0crigxM0eluWULIg4oI3DZPQI9PL6N1oXqb4GYQyvuHizh7CsbO9ltBB+1nYdVMVN7revuK4K
	LPphHEPPtKYX8QVYaPOCXm+ktin7+tb8AfehpXnK2zN/ghtQaEeXlhHivjyEpugnol1TQkKsUyL
	oGjV2a6pIDSdkg5PeRZzdU2FnTziK/ibDlshD06STDaXvyAMWHBmdn02LY5B0tSNeZiJ6luvwDT
	ABtJvDd/EtYE6S8JZDwUvpsCX2ArpJT2acYwtXVq95m6WRtYWwwMTiHPQSd5SiLQ9Vws7gEQlKB
	htkk36LmUmTLi9/V/NFj7pcZfKeodR4XvPvikfZSofZPwkQ==
X-Received: by 2002:a17:90b:1c92:b0:39e:6c68:c77d with SMTP id 98e67ed59e1d1-3a098e0515cmr614671a91.51.1790207825688;
        Wed, 23 Sep 2026 16:57:05 -0700 (PDT)
X-Received: by 2002:a17:90b:1c92:b0:39e:6c68:c77d with SMTP id 98e67ed59e1d1-3a098e0515cmr614654a91.51.1790207825215;
        Wed, 23 Sep 2026 16:57:05 -0700 (PDT)
Received: from [127.0.1.1] (RED-LION-HO.car2.Seattle1.Level3.net. [4.53.155.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976ca5f9sm1331613a91.14.2026.09.23.16.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:57:04 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 23 Sep 2026 19:56:40 -0400
Subject: [PATCH v5 7/9] iomap: reject atomic writes in
 iomap_file_buffered_write()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-blkdev-fixes-v5-7-89e60d66eb38@columbia.edu>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
In-Reply-To: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        John Garry <john.garry@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790207813; l=1162;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=eekIRUkO6xctJzh0LDxpTW7f45r0xCkvZKYTjeZsvDw=;
 b=2YSDeglgyk07rr4XCceLzHJrMpahC9wn5HyPBCzFyGWpB4A7Jm0LwTpK53X+wg/uOg2P5jPVn
 EO951ZjrUh1C4yifGSMaj539bji3K60vVy92ozbmJFDFa2hZoDofx44
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX6JnkZgCvlAeI
 NMo63EBr11piQqGKqvo0xbmsLsX13laVRpGq3YK0lzIE20Uj0ZOgkbLdFKhahYNxjgPzu1OO+WO
 Ix4lNcl/um8bISasX13P5AnbYc19AJEEkQQ4UgLJ2J0DSneTAx2E
X-Proofpoint-ORIG-GUID: n2XqOsNhvrDlomL2oFWVNl-isTcEiwqG
X-Authority-Analysis: v=2.4 cv=cPp1IVeN c=1 sm=1 tr=0 ts=6ab46752 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=6aZ3Ysb2zzbY2sELL/OBJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=ASVHLkjgWNnnwhGXR8EA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX7bvpgG4z/yi8
 ZzyELGde3rCGDBxfWoc+oA1xEg8G1WqPOxfiQc0G8Ac96l0/27IPAtYgmaJ+00co+lTQX9aG4yK
 YMIaDIvLZrEU+U3hgjsC/iwLZSdC1PJvMhFln6Vz2PsxILq56CZhrw1halTOOAM9vgTMv08vWwv
 HkgL5l0Mu/zzm8gFdvCUJBMK1numwOqNlMw8fh9P3N5M1OY2YmTUNRnJq6F5jJZHfTLPPfBJsTA
 pkriDODXzrAf2vF3aq6hHrRb370hb4Ky6IqSlvwSYUK7vm3y1yF9gNdCA+cnfF3W5Ck75rwuxKk
 vOrKdtmv1EqoEv0OidHFmFwqMBNhY84ZeYDom1QcnmvJgf0fky0WLStWtopHXxoieWvllHRjjkM
 APPOEfIPL1Jc8duJhFUVisba2Ph1qYSVsgRDrOcDbNRCuWh0I+EAkXZiYbzrtsUis4+gYiRTlpD
 su4gQvkx5WxsHVppHHQ==
X-Proofpoint-GUID: n2XqOsNhvrDlomL2oFWVNl-isTcEiwqG
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11914
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=10 priorityscore=1501
 adultscore=0 phishscore=0 bulkscore=10 clxscore=1015 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230100

Buffered atomic writes are not currently supported. The page cache
writes folios back independently, so it cannot guarantee that a range is
written atomically. iomap_file_buffered_write() does not check for
IOCB_ATOMIC, so a direct write that falls back to it would complete an
atomic write without atomicity. While no such case currently exists,
fail IOCB_ATOMIC writes with -EOPNOTSUPP, so that a future fallback
cannot complete an atomic write non-atomically.

Suggested-by: John Garry <john.garry@linux.dev>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/buffered-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..e6654cfe1cbf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1304,6 +1304,10 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 	};
 	ssize_t ret;
 
+	/* Buffered atomic writes are not supported */
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		return -EOPNOTSUPP;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)

-- 
2.39.5

