Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE872C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 23:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A80862245C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 23:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgLCXG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:06:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLCXG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 18:06:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3MjB7L106397;
        Thu, 3 Dec 2020 23:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gnI1SAGqyARtHi1AFV9Dj1hD2loZbZPiDtSrkvQkXGc=;
 b=khyZ/ODcVgDVlndyfMUAU4kEkDN+ssgOGaimcOqORuJw3/Fv8azOBPuWhB71+IfQ8DJQ
 8+ZCCrqXDqPECL034uu7RWX+DCJKytlKdWLMhBT2SVlqjcmrZKufy5G30sGuhB7C0+7t
 AXUxL1+i7lAbrXF+dsMjceUJnEoc0CEDsFSuPIWweEgZtwfhXYatLolg5KuZ04vNnIwS
 r7uLp3n9kPw7IjY4SFAMginufiZixZ5svkFlD5RvuLoeOuxlgydoV/PHXSc/jw8WRnim
 uYIu67HmC/lu1j6uYEtyIJmxV0cmqIXshCRjkbkLoV8Xq7GnvVFz2qDvvgoBs2OTECGO ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egm0kx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 23:05:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3MeX87079430;
        Thu, 3 Dec 2020 23:03:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404rhjkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 23:03:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3N3gZK007004;
        Thu, 3 Dec 2020 23:03:43 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 15:03:42 -0800
Date:   Thu, 3 Dec 2020 15:03:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: don't catch dax+reflink inodes as corruption in
 verifier
Message-ID: <20201203230342.GB629293@magnolia>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
 <20201203214436.GA629293@magnolia>
 <4db6efd8-2cf0-180c-4315-a96120e63c31@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db6efd8-2cf0-180c-4315-a96120e63c31@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 04:19:35PM -0600, Eric Sandeen wrote:
> On 12/3/20 3:44 PM, Darrick J. Wong wrote:
> > On Tue, Dec 01, 2020 at 01:16:09PM -0600, Eric Sandeen wrote:
> >> We don't yet support dax on reflinked files, but that is in the works.
> >>
> >> Further, having the flag set does not automatically mean that the inode
> >> is actually "in the CPU direct access state," which depends on several
> >> other conditions in addition to the flag being set.
> >>
> >> As such, we should not catch this as corruption in the verifier - simply
> >> not actually enabling S_DAX on reflinked files is enough for now.
> >>
> >> Fixes: 4f435ebe7d04 ("xfs: don't mix reflink and DAX mode for now")
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ----
> >>  1 file changed, 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> >> index c667c63f2cb0..4d7410e49db4 100644
> >> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> >> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> >> @@ -547,10 +547,6 @@ xfs_dinode_verify(
> >>  	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
> >>  		return __this_address;
> >>  
> >> -	/* don't let reflink and dax mix */
> >> -	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
> >> -		return __this_address;
> > 
> > If we're going to let in inodes with the DAX and REFLINK iflags set,
> > doesn't that mean that xfs_inode_should_enable_dax needs to return false
> > if REFLINK is set?
> 
> I think it does already, no?
> 
> static bool
> xfs_inode_should_enable_dax(
>         struct xfs_inode *ip)
> {
>         if (!IS_ENABLED(CONFIG_FS_DAX))
>                 return false;
>         if (ip->i_mount->m_flags & XFS_MOUNT_DAX_NEVER)
>                 return false;
>         if (!xfs_inode_supports_dax(ip)) <------
>                 return false;
> 
> 
> ----> xfs_inode_supports_dax ---> 
> 
> static bool
> xfs_inode_supports_dax(
>         struct xfs_inode        *ip)
> {
>         struct xfs_mount        *mp = ip->i_mount;
> 
>         /* Only supported on regular files. */
>         if (!S_ISREG(VFS_I(ip)->i_mode))
>                 return false;
> 
>         /* Only supported on non-reflinked files. */
>         if (xfs_is_reflink_inode(ip))
>                 return false;
> 

DOH  yes it does,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

