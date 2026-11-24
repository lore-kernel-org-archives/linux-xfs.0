Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509819;
	b=RtkvKrkE8tC4RUFprO20+stWtP969v1gB1vVqkOyrBfa8NSu5EGGmrQqqgYkhia6Qpwh
	 yhO2nTkuutmomb4XHAWH0vVFHm1d0JvN8gkRVeCT/vMzvsiivwiwyCYM7An0UgDRoygAP
	 Ndtjezc6StcQczbvR5WPET8V6lhNkfp+DyZ4707adQQstjLOIeqZz5DIqy+5WTOrp9hta
	 AxZ9M63ISQkI4fv/zOOu0Aae0kEUM1BZCGREv3w5HQF9rzRLYU/UVX4G4urFWvqreRcTk
	 a4RLvFTybje8gyQ1x5zwIlWowIZRmzYpVIWaxgk9kWUpSTTW6U5xxC7tiPNA2jJzZog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509819;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=bv+w4SPqJHgJSc/Ri/nAxGFknxpTeekag4KmQjPOdAY=;
	b=HuKmHZz1uCbvmAD1vUZuH/bYaFCFHRnaTGrXIQ14h0X1VW6TPygfWsrlSuqzoxn+fQrD
	 pz7gVA7RWCKPapvYslrIkwrul1mk6A8Je7gx7tSTtSsiV1hRSTK1EO/V+wro++YKeu/aD
	 9i05M7qxzjO4Lu1NsVXAP8jTC654rdLH1oRA3ZGa8bARZv2XlN4FnetVNIisOiC63iX4w
	 cDeuFN31qcU6HxOYjWoxwF4ekre0XKscbkzFbp5GNlg/rkt+Z27XU7/TRFJBOttvq01aw
	 ANpjDUznqpkvxKBIMpPfjbndQbexyTY/9rOeD2bq6vZqOoqRZCKhADQtGd/sOSybNIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=FmBAPLPP;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD86606A335;
	Tue, 24 Nov 2026 08:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CD86606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=FmBAPLPP
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261124084335epoutp0378f116da01da84f15e0af23bfa22fa36~q7qogInvm1692416924epoutp03d;
	Tue, 24 Nov 2026 08:43:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261124084335epoutp0378f116da01da84f15e0af23bfa22fa36~q7qogInvm1692416924epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795509815;
	bh=bv+w4SPqJHgJSc/Ri/nAxGFknxpTeekag4KmQjPOdAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmBAPLPP2mhGFVwNHvYu9RLbxnRYBoVw/8ymAq7p6DsxiuqRByG2O+15P/bQz45wH
	 ONOcDc3+s/GAA8aVXLubnSYuAWzZF6xY/sedOKG3cCL32MYutURDGQnzSa2eejzxiF
	 6GioVndOT2s5GhkSElScO45slA2g1jz2ijYeqjn0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261124084335epcas5p2c84e920886d69e131764edcb7537c200~q7qnxZ8BJ1183811838epcas5p2V;
	Tue, 24 Nov 2026 08:43:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jYbtt2JwWz6B9mC; Tue, 24 Nov
	2026 08:43:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d~q7o0df1RC0651506515epcas5p3W;
	Tue, 24 Nov 2026 08:41:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261124084126epsmtip20d1bb7fc51b7be9416c78f041855e347~q7owLbH482941029410epsmtip2v;
	Tue, 24 Nov 2026 08:41:26 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Anuj Gupta <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>, Anuj
	Gupta <anuj1072538@gmail.com>, Nitesh Shetty <nj.shetty@samsung.com>, Pavel
	Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, Sumit
	Semwal <sumit.semwal@linaro.org>, Christian Koenig
	<christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>, Dan
	Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Ojaswin
	Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang
	Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Li Wang
	<liwang@kylinos.cn>, Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
Date: Tue, 24 Nov 2026 14:10:25 +0530
Message-Id: <20261124084025.2101804-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
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
X-CMS-MailID: 20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
	<20261120154153.GC28611@lst.de>
	<361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
	<CGME20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d@epcas5p3.samsung.com>

On Mon, Nov 23, 2026 at 09:51:41AM +0800, Mengmeng Zhao wrote:
> Hi Anuj, I'd be happy to help pull our patches together into a single
> unified series and send it out for review, if you're okay with that—and
> would appreciate your review once it's posted as well. Please let me know how
> you'd like to coordinate, or if you have any updates in progress on your
> side before I put the series together.

Hi Mengmeng,

We already have updates in progress on the XFS side.

We will consolidate the combined series along with your ext4 work and
related patches, keeping your authorship.

One more thing that we are looking at combining is the ability to share
the registration across files. Pavel had mentioned this earlier in our
xfs series [1] and posted a series too [2] which needs some more work.

FWIW, we also had ext4 changes, but intentionally started with one
filesystem (XFS) so that the common interface could settle first.

[1] https://lore.kernel.org/linux-block/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
[2] https://lore.kernel.org/linux-block/cover.1793751001.git.asml.silence@gmail.com/
