Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71653CF041
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564629; cv=none; b=Lg+sNvzDvC8rvnuiWMThwz/K74nIjTGKkwSsIlXmzlhxQX55iaWGZmyPsLXarhAg8E0Cez6j+bvLQmSfbBgEjMdCOzocW6OdF9GbTVae6US0vCT/rdR5b+FtfvFN1FKeMTq4SSmXnoYrxUT+H8Q9wEjG4xmaEkTN6yrMuB4o2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564629; c=relaxed/simple;
	bh=nOUyLn4mikuuV5NB3Wyl5aQas2LTcg2ovZW2RzEQLhk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HBlZmqkMnl1sW6IV1j0X4gcQJdILa2wYu9jcbNmvyJoWVGYkjZ/rlBIEJ345Z0Vm8Nj0rRXoDDI5H+FMF7Duc20U0k1YO+IiVCkEkyzkAapl/MrsLNbxE0QRhit2cJWftVLrGoq1RfWU+prr6M+0cwQ9ZuJTKT3C7kaH/4WVbVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=idFMBDye; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Hk+YuNV9; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="idFMBDye";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Hk+YuNV9"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYoH0141915
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KmSd
	hCQKvTCx7iCBBSxeBtwdW5W857zsoal7R697w6Q=; b=idFMBDye5fdULfNdY3rm
	IrgA8nByqJoUBBKItUZcbn5sAojpR05gche47oZ8PSgi7T73xwmKmpKagS7/qrxM
	iF4T+yCUpo5wEKCsnVOKzrv6Pg939zc22V7TcT3JrfMjRfMbtawdeEjA9sYjZfyZ
	JEF25fbJvRbUK4xsLKOzHmV28aWohYef9E+v38Zfs+/PUu8VPe3jqFDCA9k3+2PH
	k6PrQah/6U1YT0UNWFGl8oj+IonyjxrtEU0T55dxCvfEulp85tlsCuTfOrdsBjiy
	B8CJrAPWFMvAY7b8NLw7OzmA9zZnAl/gs2QZx1vUyrfUP9iFyRPi4XwWwVEpLp8v
	1w==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h6xqqu27h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:27 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-535252004e9so127657951cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564626; x=1792169426; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KmSdhCQKvTCx7iCBBSxeBtwdW5W857zsoal7R697w6Q=;
        b=Hk+YuNV9SPZMyNDsaWnndFUjeUhI0aAXJGSr+SWFPc3DWfjb2WnDB9ZZzigoCN4w/f
         ZYN1FUbMuRAQ9Nq9GPtJWh10KDCcHELRkU2h9lUP/89F7d3vVy8uBE9HAy+Y7aeQqonL
         dYciTBzcksgnjQRx6kxxPaFc81L6k9vuWgF554qgpiCxvR7wvF99KAnhXmRgv1VdNpKA
         p337OyhSa8idViVWF82yMA45PiP3gxmdOEXYslDkHCMsnJ1FXT7Fh9MUzevpIe8zo/ZK
         gWHShhbapMPxvar12bTuTUCWhrg4Qa9za+X/DNQHpk5Fr7J9JMIpB3Y5WzBYkwRYLsoa
         I4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564626; x=1792169426;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KmSdhCQKvTCx7iCBBSxeBtwdW5W857zsoal7R697w6Q=;
        b=1kgcLG4MLjt857nN2tqyCtDUzoVNP6kCV1V3hADkoGQkpGt2/hunVSfK94GPdkCuBP
         ZgQ8UEC3fTOdnA6Utu5Jox4Rdne/ia4ju154HtT/eeor2CI7J9+Z8RcD+4+n5FsnWwDt
         KbkXRqFDLcSTOllNsM8i/Vf1uqXLM6BpoktucPNwjgZxOAvTxXB68Yz+E1xSQGxzKTYu
         BWAnkZoHm0sLkta+i5LBmCDqIS7t+oRtw/3BnpP7ktFr4T0+Yg5FHbnUkSRqLab/Yxxe
         zXTCsCWAMLHlMUOttyPQtqtJUluTUiXsNsba3R+J7xvLmCWlZsNiFb6ulnD4GEboUQos
         OZOQ==
X-Forwarded-Encrypted: i=1; AKwUvByV/j7z7sf9GLfV253r5/x2Gv4NnLR4TnzbKzlDmvPF5PhdrESq5A4iGE1ddTJPRQn1CtQKYHQDckk=@vger.kernel.org
X-Gm-Message-State: AFuF++nx4yNHxL4zqF6s7xXJp4VzdyWHzknemCrCVVj2+HAnLdazffXV
	YkLPksoLO0RZ+yuT+kzcnfWrjnPkniC6Y3C6+icXLhhzrXYtkkPI5Fz0UsQMVo/6fPRkIoA031t
	mYQ1BHYOyPEDAwTY5baa9gtFwoIG6CTDq1u7Ao2cCzNdZZObRKlyS9gNAjQ==
X-Gm-Gg: AYBFou1skujnw7zvwPNvP59H4I2tbFFhGoDVQm78st8yT/JVYT1vEt+m+uW1WlWiPpY
	1a1MGcLvZMl3xnVXxbETesDWpSAto3iBQ44FoZU8OcAteRtR3DWc5WMyX482/Ebi4BIRxYwG//1
	kkbQldgAiPHQSAbj4kYi8781Elyi5xQBCCkjQMTUOn9gT3kW9Irfs9t6FOLbp2pAu/KI+4lmtoU
	TPmlqlpW803/77nmIoWvu+qgxPqs13x4BB36Abr34SLIGxed3o1qndrA/GPJGk+4/RhdtMz0NSJ
	NzLTTNOBnZMYRHuX4uQGuAv3y3ydS4CtZIFX5kVZBVukXjU42FI8nQYrRlfZT5mqBPuAIcfMrTa
	Fb0M+XJzLOKegKFwMCJls6PrHZuAfXonFjedrTDMfHTqn78o=
X-Received: by 2002:a05:622a:4c89:b0:535:1a4b:a65c with SMTP id d75a77b69052e-5359fb432b3mr36915951cf.34.1791564626058;
        Fri, 09 Oct 2026 09:50:26 -0700 (PDT)
X-Received: by 2002:a05:622a:4c89:b0:535:1a4b:a65c with SMTP id d75a77b69052e-5359fb432b3mr36915461cf.34.1791564625428;
        Fri, 09 Oct 2026 09:50:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:24 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 09 Oct 2026 12:50:14 -0400
Subject: [PATCH v6 6/9] block: don't fall back to buffered I/O for atomic
 writes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-blkdev-fixes-v6-6-307939c387df@columbia.edu>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
In-Reply-To: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
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
        Sashiko <sashiko-bot@kernel.org>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=1843;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=nOUyLn4mikuuV5NB3Wyl5aQas2LTcg2ovZW2RzEQLhk=;
 b=GRY+dI66HvbGZcsKUzr9httFuonZ1PqySnkNxCOVUeKS4B187FSIqqmyLZ3rTzggMPfXvLQow
 oeJGvyx0EngAAc/r7e00x+XXW3hCpKoDE9sj/87HM8fak2oyTeYI42H
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfXyWa0rgDFvotX
 HWKyWZuTkkXXUyxegBgTYxSQD174Zl3aSTtx3uvrUUUQJeXPxVGx3ighQguyvTEQqsADypDro5V
 jnum+w4rpqyiWrw7cF+aVlxMhoI/aHQJTMbusTICi507yr8vgjoi
X-Proofpoint-GUID: sdmIr5UUVZB2O0Kjk25QYYJtIKT0IEPg
X-Proofpoint-ORIG-GUID: sdmIr5UUVZB2O0Kjk25QYYJtIKT0IEPg
X-Authority-Analysis: v=2.4 cv=I+/w19gg c=1 sm=1 tr=0 ts=6ac91b53 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=s8mzj7eOnaliLhoSWqYA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfXwSsDuzwDW6WI
 CkzSiE3Q0Lx5+84S1ETQa9SG8Iy8+kfKI05c2rYQPzsI32CNgJt0iXR/fWpRzoB7sC4q4+dOsKT
 gAF3su+kApbZutahNO8MctYvlwKybI51QpfvLvmjyd69Y+d9qh5ADttl6tycocHqZJWM43a7Elc
 P0XSAhXNrRWZOAtg5Nu8Tm69O0F8Cbs4+TUgnk9XNw3fpJGwNd+l9vMsmyQo+Npwuryru+inelp
 YJY8qCvl7oCGkDL0LAduE+Sm6Xy+aMfRLzrQkB1NHhrL+0Ry2t48q6/vcH04sBac2cVxKroefsc
 u2Szo3R0xb8x80IlhLBjYcqoIp6Uy5ajRflIt2gyQG+7fZ67D7EWf6DnqPFNxeY9dtapsSGTT8t
 HDNjSToEfngn7kgFm4QrJgKOZY01M9qsEEpEiHOea4+6JoP3fKcJ+XrLteLI0gOM6kKbsKMn2Vx
 jWA+AuElQgI3qea34Sg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 bulkscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090067

blkdev_direct_write() turns an -EBUSY from page cache invalidation into
a 0 return, so an IOCB_ATOMIC write is retried in full through
blkdev_buffered_write(), with no atomicity guarantee.

Skip the buffered fallback in blkdev_write_iter() for IOCB_ATOMIC, as
it already does for IOCB_NOWAIT, so the -EBUSY case returns -EAGAIN and
the caller retries, matching __iomap_dio_rw().

ext4 has the same fallback and only warns in it. For block devices the
fallback can be skipped before any I/O is submitted, so fail early
instead.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 1ac3fa285090..41fa0c663f77 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -782,10 +782,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
 		if (ret >= 0 && iov_iter_count(from)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_ATOMIC)) {
 				/*
 				 * The buffered fallback blocks on i_rwsem and
-				 * on writeback of the data it copied: return
+				 * on writeback of the data it copied, and
+				 * can't provide torn-write protection: return
 				 * the short direct write instead and let the
 				 * caller retry. The bytes already written
 				 * still need a flush if REQ_FUA was not set.

-- 
2.39.5

