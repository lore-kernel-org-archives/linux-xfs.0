Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D29C33CA8
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872E520838
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:22:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iEDq0qbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgAHQWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:22:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729468AbgAHQWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 11:22:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GDHBK021843;
        Wed, 8 Jan 2020 16:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ijmVGq8pxhtpSqE8zsb3tDptvDuzMJoa7HOUihySP7g=;
 b=iEDq0qbW/eG08a1WPtCpEGFt3tC83jP73Mp2TN3UKDSJdlMB3pb2ACWAzVbxI3T1ARHe
 z0Ak6wFKYTgleC4uPxdZ/KKt5jSNqDg9W8zzyXcHau9mlPlNxU6mB6ktxkIMkdbm1QUr
 pXPLkkad6bOe0zeU2OWT6oWp2pRrdDAtBm7dAFEFVjmFuFiHXxIyTIY0UIzmIY1FNVyU
 LFT/Z1CD5IwHKqLgYhzdxl9T8rdW8zwn0XZRQZJMKVnWKZ3+Cu/CQPFncCPFSvsi9RTp
 skCVxy0PmeZTTkqVmHq7iSnB3YqxgMW0tU+T6309nenNUGJowR1RjwNFgcseLvQQlOKl FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xakbqvvv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:22:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GEG2J044120;
        Wed, 8 Jan 2020 16:22:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpct0k14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:22:30 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 008GMTU7026840;
        Wed, 8 Jan 2020 16:22:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 08:22:29 -0800
Date:   Wed, 8 Jan 2020 08:22:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     guaneryu@gmail.com, jbacik@fusionio.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, zhengbin13@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
Message-ID: <20200108162227.GD5552@magnolia>
References: <20200108092758.41363-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108092758.41363-1-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 05:27:58PM +0800, yu kuai wrote:
> The cmd used in xfs_db to corrupt xattr is "blocktrash -x 32
> -y $((blksz * 8)) -n8 -3", which means select random 8 bit from 32 to
> end of the block, and the changed bits are randomized. However,
> there is a small chance that corrupting xattr failed because irrelevant
> bits are chossen or the chooosen bits are not changed, which lead to
> output missmatch:
> QA output created by 126                    QA output created by 126
> + create scratch fs                         + create scratch fs
> + mount fs image                            + mount fs image
> + make some files                           + make some files
> + check fs                                  + check fs
> + check xattr                               + check xattr
> + corrupt xattr                             + corrupt xattr
> + mount image && modify xattr               + mount image && modify xattr
> + repair fs                                 + repair fs
> + mount image (2)                           + mount image (2)
> + chattr -R -i                              + chattr -R -i
> + modify xattr (2)                          + modify xattr (2)
>                                             > # file: tmp/scratch/attrfile
>                                             > user.x00000000="0000000000000000"
>                                             >
> + check fs (2)                              + check fs (2)
> 
> Fix the problem by adding a seed for random processing to select same
> bits each time, and inverting the selected bits.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  tests/xfs/126 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/126 b/tests/xfs/126
> index 4f9f8cf9..9b57e58b 100755
> --- a/tests/xfs/126
> +++ b/tests/xfs/126
> @@ -37,7 +37,7 @@ test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
>  _require_attrs
>  _require_populate_commands
>  _require_xfs_db_blocktrash_z_command
> -test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
> +test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -2"

TBH I've wondered if blocktrash -3 and fuzz-random should snapshot the
buffer before randomizing it and try again if the contents don't change?
I suspect most of our fuzz tests expect "randomize the ____" to return
with ____ full of random junk, not the exact same contents as before.

--D

>  rm -f $seqres.full
>  
> @@ -72,7 +72,7 @@ echo "+ corrupt xattr"
>  loff=1
>  while true; do
>  	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
> -	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
> +	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -s 1024 -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
>  	loff="$((loff + 1))"
>  done
>  
> -- 
> 2.17.2
> 
