Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CD13D45DE
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 10:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174252; cv=none; b=Tqzlxxr+Z5q4eJCnjqWDaq9AdO80Z38xNKd3vGS8XJRDRAtUsvRmbsrKIRIMQ2gwB1sDbL1z+n2PurGwLdZzFX5qXYx58Ql3MXJ2TZRfY8u8Y8jPDduvvM8UCG12+ENcETBA5whfFyB21xA1HcNPoNozXPjzhdi+GAFuBYiHQHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174252; c=relaxed/simple;
	bh=EIJiXRClsqPs7P0cck/kwYeWAQHafYvtF693MQshReQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KAaqdl//jfewhxym7nQR2Q5B6Nmj4tVUDz6SfPHSstL6cFwyPPyKfpo0QrMMI0BSPeh8ggPrCklKCgxyrpU2d3yIuuoM8OAUmAHuIHM5oBXIiHPKvDVWLOOkN8EMsoPp38hTxu53KMak/+4tsOMjMnXhF/081n/5DXcYJGQxFyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 88238676658111f1aa26b74ffac11d73-20260611
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fb8404ef-6d1d-4521-aac4-a5a03daf26f0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:804df0f24aa191c5059190262b7b0b58,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|136|850|865|898,TC:nil,C
	ontent:0|15|50,EDM:-3,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 88238676658111f1aa26b74ffac11d73-20260611
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 465972522; Thu, 11 Jun 2026 18:37:23 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: hch@infradead.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	sangyao@kylinos.cn
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Date: Thu, 11 Jun 2026 18:37:12 +0800
Message-Id: <20260611103712.1999740-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aipNIhAyRkSWIlDF@infradead.org>
References: <aipNIhAyRkSWIlDF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 10:52:34PM -0700, Christoph Hellwig wrote:=0D
> Yao: can you explain what errors your are seeing?  I.e. full nvme=0D
> dmesg output that tells us the status code?  Or are you just doing=0D
> error injection for testing.=0D
> Either way we should probably document our error handling model and=0D
> back it up with tests injecting errors and verifying we conform to=0D
> this model.=0D
=0D
The original failure was not found by fault injection.=0D
=0D
I first hit it while investigating xfs/643 and xfs/646 on an external=0D
ZNS realtime device using an NVMe ZNS multipath namespace.  Tracing=0D
showed regular REQ_OP_WRITE I/O being submitted to sequential zones=0D
through the multipath head.=0D
=0D
That turned out to be caused by the NVMe multipath head missing the=0D
block layer per-zone state.  The head had zoned limits stacked from the=0D
path, but the head disk had not gone through blk_revalidate_disk_zones(),=0D
so bdev_zone_is_seq() could treat sequential zones as non-sequential.=0D
The NVMe-side fix is here:=0D
=0D
https://lore.kernel.org/all/20260610032846.54044-1-sangyao@kylinos.cn/=0D
=0D
With that bug present, the lower NVMe device reported:=0D
=0D
nvme0c0n1: I/O Cmd(0x7d) @ LBA 32768, 128 blocks, I/O Error (sct 0x1 / sc 0=
xb9) DNR=0D
=0D
After fixing the NVMe multipath bug, I used EIO injection to reproduce=0D
the same XFS-side failure mode in a controlled way.  So the injection was=0D
used to verify the behavior after a non-retryable lower-layer error had=0D
already reached XFS, not to discover the original problem.=0D
=0D
For the XFS side, ioend completion does not seem to have enough=0D
information to recover locally.  The in-core open-zone allocation state=0D
has already been advanced before I/O submission, but after the device=0D
rejects the write, XFS cannot know whether or how far the device write=0D
pointer advanced.  Therefore this patch shuts down the filesystem so the=0D
existing shutdown path wakes zoned allocation waiters and makes later=0D
waits return -EIO.=0D
=0D
I agree this should be treated as part of a broader zoned writeback error=0D
handling model, not just as a local ioend fix.  I would like to help work=0D
on that model, including the GC path, whether we need a more specific=0D
shutdown reason, and fault-injection coverage for the lower-layer EIO=0D
case.=0D
=0D
Thanks,=0D
Yao=0D
=0D
