Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89575C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 17:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C8622D58
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 17:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbhAERc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 12:32:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33914 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAERc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 12:32:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105HSqCZ011284;
        Tue, 5 Jan 2021 17:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PuciWH11jiVANDjy/k7JXxf92CnSQttqHdqP/OmTB0Q=;
 b=bJkhE8fP0EScfehQUkFHG7p0OzF2Xy7J2dGTROZ2zcSS8n/SdtMBTpK7+PFrqQNT9foG
 MH0vbmXRLSW7IPfpl9FKA5CM3MWS4XGODUbgBbpI84NWCIAnbZY2Pd3WOeOU2ioq91P/
 AGtbP+m+F0FprKcYxa3SukqjjLJ5A4Voxcku4WOiV70OJPsn60kMKZ+yjpbXP55fFPBX
 d9KV3uL4MqO+EJ7ro1Gg/9oMpod7qtdZBh94XtU3agqKQdxnyKnRGnm9xQB6z797fK+V
 ZRoXuZRrGvJoMagOJAjCm442DFBFixTTi//JdKhDeZjdE7Wtxs0apHFrQQwWMt7Vi6ME 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35tebasye8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 17:31:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105HUOAf175210;
        Tue, 5 Jan 2021 17:31:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35uxnsyckf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 17:31:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105HVfkb007005;
        Tue, 5 Jan 2021 17:31:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 17:31:41 +0000
Date:   Tue, 5 Jan 2021 09:31:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic/388: randomly recover via read-only mounts
Message-ID: <20210105173141.GY6918@magnolia>
References: <20210105115844.293207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105115844.293207-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050103
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 05, 2021 at 06:58:44AM -0500, Brian Foster wrote:
> XFS has an issue where superblock counters may not be properly
> synced when recovery occurs via a read-only mount. This causes the
> filesystem to become inconsistent after unmount. To cover this test
> case, update generic/388 to switch between read-only and read-write
> mounts to perform log recovery.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Tweak ro -> rw mount cycle error message to be unique.
> v1: https://lore.kernel.org/fstests/20201217145941.2513069-1-bfoster@redhat.com/
> 
>  tests/generic/388 | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/388 b/tests/generic/388
> index 451a6be2..2f97f266 100755
> --- a/tests/generic/388
> +++ b/tests/generic/388
> @@ -66,8 +66,14 @@ for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
>  		ps -e | grep fsstress > /dev/null 2>&1
>  	done
>  
> -	# quit if mount fails so we don't shutdown the host fs
> -	_scratch_cycle_mount || _fail "cycle mount failed"
> +	# Toggle between rw and ro mounts for recovery. Quit if any mount
> +	# attempt fails so we don't shutdown the host fs.
> +	if [ $((RANDOM % 2)) -eq 0 ]; then
> +		_scratch_cycle_mount || _fail "cycle mount failed"
> +	else
> +		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
> +		_scratch_cycle_mount || _fail "cycle rw mount failed"
> +	fi
>  done
>  
>  # success, all done
> -- 
> 2.26.2
> 
