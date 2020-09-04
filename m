Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CDBC433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA0CD2074D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWiKUOvn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIDPlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:41:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgIDPlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:41:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084Fd3KF124755;
        Fri, 4 Sep 2020 15:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UbZGtUKcs7ZuhuK4s3FT35Rj//ljJ7U+TiHKs0UoZKY=;
 b=GWiKUOvn3/CpuPB1Bvz48HAEqfA9H7K8DSRpK7+d/f+oBlY8K0IQ2DcQ9c2wLn47IOxj
 q6nmsCKCi+AePx+qwMTSo70qsf0E5wiL09VKewl9e9gLG+rs7nrZq4QdgJdpWK5KDCoE
 DzdPDA0aqthB9hivewVWZfyx1N0pYQiIsFv4M4Qcay1NkaPJYimprMey6Xz6N6xm7wzC
 6SzL3AX+ilI73e/mf008zUeDVMhYxLg8JaPW1OBwGg30CkD1226hAOX/1s+6+A+zno1n
 ZVr7zVADB1anSvgac8vFZJq57jhkdPVdtG2REirZXde7TKUeyFw2N9qEWti/cMCEZfaz 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eerf7tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Sep 2020 15:41:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084FZEbo162453;
        Fri, 4 Sep 2020 15:41:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33bhs4nj50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Sep 2020 15:41:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 084FfAk6001166;
        Fri, 4 Sep 2020 15:41:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 08:41:10 -0700
Date:   Fri, 4 Sep 2020 08:41:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: force the log after remapping a synchronous-writes
 file
Message-ID: <20200904154109.GD6096@magnolia>
References: <20200904031100.GZ6096@magnolia>
 <20200904112451.GA529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904112451.GA529978@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 07:24:51AM -0400, Brian Foster wrote:
> On Thu, Sep 03, 2020 at 08:11:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Commit 5833112df7e9 tried to make it so that a remap operation would
> > force the log out to disk if the filesystem is mounted with mandatory
> > synchronous writes.  Unfortunately, that commit failed to handle the
> > case where the inode or the file descriptor require mandatory
> > synchronous writes.
> > 
> > Refactor the check into into a helper that will look for all three
> > conditions, and now we can treat reflink just like any other synchronous
> > write.
> > 
> > Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")
> 
> More of a process thought than an issue with this particular patch, but
> I feel like the Fixes tag thing gets more watered down as we attempt to
> apply it to more patches. Is it really necessary here? If so, what's the
> reasoning? I thought it was more of a "this previous patch has a bug,"
> but that link seems a bit tenuous here given the original patch refers
> specifically to wsync. Sure, a stable kernel probably wants both
> patches, but is that really the primary purpose of "Fixes?"

<shrug> I'm not sure -- both patches fix design flaws in the xfs reflink
implementation, and the second patch requires the first one.  The docs
merely say that you should add a Fixes tag "if your patch fixes a bug in
a specific commit" without elaborating if we ought to create a chain of
Fixes tags when adding patches that slowly broaden the scope of a code
change.

FWIW these days I add Fixes tags in the hopes of tricking the LTS bot
(or Eric Sandeen) into backporting things for me. ;)

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review though. :)

--D

> >  fs/xfs/xfs_file.c |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index c31cd3be9fb2..ee43f137830c 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1008,6 +1008,21 @@ xfs_file_fadvise(
> >  	return ret;
> >  }
> >  
> > +/* Does this file, inode, or mount want synchronous writes? */
> > +static inline bool xfs_file_sync_writes(struct file *filp)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> > +
> > +	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
> > +		return true;
> > +	if (filp->f_flags & (__O_SYNC | O_DSYNC))
> > +		return true;
> > +	if (IS_SYNC(file_inode(filp)))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> >  STATIC loff_t
> >  xfs_file_remap_range(
> >  	struct file		*file_in,
> > @@ -1065,7 +1080,7 @@ xfs_file_remap_range(
> >  	if (ret)
> >  		goto out_unlock;
> >  
> > -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > +	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
> >  		xfs_log_force_inode(dest);
> >  out_unlock:
> >  	xfs_iunlock2_io_mmap(src, dest);
> > 
> 
