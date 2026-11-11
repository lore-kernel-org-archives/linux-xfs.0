Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794359145;
	b=0OyS53FnvME6KtMxfi2l8dJvjatqj4hzxQTxWtCwtL0k+UejPp7FD8b3OaLwfbss1/IY
	 vnapoIuZEI+U78DgZA9U00PlAU0v0E4pYboH4lfzK0dEP/Nczy1IBTuEPdQ3dqDrTRgsB
	 Zu/3u66Mj5OwOPqXLlqW2XCab1qTZu1xfQ2Gf+f6u1MZe3knAi/2xNcNq+5vBMYUxdJy6
	 UklfLgyhqUvQZWTJflOJh7K/rQ5p2SBH+eF83s5hMyVAfMlngKX8GLIZVawBK73XAOqJ8
	 OgWkFKXshdYqMsy6BbPFz19MZkTvaZNbcxALG9S65yMKK8EKdbAZjY9twKBoxy9NUFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794359145;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=pkbznhaBkCFi1U32w1V8mYszmNFl3w7n8yFnD+biYIw=;
	b=tE6ACnE51SIWvUKD+dWluo0EdE76ekphv+VamcjB8BVgIOMGu7EfoZq1eIqbpn2zox6M
	 tXGMjCAgD5s2Fh3m6RfGKdext+mroYMbf6T4Ks9436+K5yXsvGwHwx7Q3JZMFEHDoSgv7
	 HQrdma2a452DWerGa0l0VpMFaG1HEbONLMV8zeJBYHAVKW5YtEFWCnV5LoYnWwXz08z/B
	 FKaft50FyzvMDep8n9f0GTAMjENOcVgh49GwAomXqQ3vUCCDVcYLPYNsoaQwPtxsBBgj4
	 cATdmjgjzokx76ixoHRaIl48SPeY8klQxcm5IbNDQxSmQ+Ic+6GIW97SYZWpiLQpXzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=roQgUXRE;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B900D606A320
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 01:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B900D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=roQgUXRE
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261111010542epoutp0126fddb5af88917482ddb82d62b3d82fb~m2CIet0jE1081110811epoutp01B
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 01:05:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261111010542epoutp0126fddb5af88917482ddb82d62b3d82fb~m2CIet0jE1081110811epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794359142;
	bh=pkbznhaBkCFi1U32w1V8mYszmNFl3w7n8yFnD+biYIw=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=roQgUXREzBn4PfbSNNPJFipYYxMKmlJNlUFuGkW9D9DrheXqA54S5ACaUV9czG+Qa
	 VmHowaBd2VR8xflhxYJImrXBVePSubzCN2QUCj7fxh7lOOEXpNefErry18kT5Jw9DX
	 5D1Bo/hg7Nk1G0gDc/aPE/WuARmmw93wvW3XMEq8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261111010541epcas2p200b17ebabe51ea1b2f88afdadd42392f~m2CH3vTV00724607246epcas2p2W;
	Wed, 11 Nov 2026 01:05:41 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.200]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jPQLY44jsz6B9m9; Wed, 11 Nov
	2026 01:05:41 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH 2/2] xfs: skip the fsync flush when a later flush has
 completed
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Brian Foster <bfoster@redhat.com>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner
	<david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <avIGmcLZPKIDlf06@bfoster>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261111010540epcms2p1ac660f3ce4c6c2ed55836c8b1615a4d6@epcms2p1>
Date: Wed, 11 Nov 2026 10:05:40 +0900
X-CMS-MailID: 20261111010540epcms2p1ac660f3ce4c6c2ed55836c8b1615a4d6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261109174511epcas2p22eb1ad7fec0b96837feb110984f57fa7
References: <avIGmcLZPKIDlf06@bfoster>
	<20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
	<20261105-xfs-fsync-flush-seq-v1-2-299bdf5e28c3@samsung.com>
	<CGME20261109174511epcas2p22eb1ad7fec0b96837feb110984f57fa7@epcms2p1>

On Mon, Nov 09, 2026 at 12:44:57PM -0500, Brian Foster wrote:
> > 16 fio jobs of 4k append + fsync, QEMU guest on a 990 PRO without
> > power loss protection (virtio-blk, cache=none): 809 -> 4185 fsyncs/s,
> > mean fsync latency 19.8 -> 3.8 ms.
>
> Can you include this in the commit log so we have a record of the perf
> impact?

Thanks, will do in v2. I measured both kernels again on the current
for-next, so the numbers differ from the ones above, and added a single
job line.

[...]
> I think it would be helpful if the comment here and perhaps above
> xfs_buftarg_flush_seq() referred to the submit/completion ordering logic
> being applied. Maybe even rename seq -> submit_seq as well to make it
> more clear. For example, something like:
>
> "Return true if a flush has been submitted and completed since
> @submit_seq was sampled. If so, this guarantees writes completed before
> @submit_seq are flushed to disk."

Agreed. v2 will rename the argument of xfs_buftarg_flushed_since() to
submit_seq and reword its comment along those lines. The comment above
xfs_buftarg_flush_seq() will say that it samples the submit counter, and
that a flush numbered above the sample was submitted after the sample.

[...]
> Ok, so I think I follow the logic. We write the file, sample the submit
> sequence (after write completes), then can optimize away our own flush
> if we can confirm that a flush submitted after write completion has
> already completed. Right?

Yes, that is the logic.

> That kind of makes me wonder whether we could do something like "flush
> or wait on any flush submitted after this seq," but maybe that's
> something for another day. ;)

I'd like to leave waiting for an in-flight flush to a follow-up.

[...]
> > -	 * If the log force was a no-op, we may still need to flush the
> > -	 * file data target cache here. This can happen for fdatasync/O_DSYNC
> > -	 * when no metadata needed to be committed.
>
> Did we intend to remove the comment on why we flush in the first place?

No, that was not intended. Thanks for catching it. The paragraph was
deleted while I was cleaning up the comment changes. v2 keeps it and
adds the new condition after it.
