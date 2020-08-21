Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34A1C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 14:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7524F2086A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 14:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsV/K5U5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgHUOqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 10:46:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgHUOqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 10:46:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LEh2VU144141;
        Fri, 21 Aug 2020 14:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v+7CUCpCI7J2B6hmiUpsmOndi+P4GlMJ9NVdMGCcsoQ=;
 b=HsV/K5U5g8/jMjbOdc+Rhvlw/BhlbnNVw5JiaAD89i2TglbGMlhlkZuhoZob5nqiq6/F
 gt8wZf0gGFj+aU+vYJ8txxBmEq0cnsoMCmmyRaLk2ZO2m+yXLX6K73wczJA6RKrec6sV
 23jEPILdX1jag5bhe3mv26Ig/V1rXKnvmF1HZ2cH4kBF+ZRbfCa8Mt+NkMsiu7JleEiQ
 y7q3L5eRVke9hFx1LaOszMr9Yh51c8VvAq8Of4I09sTbAA8WyfvkEexm3ctUL3sq0LZm
 0K4ZvUR3qQBvjgl0/bpSfOdx4Z2iyihT8tzyQ9qNwgjSXEGV39Ay3cLxdLJm0YMNsY2I 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3327gca6t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 14:46:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LEhuOX009609;
        Fri, 21 Aug 2020 14:46:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 330pvrx7md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 14:46:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07LEk4mB017167;
        Fri, 21 Aug 2020 14:46:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 14:46:04 +0000
Date:   Fri, 21 Aug 2020 07:46:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: short circuit type_f if type is unchanged
Message-ID: <20200821144603.GL6096@magnolia>
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <784ed247-0467-093b-1113-ff80a1289cbd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784ed247-0467-093b-1113-ff80a1289cbd@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:05:37PM -0500, Eric Sandeen wrote:
> There's no reason to go through the type change code if the
> type has not been changed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/type.c b/db/type.c
> index 3cb1e868..572ac6d6 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -216,6 +216,8 @@ type_f(
>  		tt = findtyp(argv[1]);
>  		if (tt == NULL) {
>  			dbprintf(_("no such type %s\n"), argv[1]);
> +		} else if (iocur_top->typ == tt) {
> +			return 0;

Doesn't this mean that verifier errors won't be printed if the user asks
to set the type to the current type?  e.g.

xfs_db> agf 0
xfs_db> addr bnoroot
xfs_db> fuzz -d level random
Allowing fuzz of corrupted data with good CRC
level = 59679
xfs_db> type bnobt
Metadata corruption detected at 0x5586779a7b18, xfs_bnobt block 0x8/0x1000
xfs_db> type bnobt
Metadata corruption detected at 0x5586779a7b18, xfs_bnobt block 0x8/0x1000

<shrug> OTOH, db doesn't consistently have that behavior either --
inodes only behave like that for crc errors, so maybe this is fine.

Eh whatever, it's the debugging tool, you should be paying attention
anyways.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		} else {
>  			if (iocur_top->typ == NULL)
>  				dbprintf(_("no current object\n"));
> 
