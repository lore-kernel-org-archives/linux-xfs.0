Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED815C122;
	Mon, 14 Oct 2024 09:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898383; cv=none; b=I8+AG5wOcBEcOBJE3clGadNvE147OdNxdYy1NUwiIRENh/Vp1inphyGALfbEusDZqMPsX/ezfGig88lnmMpSK6sZr1Di9FeHVMjefRgVSzNnDJd6eB0OYRZY0aEvEuOuXGRAE3V12ItG/6C+APgBjcDzL08UYi8hwsf5jFFr5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898383; c=relaxed/simple;
	bh=/MZxwR2Jy8r1v9STI3AXC+3dGArpe3j9UUXV2ctEDXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtuhCL2lETizlwn75UOJjAm1lln/pwNKA67657RLLpXl0seZZ/7RxZX7ziAJ/vS2os2CURgzT+pTLAV5qAcE9XGaq6dEq4cfXKBsK+jCyvHvWcYvl4rBpMJJycw76Jo2WMwY5lTJA7nXeV/ZoiE4RfMPZiPw9TQ/LaEcGV+c6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WlsLcCs9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WlsLcCs9"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49E9P7RO003739;
	Mon, 14 Oct 2024 09:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=NHKQH511JNsUmcUxObbCKcHyBLI
	aFmLlUWCNl6FCQvI=; b=WlsLcCs9n8v25iNsO/UU8DZfEQk9o4KYvleTcdynpgO
	oDJt1stRiPJ8w/mYqupW0R5mmu3eLPrfZN9S5Z5PDV2FdpmqfXYH/B5XBol4qjN7
	irbfrdcNh4B8JrxcAJEXMsvZ02vAeubZpJrdFhjVojkW+ahkXZLQBe8zWjPzCKQR
	vd3bYTcGuyN0DPBG9+077i8ky5dXCmQv1K/ayJmBnRnm2nISD2ppqmPmVOvpqE5w
	Dp+26H+/u6QQJFkmsvCY4RUnXFRQYbqjG6LwxedgOn4HoTfVq9Qzz2BHHpfY/3+n
	xGbGuvXj0v7movU1OCFxuy7FTvaLDKzuCSdiV7WKnsA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4290n5r14y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:32:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49E9WqdT021032;
	Mon, 14 Oct 2024 09:32:52 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4290n5r14t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:32:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49E7nnl6001940;
	Mon, 14 Oct 2024 09:32:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emdp4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 09:32:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49E9WnLS55968030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 09:32:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDF112004B;
	Mon, 14 Oct 2024 09:32:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 824FE20043;
	Mon, 14 Oct 2024 09:32:47 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 09:32:47 +0000 (GMT)
Date: Mon, 14 Oct 2024 15:02:45 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <ZwzlPR6044V/Siph@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
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
X-Proofpoint-GUID: AfoN_S8K2Tv9fiypcSn1cPW_fR44YV3S
X-Proofpoint-ORIG-GUID: zOfp8KspInsjnjjor8XCXGEfjv1YiAhD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_08,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410140066

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

Actually a small doubt Darrick regarding the Fixes commit (asked inline
below):

> 
> --D
> 
> > --D
> > 
> > > ---
> > >  fs/xfs/xfs_inode.c | 2 +-
> > >  fs/xfs/xfs_inode.h | 5 +++++
> > >  fs/xfs/xfs_ioctl.c | 4 ++--
> > >  3 files changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index bcc277fc0a83..19dcb569a3e7 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1409,7 +1409,7 @@ xfs_inactive(
> > >  
> > >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > >  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> > > -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > > +	     xfs_inode_has_filedata(ip)))
> > >  		truncate = 1;
> > >  
> > >  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index 97ed912306fd..03944b6c5fba 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> > >  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> > >  }
> > >  
> > > +static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
> > > +{
> > > +	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
> > > +}
> > > +
> > >  /*
> > >   * Check if an inode has any data in the COW fork.  This might be often false
> > >   * even for inodes with the reflink flag when there is no pending COW operation.
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index a20d426ef021..2567fd2a0994 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
> > >  
> > >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> > >  		/* Can't change realtime flag if any extents are allocated. */
> > > -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> > > +		if (xfs_inode_has_filedata(ip))
> > >  			return -EINVAL;
> > >  
> > >  		/*
> > > @@ -602,7 +602,7 @@ xfs_ioctl_setattr_check_extsize(
> > >  	if (!fa->fsx_valid)
> > >  		return 0;
> > >  
> > > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > > +	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&

So seems like there have been lots of changes to this particular line
mostly as a part of refactoring other areas but seems like the actual
commit that introduced it was:

  commit e94af02a9cd7b6590bec81df9d6ab857d6cf322f
  Author: Eric Sandeen <sandeen@sgi.com>
  Date:   Wed Nov 2 15:10:41 2005 +1100
  
      [XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not
      using xfs rt

Before this we were actually checking ip->i_delayed_blks correctly. So just wanted 
to confirm that the fixes would have the above commit right?

If this looks okay I'll send a revision with this above tags:

Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")

Thanks,
Ojaswin

> > >  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
> > >  		return -EINVAL;
> > >  
> > > -- 
> > > 2.43.5
> > > 
> > > 
> > 
