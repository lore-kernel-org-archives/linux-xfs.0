Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7C4D8DA;
	Tue, 15 Oct 2024 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728975225; cv=none; b=cLQ8ghqXzZp24+dDB+MqH6lCsjToJhUdd34IKbN5GYDlVZxIGWsuchDlqHCHEkiuCF+5pyKEb+4n44I2sPDZ+o2Ww6xtBWZtc6sdUZsbZrRv8cF8xXFGfI7MNmWmB43qLPxb/Eld2kRdxvQxo/19LqUWuRz82fFYVTTnhQFMVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728975225; c=relaxed/simple;
	bh=B2yHHD6KhwHdxsM9ahhNN5gTO0gnTk2XJHesqN98TWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMvzgx2g74QChFyT/T8noR2krPimmKeIG522CesxsGhwjapYcDelTNkNQWp0NGBC3CFu8u/SXVoQt5c3FCw05LaVWW6R3bl8BJwz0M9YFfV0V0BHVwL1MKzMDny0Cm2qwgvu+Yw2nkL+OXQodGeaey2Pr7aaG+xPD9OClaNwqHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pik0iesn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pik0iesn"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F6PUF4026270;
	Tue, 15 Oct 2024 06:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KJXvLIboovJiMyM2Fw5X5do5itxkNG
	J8yRqFjni+mv0=; b=pik0iesn8s25OyTpKIdj3bbM4PkJVcQ5/CpHmEZ8jj+j5z
	ktkaiiyu0dWJUf1ITDDaPlxc4oyf5GiJxcSiOgwjUe5iIhi1MnmOvWMpUTPrZq5w
	DGW2eTkg6lPbiU9yOvdCaXg0yrvWa2M3LkSgS5U6YbhJHjMUFe1Mc27uoKq+POw9
	A3uod9wTD+uz2HZu3lMw/KOG4ART7fTm1HqQkpZREK0e80N3CsXBfTkz5r+pw7H9
	+VpM69uFxHiZM9J9HY0Rz29BWkbC9fms5GWmORCCAikWJiD7xBukXv4eG4U/h1vZ
	l/s0zz2ybXJNZobZVgEakbag3Ip7vSOGFMZFJgkg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xr3ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 06:53:29 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F6o4Zs012158;
	Tue, 15 Oct 2024 06:53:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xr3ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 06:53:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F3CoG0002426;
	Tue, 15 Oct 2024 06:53:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emjahf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 06:53:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F6rPvk34144536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 06:53:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6651A2004B;
	Tue, 15 Oct 2024 06:53:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95FC20040;
	Tue, 15 Oct 2024 06:53:23 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 06:53:23 +0000 (GMT)
Date: Tue, 15 Oct 2024 12:23:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, nirjhar@linux.ibm.com
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <Zw4RYapUKWH5u7yt@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
 <20241011164057.GY21853@frogsfrogsfrogs>
 <ZwzlPR6044V/Siph@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <20241014152856.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014152856.GG21853@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sRUKisQ6JgtYZE9tbXe4J99G9B5TNCYf
X-Proofpoint-ORIG-GUID: dlKm_MtXzcxw9heNBD_Zc8-0eG7jdtDk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150044

On Mon, Oct 14, 2024 at 08:28:56AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 14, 2024 at 03:02:45PM +0530, Ojaswin Mujoo wrote:
> > On Fri, Oct 11, 2024 at 09:40:57AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
> > > > On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
> > > > > Extsize is allowed to be set on files with no data in it. For this,
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
> > Actually a small doubt Darrick regarding the Fixes commit (asked inline
> > below):
> > 
> > > 
> > > --D
> > > 
> > > > --D
> > > > 
> > > > > ---
> > > > >  fs/xfs/xfs_inode.c | 2 +-
> > > > >  fs/xfs/xfs_inode.h | 5 +++++
> > > > >  fs/xfs/xfs_ioctl.c | 4 ++--
> > > > >  3 files changed, 8 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index bcc277fc0a83..19dcb569a3e7 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -1409,7 +1409,7 @@ xfs_inactive(
> > > > >  
> > > > >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > > > >  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> > > > > -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > > > > +	     xfs_inode_has_filedata(ip)))
> > > > >  		truncate = 1;
> > > > >  
> > > > >  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > > index 97ed912306fd..03944b6c5fba 100644
> > > > > --- a/fs/xfs/xfs_inode.h
> > > > > +++ b/fs/xfs/xfs_inode.h
> > > > > @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> > > > >  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> > > > >  }
> > > > >  
> > > > > +static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
> > > > > +{
> > > > > +	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * Check if an inode has any data in the COW fork.  This might be often false
> > > > >   * even for inodes with the reflink flag when there is no pending COW operation.
> > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > index a20d426ef021..2567fd2a0994 100644
> > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
> > > > >  
> > > > >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> > > > >  		/* Can't change realtime flag if any extents are allocated. */
> > > > > -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> > > > > +		if (xfs_inode_has_filedata(ip))
> > > > >  			return -EINVAL;
> > > > >  
> > > > >  		/*
> > > > > @@ -602,7 +602,7 @@ xfs_ioctl_setattr_check_extsize(
> > > > >  	if (!fa->fsx_valid)
> > > > >  		return 0;
> > > > >  
> > > > > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > > > > +	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
> > 
> > So seems like there have been lots of changes to this particular line
> > mostly as a part of refactoring other areas but seems like the actual
> > commit that introduced it was:
> > 
> >   commit e94af02a9cd7b6590bec81df9d6ab857d6cf322f
> >   Author: Eric Sandeen <sandeen@sgi.com>
> >   Date:   Wed Nov 2 15:10:41 2005 +1100
> >   
> >       [XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not
> >       using xfs rt
> > 
> > Before this we were actually checking ip->i_delayed_blks correctly. So just wanted 
> > to confirm that the fixes would have the above commit right?
> > 
> > If this looks okay I'll send a revision with this above tags:
> > 
> > Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
> 
> Yeah, that sounds fine.  Want to write a quick fstest to bang on
> xfs_ioctl_setattr_check_extsize to force everyone to backport it? :)

Got it, thanks, I'll send a v4.

Regarding the tests, we were thinking of adding more comprehensive
generic tests for extsize now that ext4 is also implementing it. We
have a new team member Nirjhar (cc'd) who is interested in writing the 
xfstest and is working on it as we speak.

Since the area is new to him, it might take a bit of time to get that
out, hope that is okay?

Regards,
Ojaswin

> 
> --D
> 
> > Thanks,
> > Ojaswin
> > 
> > > > >  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
> > > > >  		return -EINVAL;
> > > > >  
> > > > > -- 
> > > > > 2.43.5
> > > > > 
> > > > > 
> > > > 
> > 
