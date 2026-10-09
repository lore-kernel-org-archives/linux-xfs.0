Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8573B3BE7
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564624; cv=none; b=FtXRIUgV00WdtOxRVL5oroHNHpymZ0bdpTkPpV8yy6z9LoRXPsk/wfaDgSmtqT/ft0LLxHvSBrIkCHdWZdR4m4sN9CmjaLLnvXSXg9ma+c0oWtZGwoy969FmcxcwkN/z4xazzl7tzoZTFBR935Sfi1/vGdJg8IVLIna036dGsm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564624; c=relaxed/simple;
	bh=QWCjvSArrnPRtD+0j04CDKUtmIxaPixLlth1E/uEyZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nBULnTgPnwYt/oP6QN6gcmYGv4kedKwo18WMCePSSqNHn3kHKCLc4Rn1QXlCGJ94Cm+lbNoGws7/HT9TITKmHwKMkxih64RyDV4L8vMc+iGVZgO9Hw+IUUnnlQoWme5xQqnP6tk/6ttCn5USRTi2tS9T2XbFqj0SwKFP1GF6mA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=OY9if/AI; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=PL4H7yBN; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="OY9if/AI";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="PL4H7yBN"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYR0A984692
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=l3JT
	rRt39SQipVSWvndi+FFbNSesn5q0JN18E/yrYeM=; b=OY9if/AIK6inCYoKOLPD
	UxP8kNZRCLIQfjKOH43P7bhel6CPP2ogbwArZ2HY8eoZGdjFAscN8I2fZJvEisMw
	ujJUe3L7FXpqNFbqDYRdWYk0gC9g91HgXjxtkSvXDoV+HhBVzojBa7P/KVjIgAFo
	MsnSO082PG9f/tpcsaPHQMkzqn0HxjWlH1Prue7ZXoyX8CYdgAJoQLqUgS4+Yddj
	htY7DzcRcW/1w492J/yQRJ8qiwXvvz/9TD8LHqLE3pQ8jcTgTOxnleL8v7QKA0Nk
	o7ZTaDYgFkrbuBZSx0wCVJ/ykDJS7h01v4uzWIOQYYFoXiA60k729nUJU8zkJnKj
	Cg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h6p2nn48t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:20 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-53522c265f1so125279951cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564619; x=1792169419; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l3JTrRt39SQipVSWvndi+FFbNSesn5q0JN18E/yrYeM=;
        b=PL4H7yBNrZA+7ye0WxGPWs+pAJ+hXN1M42grPQWmw065/32gPStZ/UY2kuq8IbsUC0
         uAWMmUHBd5NFqsy4F1O5tCg/brZgx2BiTSvjfDXuYjEB33OIBMdMbLNtSnCz1a69XZLN
         oNDRpqWB4kVz3t6ho8ocNwLV8wRjrfdvh9XPNPHlPBqJPzTek/vOr+3hmfZrXAxNlbnv
         jMgRGeq3Zl3JMjuGHSwN3UEHF1xGjxGK3ZOZVmbXZtoVT17zVKc/DVnlFzeQ0BubFuUI
         s+SywuVLbo6+zB8j08ba1YJj4Wkh2Mpk9BrO+lhqrG0PIK/r3b0AVPmWv2t78VpBxGqb
         9T8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564619; x=1792169419;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l3JTrRt39SQipVSWvndi+FFbNSesn5q0JN18E/yrYeM=;
        b=tPnQh7nB+u8MJ/A67ZbydbK+enSceqtEka12EaTXRRdiRMkMR/Nltuq62PZCmBL4En
         Y5uuTv0Uz7FrINbFQgZnA9JDk0gAMPO7N1Y4Sg+tQOeq+B3+hM1cXTdVk4ZwnJDsgp98
         vP60Y76HD8jXTA9IKdpIY23Xe6ZorZcAORaFbUCRKdViYQ/HJVECpcdfePPgUAm1OOro
         KLMG7pvnz3y507pu8VYhw0TaotQaHLBqvtNHCTr9AR9EaCXUtlCyoSdkVdYhFvDStwu+
         ZbCGtWm0jBPpb11KtlDmh7gyGYcw3nJWUwaFwHtHA/pQCD/SZtrkuPS27y+VeSsyhu6G
         9lhw==
X-Forwarded-Encrypted: i=1; AKwUvBwxHCtYAAPhYRIKH8156UMeCqmT+vTWaoV0Go7XxWl9w+9GUdLd1ItJFIa5W3YkCBxyFvoOABqmQ/o=@vger.kernel.org
X-Gm-Message-State: AFuF++mqjW4p/+/OQUU+E0QCJuUlDpKymg11GokUvrZPK2DJ8LvhZenZ
	iR9mqypwOXQcULmBs/tqHv0DzguZ22R9QOK4Bj9WQpMbR9mfAnBaWdbEw+CBp+gY9XBQYxkQ64z
	xZ1tz+gMAN/DD4vNhodJCMk3c48jSWPEdY8daBHJnZ9PfsHtQd660MfhYyw==
X-Gm-Gg: AYBFou2WjFQtoKYfhNEebSoHCJfEC+voDO1mhSb7uaD84oxzIp5jxpTEv231387oLgr
	GO+vkyjaDyaDXAfaDl5NlRDOl8RDVjkw5l2EHWmKaecbVCZ0rEw6vpmqhChsWtKOxX0bXXNcxgq
	fbUzWHabO6TOCjbY4X9B3oxpQsdBqAXnE2kDQPInDJJxwqCqWp/2kGnG1s2SvrHjClbbZ45X+3w
	Cph5syPGtIcE9v+MuQpLZL4g/PtiD44a2BgEOsJNu52UdHy4zpJw63NtRhd7qtIMPEvXW02JmYb
	H62jxARoGNeVKEdoBBVFhA/74vxou4NtkAm0kCHViWGZ6h2ZBbATqfoAU8NIklv9haUTv50THpo
	g6gMoJCS2pvk1xMbepICS0s42khy34zxGGl70wUTtiqkffDg=
X-Received: by 2002:a05:622a:4005:b0:535:1463:ec27 with SMTP id d75a77b69052e-5359fb5a42emr38189851cf.48.1791564619458;
        Fri, 09 Oct 2026 09:50:19 -0700 (PDT)
X-Received: by 2002:a05:622a:4005:b0:535:1463:ec27 with SMTP id d75a77b69052e-5359fb5a42emr38189271cf.48.1791564618838;
        Fri, 09 Oct 2026 09:50:18 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:18 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 09 Oct 2026 12:50:09 -0400
Subject: [PATCH v6 1/9] block: use iomap_dirty_folio for block devices
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-blkdev-fixes-v6-1-307939c387df@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=2128;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QWCjvSArrnPRtD+0j04CDKUtmIxaPixLlth1E/uEyZQ=;
 b=qMLmvZeuSixOMS38x6EmKAp4mC0Z6ytGiXLIW869jZX/sxWmXGZmFtbD16FIcyMxeAhASjd36
 cYbRlGpBwoXDkw8TKIZpbqkBpJXceSkdRkCWwmS9nmmdt9xDp92Ohvj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=eaGo7LEH c=1 sm=1 tr=0 ts=6ac91b4c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=NEAV23lmAAAA:8 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=lHyHCDWJ2e6pF_oXpYUA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: g6qri0sjPP323kA8sJmj3I5haB8yiAl9
X-Proofpoint-GUID: g6qri0sjPP323kA8sJmj3I5haB8yiAl9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX4zI5SHVh1gMp
 eH4J4Jb33vzIZ/l0WspCbLQ1WgP84xKLzMy4FgStB5Gk1NDQrpwgLp9EXFw1iGQEFze8E5uJOpj
 6t/NGSSeQzK3REBH6n66pf13hTmpu3An8BqCyaDOP6McJA6CVMEx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX7FV4+dDnJGNz
 Nxyih66Ti4fH8VdH9+cKPMvSlmcfs3w1kIGvDsqK4Zhyv4kund5UpOfRi6BWjwxzewFG/3XN+8d
 ukja3jcRLgXrxoOF6iNCtyNjbw6sGHh2NFT93D4VnE3SGChpY0PL/SxMp2jKeTKDtFS1RH+ujy+
 wceMy0yeoQjX9oPPRjV83Ztlt8xPOzY+MfAemiXCWwtyzj0VxDIAlcr2vFhTyOQdFspxFkxXM/2
 zle4SkrS47wTYYqnqjNvwumIs2koxa9gLduhCkf5Krg6c8m8/40GfTmfnlDKPXxpC21vbJql7Yg
 TDeOnOXNKJ35no7GSZJX2ngtRRs/3IABAyIh2MEHdgAz9VVVSTDbmttfI83QbMUJM8wpYw0IbjV
 Fm57YW3sEjhNuZZ6nPEUdBvWfyUgih/JNa4DyyDKlKcNqlDzBNfSa6njuQJR0wIUm0bAnA8L4dq
 gpVXswgSfSG521sFbiQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=10
 lowpriorityscore=10 malwarescore=0 phishscore=0 bulkscore=10 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090067

With CONFIG_BUFFER_HEAD=n, block devices are written back through iomap,
but def_blk_aops uses filemap_dirty_folio, which only sets PG_dirty. It
does not set the per-block dirty bits in the folio's iomap_folio_state,
so iomap_writeback_folio() finds no dirty range, submits no I/O and
clears PG_dirty, resulting in data loss.

Other iomap users set .dirty_folio to iomap_dirty_folio, which marks the
folio's blocks dirty before calling filemap_dirty_folio().

This is only observable with block size < folio size. With a single
block there is no iomap_folio_state to get out of sync and
iomap_writeback_folio() marks the whole folio dirty itself. For a
page-aligned device, this may require using the BLKBSZSET ioctl to set
the block size, which requires CAP_SYS_ADMIN. A device whose size is not
page aligned already gets a sub-page block size from
set_init_blocksize(), so no ioctl and no privilege is needed.

To reproduce, on a device with a sub-page block size, write a known
pattern with O_DIRECT, mmap the same range, store to it, msync() and
fsync(), then read it back with O_DIRECT. A reproducer is available at
[1].

[1] https://gist.github.com/tzussman/18ab05cba4b3fdc79cce0a69d1fd05b4

Fixes: 925c86a19bac ("fs: add CONFIG_BUFFER_HEAD")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index b917bc0f6b44..5a559fcfadf9 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -575,7 +575,7 @@ static int blkdev_writepages(struct address_space *mapping,
 }
 
 const struct address_space_operations def_blk_aops = {
-	.dirty_folio	= filemap_dirty_folio,
+	.dirty_folio		= iomap_dirty_folio,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.read_folio		= blkdev_read_folio,

-- 
2.39.5

