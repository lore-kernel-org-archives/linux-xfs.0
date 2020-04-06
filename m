Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A639C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 15:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE26248A6
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 15:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ebI72P/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgDFPcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 11:32:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgDFPcG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 11:32:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036FRm9N074010;
        Mon, 6 Apr 2020 15:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zHBq8dI0KI+DNIVJ1fAx38RD0ZZn+tk/hVHDJh2zo1E=;
 b=ebI72P/xWlg4jXMrMVve2OyD7TtPmbBED1fv/HaU/CL4RJ99dCz6GJmCZwuwlPSJWyU2
 e9zrQTT4iLWF9Rcuq7QaWWnabDmeHZg2wko+80M/6GY52ebCnPaSNE+kT0CWhC+v5dfr
 rBzjTF+KDu3CFB+uTOBm8Vuvk+Z6t5hb/ZJtimUUfD+Hc48x1l6FIuaxKJXBfB+WdUKt
 pHGNorbPiaGkszc2UU/xfRIfxatyIXq9B2Trj7keigJShicxk240HQboTiaN5VL+CR08
 iPu68xTBAeVM2Qv6I93laZfEnWuIWgIwnuAOgvGNfq4VFNedIgBSounUSVNStCg3JHel 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 306hnqymnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 15:31:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036FSRND016285;
        Mon, 6 Apr 2020 15:31:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30839qbm5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 15:31:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036FVujY020784;
        Mon, 6 Apr 2020 15:31:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 08:31:55 -0700
Date:   Mon, 6 Apr 2020 08:31:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reflink should force the log out if mounted
 with wsync
Message-ID: <20200406153154.GA6742@magnolia>
References: <20200403125522.450299-1-hch@lst.de>
 <20200403125522.450299-2-hch@lst.de>
 <20200406121437.GB20207@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406121437.GB20207@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 08:14:37AM -0400, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 02:55:22PM +0200, Christoph Hellwig wrote:
> > Reflink should force the log out to disk if the filesystem was mounted
> > with wsync, the same as most other operations in xfs.
> > 
> 
> Isn't WSYNC for namespace operations? Why is this needed for reflink?

The manpage says that 'wsync' (the mount option) is for making namespace
operations synchronous.

However, xfs_init_fs_context sets XFS_MOUNT_WSYNC if the admin set
the 'sync' mount option, which makes all IO synchronous.

> > Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
> 
> At a glance this looks like a refactoring patch. What does this fix?

It probably ought to be 862bb360ef569f ("xfs: reflink extents from one
file to another") but so much of that was refactored for 5.0 that
backporting this fix will require changing a totally different function
(xfs_reflink_remap_range) in a totally different file (xfs_reflink.c).

--D

> Brian
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_file.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 68e1cbb3cfcc..4b8bdecc3863 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1059,7 +1059,11 @@ xfs_file_remap_range(
> >  
> >  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> >  			remap_flags);
> > +	if (ret)
> > +		goto out_unlock;
> >  
> > +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > +		xfs_log_force_inode(dest);
> >  out_unlock:
> >  	xfs_reflink_remap_unlock(file_in, file_out);
> >  	if (ret)
> > -- 
> > 2.25.1
> > 
> 
