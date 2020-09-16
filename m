Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FB9C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 03:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 034A921D94
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 03:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qSkwu5T6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIPDor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 23:44:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgIPDop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 23:44:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G3dadW029637;
        Wed, 16 Sep 2020 03:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=PmqigyLPhFXoDr4ZSgt5r0/mAd+AHL9Gn00TKwA4+Yg=;
 b=qSkwu5T6lKEKC22VtOngBsiWzWmf89r5IbJHNdC6TA5rJlnlyHzdUXBsXEg+Nt22tmLn
 aS7hPEH5mzESlVVkIw74XeFB+7wb6qPWWGFYk1Anzm7JTf0w7OXJxdhYPqNekOjEb+SL
 C5/ItW0Uf0E/QfT8kflpjLOozG0GWnV9WhGQ7JjqoLzq4ZJC3A7zas1MmIfaTggFsYE+
 Hrw51C196yHps9qLqtRnUSDGMGIaJ/iIT+lxCw3bj2zG2LVPuJwvFnAmKJTwC88lgShO
 ZJTzcmCv2cqyShbd6rSGi4auyP30sag3Gc1gQ0HKkCI7JYVEPclp0Hnse3DvbFLQ12YT vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrr0kun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 03:44:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G3dxrY181549;
        Wed, 16 Sep 2020 03:44:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33h7wq5efb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 03:44:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08G3iZ1W032380;
        Wed, 16 Sep 2020 03:44:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 03:44:35 +0000
Date:   Tue, 15 Sep 2020 20:44:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop extra transaction roll from inode extent
 truncate
Message-ID: <20200916034432.GF7955@magnolia>
References: <20200910132926.1147266-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200910132926.1147266-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=5
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 09:29:26AM -0400, Brian Foster wrote:
> The inode extent truncate path unmaps extents from the inode block
> mapping, finishes deferred ops to free the associated extents and
> then explicitly rolls the transaction before processing the next
> extent. The latter extent roll is spurious as xfs_defer_finish()
> always returns a clean transaction and automatically relogs inodes
> attached to the transaction (with lock_flags =3D=3D 0). This can
> unnecessarily increase the number of log ticket regrants that occur
> during a long running truncate operation. Remove the explicit
> transaction roll.
>=20
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>=20
> Just something I noticed when reading through the code based on Dave's
> recent EFI recovery reservation patches..
>=20
> Brian
>=20
>  fs/xfs/xfs_inode.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..7af99c7a2821 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1532,17 +1532,10 @@ xfs_itruncate_extents_flags(
>  		if (error)
>  			goto out;
> =20
> -		/*
> -		 * Duplicate the transaction that has the permanent
> -		 * reservation and commit the old transaction.
> -		 */
> +		/* free the just unmapped extents */
>  		error =3D xfs_defer_finish(&tp);
>  		if (error)
>  			goto out;
> -
> -		error =3D xfs_trans_roll_inode(&tp, ip);
> -		if (error)
> -			goto out;
>  	}
> =20
>  	if (whichfork =3D=3D XFS_DATA_FORK) {
> --=20
> 2.25.4
>=20
