Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765F333C5;
	Mon, 14 Oct 2024 11:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905078; cv=none; b=DRXAUUCuGWX2z6m6D5Yq55DGf+I07QUkRPRt1dA7BJtrLkgiWP39V+mbXFBRrS1ok9/Bvf10FVsNOkRxiDBnKD0R5z0PHQSn5fnPdg4CIJqKjS9sM4SdqcJp6znDm1ti5PMtSJNsyw3mgV/7OKCR1EToZW1yt19uHBMvFk/xvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905078; c=relaxed/simple;
	bh=bzgJLoHJNIFDjxLUz4r8x6yxP7VLh/FeHmsesfMOCxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTm7Sypc/QXmM6ajMtUdr1+wDrPgLBQtbbY65XQYC+KBgFDrlpE7t95ob3518abHvlFdq76siwngGTW6rld4jVLYO6PL4otG0ckLxN4W6GRUNDmPG5tLbF1aSCbEuRwozj/fSldOqLh/oc/3ubM9KUQch9252QARDD/3tWIBZS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fMHpMYrj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fMHpMYrj"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EBJSbg005273;
	Mon, 14 Oct 2024 11:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=u0BQtRuHL+zfMcIRkrmTGSZb0xc
	viN2f3uOCWalGQDI=; b=fMHpMYrjbgtrKtEKRikcuHTvkNAUkcgqzfay9ZZt2r5
	nNppWMw5ohyF+1Kl0pZtMHcjaFdvb2p74tVvwwI7zULR4++V3pSMomH0qqKAjsIJ
	6EH41BCPXMQoAHO+CXG2wDpM+uMqlHbhH+IDq7SzOp0Me/b6WyYvucSuqOo5nhaY
	9lUfDF03IHHd1w/cUNjsyVm5FYDmmRg6wK8vZTee2eFarwfBTrLKuPExIrOpf9Gh
	x8FBRqOEBJ15vrY6UumuiZ4m8UmjU41Jy+tKOfcgK733CPr3kOHSkchqAT3LG9KJ
	4JMdQ5i0Ah4Bc5oFnQJrj2xvEVgm7vft5z0gwyEHkbA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4292ax00ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 11:24:27 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EBOQcO018307;
	Mon, 14 Oct 2024 11:24:26 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4292ax00gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 11:24:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49E8eXvb005218;
	Mon, 14 Oct 2024 11:23:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285nhwwjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 11:23:34 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EBNXSg53936610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 11:23:33 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C7A120040;
	Mon, 14 Oct 2024 11:23:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 589102004D;
	Mon, 14 Oct 2024 11:23:31 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 11:23:31 +0000 (GMT)
Date: Mon, 14 Oct 2024 16:53:28 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <Zwz/MMcxj3eBHEG+@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
 <20241011164057.GY21853@frogsfrogsfrogs>
 <ZwzgFTX7H35+6S9U@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <a940924c-5e04-43f1-81f9-1d164fd384cc@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a940924c-5e04-43f1-81f9-1d164fd384cc@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VTMZm80lSJlN8L9Pvt1nDSOG0haWcxWC
X-Proofpoint-GUID: is7-q5a75Pn22hjf7jSC7yqoVF3wInMH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_10,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=745 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410140080

On Mon, Oct 14, 2024 at 10:56:57AM +0100, John Garry wrote:
> On 14/10/2024 10:10, Ojaswin Mujoo wrote:
> > On Fri, Oct 11, 2024 at 09:40:57AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
> > > > On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
> > > > > Extsize is allowed to be set on files with no data in it.
> 
> Should this be "Extsize should only be allowed to be set on files with no
> data written."

Sure, I can make the change.

> 
> > For this,
> > > > > we were checking if the files have extents but missed to check if
> > > > > delayed extents were present. This patch adds that check.
> > > > > 
> > > > > While we are at it, also refactor this check into a helper since
> > > > > its used in some other places as well like xfs_inactive() or
> > > > > xfs_ioctl_setattr_xflags()
> > > > > 
> > > > > **Without the patch (SUCCEEDS)**
> > > > > 
> > > > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > > > 
> > > > > wrote 1024/1024 bytes at offset 0
> > > > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > > > 
> > > > > **With the patch (FAILS as expected)**
> > > > > 
> > > > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > > > 
> > > > > wrote 1024/1024 bytes at offset 0
> > > > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > > > xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> > > > > 
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > > 
> > > > Looks good now,
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > That said, could you add a fixes tag for the xfs_ioctl_setattr_*
> > > changes, please?
> > 
> > Hi Darrick,
> > 
> > Sure I'll send a new version. Thanks for the review!
> > 
> > Regards,
> > ojaswin
> > 
> Feel free to add the following if you like:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks John!

Regards,
ojaswin
