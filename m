Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794111899;
	b=4k/MJqcYvBxe1+RnjuKi/Sf5RDLSXBadhi1rJS73cjHgCaaRJl55YrDZpQ99vmpK4dX2
	 jD7TBhxavSOdDEINbk+MgZ1hStPRTndmZtTRBYdRa8chpe8M4GJGVNKR/daoWjqgfOAFv
	 jvn6MyqCpF3ect0QrPTWY43J8plbMmuhw0dWPVmAnvp5s6DsJP5/49yumEReMxAdQP1bK
	 XcloQdd3ROo9tytEeiHxy9ZmdN7ZHrOV5j8/mfg+CWPeFCIcuh5DC6qHjeqvbgQJi3F4C
	 +H4M92xkuUN0kKO4GuImR2CMYRGDTI8GaK1E3wttf0Br8V44uEddwPFcio5vVrX2W3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794111899;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=K+8Bg6EUw3TF1wR9YyKQuQJJAgHFmn9Yf5SnbT8zOjA=;
	b=4k3MQiTOv1urYmqGHohakfTDYvVxJk+s+enm4+ey3z0Sf8nZ8NaPAEMDS7V3EC/NLw/r
	 +frMRuRbo4w01xjkW3NdTAei/CWKaDLSJwkwSW7Ts2wD0l6jZSCjgC/sc5WBdX0NGkkIu
	 mF6UoPigr6tgxJU/SJcaREvOw8GMe13pyVY4QtIckbLWb2u+wSclhDzOyOvjnzxpPEPvn
	 FspQUFLno53/Frul8iwmIlF8iEDPXX6xvdnmorLD03TcotOR0pTE2seLVGGJiTIBnRVA7
	 7OazDa3WDlbHxyfC20gadOj2WOfbSn0SDVxAAkM0oxBfUWX9VuoDZvbxKtfCDGdGq7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=NA+eMRwy;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=M6UZqeGy;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADB6606A31E
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 04:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ADB6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=NA+eMRwy;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=M6UZqeGy
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A83fB1L2512762
	for <linux-xfs@vger.kernel.org>; Sat, 7 Nov 2026 23:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=K+8Bg6EUw3TF1wR9YyKQuQJJAg
	HFmn9Yf5SnbT8zOjA=; b=NA+eMRwysoiN1QqrWsbt0Rr0FUO3Ilui52wc1rcSmO
	en6V7Ir8uKs8LkuguDrcnqd1Kcam+Batzv2jaT1PfxF2nygaoL7XUKJiTz1pry6W
	8B1CVmCDU7meCThFXHtqI1Hzt41QT46OxMOpdeTnbljnl/R5wxhlMeYnriQ3RToJ
	VyLusS52dlctIy2ZDmYtjCfGmKV3URoK5HgPEPNk+6rY6GsYcQEkmDeNOET3wur4
	vS5gdv0f9/sFEGJcIVzbnI8WzF9dMCvDFa1zsOm7jaHtTXo5cXLtQH4KyAGB0hbp
	xpubgBwv3V2nH1+Qq8/je55ze5OKg2jpfWGHBE9C+3UA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hsy4umanq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 23:24:57 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91ea39a2f8eso2373566d6.2
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 20:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794111896; x=1794716696; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K+8Bg6EUw3TF1wR9YyKQuQJJAgHFmn9Yf5SnbT8zOjA=;
        b=M6UZqeGyCCs71GXwtMsnjxVweAjJnJbO98QMbCdn3nrbyEqFpypYPEN83l//wHMfDT
         6oacT/xFjTsM16dMuPHGW0o5OoKNHk+m2OB6/LkbrpdEYHIt1ANfZ3Jp4G1zaVKBo0a0
         4xNWOz+MURlXYb+r5HWe1axQb9aRGr6RfZJ/R0PHmgTQlzP733QwJLoa/j2zESUoykfL
         J4CbKibCm0hs0WRCYaRaNSIajE8tQudXpcN7uHMI+dXPw9ALS7jPjxaHGMxwgN05zg+9
         a9I9OyXKwTYHJQSE3DDH6qSA//SMb6VraQA+19N0z9mXTDth4RfOEUfg8NOxbKuY6WYU
         7Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794111896; x=1794716696;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K+8Bg6EUw3TF1wR9YyKQuQJJAgHFmn9Yf5SnbT8zOjA=;
        b=xPHjnDLzgrFFL0gr+FFBdkpUshNsbxrUbpOvbNaa72KBKd/qhXCvmulhE9VFAxe0nB
         sO3YzYPrJpAM41dMkVagpykbHblz93DBAZDPVprdAlzmAp/G6AUWrqpRR3ANnfG72JOW
         Fa0ZrQKa+4Vm650mDrvldWDjfcENip/YQ7FADDaQbfC0hjen8k6tMzWDcG3dr+x1HiJ/
         8PA6J1TRLXw9TyAWXrD6mVZG1VEtuG/4Uamsn2sfLQnk7mK55bAx7t6G0x3Bdf8s9FVS
         c2zoYeRFY+Z42fpq6Fqes/ov3D9+6Ps/CPGp4W11SgCV6fi6gEdUtr1HxheXqFb0qMI/
         EIJQ==
X-Forwarded-Encrypted: i=1; AL+hErG45g3asM4R+44FIFAQGM+SayF38wa5wIknXcidcs9SXQRbH4uajemI+xJHXxldSbJMM0TbyKU9rrM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Uc5s6pXUl2cqIA6rqJz7nUhtjeV5iUQw4dkMQieqXCFAGUfSe
	TRs2RH8esPp+3JbxciwKKmR4SzayK/VLOkShMO+/9283/Pu0/oANaxuSxG1A2pgdDsc0jP+LNog
	/QIGCNsPwjwCUB4lsGO3TGeC4FfDGzHpUsWvXYxrjGG0nqKPTJb2k6BSmpQ==
X-Gm-Gg: AYBFou2u1gqi2j9+IXCiUyqZzy5lvu33eTpyNv+QX/HqeautYF1qpWc+n8iPXWe5I/m
	Ml6P/iPy9nG/UjHNh7JmYKrqPQYf26LRZbXafLelRZjdrQXw/FvB9NLY8LegkBC1dxaMd2SfzYS
	rTi6BR8/vblU54kJC1vcN6/n/o8d0OLq52iaFxY9t9cp+q5KNzD/9XlUt7Gx1rGu7JdjqrOrSnp
	k3fXJrmJlwLfUy1m7iehdQnFSnYs/wV1W8JiZqvyW2wV4maSdZl7BWlWKf9zEaxUkt7xJYUtad0
	FBGizSnkBUDQFCJ11wDXELlU3ZELUlpcZkiX68j6hrQSJWqT15gKmf3D2r13NeKhC3C8ln7tILq
	UGg3tjt7VwZlj4RjV7QA2iNR5oCi+pXXWXlV0EA9J3Hb994jlT05cj8GzlxLyMtORNiGk/QBlCO
	nt2WpLa9X5jDYrlzo5Uw==
X-Received: by 2002:a05:6214:4b07:b0:91e:8ed6:896d with SMTP id 6a1803df08f44-91ed2476a9fmr5970756d6.41.1794111896370;
        Sat, 07 Nov 2026 20:24:56 -0800 (PST)
X-Received: by 2002:a05:6214:4b07:b0:91e:8ed6:896d with SMTP id 6a1803df08f44-91ed2476a9fmr5970596d6.41.1794111895960;
        Sat, 07 Nov 2026 20:24:55 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eceb56290sm10085586d6.1.2026.11.07.20.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 20:24:55 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] block: fail short atomic bounce bios in
 bio_iov_iter_bounce_write()
Date: Sat, 07 Nov 2026 23:24:34 -0500
Message-Id: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIL572oC/yXMQQ6CMBBA0auQWTtJCyroVYwLOh1gAFvSAjEh3
 N2Cy7f4f4PIQTjCM9sg8CpRvEvQlwyoq13LKDYZcpXftdJXNONgecV69h8hNH5xxNjQg25Voar
 ClpDSKXAj33P7ev8dF9MzzccL9v0HmrkbengAAAA=
X-Change-ID: 20261014-blkdev-atomic-bounce-fc9c583083d7
To: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>
Cc: John Garry <john.garry@linux.dev>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794111894; l=996;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=MQysUVjlstPiGv0HFbdIIHEKVGY3qk9oBru4ywVAac8=;
 b=ZFIpiuUVZQBRB9X/AYDUXtP1xkrxSWzeG52xXn4uDmJFAT+3ouMLtp87i4lyR+EjUxAB/zX2n
 numf/QkOPTuDfVi31ykeyiHjhEgiSSSyJiFjO0NEm0fExmh7ItRJ5Yy
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfX8ffr95Va3TEP
 2ooUCBsJwuKDZqV/Q9cBtudgsPUIgWEbDZycZoTiWMc03O/zpI26zflI8XeppgGeQQm6C3RIAbG
 zihajbm2VFfDpx926GW9GTcaIE5i+9iVmVL5EiqraDO9RqPVxjS1ticcMFLABuhzsUO5KkSfZ7C
 oOmhZUon9mysc8PvbaDHmJKl92S0Ou2/Ns6knHmZikh8cTAxH68E8rgAQcAYDMksKtlR4+ThKEB
 MPBVUf4GiLlS0EYICYd3TQDjfSShT6uNVJiy2trjRiL2xsA371dzSjJWHqF7xg5T79k6/9o6aj0
 54iKxSpiAFDWcFXwV+f8jWGkO++TQ69TpLbILtIwCZghhJ/Xkmr+rJ7YylmeFqEHpl1v3oZm9Xk
 /41yh8VA0ol0dwpxkky8RnAz/uWfiJ2eieeelfEQAajZIiAfJNt92955KVJmLsNQpSNG3sZPvir
 z7Au00PsgF6XH9VRvZg==
X-Proofpoint-GUID: 82QPHsxZDTfM6wPWW6_FYn0EbeM2sQPP
X-Authority-Analysis: v=2.4 cv=S9JMU4sP c=1 sm=1 tr=0 ts=6aeff999 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=kv0fz9X2Bfwy0Ckj0RYA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfX05Tk2x6qtSEB
 ohMTpTMjiRXODHXCu6s2eB7xPXe9g8B9v7PcvTMmv9btCo1Am62MAAcT+XptaxMoRNXfUgPQ8fO
 PiY5zqxaJZMQxZlonny7aPDcw5mwR48v6OKSOvXsN/VyE2DxNEEv
X-Proofpoint-ORIG-GUID: 82QPHsxZDTfM6wPWW6_FYn0EbeM2sQPP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 impostorscore=10
 bulkscore=10 clxscore=1015 phishscore=0 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080017

bio_iov_iter_get_pages() fails a short REQ_ATOMIC bio. In contrast,
bio_iov_iter_bounce_write() doesn't, so a bounced atomic write that runs
into a folio allocation failure triggers a WARN_ON_ONCE() in
iomap_dio_bio_iter_one().

The first patch makes bio_iov_iter_bounce_write() also check that a
REQ_ATOMIC bio covers the whole iterator, and clean up and return
-EINVAL if it doesn't. With both paths covered the iomap check can't
trigger, so the second patch removes it, as suggested by John Garry.

---
Tal Zussman (2):
      block: fail a short atomic bounce in bio_iov_iter_bounce_write()
      iomap: remove the atomic write length check in iomap_dio_bio_iter_one()

 block/bio.c          | 10 ++++++++++
 fs/iomap/direct-io.c | 14 --------------
 2 files changed, 10 insertions(+), 14 deletions(-)
---
base-commit: 839203759f536e6ef1267c80309c3532a7d588cc
change-id: 20261014-blkdev-atomic-bounce-fc9c583083d7

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

