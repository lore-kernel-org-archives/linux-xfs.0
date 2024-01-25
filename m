Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773347318D
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706198803; cv=none; b=Mun1XH6M9c5D2w7Ge/Sxzm7Prm+/zfxfjujgGEdB2jjSeoR04++i6jw83FWbJi3GR/bdyAjce4fVXjVfRMPlrbqT75QZ+8kP8NwZ7nbxioCQBWYUrEuZsXk2QhZz3zWlZNOs30cP0Se2LzAIQDJM92FGvcrLMxECcvJM+0eLJ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706198803; c=relaxed/simple;
	bh=tLVU0GFRX5nRYQ2d+NOAmS813kep0m928rKDEDBLIkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=YSLZnngHhBgYIIzgWmci7KetyHs3CuKevBoeCe3jYI0s/nafw/pcKGDHsvUjRy+O/pibaGbxY8NgzP0vdiIkDN/mH7oJWckB7vWXcE70JBfJ5q88t71oZHzq7TVq9yUzTlLO7llCdhMyTHeSjnF+Cnqd9XkOxqqdI3R877u6i1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Rnmc76hm; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rnmc76hm"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240125160632euoutp02ae44a7c2645a4caabd0c14411b67afde~tosMheX6A2826328263euoutp02I
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 16:06:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240125160632euoutp02ae44a7c2645a4caabd0c14411b67afde~tosMheX6A2826328263euoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706198792;
	bh=nvaF5g87ZOFbDsyOS9jYf1ISG0i3fk0OJopYLmyw1YI=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=Rnmc76hm5XTugkL0m58nvBHs468m8jM02g1MCUpZpaT7snpWv8MofU8QUJR/A0zVa
	 Zojryj+9KU6s3RXe3TVsOVLDTU5rmFWNjUl4rrsHN0nwhMpj54k21cWUevLxv9rxVp
	 JNb/eS0htN1Q8/bxaBfXXjAAIdLM2Z4Q+4x7wOLY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240125160632eucas1p29cbfe68126ec83a9e16a3ec2c4732620~tosMToEiI0480104801eucas1p2E;
	Thu, 25 Jan 2024 16:06:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id B4.D0.09552.80782B56; Thu, 25
	Jan 2024 16:06:32 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240125160632eucas1p21012a35cae905f9872982ae8323b3520~tosL7GSZq0481704817eucas1p2J;
	Thu, 25 Jan 2024 16:06:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125160632eusmtrp192e4bd8e5a2b60bd4bf962ca46c60ff0~tosL6Z8G-2468524685eusmtrp1b;
	Thu, 25 Jan 2024 16:06:32 +0000 (GMT)
X-AuditID: cbfec7f5-83dff70000002550-d3-65b287083ad0
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 25.D4.10702.70782B56; Thu, 25
	Jan 2024 16:06:32 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125160631eusmtip1d31cca102220371434b2b14b30b3cb63~tosLtpZwQ2325823258eusmtip1F;
	Thu, 25 Jan 2024 16:06:31 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.241) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 25 Jan 2024 16:06:30 +0000
Message-ID: <a05f3bfa-ee30-4309-b1e4-89f2cfb43510@samsung.com>
Date: Thu, 25 Jan 2024 17:06:30 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
To: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner
	<david@fromorbit.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <mcgrof@kernel.org>,
	<gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>, "Pankaj Raghav
 (Samsung)" <kernel@pankajraghav.com>, <chandan.babu@oracle.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240122165756.GB6188@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsWy7djP87oc7ZtSDa6skbW4dFTOYsuxe4wW
	l5/wWZxu2ctuceblZxaLXX92sFvcmPCU0WLvyZ2sDhwepxZJeGxa1cnm8fHpLRaPsysdPd7v
	u8rm8XmTXABbFJdNSmpOZllqkb5dAldG14c5jAWXZSsaHq9kbWC8L97FyMEhIWAi8fu0Txcj
	F4eQwApGiRPrNzN1MXICOV8YJaYvToBIfGaU+PH5ITtIAqThxppTTBCJ5YwSK5dcY4Or+jXx
	MDuEs5tRYtukT6wgLbwCdhJL9x8Dm8sioCpxbOpjdoi4oMTJmU9YQGxRAXmJ+7dmgMWFBTwk
	pm2ZwgZiiwj4S2y70ge2jlngPKPE2fVPwQYxC4hL3HoynwnkCTYBLYnGTrBeTqDzWncugirR
	lGjd/psdwpaX2P52DjPEC8oSiy9cY4SwayVObbkFNl9CoJ9TomHXVBaIhIvEv65tTBC2sMSr
	41ug/peROD25B6qmWuLpjd/MEM0tjBL9O9ezQULVWqLvTA6E6SjRuToMwuSTuPFWEOIcPolJ
	26YzT2BUnYUUErOQPDYLyQezkHywgJFlFaN4amlxbnpqsXFearlecWJucWleul5yfu4mRmBC
	Ov3v+NcdjCtefdQ7xMjEwXiIUYKDWUmE18R0Y6oQb0piZVVqUX58UWlOavEhRmkOFiVxXtUU
	+VQhgfTEktTs1NSC1CKYLBMHp1QDk1yV1gF9BZ3na3MlHC73CEq1nqn+6s21oFn3paGqSc+8
	bgmVEzNP+W3yWp2wf/et/Tfe9bfdPTjHyGJSA1uZ0dEXF3Pe8Qd41kzRl03Xil/bcWDv879M
	LN9elVSzLAzZ6JtV/2lSucypcK+rCZOv/vM2XuTAVaGgZRTT963Ai2evVXrj7u2XXn+dxh0/
	d1tbnM+JDKsin6g/zhnG9Q52ugd2HOo6ePTKoe8/xC7oyV000u6fvtvaz/Doys0+OSvYujdM
	lnzr+mwfG4en7AfZJRH1+7izcpa0P3/CZjLHpO/o2cJdjKy9h+8VG7xr+rDuhVLJ0QV/9jzK
	XfG5bOra8Ffcx2/03c9J3ld+VUSLTYmlOCPRUIu5qDgRAGdG2T+3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xu7oc7ZtSDU7fZLK4dFTOYsuxe4wW
	l5/wWZxu2ctuceblZxaLXX92sFvcmPCU0WLvyZ2sDhwepxZJeGxa1cnm8fHpLRaPsysdPd7v
	u8rm8XmTXABblJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllq
	kb5dgl5G14c5jAWXZSsaHq9kbWC8L97FyMkhIWAicWPNKaYuRi4OIYGljBLXHxxngkjISGz8
	cpUVwhaW+HOtiw2i6COjRM/cDnYIZzejxNe3c1hAqngF7CSW7j8G1s0ioCpxbOpjdoi4oMTJ
	mU/AakQF5CXu35oBFhcW8JCYtmUKG4gtIuAr8eTcOVaQocwC5xklzq5/CnXTe0aJaw8mM4NU
	MQuIS9x6Mh8owcHBJqAl0dgJNogT6IfWnYuYIEo0JVq3/2aHsOUltr+dwwzxgrLE4gvXGCHs
	WonPf58xTmAUnYXkvllINsxCMmoWklELGFlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBEbz
	tmM/t+xgXPnqo94hRiYOxkOMEhzMSiK8JqYbU4V4UxIrq1KL8uOLSnNSiw8xmgIDaSKzlGhy
	PjCd5JXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MC0Ivv/yb4+s
	w2X3CxJKGcH8PpMM+F/Emp01UDP3/ab9gePmXZEbX4VqPc4X1JaGz5x9Ye3Z74IJc6fqTJi4
	6LB8YNotxSeiIUnaP9b9d4/+c+bXvUR/rYn1umoVtxTyT1wuKrFN+Gnr8djL+spO6dC/9jcc
	Lk3Qm7B1nSZbk+YNkYZziUEC25coX1aYMXVpT4vrd1s5ow+vV+16Vfp+7pcJYX+WNBQu+Pih
	oKe7Ub3tiijD7Nqa4xtPLlb1enFKZebEQw3+OlOeT1lg1zTz1spl0w79q7f3uL9aqvPey4Rf
	Lc8U/D6LzE8JvMSYwmX6P/Op1jZn5kkzm93fH1c/IFla/rWmZ2fQwQ/XL3xrbmpQYinOSDTU
	Yi4qTgQAD71W1m8DAAA=
X-CMS-MailID: 20240125160632eucas1p21012a35cae905f9872982ae8323b3520
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
> 
> How does this fail, specifically?  And, uh, what block sizes > 64k were
> tested?
> 
> --D
> 
>> Cap the blksz to be at least 64k to retain the same behaviour as before
>> for smaller filesystem blocksizes.
>>
>> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>>

I tried the same test on a machine with 64k page size and block size, and I get the same error
and this patch fixes it!

Kernel version: 6.7.1
xfstest version: for-next
PAGE_SIZE: 64k

# Without this patch

ubuntu@xfstest:/mnt/linux/xfstests$ getconf PAGE_SIZE
65536

ubuntu@xfstest:/mnt/linux/xfstests$ sudo ./check -s 64k xfs/161
SECTION       -- 64k
RECREATING    -- xfs on /dev/sdb2
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64 xfstest 6.7.1-64k #8 SMP Thu Jan 25 13:38:41 UTC 2024
MKFS_OPTIONS  -- -f -f -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k, /dev/sdb3
MOUNT_OPTIONS -- /dev/sdb3 /mnt/scratch

xfs/161 6s ... - output mismatch (see /mnt/linux/xfstests/results/xfstest/6.7.1-64k/64k/xfs/161.out.bad)
    --- tests/xfs/161.out	2024-01-25 15:36:48.869401419 +0000
    +++ /mnt/linux/xfstests/results/xfstest/6.7.1-64k/64k/xfs/161.out.bad	2024-01-25
15:59:47.702340351 +0000
    @@ -1,6 +1,15 @@
     QA output created by 161
    +Expected timer expiry (0) to be after now (1706198386).
     Running xfs_repair to upgrade filesystem.
     Adding large timestamp support to filesystem.
     FEATURES: BIGTIME:YES
    -grace2 expiry is in range
    -grace2 expiry after remount is in range
    ...
    (Run 'diff -u /mnt/linux/xfstests/tests/xfs/161.out
/mnt/linux/xfstests/results/xfstest/6.7.1-64k/64k/xfs/161.out.bad'  to see the entire diff)
Ran: xfs/161
Failures: xfs/161
Failed 1 of 1 tests

SECTION       -- 64k
=========================
Ran: xfs/161
Failures: xfs/161
Failed 1 of 1 tests


# With this patch:

ubuntu@xfstest:/mnt/linux/xfstests$ sudo ./check -s 64k xfs/161
SECTION       -- 64k
RECREATING    -- xfs on /dev/sdb2
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64 xfstest 6.7.1-64k #8 SMP Thu Jan 25 13:38:41 UTC 2024
MKFS_OPTIONS  -- -f -f -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k, /dev/sdb3
MOUNT_OPTIONS -- /dev/sdb3 /mnt/scratch

xfs/161 6s ...  6s
Ran: xfs/161
Passed all 1 tests

SECTION       -- 64k
=========================
Ran: xfs/161
Passed all 1 tests

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
