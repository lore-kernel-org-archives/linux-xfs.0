Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A022EC35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB4E21D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fAIIDpEF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYA4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:56:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgBYA4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:56:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P0nELF104389;
        Tue, 25 Feb 2020 00:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=31MRzhnfvXmHfHuyInzX+kikBMRvqfs+ou3IuqKMLEg=;
 b=fAIIDpEFXGP7aUZmMbxuITAAmMV9SF9AJY+U/9yISYzNWrZqiR16phEQQ+PAvb7NvVPQ
 epEjRTgrLKhP7owrIhI/PBN8pX1Leaq0aH3RCgyJrQLpr/+ndDaKYxuBgbaAEQmu3bPs
 KWsaHuLfYGjmjjtJ9Vh2BKnXWXwA8VxKJbcwUymrhBqjXhfH0Oz3bmQDeEDGBt94rrYj
 dCw+vSo2J4IciQ114D0eXK7j8G0xSk7FTz1Dw6/tZAPIkQcgOsaB2AWrlQZBk1yuJ8mh
 xm8wIbenHF7bPRg4hJfGWlKXk7n/WmuffmQYTqS/rPM3gLgZahqN0DT1RC1Lwrsbrc2k ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q858-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:55:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P0lvEP116871;
        Tue, 25 Feb 2020 00:55:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ybe12h2ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:55:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0ts12004722;
        Tue, 25 Feb 2020 00:55:54 GMT
Received: from localhost (/10.159.137.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:55:53 -0800
Date:   Mon, 24 Feb 2020 16:55:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] xfs: mark ARM OABI as incompatible in Kconfig
Message-ID: <20200225005553.GD6740@magnolia>
References: <ee78c5dd-5ee4-994c-47e2-209e38a9e986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee78c5dd-5ee4-994c-47e2-209e38a9e986@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:49:12PM -0800, Eric Sandeen wrote:
> The old ARM OABI's structure alignment quirks break xfs disk structures,
> let's just move on and disallow it rather than playing whack-a-mole
> for the infrequent times someone selects this old config, which is
> usually during "make randconfig" tests.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index e685299eb3d2..043624bd4ab2 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -2,6 +2,8 @@
>  config XFS_FS
>  	tristate "XFS filesystem support"
>  	depends on BLOCK
> +	# We don't support OABI structure alignment on ARM

Should this limitation be documented in the help screen?

> +	depends on (!ARM || AEABI)
>  	select EXPORTFS
>  	select LIBCRC32C
>  	select FS_IOMAP
> 
