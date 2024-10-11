Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E66820ADE4;
	Fri, 11 Oct 2024 08:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728636730; cv=none; b=eAApSpgjIH1zEmM9OXVOop/DR22M6+ONkcGVKXo/aBvAVarW+c64k04Gpqym/b9+TQ2ynhRB65F+WV0rbOXUTvwuRqqDxlxa8iUkaZzLjXcT0EelIlBR9SxSD1SAoRQUuZQNCSprPMttv/v2WWo9aig2eG3FSrl9Gbq3Zmhu7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728636730; c=relaxed/simple;
	bh=OgELRwyBCDB4lUo9n9NdD1JTTv8WmWQr2cHsDjwxe5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KgDxwyvdPYaVBnJQi6pSZXkHwcH09fMeAdbUw/dio4/UL/UxKXdCS4LKxH+Hih7bJLfygrltabf2tLSCllZPwkSLCNGzr4H9ZLj0k3ojAwl4nVnAqTWX3TzKXjc96xGaSZVX/QJlmzglhpsR+JKl/GORzDTzaUwnRqjau+f6LVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GzfJqAaU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GzfJqAaU"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49B8d16I007795;
	Fri, 11 Oct 2024 08:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=N8a0pSiuyOhBPuxHC51q4aUguj9
	v681L9evUAKLiPtg=; b=GzfJqAaUFjxeAuWzo0+Xg+vRR4WQUr4/i8x+X/PGNgN
	eugv1Yj9rfnd4NxmfUzgY74jZ48e1ugScaq+quZ8gXKckkF9AkWZPVenVVAOsPr+
	EbFRrbPzDYfmFclY61vx1TEbIMnjrBVLZqlWnBT3cTrVDG6UUEP2WygXDRQYCuzV
	bAnlz+4Wx1mUh1mFFui9Yfm8m92/n1FsWI/pFNaz5s8/SfOmqPKFXJWmry3Fc0RC
	JnsLJHbG08w58PFZ3qXjU02ne612Bt1qvXPPEhJAtnqqznxsSK3Mfjut3hKKzKPC
	QgAAJ6LeA1g0/Ofe+sJyrMgPoH4gA8QvTpD2FnoN/zQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4270pn81q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:52:00 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49B8q0Fk002209;
	Fri, 11 Oct 2024 08:52:00 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4270pn81py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:52:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49B8kwbH010715;
	Fri, 11 Oct 2024 08:51:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 423j0jv5sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:51:59 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49B8pvhZ32047710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 08:51:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF3B320043;
	Fri, 11 Oct 2024 08:51:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7814F20040;
	Fri, 11 Oct 2024 08:51:56 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.124.219.114])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Oct 2024 08:51:56 +0000 (GMT)
Date: Fri, 11 Oct 2024 14:21:54 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <ZwjnKi+ZyvrLcOiF@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241010063617.563365-1-ojaswin@linux.ibm.com>
 <20241010183447.GZ21877@frogsfrogsfrogs>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010183447.GZ21877@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: efi4Hx6LncsbHCwzN81lMgBY5oGK9Gt1
X-Proofpoint-GUID: Y7hxygTOuNCHw4BlyepBy05rQLfpkKwY
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_06,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=996 suspectscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410110059

On Thu, Oct 10, 2024 at 11:34:47AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 10, 2024 at 12:06:17PM +0530, Ojaswin Mujoo wrote:
> > Extsize is allowed to be set on files with no data in it. For this,
> > we were checking if the files have extents but missed to check if
> > delayed extents were present. This patch adds that check.
> > 
> > While we are at it, also refactor this check into a helper since
> > its used in some other places as well like xfs_inactive() or
> > xfs_ioctl_setattr_xflags()
> > 
> > **Without the patch (SUCCEEDS)**
> > 
> > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > 
> > wrote 1024/1024 bytes at offset 0
> > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > 
> > **With the patch (FAILS as expected)**
> > 
> > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > 
> > wrote 1024/1024 bytes at offset 0
> > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> > 
> > * Changes since v1 *
> > 
> >  - RVB by Christoph
> >  - Added a helper to check if inode has data instead of
> >    open coding.
> > 	
> > v1:
> > https://lore.kernel.org/linux-xfs/Zv_cTc6cgxszKGy3@infradead.org/T/#mf949dafb2b2f63bea1f7c0ce5265a2527aaf22a9
> > 
> >  fs/xfs/xfs_inode.c | 2 +-
> >  fs/xfs/xfs_inode.h | 5 +++++
> >  fs/xfs/xfs_ioctl.c | 5 +++--
> >  3 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index bcc277fc0a83..3d083a8fd8ed 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1409,7 +1409,7 @@ xfs_inactive(
> >  
> >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> >  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> > -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > +	     xfs_inode_has_data(ip)))
> >  		truncate = 1;
> >  
> >  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 97ed912306fd..ae1ccf2a3c8b 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> >  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> >  }
> >  
> > +static inline bool xfs_inode_has_data(struct xfs_inode *ip)
> 
> Can you please change this to "const struct xfs_inode *ip"?
> This predicate function doesn't change @ip.

> 
> I might've called it xfs_inode_has_filedata fwiw, but the current name
> is fine with me.

Hey Darrick, sure I'll make it const and change data -> filedata.

Thanks for the review,
ojaswin

> 
> --D
> 
> > +{
> > +	return (ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0);
> > +}
> > +
> >  /*
> >   * Check if an inode has any data in the COW fork.  This might be often false
> >   * even for inodes with the reflink flag when there is no pending COW operation.
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index a20d426ef021..88b9c8cf0272 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
> >  
> >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> >  		/* Can't change realtime flag if any extents are allocated. */
> > -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> > +		if (xfs_inode_has_data(ip))
> >  			return -EINVAL;
> >  
> >  		/*
> > @@ -602,7 +602,8 @@ xfs_ioctl_setattr_check_extsize(
> >  	if (!fa->fsx_valid)
> >  		return 0;
> >  
> > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > +	    xfs_inode_has_data(ip) &&
> >  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
> >  		return -EINVAL;
> >  
> > -- 
> > 2.43.5
> > 
