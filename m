Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243ABC3A59D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 21:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E681C2332A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 21:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMulttqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbfHTVS7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 17:18:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbfHTVS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 17:18:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KLItGb193134;
        Tue, 20 Aug 2019 21:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sGxKJvxC8l7NMGIwOlSTK+w5kKzdKPlbp5f6YfDbl4I=;
 b=WMulttqLUvKfvVtM8/zDS3YfDoMmm3WEgQPQAJiiB17JnaQJ4+xddUuU3HeQEkSYWCi+
 OXsHPesLK3unGQy9OZfdOU6Lod+dgA8JAqExhyQZ4XihHojEr5rykyF1eV9jr6XdBk7L
 Udfel4g7CFlWfP1QF4aHxEh5/Hc87YekZXmvbwaD6jN5euLf73VtTZ3e1YriM7vMhqeV
 t0VZtYKkY4GSg/1XdIS/LZXHnwn0nZtJZ2PugA5XbPLAiRUwNcHerkH2+6JA60Hc6w/V
 krRAKXOudNVLaCV+c7u78+BqiSTjESDIJl9Cktijf8OsFpuq9Z5IBg1mq3k74D9SCZMX 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90thf17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 21:18:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KLIpvK029376;
        Tue, 20 Aug 2019 21:18:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ug2697e83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 21:18:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KLITHc018208;
        Tue, 20 Aug 2019 21:18:29 GMT
Received: from localhost (/10.159.155.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 14:18:29 -0700
Date:   Tue, 20 Aug 2019 14:18:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: fix geometry calls on older kernels for 5.2.1
Message-ID: <20190820211828.GC1037350@magnolia>
References: <7d83cd0d-8a15-201e-9ebf-e1f859270b92@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d83cd0d-8a15-201e-9ebf-e1f859270b92@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200193
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 03:47:29PM -0500, Eric Sandeen wrote:
> I didn't think 5.2.0 through; the udpate of the geometry ioctl means
> that the tools won't work on older kernels that don't support the
> v5 ioctls, since I failed to merge Darrick's wrappers.
> 
> As a very quick one-off I'd like to merge this to just revert every
> geometry call back to the original ioctl, so it keeps working on
> older kernels and I'll release 5.2.1.  This hack can go away when
> Darrick's wrappers get merged.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

For the four line code fix,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> I'm a little concerned that 3rd party existing code which worked fine
> before will now get the new XFS_IOC_FSGEOMETRY definition if they get
> rebuilt, and suddenly stop working on older kernels. Am I overreacting
> or misunderstanding our compatibility goals?

As for this question ^^^ ... <URRRK>.

I thought the overall strategy was to get everything in xfsprogs using
libfrog wrappers that would degrade gracefully on old kernels.

For xfsdump/restore, I think we should just merge it into xfsprogs and
then it can use our wrappers.

For everything else... I thought the story was that you shouldn't really
be using xfs ioctls unless you're keeping up with upstream.

<shrug> Feel free to differ, that's just a braindump of my shattered
mind. :P

--D

> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index f1158a79..253b706c 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -720,7 +720,10 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
>  #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> -#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> +/* For backwards compatibility in 5.2.1, just for now */
> +/* #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom_v5) */
> +#define XFS_IOC_FSGEOMETRY XFS_IOC_FSGEOMETRY_V4
> +
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  /* reflink ioctls; these MUST match the btrfs ioctl definitions */
> 
