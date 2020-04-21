Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8EDC54FD0
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 15:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD4F2071E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 15:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tT1pBZTx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDUPh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:37:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgDUPh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 11:37:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LFYsaK158690;
        Tue, 21 Apr 2020 15:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=92JRpadtmq1JsM5Zkmp+p01bMR+UFRmZ/CT+85uhmHI=;
 b=tT1pBZTxwKLL21FWdWh4aio1qZPD9dSS8uTrgy/UPuEkWiXsuU0zdGxxw4cCehAcSmQc
 It00gh5YEVerr9opIPUTFDh/T7ackxC7Pj1g3VswN7hmwtKYZnivbpRBZykpS2+A1XyW
 lZQkMFEaPP+Y7divDjKoiftsMAxWIIgiBh+AHqqGKp8gjh6obMfOZmqtwnuDJgl8q9MO
 lsHjVK3MWV1FUMRKrjUXxFQLQ0RvNWzcgyFTDMglnrTJwAgar2sRwxCzJ+R2lsOfpqRU
 BvGdOCKtUeLTx3D0TzSoh8PnjIkoz/O7enG/CpboRPMcQgew/Uu5yzuXw+kK0mKUIJVC Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30grpgj64s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 15:37:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LFWUvM031195;
        Tue, 21 Apr 2020 15:37:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30gbbe488w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 15:37:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03LFbKZ8025957;
        Tue, 21 Apr 2020 15:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 08:37:19 -0700
Date:   Tue, 21 Apr 2020 08:37:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/fuzzy: don't attempt online scrubbing unless
 supported
Message-ID: <20200421153717.GY6742@magnolia>
References: <20200421113643.24224-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421113643.24224-1-ailiop@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 01:36:42PM +0200, Anthony Iliopoulos wrote:
> Many xfs metadata fuzzing tests invoke xfs_scrub to detect online errors
> even when _scratch_xfs_fuzz_metadata is invoked with "offline". This
> causes those tests to fail with output mismatches on kernels that don't
> enable CONFIG_XFS_ONLINE_SCRUB. Bypass scrubbing when not supported.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
>  common/fuzzy | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index 988203b1..83ddc3e8 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -238,7 +238,7 @@ __scratch_xfs_fuzz_field_test() {
>  	if [ $res -eq 0 ]; then
>  		# Try an online scrub unless we're fuzzing ag 0's sb,
>  		# which scrub doesn't know how to fix.
> -		if [ "${repair}" != "none" ]; then
> +		if _supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}"; then

Huh?

This changes the behavior of the repair=none fuzz tests, which mutate
filesystems and then write to them without running any checking tools
whatsoever to see if we can trip over the mutations with only regular
filesystem operations.  Whereas before, we'd skip xfs_scrub, now we
always run it if it's supported.

The open-coded repair conditionals scattered through this funciton
probably ought to be refactored into helpers, e.g.

__fuzz_want_scrub_check() {
	local repair="$1"
	local field="$2"

	test "${repair}" != "none" && \
		_supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}" && \
		[ "${field}" != "sb 0" ]
}

if [ $res -eq 0 ]; then
	# Try an online scrub...
	if __fuzz_want_scrub_check "${repair}" "${field}"; then
		_scratch_scrub -n -a 1 -e continue 2>&1
		...

--D

>  			echo "++ Online scrub"
>  			if [ "$1" != "sb 0" ]; then
>  				_scratch_scrub -n -e continue 2>&1
> -- 
> 2.26.2
> 
