Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4512D75C;
	Fri,  4 Oct 2024 08:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032186; cv=none; b=gYeXOqgn+TQNgYrTQT9RdtN84WK2V4cmdGAFQD+Jm+J7+bq4P8mx9+ph0pMsELhRDww47wkI4XAP/Matzgp7MadRgThlbI2UBcwSTOfWVcQ5+nw9NiS2/cSpzfVDNBv9uM/UJfSI7Hym/F7GmlULY2ndklHJ44YrdOsJZPcywlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032186; c=relaxed/simple;
	bh=lS3HUIKLQ8WqglmBcueM1aFx4v3vrUwt6x3/lWmlwzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psOQjJji7myeXDPrhPqY99VjRwuwXXeAyd/Z1nDWUQIkvL2ec3vQFSLCTWfH1GS93aOnty61ioPVJJBNKUxUVHyfoCKOqTVM2b2kAtTyApq/4Rt4c1PYpdcUNeDPefYwLHi7v71Kio+znOZUd1+WZRWn/8Av//eqAynU+pPvHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MjllzRRr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MjllzRRr"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4948qX9i024974;
	Fri, 4 Oct 2024 08:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=nBwjeGPrXf2Nj/xVxGJ8mzlowNt
	ZWESSqNzgTAsTDL8=; b=MjllzRRrlFRwK0VmZKhLsakynh7LXjqeVDgHUo0N8s7
	nL1JWFxO2Z9DgyAbURKwth39LbC5zGfzTzVJhjTmc2EbR3/2dZZ2MZfWagCgxdqt
	uFV6oxGSsP4CKDqoCmbvJv/46cmgJgfV7HsRIKzdZzbYx5Xq+Yv73qpgqeNPUIXU
	+t9J53reSErsMB36zegoxL8qbZvdlum0lE3PMgK2q+wKyfPZWU75kHSsv7YJWRge
	2u2JrccmJwl4LTxyppYWP4Mq2gGpVpmWUvj+NShZ36Hr9IBpyKHO0TBMQIY44Xic
	kf/D0XIo2rf3g1vj5M8ufVHBU/SzWSWhzQaaWhTuaIg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 422d7vr0ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Oct 2024 08:56:15 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4948uErx002617;
	Fri, 4 Oct 2024 08:56:14 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 422d7vr0sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Oct 2024 08:56:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49471uM0001035;
	Fri, 4 Oct 2024 08:56:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42207kk1q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Oct 2024 08:56:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4948uBYj47972780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Oct 2024 08:56:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75E4B2004B;
	Fri,  4 Oct 2024 08:56:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D50420040;
	Fri,  4 Oct 2024 08:56:10 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.124.214.133])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  4 Oct 2024 08:56:09 +0000 (GMT)
Date: Fri, 4 Oct 2024 14:26:07 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        dchinner@redhat.com, Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <Zv+tfQhBdxuownfv@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241003101207.205083-1-ojaswin@linux.ibm.com>
 <Zv6sU5eF4OCPTzNH@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv6sU5eF4OCPTzNH@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 86Jid2pEkAqYG89wWqwL4I6iq0w8Pjss
X-Proofpoint-GUID: BWALg5qlPipqkLEwDiJzfOqXPkZtOG5u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_06,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=809 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410040064

On Thu, Oct 03, 2024 at 07:38:11AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 03, 2024 at 03:42:07PM +0530, Ojaswin Mujoo wrote:
> > Extsize is allowed to be set on files with no data in it. For this,
> > we were checking if the files have extents but missed to check if
> > delayed extents were present. This patch adds that check.
> > 
> > **Without the patch (SUCCEEDS)**
> > 
> > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> 
> Can you add a testcase for this to xfstests?

Hi Christoph, actually now that we are also planning to use this for
atomic writes, we are thinking to add a generic extsize ioctl 
test to check for:

1. Setting hint on empty file should pass
2. Setting hint on a file with delayed allocation data should fail
3. Setting hint on a file with allocated data should fail
4. Setting hint on a file which is truncated to size 0 after write should pass

So that should cover this for ext4 and xfs as well.

> 
> > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > +	    (ip->i_df.if_nextents || ip->i_delayed_blks) &&
> 
> We have two other copies of the
> 
> 	ip->i_df.if_nextents || ip->i_delayed_blks
> 
> pattern to check if there is any data on the inode in xfs_inactive and
> xfs_ioctl_setattr_xflags.  Maybe facto this into a documented helper?

Sure I can do this.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for the review.

Regards,
ojaswin
