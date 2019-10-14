Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5E0ECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4538720854
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NRfYrTFx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfJNRe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:34:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbfJNRe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 13:34:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHTp3K055924;
        Mon, 14 Oct 2019 17:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Sj5E7ri9EjF2cgNcXdjfk05LQnS3NN8JCDICViSe1l4=;
 b=NRfYrTFxZzoOLxMcx65XLBB3ERJNQMv6n5M78L/0xlTcg1yrbwGrNSDcLoOjtucMpMiw
 nCdS2UdRbm/zV3OryxWtaiUcBT2dhyN9Y3ciyKA+D7eqfulGWi8hxdzv2jYY+x7V2fRh
 7Y7PnwKF+QiHacsd2rSppbdChEsZYK01alggAyr6KWNbEFwpI6SqS1Fw44fIYvxuAzF/
 QPSlZ9xDXQHJe/9Nec9YXT8VquHrSH0Q5X7a1Dyo118w1dad2a6ZkrO3Vf6iNpLxEUvF
 Wy0jby1mjEKRIw9YtOHOrgKMyLBbBeD4dzwQionO6Q0mKiHajLAiYzsQ0laTRndJLz/T Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vk7fr2awy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:34:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHSTkp104914;
        Mon, 14 Oct 2019 17:34:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vks076tgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:34:27 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9EHYQIv015116;
        Mon, 14 Oct 2019 17:34:26 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 10:34:26 -0700
Date:   Mon, 14 Oct 2019 10:34:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     sandeen@redhat.com, billodo@redhat.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] xfs: include QUOTA, FATAL ASSERT build options in
 XFS_BUILD_OPTIONS
Message-ID: <20191014173424.GX13108@magnolia>
References: <1567751206-128735-1-git-send-email-yukuai3@huawei.com>
 <20190916162406.GY2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916162406.GY2229799@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 09:24:06AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 06, 2019 at 02:26:46PM +0800, yu kuai wrote:
> > In commit d03a2f1b9fa8 ("xfs: include WARN, REPAIR build options in
> > XFS_BUILD_OPTIONS"), Eric pointed out that the XFS_BUILD_OPTIONS string,
> > shown at module init time and in modinfo output, does not currently
> > include all available build options. So, he added in CONFIG_XFS_WARN and
> > CONFIG_XFS_REPAIR. However, this is not enough, add in CONFIG_XFS_QUOTA
> > and CONFIG_XFS_ASSERT_FATAL. 
> > 
> > Signed-off-by: yu kuai <yukuai3@huawei.com>
> > ---
> >  fs/xfs/xfs_super.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> > index 763e43d..b552cf6 100644
> > --- a/fs/xfs/xfs_super.h
> > +++ b/fs/xfs/xfs_super.h
> > @@ -11,9 +11,11 @@
> >  #ifdef CONFIG_XFS_QUOTA
> >  extern int xfs_qm_init(void);
> >  extern void xfs_qm_exit(void);
> > +# define XFS_QUOTA_STRING	"quota, "
> >  #else
> >  # define xfs_qm_init()	(0)
> >  # define xfs_qm_exit()	do { } while (0)
> > +# define XFS_QUOTA_STRING
> >  #endif
> >  
> >  #ifdef CONFIG_XFS_POSIX_ACL
> > @@ -50,6 +52,12 @@ extern void xfs_qm_exit(void);
> >  # define XFS_WARN_STRING
> >  #endif
> >  
> > +#ifdef CONFIG_XFS_ASSERT_FATAL
> > +# define XFS_ASSERT_FATAL_STRING	"fatal assert, "
> 
> /me wonders if the space here will screw up any scripts that try to
> parse the logging string, but OTOH that seems pretty questionable to me.

Answer: There are already string components with spaces.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Also, whatever happened to adding a sysfs file so that scripts (ok let's
> be honest, xfstests) could programmatically figure out the capabilities
> of the running xfs module?
> 
> --D
> 
> > +#else
> > +# define XFS_ASSERT_FATAL_STRING
> > +#endif
> > +
> >  #ifdef DEBUG
> >  # define XFS_DBG_STRING		"debug"
> >  #else
> > @@ -63,6 +71,8 @@ extern void xfs_qm_exit(void);
> >  				XFS_SCRUB_STRING \
> >  				XFS_REPAIR_STRING \
> >  				XFS_WARN_STRING \
> > +				XFS_QUOTA_STRING \
> > +				XFS_ASSERT_FATAL_STRING \
> >  				XFS_DBG_STRING /* DBG must be last */
> >  
> >  struct xfs_inode;
> > -- 
> > 2.7.4
> > 
