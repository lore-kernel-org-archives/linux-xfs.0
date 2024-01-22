Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A565BCE
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944779; cv=none; b=Rb7Wz/+xkCFoaTA4JzS9L5HkzaVHBcpOnbtJVAFsG9/SlLDgIfdTdJXEqoFbMecyXtfkKXfGfbVET4SesLYC1LnDxperr0iZ4S5RlCYljra2VtN7vpRMng8MK16sS58OoqehIZO96H+G0McW27lvcY7Pn26WVua20anSus6Hr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944779; c=relaxed/simple;
	bh=4PpXZngj9nb7PoouNsMwtXA+Ql25JdJJN5me9aGVLy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=sGr7E6hqBJT37D+7mGnjEpJLBUrgZ9XjrVRZ39zgIQUPN/GBBBDey5WUnxd//OvCYG+9+YtKMNPpzd4WsLriEFXSqGMgH1VB4UesNv830zdt6DS/gVoVGPdjdCenpQQM0d+XC+LdA01NkEsVLLZOYW9ZWIL17bT/nDK2fb8sxB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nQ08Xnga; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nQ08Xnga"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240122173255euoutp02d453d47ac2c5774f1054b2421cf3ba6f~su7wR61xe1011810118euoutp02h
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 17:32:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240122173255euoutp02d453d47ac2c5774f1054b2421cf3ba6f~su7wR61xe1011810118euoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705944775;
	bh=vrGu+T6Mb9CSHXTFUM617Z6hz9ceYTatRALbdHDqqHY=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=nQ08Xnga6n9pOzKexbOqY3g/qG7ThgcDuLygqL8ry3iMqGQV2uOE1W8CAxfmsUcZF
	 TVkUEmh+oqhFXBs7bHkJME2tTfoVeDl/1tmpp6oWDQVBVPlriBRRkkJdyCFiTYqTAk
	 cLi1PZTyN6gqNnO72Rsg9NLEO8Xln1p+W5ARzIV0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240122173254eucas1p29d86d785b3808cabb342953eed6ae7bc~su7vlX_pD1208812088eucas1p2Y;
	Mon, 22 Jan 2024 17:32:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 36.0B.09552.6C6AEA56; Mon, 22
	Jan 2024 17:32:54 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240122173253eucas1p17bcd38f21ef8479da6b75716e1b9fdbb~su7uvccJy2976929769eucas1p1Z;
	Mon, 22 Jan 2024 17:32:53 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240122173253eusmtrp1987688d487edf2f69fc75bb22cbba3d6~su7uu6Ula0421104211eusmtrp1N;
	Mon, 22 Jan 2024 17:32:53 +0000 (GMT)
X-AuditID: cbfec7f5-853ff70000002550-32-65aea6c6dca9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 20.E2.10702.5C6AEA56; Mon, 22
	Jan 2024 17:32:53 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240122173253eusmtip1d706c6453727bb6a53a9335687f863d8~su7ukSTGN1337113371eusmtip1j;
	Mon, 22 Jan 2024 17:32:53 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 22 Jan 2024 17:32:52 +0000
Message-ID: <9c9bf45f-aef5-48a1-8d76-580198ebb988@samsung.com>
Date: Mon, 22 Jan 2024 18:32:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <mcgrof@kernel.org>,
	<gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240122165756.GB6188@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42LZduznOd1jy9alGqz/Im1x+QmfxemWvewW
	Z15+ZrHY9WcHu8WNCU8ZLfae3MnqwOaxaVUnm8fZlY4e7/ddZfP4vEkugCWKyyYlNSezLLVI
	3y6BK2PfO92CN6IV0/6bNjCeF+xi5OSQEDCRWLOjmQnEFhJYwSjxe610FyMXkP2FUeLazrss
	EM5noMTPLYxdjBxgHX+fhkDElzNKTHndwwpX9LO7kRnC2c0oMensUmaQubwCdhL790wE28Ei
	oCqxZNcXFoi4oMTJmU/AbFEBeYn7t2awg9jCAh4S07ZMYQOxmQXEJW49mQ/WKyKQIHHp2mRW
	iHitxK+nG5hBLmIT0JJo7ARr5QQ6rnXnIiaIEk2J1u2/2SFseYntb+cwQzygLDF1qRfE97US
	p7bcYgI5WULgDYfEzQMX2SASLhInehczQ9jCEq+Ob2GHsGUkTk/uYYGwqyWe3vjNDNHcwijR
	v3M9G8QCa4m+MzkQpqNE5+owCJNP4sZbQYhr+CQmbZvOPIFRdRZSOMxC8u8sJA/MQvLAAkaW
	VYziqaXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIFJ5vS/4193MK549VHvECMTB+MhRgkOZiUR
	3huS61KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ86qmyKcKCaQnlqRmp6YWpBbBZJk4OKUamAw4
	mSbMZw/wjL2o9m735RmzxMSklT1yJ3xsMd1eI6U0VffHwvcspkYz2EtOBB5UUdCQ+nbjyyqW
	sFlN1t8PaS4Jqks9NNF19u6wvll6HQzq4t8EZd9+Xpm75fqMR5/6mR4/fOHMza92WIdZffKt
	RKN63h+zG7MiDL+yHUxg2lEZ8Sdea7Wn+iPha29PHWFfNVNzT5noVv2KA6v7Suf9yfv7KXPx
	zfp3OnrHubtVb0x6ZDs307Rg/u8zC022xc5v25tQuC+E4+eVjb03uwOE/Z25T31uN/1yKCWh
	4LvilOh59pHfPr+Um8tvaFvoyDBzquPc8LQTbjd9qi2uFfPemxnCu4uFUW8F453P796wblNi
	Kc5INNRiLipOBAA7D9qLoQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t/xu7pHl61LNZj1WdHi8hM+i9Mte9kt
	zrz8zGKx688OdosbE54yWuw9uZPVgc1j06pONo+zKx093u+7yubxeZNcAEuUnk1RfmlJqkJG
	fnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsa+d7oFb0Qrpv03bWA8
	L9jFyMEhIWAi8fdpSBcjF4eQwFJGiZ3/PjF3MXICxWUkNn65ygphC0v8udbFBlH0kVHi2oHF
	TBDObkaJq4+fsYFU8QrYSezfM5EJxGYRUJVYsusLC0RcUOLkzCdgtqiAvMT9WzPYQWxhAQ+J
	aVumgPUyC4hL3HoyH6xXRCBB4tK1yawQ8VqJX083MEMsew+0+cFkZpCz2QS0JBo7weZwAn3Q
	unMRE0S9pkTr9t/sELa8xPa3c5ghvlSWmLrUC+KZWonPf58xTmAUnYXkullIrpiFZNIsJJMW
	MLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzPbcd+btnBuPLVR71DjEwcjIcYJTiYlUR4
	b0iuSxXiTUmsrEotyo8vKs1JLT7EaAoMoonMUqLJ+cAEkVcSb2hmYGpoYmZpYGppZqwkzutZ
	0JEoJJCeWJKanZpakFoE08fEwSnVwJR9OuaCtorX0aJyh5jfEpx1wq+nbnXMsuRfdG/6m1ch
	JSfz9UOOll1cNS3LK+DlGjX7Q6evKmzZfvix7PUo29YFC7r+LNronmsV9Ksw8MrkjZf377q0
	Ra9U8/rHvbtnzBM9nrJ5slsWvw7H3d/yfhbOImFWIglSW6KUzgtNkrep27mkbsEj/5/2FT7u
	flYqO475RXFxfDeZcUdy0R3LSSt3z7SIDbY6vd2MUd/Lb3JH0kcNm0aew1trQ9brzekv263W
	9k3b/+gxy2vSn+9dTPlz7JT4jsm/Zt3bL7hHK946c/a7G/O+nNXv+DrTgfVZ3Ol3XObLGPo4
	PwgWFvLa7mWtvHvZMEbO2N14Ba+I4i0lluKMREMt5qLiRAA0N38dWAMAAA==
X-CMS-MailID: 20240122173253eucas1p17bcd38f21ef8479da6b75716e1b9fdbb
X-Msg-Generator: CA
X-RootMTR: 20240122165801eucas1p10c90512236fe96befd4a8ad616bb868d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240122165801eucas1p10c90512236fe96befd4a8ad616bb868d
References: <20240122111751.449762-1-kernel@pankajraghav.com>
	<20240122111751.449762-3-kernel@pankajraghav.com>
	<CGME20240122165801eucas1p10c90512236fe96befd4a8ad616bb868d@eucas1p1.samsung.com>
	<20240122165756.GB6188@frogsfrogsfrogs>

On 22/01/2024 17:57, Darrick J. Wong wrote:
> On Mon, Jan 22, 2024 at 12:17:51PM +0100, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
>> system(see LBS efforts[1]). Adapt the blksz so that we create more than
>> one block for the testcase.
> And, uh, what block sizes > 64k were tested?

I thought I removed >= 64k and put just 64k before I sent the patches as we
don't allow FSB > 64k, for now. Hypothetically, due to the hardcoded 64k blksz, we might
face the same issue for > 64k FSB as well.
> How does this fail, specifically?

This is the output I get when I set the block size to be 64k:

QA output created by 161
Expected timer expiry (0) to be after now (1705944360).
Running xfs_repair to upgrade filesystem.
Adding large timestamp support to filesystem.
FEATURES: BIGTIME:YES
Expected uid 1 expiry (0) to be after now (1705944361).
Expected uid 2 expiry (0) to be after uid 1 (0).
Expected uid 2 expiry (0) to be after 2038.
Expected uid 1 expiry (0) to be after now (1705944361).
Expected uid 2 expiry (0) to be after uid 1 (0).
Expected uid 2 expiry (0) to be after 2038.
grace2 expiry has value of 0
grace2 expiry is NOT in range 7956915737 .. 7956915747
grace2 expiry after remount has value of 0
grace2 expiry after remount is NOT in range 7956915737 .. 7956915747

Seeing the comment: Force the block counters for uid 1 and 2 above zero,
I added the changes which fixed the issues for 64k FSB.

> --D
> 
>> Cap the blksz to be at least 64k to retain the same behaviour as before
>> for smaller filesystem blocksizes.
>>
>> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>>  tests/xfs/161 | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/xfs/161 b/tests/xfs/161
>> index 486fa6ca..f7b03f0e 100755
>> --- a/tests/xfs/161
>> +++ b/tests/xfs/161
>> @@ -38,9 +38,14 @@ _qmount_option "usrquota"
>>  _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
>>  _scratch_mount >> $seqres.full
>>  
>> +min_blksz=65536
>> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
>> +blksz=$(( 2 * $file_blksz))
>> +
>> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
>>  # Force the block counters for uid 1 and 2 above zero
>> -_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
>> -_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
>> +_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/a >> $seqres.full
>> +_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/b >> $seqres.full
>>  sync
>>  chown 1 $SCRATCH_MNT/a
>>  chown 2 $SCRATCH_MNT/b
>> -- 
>> 2.43.0
>>
>>
