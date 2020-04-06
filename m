Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BE8C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E345024953
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zSfUfLqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgDFQWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:22:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgDFQWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 12:22:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036GHunt156470;
        Mon, 6 Apr 2020 16:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KDEcD45f0BcyL1eiSjGAvg+svM57U8ck0mrFria1kYI=;
 b=zSfUfLqLGfYMKDgxqJioC9Zfr2bdyzEBX/CviAROF7cTG86azpaZ7vXiL7qOAgW3Bpax
 QToSklJXfm1keX5m5wiZ9YFccMT6YgI6msW9EEL2OrD2EaqoKut40YZALaLv76JpBi+c
 4dkG/KayK0T8Cu8FwHjp1g0Sty9rO8hV5xd4lRhBodroBEyCkaojiEe4npUeoRq2frCz
 R107AGfR/mjtmRbSV35DKa5EuamYIW3SH/RS7naMe/eMksMSN6H/DMfVPEYORwo8xrLm
 z67Nf0+Utmun0x+dludGDlsPESZ9j6iO9UvmSP19kJDTmhoZaXPDyTPYxq+sz+weIPow UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 306hnqyxy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 16:22:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036GJQU4053447;
        Mon, 6 Apr 2020 16:22:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3073qdg7vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 16:22:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036GMAC8008597;
        Mon, 6 Apr 2020 16:22:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 09:22:10 -0700
Date:   Mon, 6 Apr 2020 09:22:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reflink should force the log out if mounted
 with wsync
Message-ID: <20200406162209.GB6742@magnolia>
References: <20200403125522.450299-1-hch@lst.de>
 <20200403125522.450299-2-hch@lst.de>
 <20200406121437.GB20207@bfoster>
 <20200406153154.GA6742@magnolia>
 <20200406160437.GF20708@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406160437.GF20708@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 12:04:37PM -0400, Brian Foster wrote:
> On Mon, Apr 06, 2020 at 08:31:54AM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 06, 2020 at 08:14:37AM -0400, Brian Foster wrote:
> > > On Fri, Apr 03, 2020 at 02:55:22PM +0200, Christoph Hellwig wrote:
> > > > Reflink should force the log out to disk if the filesystem was mounted
> > > > with wsync, the same as most other operations in xfs.
> > > > 
> > > 
> > > Isn't WSYNC for namespace operations? Why is this needed for reflink?
> > 
> > The manpage says that 'wsync' (the mount option) is for making namespace
> > operations synchronous.
> > 
> > However, xfs_init_fs_context sets XFS_MOUNT_WSYNC if the admin set
> > the 'sync' mount option, which makes all IO synchronous.
> >
> 
> Ok.. so we're considering reflink a form of I/O.. I suppose that makes
> sense, though it would be nice to explain that in the commit log...

Ok, I'll add the following:

    [Note: XFS_MOUNT_WSYNC is set when the admin mounts the filesystem
    with either the 'wsync' or 'sync' mount options, which effectively means
    that we're classifying reflink/dedupe as IO operations and making them
    synchronous when required.]

Thanks for reviewing. :)

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > > > Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
> > > 
> > > At a glance this looks like a refactoring patch. What does this fix?
> > 
> > It probably ought to be 862bb360ef569f ("xfs: reflink extents from one
> > file to another") but so much of that was refactored for 5.0 that
> > backporting this fix will require changing a totally different function
> > (xfs_reflink_remap_range) in a totally different file (xfs_reflink.c).
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_file.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 68e1cbb3cfcc..4b8bdecc3863 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -1059,7 +1059,11 @@ xfs_file_remap_range(
> > > >  
> > > >  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> > > >  			remap_flags);
> > > > +	if (ret)
> > > > +		goto out_unlock;
> > > >  
> > > > +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > > > +		xfs_log_force_inode(dest);
> > > >  out_unlock:
> > > >  	xfs_reflink_remap_unlock(file_in, file_out);
> > > >  	if (ret)
> > > > -- 
> > > > 2.25.1
> > > > 
> > > 
> > 
> 
