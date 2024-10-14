Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581721586DB;
	Mon, 14 Oct 2024 09:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728897064; cv=none; b=VecljIkqK+94XRUL+2WMLLMiCr1fgjHL2HmkwnThDVrVQx/qblRbW+vK+ptkTE0EL2qLLJ2s9aXG8ahsOqOxspkY8o3gdqns9JAD8kN5hhLZI0+kpDhhZFMRJl/eUXNiTSN6joKtEgeP96mA3PDlzYJtLTb9FLh2v81IIopnCLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728897064; c=relaxed/simple;
	bh=IWMFo0CUkbGGCkiXoO60kGmPwwahy1ZsLnaAq0JE7mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRVJ/mCyst1X1kdCuRqnAGYQaukigM4Deu5KlQZWzKiXEFJCy6Ma6yr2QtsnR/AKOXDoBwfnVBPFZ6iTXV7iRbSu2ClvGa5FfMAJEC5u3yrqZXhvVEc8S4MiYtBN8GZW5eMU2hd0C0B6mjWw4sWG4nD1d2OgT1Iwf+DlnzhSLJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dRq9dTB+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dRq9dTB+"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49E7pSBB000965;
	Mon, 14 Oct 2024 09:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=abMqXhXzs5egyLkdSjXUaqJTQsj
	P1mdRKGJi5z9WjHE=; b=dRq9dTB+NXYi4F+AyOByzeA6K2jMLlpzNboaWRY5KEr
	R2MKm43/WdDhqs85o59B7rCt8A+vnhSdvmugUEkt4qKFoCAu8qoEnu5C9YFeq4aj
	PluECwDMEqYR3HlyfDOQ5xBY3eL56si1GyN9fj/olVCqvCaTLBeagJ5HNkbn2Ml1
	JTjtmG7M5tfi5PGCrywu6dvDkmhOmLC5XsPpmB7uzVr0/DJmktGWXhkCqgA+w7wm
	CIjCncnYM3N4CAEGgHpEYl6w2PSm45y7yg52SX/4yda+TDxjn0zIPsXUXgDKQpzf
	qaZPznJK3Wg6lWLYwFSZ0pHh8hTbvNXOmCJ9LZidnvw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 428y8urbwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:10:54 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49E9ArDs026745;
	Mon, 14 Oct 2024 09:10:53 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 428y8urbwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:10:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49E7nngE001940;
	Mon, 14 Oct 2024 09:10:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emdkq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:10:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49E9AoBm20578790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 09:10:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29C4220040;
	Mon, 14 Oct 2024 09:10:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA11320043;
	Mon, 14 Oct 2024 09:10:48 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 09:10:48 +0000 (GMT)
Date: Mon, 14 Oct 2024 14:40:45 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <ZwzgFTX7H35+6S9U@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
 <20241011164057.GY21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011164057.GY21853@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EmYe1RyLYM-D4SUWCeCAZxXOGPiTym5b
X-Proofpoint-ORIG-GUID: 5V3K5SOs2D1rE9yxXk_rTSVQuUr8NpAC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_08,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=487
 lowpriorityscore=0 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140066

On Fri, Oct 11, 2024 at 09:40:57AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
> > > Extsize is allowed to be set on files with no data in it. For this,
> > > we were checking if the files have extents but missed to check if
> > > delayed extents were present. This patch adds that check.
> > > 
> > > While we are at it, also refactor this check into a helper since
> > > its used in some other places as well like xfs_inactive() or
> > > xfs_ioctl_setattr_xflags()
> > > 
> > > **Without the patch (SUCCEEDS)**
> > > 
> > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > 
> > > wrote 1024/1024 bytes at offset 0
> > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > 
> > > **With the patch (FAILS as expected)**
> > > 
> > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > 
> > > wrote 1024/1024 bytes at offset 0
> > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > 
> > Looks good now,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> That said, could you add a fixes tag for the xfs_ioctl_setattr_*
> changes, please?

Hi Darrick,

Sure I'll send a new version. Thanks for the review!

Regards,
ojaswin
