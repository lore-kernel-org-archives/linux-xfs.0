Return-Path: <SRS0=0PGo=3W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96B5C3524C
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Feb 2020 19:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 887C72082F
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Feb 2020 19:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DjdJlW7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBBTyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Feb 2020 14:54:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgBBTyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Feb 2020 14:54:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 012JrEH4169747;
        Sun, 2 Feb 2020 19:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xCvVKNyTbCLiVMZlZ/qKKWNLLwXtm0FuE7phomgC3wA=;
 b=DjdJlW7aOVCieSjOFRQO2Ds8Jti6qBT8E8M+beTt4Ezk14rh5VGUh+vrt88pQcPh4YRt
 rj7FXGT7SGQajQGvxaTevnXO7WHqSOiEX2MMDfhVWlOnC5QDva37HczHvXnqOML16mzu
 X6ZjgpA+uCdFeKcPBnxRR5Nh/1SmKBopesGOTMsDoX1sqLw7X4PVwaq66g0NBywryv6X
 9fdo/htvUc6/4U813bBZ7WWuhKRRKBgFV1Hgi2JUWNY+vIsF7I4xE2sNCsexZ5PV/9NU
 xmiJCDN0Lj2ovYgufL1ndVHUyv11FrQovwnE/g+C6EfIUd5+J28uZXYFh/x7PW6CDnlj mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xwyg98k1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 02 Feb 2020 19:54:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 012JjYdW047838;
        Sun, 2 Feb 2020 19:54:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xwjt1ttyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 02 Feb 2020 19:54:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 012JsIa2011662;
        Sun, 2 Feb 2020 19:54:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 02 Feb 2020 11:54:18 -0800
Date:   Sun, 2 Feb 2020 11:54:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs/020: call _notrun if we can't create a 60t
 sparse image
Message-ID: <20200202195418.GD6869@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915147960.2374854.2067220014390694914.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915147960.2374854.2067220014390694914.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002020158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002020159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we can't create the 60T sparse image for testing repair on a large fs
> (such as when running on 32-bit), don't bother running the rest of the
> test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/020 |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/tests/xfs/020 b/tests/xfs/020
> index 61da4101..e39c3482 100755
> --- a/tests/xfs/020
> +++ b/tests/xfs/020
> @@ -42,6 +42,8 @@ echo "Silence is golden"
>  
>  fsfile=$TEST_DIR/fsfile.$seq
>  rm -f $fsfile
> +truncate -s 60t $fsfile || _notrun "Cannot create 60T sparse file for test."

Um, this got committed with "xfs_io -x -c 'truncate 60t' and not as
written, which means that this test does not work on i386 because xfs_io
doesn't return nonzero when the truncate syscall fails.  Will send
patch.

--D

> +rm -f $fsfile
>  
>  $MKFS_PROG -t xfs -d size=60t,file,name=$fsfile >/dev/null
>  $XFS_REPAIR_PROG -f -o ag_stride=32 -t 1 $fsfile >/dev/null 2>&1
> 
