Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB373A7D6E;
	Wed, 13 May 2026 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778651319; cv=none; b=CiaZZgYF4tn+L0SHkGA+3HWRIRJw2meON4Mz7bAT2aZWolbyqZq14/LFj8oICZQYZyUq1jODaPBpdPke0A920eZVYop+y3Tfv3Q2U3ekvTlc1MIJza/3PUB/7Mm0n4/NhE07XOTQVYJsHyFH6l4AtQPUDpkoVD6VTx6s9Dqz4xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778651319; c=relaxed/simple;
	bh=ZDFlD9nsHgd27geF+Rb2AtZvStqqSfbUC7zxO/vvEMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMFaYSOg1PUUNsf8TybRxWEmYgw3zr4HASsz6C8KG4Z53BlcYTz4Qd38s4w2vT3RY57EJIaNuqlndD/3lg+n0X3z2EKoMGIg5oztPBL/DqPI4IkasgmuOynmS82SNez+eClv+bJEHvUQ5VvGO++OnyQuWwHALZISyslVrHnVQSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mWHMG0UY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mWHMG0UY"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D3AaU43179891;
	Wed, 13 May 2026 05:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=y5nkvrhcTp0ZLxYE/7ciAVLdhgaAzJ
	xIEPhcn/2rpz0=; b=mWHMG0UYM8GorUZEQ6kw4Q3J4qBRCotpl6kstECvJD1rtb
	xCfXEkIxJ4fmJPIQ+RSJsF3Eg3coBVehAPUDFIE0TaIiUmjJfeZKgZp1C5ytMBUb
	JDsPtELRt0bCLSIMeCGsEW5fmY4TgC6nLP2CYbjctaNNzkVGbkt+a/uLHLIgJDv5
	4Sa1F+TYCRFwkDQ3c7MWZ6ScuVXuh+CsAGRgHr5FugQdX71mt18waHUfRCt0Nrtg
	GbhjGWRYzOKOZabLdeSvo6LU5LhrFCbkgxy6KgtCLVvaNsDE6Ri+3E4smeAY/Clh
	uuHTT9OX4+uCDz8UsjYx2WoR6TZJowDRGP4dli0A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv6nxxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 05:45:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64D5dOtk018879;
	Wed, 13 May 2026 05:45:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgxe3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 05:45:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64D5jSiI31130048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 05:45:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16D9C2004B;
	Wed, 13 May 2026 05:45:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7B7220043;
	Wed, 13 May 2026 05:45:18 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.65])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 13 May 2026 05:45:18 +0000 (GMT)
Date: Wed, 13 May 2026 11:14:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Us1T8ewB c=1 sm=1 tr=0 ts=6a040ffb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8
 a=lcIDxHtVAAAA:8 a=6-Iau3dbAAAA:20 a=e6PEXMpC0EWP8Up90DUA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=CjuIK1q_8ugA:10 a=SmPfr9tXhjlp3KZZvEYH:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-GUID: Y02irxQB16MSD0o1gbPDksguta2VQXTm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA1NCBTYWx0ZWRfX25Y19o3iK7En
 Szk95/27oHoKr0ldyYQl2XiVgKxouARyLOPuBzsiB8pV4pxQZ3pujNnmWnGnueHT9UoJ9H+y4/P
 6fxtxF4UwdvM2rayClHEDLdSIiqpIu5bFs5h1YnT9qejxm1KcAXSLozg93Qcts2uhgurM1inLGW
 3AETfqHMezU9dzoZ0mSaib7Sj3LJliaA4Ed7VDjZ1+iCYKLFMVwxcpGwhwLTythjtr4ZHuCea2J
 Tl4nt1AmBG0vV/g6D2RjMloZ0FLFoVfpoJHdG+85SdP8LYFmPStr5xP1z5si8N03UcWzRcV0uva
 PsrrqohchQwqay+/0W76l08NODI+CM0+c2Q2rvqR1xrm5JmodScB0UgxzVf5N7pXnTQpFMtXo0F
 FYyt/iGu8Bn2pEw5+OKzvAEG2RZoF2i5m49OFa6IktJ4MkS8ZBbfhdLT8osAN3lwTeejBhM6ZjE
 6lfKoiVACTgmP/6oduA==
X-Proofpoint-ORIG-GUID: w8tY36-yrZQPqJpaWnynhyVjgRf4QTu5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1011
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605130054

On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> > Hi all,
> > 
> > This is the v2 RFC to add buffered writethrough support to iomap and
> > xfs. The changes made are mostly to get the writethrough implementation
> > more inline with how dio handles writes. 
> > 
> > 
> 
> I gave these series a run with kdevops and fstests using the following
> profiles: xfs-crc-logdev, xfs-crc, xfs-reflink-logdev, xfs-reflink.
> 
> Note that I applied all patches on top of v7.1-rc1 and xfstest-dev
> patches from Ojaswin have been rebased on latest master [1].
> 
> Link:
> https://github.com/dagomez137/xfstests-dev/tree/iomap-buf-writethrough2 [1].
> 
> In general, some of the results here seem flaky. But let me know what
> you think. I'll try to confirm the possible regressions with another
> full run.
> 
> 
> Summary per profile:
> 
> * xfs-crc-logdev: no regressions or fixes found
> * xfs-crc:
>   * generic/753 fixed. This test failed on 7.1.0-rc1 run but succeeded
> on 7.1.0-rc1-00005-gc6a39600d3c3.
> * xfs-reflink-logdev:
>   * generic/415 failed on 7.1.0-rc1-00005-gc6a39600d3c3. I tried to
> replicate the issue by just running generic/415 (not the entire test
> suite), and I couldn't replicate it.
> * xfs-reflink:
>   * generic/457 failed on 7.1.0-rc1-00005-gc6a39600d3c3.
>   * generic/561 failed on 7.1.0-rc1 but not on
> 7.1.0-rc1-00005-gc6a39600d3c3.

Hey Daniel, 

thanks so much for testing the patches. I'm back this week
from travel so still catching up to my emails. I'll go trhough thi and
get back to you soon.

Regards,
Ojaswin

> 
> 
> Here the full report list for each A/B profile test run:
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc-logdev.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink-logdev.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink.html
> 
