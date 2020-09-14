Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08052C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B42A0208E4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rGFSYagq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgINTYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 15:24:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINTYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 15:24:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EJK0kL056047;
        Mon, 14 Sep 2020 19:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wqsDsYDZjxCRvxm5oAnoIlA0qb5f7lwTYglVJDM1eso=;
 b=rGFSYagquogv5zk0UGV72ISSsBymnJ8mJDxvSuVoLV8rrwjnf/tuTUZiGLFf7gnv3hoL
 D1XtIqw102pP/s2HDikYxZ12luNPEH5JIuTw8p59E4ByCitjedb93y80dZPWgxUn9c9X
 eXSCVNueRQRJHORoILiN72lm7e77XPLT671V6SHsMFTVJTEIeWYK7yRED7NeVHIxX/Kg
 MEXsygwVIZH3PVHn1mVK50U2C+q4EI3nIbgHaEaHEkNTW9SCTsQ/MvHMwJpCIvIJsvAf
 S8mv8K2X/TM4JNmYVkgwINBfXyxL8w82LQ3gUpakFBcMZwR+1nLndQnZdMUd8BimLA0g Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqrn6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 19:24:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EJLO2V194742;
        Mon, 14 Sep 2020 19:24:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h882ce49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 19:24:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08EJO97B000645;
        Mon, 14 Sep 2020 19:24:09 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 19:24:09 +0000
Date:   Mon, 14 Sep 2020 12:24:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH V2] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <20200914192408.GZ7955@magnolia>
References: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
 <7c05a2d1-e9aa-7c5c-0f99-912d29b7c583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c05a2d1-e9aa-7c5c-0f99-912d29b7c583@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 02:00:52PM -0500, Eric Sandeen wrote:
> When a too-small device is created with stripe geometry, we hit an
> assert in align_ag_geometry():
> 
> # truncate --size=10444800 testfile
> # mkfs.xfs -dsu=65536,sw=1 testfile 
> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
> 
> This is because align_ag_geometry() finds that the size of the last
> (only) AG is too small, and attempts to trim it off.  Obviously 0
> AGs is invalid, and we hit the ASSERT.
> 
> Fix this by skipping the last-ag-trim if there is only one AG, and
> add a new test to validate_ag_geometry() which offers a very specific,
> clear warning if the device (in dblocks) is smaller than the minimum
> allowed AG size.
> 
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Seems fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: remove stray printf, sorry
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..2139aedb 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1038,6 +1038,15 @@ validate_ag_geometry(
>  	uint64_t	agsize,
>  	uint64_t	agcount)
>  {
> +	/* Is this device simply too small? */
> +	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
> +		fprintf(stderr,
> +	_("device (%lld blocks) too small, need at least %lld blocks\n"),
> +			(long long)dblocks,
> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
> +		usage();
> +	}
> +
>  	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>  		fprintf(stderr,
>  	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
> @@ -2827,11 +2836,11 @@ validate:
>  	 * and drop the blocks.
>  	 */
>  	if (cfg->dblocks % cfg->agsize != 0 &&
> +	     cfg->agcount > 1 &&
>  	     (cfg->dblocks % cfg->agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog))) {
>  		ASSERT(!cli_opt_set(&dopts, D_AGCOUNT));
>  		cfg->dblocks = (xfs_rfsblock_t)((cfg->agcount - 1) * cfg->agsize);
>  		cfg->agcount--;
> -		ASSERT(cfg->agcount != 0);
>  	}
>  
>  	validate_ag_geometry(cfg->blocklog, cfg->dblocks,
> 
> 
