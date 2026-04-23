Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E916637C0E2;
	Thu, 23 Apr 2026 23:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988486; cv=none; b=kjGPu0dhWSmhwSXBGAEWLGbcH1ABKdQ8D0aDgV+b7ROU3dn03qVqFc6GRVneYrY+L9C+eoXpo4KEN12eNPhpcpaNXHEzalP894kWhz8hjEa2+uSqT/6/POYH3e3PYDDujQbtNVbLek/tBS8BANMWoFBbYchOPzcVo94AKX9+fCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988486; c=relaxed/simple;
	bh=nagBPIpdRQa10G3bzPDgD2eBKZdrwZkzTPtDAzYbtOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBqj3RO70se2xDb7RCI18XcGNGA28XsiljIYjk3dLhTMgmpqdxqxQgl8ZkgwwESlX09lWA/EDqPwfIRHfnb1oOixo09wGiT9UQcYqFHpVBBLEskGRc3RvRPu+BxSr4RAmwoY7Ht/4otqveEvf2VTYK4NHO20iKyRyjXSPL44LNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BqBqBWtJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BqBqBWtJ"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63NILGAX3229030;
	Thu, 23 Apr 2026 23:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NyZUs9RcJWsPCXqiAFbbwt3NY3+KB5
	ydyk2N2aDclQU=; b=BqBqBWtJ51aKRs1v1ejXoCLyzZgFsyCqN2peRL7cjd/J0c
	rxnuxZgILW8vlzeRiigp1Y9kgbQhmcInD5fWdDx+43KAiXj1KIJzPE4OoEL6U3eO
	b7Qqj9pOacGXuouO/Wy2hrH6I7L0sYdmMPUwr8KXI8KSTAipYBorE0u0NQg4149W
	4x+HL7LGhnBybCjBt4UHM+Zd/cwG7INdnkjPHF9T90c4QzJn0YG/fpfEp5F8HceE
	XDpjly+wE4fqyG4UlPs502Ax72WLIgeVsMpJDaJcJZXQxhsov99lT3X3HmYJfHLp
	e8cMe7s2g1918VKiXuokZjo5G+gmF3EmGWivI/mQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu2b9cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 23:54:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NNoWoH006542;
	Thu, 23 Apr 2026 23:54:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyrpxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 23:54:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NNs54142533294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 23:54:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2F4120043;
	Thu, 23 Apr 2026 23:54:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0A0220040;
	Thu, 23 Apr 2026 23:53:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.219.54])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 23:53:59 +0000 (GMT)
Date: Fri, 24 Apr 2026 05:23:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -nl9_K83Kzn9u7skxJWMWCIcGNgHNF2y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDIzMiBTYWx0ZWRfX8PqZYRV+bedE
 hsO8a0m/D+pucfImoyw014nW7oP3jzKYYaf/TJtc3eSY/OQDD2dHyzcMinGRcTvyx4AI/HscdrA
 p6JdEScmepGWWYATYuSuYP5oAtI8JCrZljnfhdEr1SIR+24Ob+ukLdx467L3sCAU5A1avxqqahM
 CIQTvlp8CHdZQz2r+Mpf9151cRifjBS19KhBBZQ8y3kuQelXKdcjebdPlU6+wJrIUZ2b7nPZid3
 ykimUKZl+JP8dwj+rJhitIMXjgDWR9OChwNdNraC9nJn5ssDS463sEyEs9BlBGspEKmLLJdeXQ3
 nNPlZfjYoGhblrIEJozMXrBt11OOVreHNqOPudQkkODpYFeFNwhp2Pf1kDYtZZ9QHzErdUIP7Df
 1tlNGeRk8vpIBTQ7A5tIMmEviO3GjF/QASiwui4MiNMan2zREeDVQSFV8ZhxSXMzQwH5OaU3v37
 kV0SqKEpDdb/zb9x3mw==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69eab121 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=rsA8cc2tDGwubhWhQn0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: id_LFKqk8OLTXWmlKq-3TLgzfsarewvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230232

On Thu, Apr 23, 2026 at 02:25:43PM +0200, Pankaj Raghav (Samsung) wrote:
> > 
> > 
> > * Testing Notes (UPDATED) *
> > 
> > - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
> >   xfstests and these patches survive fsx with integrity verification as
> >   well as fsstress parallel stressing.
> > - -g quick with blocks size == page size and blocksize < pagesize shows
> >   no new regressions.
> 
> I am hitting a very strange error in generic/127. I deconstructed it in
> to two commands that can reproduce the issue:
> 
> ```
> $ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1
> 
> $ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
> mapped writes DISABLED
> Seed set to 191110531
> main: filesystem does not support exchange range, disabling!
> main: atomic writes need O_DIRECT (-Z), disabling!
> short read: 0x0 bytes instead of 0x6c7f
> LOG DUMP (1 total operations):
> 1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
> Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
> fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
> : Operation not supported
> Correct content saved for comparison
> (maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
> ```
> 
> This is on a bs == ps (4k block size) xfs filesystem.
> ```
> $ xfs_info /media/test/
> meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=8388608, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ```
> 
> The same test passes if I pass `-G` to fsx parameters(disabling writethrough).
> 
> The error is coming when we do a read operation which feels very
> strange. Could you run this in your setup and see if you can reproduce
> them? I still do not know where the issue is coming from or it is
> because of my test setup.

Hey Pankaj, I think the xfstests branch I shared might have been missing
one small fix that can cause this issue. I've update the branch with the
fix, can you give it a try:

https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2

Regards,
Ojaswin

> 
> --
> Pankaj
