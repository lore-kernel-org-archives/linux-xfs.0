Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B12F3C25;
	Fri, 31 Oct 2025 08:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761898118; cv=none; b=mX7PVPwAt7hbDuTHujGMBt8vRlJDrMCP2AoS/Hl3Zps6iQrwEFGZARjNAm/nk2n3riJJj3TZXIldMvrIbVe9bxaB0i3RysmBBEW4lLZpVg0Yg0LvniFVAFeXnCirDhzW4Bt8M2giBisPhY1+J8jMVYlCrffBTPVqoRj9hHrjtfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761898118; c=relaxed/simple;
	bh=Gzs8Zi8/kBlkeWh5K36JU3+5F87HuKCvEN/zPQixAk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZCu8CJajRGNzjdATRxm3WL2aTuQM8J5+8g1JDGSwa6H6MIdhZ58jwQtbl8za4336uDxPintUPgL/M7aJWeGbZeJ2GpwufoAn27sx+NlGThudC4qv1ThgcO1g3k4oXI/tzhXMaFvaUysM9E36qJXOJut/ft3ZGX1rMtETagv6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ie+Z8w15; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ie+Z8w15"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59ULIZuJ025849;
	Fri, 31 Oct 2025 08:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hfKwAs706cmhqnAx4QJ4L/ANWsK17N
	VxNqBgJK96p5g=; b=Ie+Z8w15WErsV0EsJBcy9l7gjaxfZfByAY7NuA/QXpUE72
	SBj5IPsyIL9ae5pT3QJ7CEzL+heBEGpsAxulaXZPIm71PcThfWdkWw/UyYqKQ4hl
	/JrQraty/q9L1HPmQvfNujjD+OJL868dUky4X5CmSMr5NRVgZQ5QjZNr/7mtc9cq
	eSyAr2Cgw1s4cVtIPh1uHbCBCEKD14iFa9a2qPlREEN7+0il3abWmh6EsCt8Dz/d
	UZZHGHjSg0sr/JuSlkR/cPEkBWuug7FbHh4qWKuQ0e6HOqYa6x9GoNeKJQM80jMb
	SQm/klmOPcxwTEONe5wF/PHiJ9XxpWL/yS8JbkbA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34acvtpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 08:08:30 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59V85Tv0009388;
	Fri, 31 Oct 2025 08:08:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34acvtp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 08:08:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59V3fuQF018751;
	Fri, 31 Oct 2025 08:08:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33xwn7ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 08:08:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59V88Rsn31850866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 08:08:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E9D120040;
	Fri, 31 Oct 2025 08:08:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68EDB2004B;
	Fri, 31 Oct 2025 08:08:25 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.245])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Oct 2025 08:08:25 +0000 (GMT)
Date: Fri, 31 Oct 2025 13:38:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <aQRuGS13PtCu4Cyd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbuEDY55 c=1 sm=1 tr=0 ts=69046e7e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u2sqHc5NxK-EW0QZsWgA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: A6dvdEiky42cFHcpl_EBNA6-iZmc2JVu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX3DTZkn3DKHa5
 vEcznoaMm2Z5g/aeaET7EtQ6tOuxFzcsOvfDU8wqtEvGrUR3IzAze2DWCsNojwr6Ud2ycfEf0aF
 ApcijdZP+Ldg8odNsrKw2a7zvrOIqiMYhlb9X2dXlQ5bXzJay1Zsj54ytukcxwxdMTpdSQ2CDuL
 +kUpP7Aypmow7qA7AqfZEi9MB2Dtkxj8IXCtmAMpXqMP3L1nm1WVXXY0lIDU0R/llk6rI1NxDqP
 L91hfk31ZOo7slHLsx+wp3nPGO0KXURJZQbggxIANyoQ/pX3e3ZqOikyAGyRZaVO+utJIk11/Fd
 z9X80NNwvbuJpUEVX0IgMC6zT+xjtCU/RHURJZbZxQ/EnLHS0tFntiScZdagajhywuClsaG6Omq
 dpmelcERkgobmp1GqAxy8zmQ9C9kkg==
X-Proofpoint-GUID: 03fpDtrKQsX9UPXBQPFDHZHKiejrxhgL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On Thu, Oct 30, 2025 at 07:38:43PM +0000, John Garry wrote:
> On 30/10/2025 16:35, John Garry wrote:
> > > > 
> > > That's a good breadcrumb for me to follow;
> > 
> > I hope that it is ...
> > 
> > > I will turn on the rmap
> > > tracepoints to see if they give me a better idea of what's going on.
> > > I mentioned earlier that I think the problem could be that iomap treats
> > > srcmap::type == IOMAP_HOLE as if the srcmap isn't there, and so it'll
> > > read from the cow fork blocks even though that's not right.
> > 
> > Something else I notice for my failing test is that we do the regular
> > write, it ends in a sub-fs block write on a hole. But that fs block
> > (which was part of a hole) ends up being filled with all the same data
> > pattern (when I would expect the unwritten region to be 0s when read
> > back) - and this is what the compare fails on.
> 
> This makes the problem go away for me:
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e1da06b157cf..e04af830d196 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1113,6 +1113,7 @@ xfs_atomic_write_cow_iomap_begin(
>  	unsigned int		dblocks = 0, rblocks = 0;
>  	int			error;
>  	u64			seq;
> +	xfs_filblks_t		count_fsb_orig = count_fsb;
> 
>  	ASSERT(flags & IOMAP_WRITE);
>  	ASSERT(flags & IOMAP_DIRECT);
> @@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
>  found:
>  	if (cmap.br_state != XFS_EXT_NORM) {
>  		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
> -				count_fsb);
> +				count_fsb_orig);
>  		if (error)
>  			goto out_unlock;
>  		cmap.br_state = XFS_EXT_NORM;
> @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
>  	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> 
> I think that the problem may be that we were converting an inappropriate
> number of blocks from unwritten to real allocations (but never writing to
> the excess blocks). Does it look ok?

Hi John, this seems to be fixing the issue for me.

Thanks,
Ojaswin

> 
> thanks
