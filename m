Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABA44D955C
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772551; cv=none; b=eVfOuhqz95yQRMAJm44WQ3SesO/hysA7qU3iiNJklODR7gduciEoPSiIYmzJh6DAQQuCCf6T8vMA6S8fKrCaFbQ5He8u3hZ4y93iBszJMksYhVPbTiFdvEkhuPKVCHmbP7t4PlOkJ7Lfew3WQ/DaI1KfN/bJpUt4MwHIaKMHicA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772551; c=relaxed/simple;
	bh=lotNoXinHPmCjECXmwk8u7ux+U6MBM6IzffV8MkwmjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VgCo+Ed+unHt6IcCZ4O8zVKhYTnb3F8cjGg1P0tE5aC+BSUaNhNMopb7Vcvjq1823H520ItNEHmzH92UUd3OPUbYp6hYrDXkSJB5LzVF+oWxdny9HwR+uCBp2DQwUElI2oq/G3Ygcjz1lwE8Y7NEXSat5WBH+BQEjY9XT8xvfRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nf6M1hIf; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nf6M1hIf"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lotNoXinHPmCjECXmwk8u7ux+U6MBM6IzffV8MkwmjA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790772536; v=1; x=1791377336;
 b=nf6M1hIfCxVtrwWyXdghNCZFaMcfuXO8G7SiRYWO/tvx4Mk7OPWo8eJ40ztJE/Ed8lmljjbA
 8otlpUeypfzFQFbxJQX8ZnJf5P49iypmPAxEtGh3AkHQQrQHFV2eUVJWqPhMdbAo0LDtVHnKuAV
 UsP/g9LhJfUiWlLd7iDukveY=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id cc040c7adac36214;
	Wed, 30 Sep 2026 12:48:55 +0000
X-Mizu-Trace-ID: cc040c7adac36214
X-Migadu-Flow: FLOW_OUT
Message-ID: <3e6c32cc-64cd-4460-a587-b3bc04d31d9f@linux.dev>
Date: Wed, 30 Sep 2026 13:48:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
 "Darrick J . Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 gost.dev@samsung.com
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>
 <jwtdhhbo7ukt5cynhdfrxu3xjwyk3wwg66uxhtnkokvabbokge@b6b4pk3yja24>
 <29380cd8-19f5-4ae7-bdb7-b7908decb474@linux.dev>
 <e96b6411-3392-480e-8cef-bdc94b8041e7@linux.dev>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <e96b6411-3392-480e-8cef-bdc94b8041e7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/26 13:27, Pankaj Raghav wrote:
>>
>> Maybe in this case we don't need to restrict CoW-based atomics to 1 
>> fsblock. But why care? I mean, you have HW support, which is so much 
>> better to use than CoW- based atomics, so better to config your FS to 
>> avail of them.
> 
> That is true but it is a bit strange we expose a smaller CoW based 
> atomics when we have HW based atomic support.
> 
> For me the main issue is this function:
> static xfs_extlen_t
> xfs_calc_group_awu_max(
>      struct xfs_mount    *mp,
>      enum xfs_group_type    type)
> {
>      struct xfs_groups    *g = &mp->m_groups[type];
>      struct xfs_buftarg    *btp = xfs_group_type_buftarg(mp, type);
> 
>      if (g->blocks == 0)
>          return 0;
>      if (btp && btp->bt_awu_min > 0)
>          return max_pow_of_two_factor(g->blocks);
>      return rounddown_pow_of_two(g->blocks);
> }


----->8-----

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -694,7 +694,7 @@ xfs_calc_group_awu_max(

         if (g->blocks == 0)
                 return 0;
-       if (btp && btp->bt_awu_min > 0)
+       if (btp && btp->bt_awu_max > mp->m_sb.sb_blocksize)
                 return max_pow_of_two_factor(g->blocks);
         return rounddown_pow_of_two(g->blocks);
}

-----8<-----


You are advocating something like this (to solve the issue below), right?

note: that we still need to ensure that bt_awu_min <= sb_blocksize to 
get HW atomics at all (so should keep a check for bt_awu_min in 
xfs_calc_group_awu_max() or similar)

> 
> Why do we take into account hardware limits when we calculate SW atomic 
> limits?
> 
> For more context:
> 
> In my drive, I am getting odd nr_blks agsize for the drive I have when I 
> format
> it with 16k block size. This is fine because block size is aligned
> with HW atomic write size. The issue comes in xfs_calc_group_awu_max where
> we do max_pow_of_two_factor on blocks if HW based atomics are enabled, 
> thereby,
> awu_max is reported as 1.
> 
> 
> So this results in the following
> 
> panky@blixen:~$ mkfs.xfs -V
> mkfs.xfs version 7.1.1
> 
> panky@blixen:~$ xfs_info /mnt/atomssd/
> meta-data=/dev/nvme1n1           isize=512    agcount=14, 
> agsize=67108863 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>           =                       reflink=1    bigtime=1 inobtcount=1 
> nrext64=1
>           =                       exchange=1   metadir=0
> data     =                       bsize=16384  blocks=937558016, imaxpct=5
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
> log      =internal log           bsize=16384  blocks=130432, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=16384  blocks=0, rtextents=0
>           =                       rgcount=0    rgsize=0 extents
>           =                       zoned=0      start=0 reserved=0
> 
> 
> root@blixen:~# trace-cmd report
> cpus=8
>             mount-4432  [005] ..... 24183.039820: 
> xfs_calc_atomic_write_unit_max: dev 259:2 ag max_write 131072 max_ioend 
> 4096 max_gsize 1 awu_max 1
>             mount-4432  [005] ..... 24183.039820: 
> xfs_calc_atomic_write_unit_max: dev 259:2 rtg max_write 131072 max_ioend 
> 4096 max_gsize 0 awu_max 0
> 
> panky@blixen:~/tools$ sudo ./statx /mnt/atomssd/hello.txt
> /mnt/atomssd/hello.txt:
>    stx_atomic_write_unit_min:            16384
>    stx_atomic_write_unit_max:            16384
>    stx_atomic_write_unit_max_opt:        0
>    stx_atomic_write_segments_max:        1
> 
> 
> I hope I have explained the issue clearly now.

