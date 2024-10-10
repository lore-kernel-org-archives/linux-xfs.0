Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611351BBBC1;
	Thu, 10 Oct 2024 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550576; cv=none; b=VlrLECHBVGldokAG8jbWnq4wKmp3HBZYqT7NUHhr+/7do8yAcZ1lIXXKJHNeXU519PMAloHdbJ72O1J2Ck6gVWxCahThiI0bg53ku4vWVl9uLp2H27Ryyf/q6eDbuLq92ouWm5Y2aXiUXbKuhoSWxJB+PfAdfoYMhnSJxgnwXzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550576; c=relaxed/simple;
	bh=zC9p66fE7VMCFNoontq1h7Rr2Vasynv+ZTzxgtVQxiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEXEJWsq95y6md5e9Fl6u556gNnuA3gLS3uHnsxVw/M8B7P/jhEjChz5r09XBm0KKqXs0BBysGiLRGjK06BeomS6NZR9EnLxzzg9sLw53TdvYcFz/R1FF/2Yc5nge7L8Rl+Q5Nz7GnaD87ebB3nnzJl5iFM4+vhhNETB9fvjpaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fftw3fjA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fftw3fjA"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A733ew015364;
	Thu, 10 Oct 2024 08:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=LT6OpCAjFdPGcnZd9zmNLgVTeN6
	FJCyMAB7EAQjVRnA=; b=Fftw3fjAAxljDpDVzrcNDMR1MqaK2fOjEJgLvburyaY
	EmkxMJ6wyORxdpAHfiIGSHRqUqjFX88QP89hTOVazriNqcUAUXFzibdzKVOxsHSF
	HsFppXSNZM+a461y/aGsVAtqCCb9ZjJ+Co23atbKDRwyZcFB1YhbFSIjTRWueoOi
	WZeIdSbamuMNS0V0NPltUsjL5HorE7+hkSIHwn/THMApOxyVXsyLd1mybvUl5/cR
	UYgYFnGW4LbZZWcJvmtza7PlD72jGOUuH7t1Lrx9pOn0vQjOl46U2Xegqr7b7gtG
	6E39BDjhVKd195VRxv6BInGZBoij4cMwQ5l/A8Gr0tw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mgjq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:56:07 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A8pJTM009118;
	Thu, 10 Oct 2024 08:56:07 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mgjq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:56:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A8tGkr013833;
	Thu, 10 Oct 2024 08:56:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 423fsseygj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:56:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A8u4He51577226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 08:56:04 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 684052004B;
	Thu, 10 Oct 2024 08:56:04 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1417E20043;
	Thu, 10 Oct 2024 08:56:03 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.124.218.86])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 10 Oct 2024 08:56:02 +0000 (GMT)
Date: Thu, 10 Oct 2024 14:26:00 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        dchinner@redhat.com, Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH v2] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <ZweWoArbBSDRNDbJ@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241010063617.563365-1-ojaswin@linux.ibm.com>
 <20241010065021.GA6611@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010065021.GA6611@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kbbXE1BCWgDbNUQnk1N0K8VomxAo0rFe
X-Proofpoint-GUID: DmzNeESTfuHJaPC-eIy4c3TJgudHKsqN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_05,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxlogscore=455 clxscore=1011 lowpriorityscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410100056

On Thu, Oct 10, 2024 at 08:50:21AM +0200, Christoph Hellwig wrote:
> s/deallayed/delayed/

Hi Christoph, sorry I missed this, will fix it.
> 
> >  
> > +static inline bool xfs_inode_has_data(struct xfs_inode *ip)
> > +{
> > +	return (ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0);
> 
> Nit: no need for the braces.
> 
> > +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > +	    xfs_inode_has_data(ip) &&
> 
> This can now be condensed to:
> 
> 	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_data(ip) &&
> 
> Otherwise this still looks good to me.
> 

Got it, I'll make the changes and send v3 by end of day.

Regards,
ojaswin
