Received: from out28-58.mail.aliyun.com (out28-58.mail.aliyun.com [115.124.28.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA462E36E2
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 00:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752713876; cv=none; b=ozHKalgEjFM8NlSgKlMI4bvox0acGGtd1tacNclH3iUs4BUn6PKzaApj1fbY9eRD1lw97pDmAwM+pCrmupz04ILANuOdjZAzznZ9EPGJ1Bit+L9vvyKMLLqdalKGlHa/tnP+DwjOkAM1NWSdkxUuMVwovm3DMo/IERxEyIAaJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752713876; c=relaxed/simple;
	bh=+1+YGUL639U2EwSLfJJWgt9BkbfChDTsyiIUO9pdNOs=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=n5GasKr9IbVNuObECUpbJWk/3JdEUjz1H+Umir458zgzDnO9miQphPbiiDUz5aRm1U2z7K58sEPuvDeRsOTXy54CrdYmiiRiStCPJ9uNx0wI4W3fBUzQ2RTnZOculS//tKZzbEQR8nPZXaMRGsjrrjFlqv5DFVyMeNRtsOdZPlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.dpJwCJt_1752713552 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 17 Jul 2025 08:52:33 +0800
Date: Thu, 17 Jul 2025 08:52:34 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-xfs@vger.kernel.org
Subject: Re: a deadloop(?) when mkfs.xfs -o rtdev
In-Reply-To: <20250717081332.E87F.409509F4@e16-tech.com>
References: <20250717081332.E87F.409509F4@e16-tech.com>
Message-Id: <20250717085233.47E2.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.08 [en]

Hi,

> There seems a deadloop(?) when mkfs.xfs -o rtdev.
> 
> # mkfs.xfs -r rtdev=/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 /dev/d
> isk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA -f
> meta-data=/dev/disk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA isize=512    agcount=20, agsize=1221072 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0
> data     =                       bsize=4096   blocks=24421440, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=41799, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 extsz=4096   blocks=390703446, rtextents=390703446
> Discarding blocks...Done.
> Discarding blocks...Done.
> 
> It did not fishish after 10 mins.
> 
> # pstack 5785
> #0  0x00007f8df5efc01a in pread64 () from /lib64/libc.so.6
> #1  0x0000557b7bbfe9c3 in __read_buf.constprop.0 ()
> #2  0x0000557b7bbc3030 in libxfs_buf_read_map ()
> #3  0x0000557b7bbfe1ae in libxfs_trans_read_buf_map.constprop ()
> #4  0x0000557b7bbee7ef in xfs_rtbuf_get ()
> #5  0x0000557b7bbf03d8 in libxfs_rtfree_extent ()
> #6  0x0000557b7bbbb322 in parseproto.lto_priv ()
> #7  0x0000557b7bbb7643 in main ()
> 
> And,
> 1) more chance happen when kernel 6.12.36, but yet not happen when kernel 6.6.93.
> 2) it happen on both xfsprogs-6.11.0 and xfsprogs-6.4.

it happen on xfsprogs-6.15.0 too.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2025/07/17

