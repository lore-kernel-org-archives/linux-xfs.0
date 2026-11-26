Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660299;
	b=Q+4F/3XlKzZggaXuy8dCTgRz61j4qs+JS48PynM920Ejg125I6q0Y4mJGsifsfsP+oqU
	 hn5Gt+U7dBTpweJVkhTevLHYP0lHxeXPMsjPjCXdPqOSqszzHfu1ipdrl+t5CKCGnNt6r
	 jBtmfgJdOS0Y53zih7kg3ADRluaIAZDggNKhUgm4BXv/1UwmgN9YdpnFhCbapgg2NOYZP
	 Zh4za21e8sj3mh/Tt1jXhB3u8trIjA6CPhp5kIhQOJyMX5y33hIokVv1XULq197GwBlti
	 GrgkmgRWd821IagQSs3DJbwy0NGrvg3dMT4EXsOl2+tOGcS0NJYki0DYuj79X2bfPlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660299;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=Dq6OBzQdHUbs/BzDJCNRfQdk6Xw3G/4Db/gI/OgFZSs=;
	b=x+exvP9aH/+pxsPlRT/P4GG2sC9bHTrmsjsla3djKRCFm73aSwTqN3KXNO5CzCEC9SZO
	 XkuKkyB7AP+LwFPnUDXBbxXJFnzHY6GLHpPVBaXLivyO2HJJ7OXU4Z3X4phoRZ7PvWSUx
	 Ky0sywKH9HOXFItWbgMZEtRoqawHGgiZ7/7fVuVcmrWNkslP6GqT8knonYECFgiek8Mxm
	 ZSpiIV3JRZrujnlfx0nTq8Ez2dRcuhHkwR3bS81ztQsvAidDRudHIoeuG2sgzc2SRMMbs
	 /PPvg8movKweT0JedIwWdjClF97FtnnIXx012FibTygcSTcND373RI/+H2ehD4D2urA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Ki00RmGm;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1B606A327
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 02:31:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCA1B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Ki00RmGm
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261126023130epoutp0421fdcdd4ae40c0701a470c9374f6b266~rd4UxmQwi0285402854epoutp04j
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 02:31:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261126023130epoutp0421fdcdd4ae40c0701a470c9374f6b266~rd4UxmQwi0285402854epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795660290;
	bh=Dq6OBzQdHUbs/BzDJCNRfQdk6Xw3G/4Db/gI/OgFZSs=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Ki00RmGmAUmAFRSQpvSl9fMNY1toHGO+OgfTpzgmTy9k+z0sjL9I9/URcjNeNxUQW
	 6zqdOBg5geJq3a3gR069TbbUfLlVqeOObCCtlUHZFj702hRNbKaiI+7iwUcYXezmkK
	 3QqZzf1Sf7LCLylutVbl8VNN9CBStMHwsnpAO7Vc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261126023129epcas2p419befa3754bc98095d9901f6835d3a5f~rd4UXsAxB0124701247epcas2p4z;
	Thu, 26 Nov 2026 02:31:29 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.202]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jZgXd5F2fz6B9mB; Thu, 26 Nov
	2026 02:31:29 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) (2) [PATCH v2 0/2] xfs: skip redundant fsync cache flushes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
CC: Dave Chinner <dgc@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig
	<hch@lst.de>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Brian Foster
	<bfoster@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <awWJ54ztH1pWu61B@quentin>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261126023129epcms2p114dbcd5fc1669a670ed09e71a24f44f2@epcms2p1>
Date: Thu, 26 Nov 2026 11:31:29 +0900
X-CMS-MailID: 20261126023129epcms2p114dbcd5fc1669a670ed09e71a24f44f2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261111064724epcas2p11498de70e50f2fbf4e21d5e7a723e01d
References: <awWJ54ztH1pWu61B@quentin> <avQPb5z4ExBOiEJq@dread>
	<20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
	<20261117023345epcms2p5117009330b6c600f68c598d5e08aef5e@epcms2p5>
	<CGME20261111064724epcas2p11498de70e50f2fbf4e21d5e7a723e01d@epcms2p1>

On Tue, Nov 24, 2026 at 02:08:23PM +0100, Pankaj Raghav (Samsung) wrote:
> It looks like the delay caused by flush acted as a group commit delay
> which allowed for more batching and optimization before the logs were
> written out?

At 128 clients, where neither kernel stalls in unlink(), v2 does 18%
more log writes per fsync (0.10 -> 0.12 in my table). The large
increase from 256 clients comes with the unlink() stalls.

[...]
> Could you detail your setup and how you measure log writes/fsync and the
> latency numbers?

Setup 1 is a QEMU guest with 8 vCPUs. Its disk is an 80 GiB partition
of a Samsung 990 PRO, attached as virtio-blk with cache=none. The
kernel is for-next 48326a2382d8 without XFS_DEBUG, KASAN or lockdep,
with and without v2. Each run does mkfs.xfs with defaults and then
"dbench -t 30 N" with the client.txt load file from dbench.

Log writes per fsync is the change in the first field of the "log"
line in /proc/fs/xfs/stat over the dbench execute phase, divided by
the xfs_file_fsync() calls that bpftrace counts over the same phase.

max_latency is the value dbench prints. The values over 1 s are
unlink() calls.

> I can also try to reproduce it locally.

Thanks, that would help.

Best regards,
Daejun
