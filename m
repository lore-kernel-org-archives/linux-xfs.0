Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C2C201002;
	Fri, 18 Oct 2024 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729245298; cv=none; b=iCDhh6gfkx/CF0wbUwAwZndlZ4cJShNyqWHwKuy057aw1KEeqwHRvL6gwnlcdYdw0xnTRpltIUJStbW0regHcIgyPM+dLUlzj3l5fMddKmRe7+RbpCQ/B0iQlsxdUuwIQejMLfH1D1mAxPLWUIXBHztbh6yc4nKs1FCB3JmPOOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729245298; c=relaxed/simple;
	bh=SeSwzr6EzUAcT/MCOBwVjCKx6s0L9EQWrYbUqEDA6VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcfMGI9gFGikG5acgeYRGs1wutzlLzydq43xrWyIXj5dAPrd2THB1o4lx7L2WXfG/0Ydif1JvAGi/QeInFcGqk+fBdoV2TmesvJYChZ5lJjml/gbXo0Syw7yI3zyEJ1+JDA3WH1Mb5gEK+Usz7cF6+MuJw4zvumS+X9QrkxFxUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MkcU2s5w; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MkcU2s5w"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49I8RdPX014660;
	Fri, 18 Oct 2024 09:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hoEsiEKp9zGlUSc9yQiidoLpEcUdiB
	kBdXP4ZJ2KNYs=; b=MkcU2s5wOseMfU1hkNSvzHhrafmAAGxFE0fqnGV3j3FHuf
	tRLZYG9bylch7Au7q6CCyszRHpCxICTjQIQhA/DBaQhoZeV1SWFqt/ppMTGqL3Mv
	jWGcXcsnD+HLC3blL1WsYYQA6ZNGFWMHDfwFngseNwsHDFGtFZ4ex7y+uJ+uOO4R
	x6TPQAl3Sp2hBCqi88n1F9ifRT9UWDwicVzRA0Z8h7SbdF47h7CT2ladhnPBLTQe
	/T/oLTN/nOfnLmDR9ul/ia3FuL6B8HhueWMYRvXz73J19w7BbXuEn8TriNR9HOfj
	jBJ2Fi0jPJWB/CBOKPpwBwDkMnPWCoo4idnQiYEw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42aqgr7yuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 09:54:45 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49I9sjrA017375;
	Fri, 18 Oct 2024 09:54:45 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42aqgr7yuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 09:54:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49I9h5Cv005951;
	Fri, 18 Oct 2024 09:54:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428651bc0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 09:54:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49I9sgWX21102854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 09:54:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99D4C2004D;
	Fri, 18 Oct 2024 09:54:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1EE620049;
	Fri, 18 Oct 2024 09:54:40 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 18 Oct 2024 09:54:40 +0000 (GMT)
Date: Fri, 18 Oct 2024 15:24:38 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, nirjhar@linux.ibm.com
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <ZxIwXkHvI/aV++Nl@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
 <20241011164057.GY21853@frogsfrogsfrogs>
 <ZwzlPR6044V/Siph@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <20241014152856.GG21853@frogsfrogsfrogs>
 <Zw4RYapUKWH5u7yt@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <20241015162237.GX21853@frogsfrogsfrogs>
 <ZxC2xEdWGVXDIFqR@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <20241017145630.GU21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017145630.GU21853@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7-eLRouJC4xqNhxkQtw1oQCeExuVQMKC
X-Proofpoint-GUID: DCNmqGBXicvToS4MhmIXShLuralR_0f2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410180060

On Thu, Oct 17, 2024 at 07:56:30AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 17, 2024 at 12:33:32PM +0530, Ojaswin Mujoo wrote:
> > On Tue, Oct 15, 2024 at 09:22:37AM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 15, 2024 at 12:23:21PM +0530, Ojaswin Mujoo wrote:
> > > > On Mon, Oct 14, 2024 at 08:28:56AM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Oct 14, 2024 at 03:02:45PM +0530, Ojaswin Mujoo wrote:
> > > > > > On Fri, Oct 11, 2024 at 09:40:57AM -0700, Darrick J. Wong wrote:
> > > > > > > On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
> > > > > > > > On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
> > > > > > > > > Extsize is allowed to be set on files with no data in it. For this,
> > > > > > > > > we were checking if the files have extents but missed to check if
> > > > > > > > > delayed extents were present. This patch adds that check.
> > > > > > > > > 
> > > > > > > > > While we are at it, also refactor this check into a helper since
> > > > > > > > > its used in some other places as well like xfs_inactive() or
> > > > > > > > > xfs_ioctl_setattr_xflags()
> > > > > > > > > 
> > > > > > > > > **Without the patch (SUCCEEDS)**
> > > > > > > > > 
> > > > > > > > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > > > > > > > 
> > > > > > > > > wrote 1024/1024 bytes at offset 0
> > > > > > > > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > > > > > > > 
> > > > > > > > > **With the patch (FAILS as expected)**
> > > > > > > > > 
> > > > > > > > > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > > > > > > > > 
> > > > > > > > > wrote 1024/1024 bytes at offset 0
> > > > > > > > > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > > > > > > > > xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> > > > > > > > > 
> > > > > > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > > > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > > > > > > 
> > > > > > > > Looks good now,
> > > > > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > > 
> > > > > > > That said, could you add a fixes tag for the xfs_ioctl_setattr_*
> > > > > > > changes, please?
> > > > > > 
> > > > > > Actually a small doubt Darrick regarding the Fixes commit (asked inline
> > > > > > below):
> > > > > > 
> > > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > --D
> > > > > > > > 
> > > > > > > > > ---
> > > > > > > > >  fs/xfs/xfs_inode.c | 2 +-
> > > > > > > > >  fs/xfs/xfs_inode.h | 5 +++++
> > > > > > > > >  fs/xfs/xfs_ioctl.c | 4 ++--
> > > > > > > > >  3 files changed, 8 insertions(+), 3 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > > > > > index bcc277fc0a83..19dcb569a3e7 100644
> > > > > > > > > --- a/fs/xfs/xfs_inode.c
> > > > > > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > > > > > @@ -1409,7 +1409,7 @@ xfs_inactive(
> > > > > > > > >  
> > > > > > > > >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > > > > > > > >  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> > > > > > > > > -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > > > > > > > > +	     xfs_inode_has_filedata(ip)))
> > > > > > > > >  		truncate = 1;
> > > > > > > > >  
> > > > > > > > >  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > > > > > > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > > > > > > index 97ed912306fd..03944b6c5fba 100644
> > > > > > > > > --- a/fs/xfs/xfs_inode.h
> > > > > > > > > +++ b/fs/xfs/xfs_inode.h
> > > > > > > > > @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> > > > > > > > >  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> > > > > > > > >  }
> > > > > > > > >  
> > > > > > > > > +static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
> > > > > > > > > +{
> > > > > > > > > +	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >  /*
> > > > > > > > >   * Check if an inode has any data in the COW fork.  This might be often false
> > > > > > > > >   * even for inodes with the reflink flag when there is no pending COW operation.
> > > > > > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > > > > > index a20d426ef021..2567fd2a0994 100644
> > > > > > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > > > > > @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
> > > > > > > > >  
> > > > > > > > >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> > > > > > > > >  		/* Can't change realtime flag if any extents are allocated. */
> > > > > > > > > -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> > > > > > > > > +		if (xfs_inode_has_filedata(ip))
> > > > > > > > >  			return -EINVAL;
> > > > > > > > >  
> > > > > > > > >  		/*
> > > > > > > > > @@ -602,7 +602,7 @@ xfs_ioctl_setattr_check_extsize(
> > > > > > > > >  	if (!fa->fsx_valid)
> > > > > > > > >  		return 0;
> > > > > > > > >  
> > > > > > > > > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > > > > > > > > +	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
> > > > > > 
> > > > > > So seems like there have been lots of changes to this particular line
> > > > > > mostly as a part of refactoring other areas but seems like the actual
> > > > > > commit that introduced it was:
> > > > > > 
> > > > > >   commit e94af02a9cd7b6590bec81df9d6ab857d6cf322f
> > > > > >   Author: Eric Sandeen <sandeen@sgi.com>
> > > > > >   Date:   Wed Nov 2 15:10:41 2005 +1100
> > > > > >   
> > > > > >       [XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not
> > > > > >       using xfs rt
> > > > > > 
> > > > > > Before this we were actually checking ip->i_delayed_blks correctly. So just wanted 
> > > > > > to confirm that the fixes would have the above commit right?
> > > > > > 
> > > > > > If this looks okay I'll send a revision with this above tags:
> > > > > > 
> > > > > > Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
> > > > > 
> > > > > Yeah, that sounds fine.  Want to write a quick fstest to bang on
> > > > > xfs_ioctl_setattr_check_extsize to force everyone to backport it? :)
> > > > 
> > > > Got it, thanks, I'll send a v4.
> > > > 
> > > > Regarding the tests, we were thinking of adding more comprehensive
> > > > generic tests for extsize now that ext4 is also implementing it. We
> > > > have a new team member Nirjhar (cc'd) who is interested in writing the 
> > > > xfstest and is working on it as we speak.
> > > 
> > > Heh, welcome! :)
> > > 
> > > > Since the area is new to him, it might take a bit of time to get that
> > > > out, hope that is okay?
> > > 
> > > Sounds good to me.  You might see how many of the tests/xfs/ stuff can
> > > be pulled up to tests/generic/ as a starting point.
> > 
> > Sure Darrick, I believe you mean how many of the extsize related tests
> > we can pull up right?
> > 
> > So I was checking this and I could find some relevant tests:
> > 
> >  * Looking into existing tests around extsize:
> >    * xfs/074
> >      * Check some extent size hint boundary conditions that can result in
> >        MAXEXTLEN overflows.
> >      * This looks specific to xfs however
> > 
> >    * xfs/208
> >      * Testing interactinon b/w cowextsize and extsize but again seems xfs specific
> > 
> >    * xfs/207
> >      * basic test on setting and getting (cow)extsize on file with data or empty
> >      * This is a subset of the features we are testing with our test, but only
> >        for extsize not cowextsize.
> >      * So we can probably remove the equivalent tests from here when we add the generic
> >        one.
> > 
> >    * xfs/419
> >      * These are related to extsize inherit feature but with rtinherit.
> >      * The current patchset in ext4 doesn't implement this extszinherit but it
> >        might be something we might want to do in the future
> >      * We can look into hoisting the extszinherit related tests at some point
> > 
> >   * The other ones I looked into around extsize again seemed to be specific to
> >     xfx but maybe i missed something.
> > 
> > Are there any other tests you had in mind Darrick?
> 
> Not really.  Most of my testing comes from setting up an entire vm
> config with extszinherit=X in the MKFS_OPTIONS.  I wonder if we need a
> single generic test to kick the tires on the functionality just to make
> sure that everyone runs it even if they only do an all-defaults testrun?

Got it Darrick, thanks for the inputs.

Sure we can look into adding/enhancing tests for extsizeinherit in mkfs
as well as setting using xfs_io.

Regards,
ojaswin
> 
> --D
> 
> > Regards,
> > ojaswin
> > 
> > > 
> > > --D
> > > 
> > > > Regards,
> > > > Ojaswin
> > > > 
> > > > > 
> > > > > --D
> > > > > 
> > > > > > Thanks,
> > > > > > Ojaswin
> > > > > > 
> > > > > > > > >  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
> > > > > > > > >  		return -EINVAL;
> > > > > > > > >  
> > > > > > > > > -- 
> > > > > > > > > 2.43.5
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > 
> > > > > > 
> > > > 
> > 
