Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16ACC10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9455F21783
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WeUomPOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbfJCO5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 10:57:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJCO5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 10:57:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93En3MK071886;
        Thu, 3 Oct 2019 14:56:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=G1ZLF9Wn+vt/iAoPOlLl24mXk3FAnN8oaz5y1f80EGk=;
 b=WeUomPOy2mBPMG7Va1wyjoiVuWEL5jHdGQ9hmTw0v4kSqIDfz33Q3uOhXfj9kBu6liAQ
 aXV39bGqNtpYHi0vF+8JpV0iGbtM2TNSi1QGiPiurjW6T0TQihzOfEaMiNWvf1P8C+7L
 hy96RWL1Dxriy+cMlzIYxPLY6gdAhe1j2ZfqCtxfjOBeJe8iTQvjlfhMVHdBQLKRlYo5
 BMiC2eYbSx+frhdNw+UvWkNPMnt4NwrrPBaTpdfq2t/RrE/DIpZDZwAph20z3QD3HPUH
 mfEiHNuZVKF7jTrFVShwDlE5dGCS9j+5r4Ico7KkPi8tWD+iWaF4sAUyDfp8O/5j8K4s KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfqmnvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 14:56:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93Es5I2170732;
        Thu, 3 Oct 2019 14:56:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vdjxj0wwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 14:56:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x93EubAI028185;
        Thu, 3 Oct 2019 14:56:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 07:56:37 -0700
Date:   Thu, 3 Oct 2019 07:56:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v4 02/17] vfs: add missing blkdev_put() in get_tree_bdev()
Message-ID: <20191003145635.GJ13108@magnolia>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009832879.13858.5261547183927327078.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009832879.13858.5261547183927327078.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:25:28PM +0800, Ian Kent wrote:
> There appear to be a couple of missing blkdev_put() in get_tree_bdev().

No SOB, not reviewable......

--D

> ---
>  fs/super.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index a7f62c964e58..fd816014bd7d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1268,6 +1268,7 @@ int get_tree_bdev(struct fs_context *fc,
>  	mutex_lock(&bdev->bd_fsfreeze_mutex);
>  	if (bdev->bd_fsfreeze_count > 0) {
>  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		blkdev_put(bdev, mode);
>  		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
>  		return -EBUSY;
>  	}
> @@ -1276,8 +1277,10 @@ int get_tree_bdev(struct fs_context *fc,
>  	fc->sget_key = bdev;
>  	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -	if (IS_ERR(s))
> +	if (IS_ERR(s)) {
> +		blkdev_put(bdev, mode);
>  		return PTR_ERR(s);
> +	}
>  
>  	if (s->s_root) {
>  		/* Don't summarily change the RO/RW state. */
> 
