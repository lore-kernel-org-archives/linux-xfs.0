Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB0B28FA84;
	Wed, 18 Jun 2025 09:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238726; cv=none; b=ls2m2Gm9hFNN8gKwog22L/UKZ/cqR78hxa9726f48P0pAfRMWC0zXF3vlvzu1UuIVdpgAhBdx8Ojzye4BTZrjPPjYLlX8v/uq9HZ+t++d/RM3xSHWLdJ7vBOu6rQH2VPDqtNwvOlegRJPVkk6LddvhdbrNT7yCIU6z07VgmTaHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238726; c=relaxed/simple;
	bh=a6Gvg5y8MpL5OOxAbzgLKu4qg+AYFxeldf4AvvLWsvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJq6ZnOX9Vg0VPRxKN7pYpq2GaN5v/zbVuuffjeOZoTspaVkrdUrB6WN1xHgvdM0Ps+5tCo/sxMz4Y0xNc6uYTbaYEUXi2kYoWhzjUkf0+yqiirNqFCZermMOKQ8g3RbwvvJrCGAcfokKZnJgIn8RXLQEN4dVnWIkPSmgAQVrmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r2kvgHBA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r2kvgHBA"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HMiQrA026479;
	Wed, 18 Jun 2025 09:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fkB0nitJZG3lDOymi7z9JQOx7cypOh
	HCNqtvl0Nmu1Y=; b=r2kvgHBAag+d+lu2I7NMcmDzCKZvKNTtaHaWtFoaXfy8pH
	VLaHM3jNRkuIdNXU7GJBYCgEDjGKcFeN7b3oYibbHoM12ESCpZYez//0IREo2QPI
	inuifWpxcvyJ6/q/CGKxV9yPzFLauyTDz8H8T3+KcX2YS2KOgW10EvgRbk6W8dS0
	iJRhLLRSSHuo+mrK20Gh6TG2a7rHvgVnUKX/dd/AlujtwLltWnDdmOyzsUof00kX
	1auWhI6JshM5HF+85oFrnuG5C2YmCCer0tU+DlteNdEIPMoo0GnvnY6s0oE+WSer
	mOP1TGQjnKHRlV78dIWGFuzslAfyC+2+sjWDuRWQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r25arg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:25:13 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55I9Jd0k003542;
	Wed, 18 Jun 2025 09:25:12 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r25arc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:25:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55I8IO7w025755;
	Wed, 18 Jun 2025 09:25:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 479xy5xar9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:25:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55I9PAUj32768424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 09:25:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BCBE2004B;
	Wed, 18 Jun 2025 09:25:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6451920040;
	Wed, 18 Jun 2025 09:25:08 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.234])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Jun 2025 09:25:08 +0000 (GMT)
Date: Wed, 18 Jun 2025 14:55:05 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v5 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <aFKF8YAuLPTHnBdD@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
 <20250616215213.36260-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616215213.36260-3-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dKjmKoXpAPE9CpxjAux_FyqB0bPnE5z-
X-Proofpoint-ORIG-GUID: 4IfGXqdcmweMZc80SolQ0IYszbINdLRa
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=685285f9 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=2nle5uG55BRm5s_oWRMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA4MCBTYWx0ZWRfX9jUve1oChUgT k51xNuMAf43aT2RHPEeUrcbhehmBJrhBXajOuCOLQR5oep8TwWo0eXVIQ8Y9EPuc9Sb7I5eXTiC +sQD9MnjiQw0dDIlAj5qe8ycdwu+jpmw8sJVz5lrHPdSxRKdnhjadiCoKoFDCEnMNn+ZSVkSE4z
 /YHEy9/J89YJeuA+8zTE1eBGT8h8du99e5mcVLs3ssiNkwzZw9xGOIjn3QDyCGgkWnPUXUItXUX ZpvR4nGyO90G2tPxfUVStVbnhwq3rQqXdynWNsCgxJzBaEcDGPimfxrx/LMVsFsb9YFwJ7koudv 7ajmZFLIcmH6lT6cCuQWe5w/UeVphCXUQ6YsDGhktz0TpJzwXCfRWXSuicZ/TlvjQVYBIT1oqAy
 oi2SqQvr/tRKZ6EQ09qL1C0bnj1BVR5rV1JCqBML0k/jdfzaqzx1z031qFNbr/42KGfrVIJx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=909 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506180080

On Mon, Jun 16, 2025 at 02:52:12PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
> 
> The first test performs basic multi-block atomic writes on a scsi_debug device
> with atomic writes enabled. We test all advertised sizes between the atomic
> write unit min and max. We also ensure that the write fails when expected, such
> as when attempting buffered io or unaligned directio.
> 
> The second test is similar to the one above, except that it verifies multi-block
> atomic writes on actual hardware instead of simulated hardware. The device used
> in this test is not required to support atomic writes.
> 
> The final two tests ensure multi-block atomic writes can be performed on various
> interweaved mappings, including written, mapped, hole, and unwritten. We also
> test large atomic writes on a heavily fragmented filesystem. These tests are
> separated into reflink (shared) and non-reflink tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good now, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

