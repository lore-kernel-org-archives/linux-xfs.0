Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F77FFA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563D721D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QgGNqoux"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390923AbfJPS2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:28:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390895AbfJPS2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:28:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIm5c146239;
        Wed, 16 Oct 2019 18:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CFfiFxiHTict5HtDumOROlvAfbY4dfmmctFAmPjjTPk=;
 b=QgGNqouxBtwdRoUSZosQ7cPUDW1Xz+w/xZ//s9FakZGu3bMEjLyWvQ/c5+Ao2aiGObXY
 FNhuWi2W/N/UrBT13UWewFP+9zXR4iAru+0tHpVCoIUBZeMfA1l8xkPo7dxi4BwV/zot
 gNsaKcz+V/HDNfIT+QyLR4TWLz2R1F0rtRS2IzB6VRty06fMm+OQZt6YmEf+V2uvciiz
 J4Pi4hFTwaAorKhFPnRZDipR2++LlA7wvUk6SfSZ0esQ3KY0TS9X60CiOStUapUgLXzs
 XGpxYz0ADaNVts5XduoxW9ZBgtgVdNfbGrQTlExbCUKucle/PBh4WWrkDSf6pPHkZ/ah zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vk68ury8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:28:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIANe121914;
        Wed, 16 Oct 2019 18:28:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vnxva8nf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:28:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9GISUOZ032331;
        Wed, 16 Oct 2019 18:28:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 18:28:29 +0000
Date:   Wed, 16 Oct 2019 11:28:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 05/12] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
Message-ID: <20191016182828.GE13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118646832.9678.14900204464012668551.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118646832.9678.14900204464012668551.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:08AM +0800, Ian Kent wrote:
> When CONFIG_XFS_QUOTA is not defined any quota option is invalid.
> 
> Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
> has been given is a little misleading so use a simple m_qflags != 0
> check to make the intended use more explicit.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

With hch's comments addressed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5876c2b551b5..f8770206b66e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -349,7 +349,7 @@ xfs_parseargs(
>  	}
>  
>  #ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +	if (mp->m_qflags != 0) {
>  		xfs_warn(mp, "quota support not available in this kernel.");
>  		return -EINVAL;
>  	}
> 
