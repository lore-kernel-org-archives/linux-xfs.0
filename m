Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27FBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E50321D94
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbhADSfL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:35:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbhADSfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 13:35:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104IP5lL091190;
        Mon, 4 Jan 2021 18:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7yPVJBok261C1tzUJCuLNeerUX+IAy+AetWgqSB5PVA=;
 b=xvypDlMWjC+3GOql/vvF/1DkTyzylr46+tw6YPJXtF8mQjNVIbtEhWeXb3mLSuYaGdTQ
 PbLGr19myZFY6zBrHYNiY+YOvD6nY/vLEXvDHrlNpEfxnP0dnSOgSsblbuyQSwcxRl1X
 hsaAC0KVtxzOuPBe2avuQTJLCFoNYSqCrzhde9ue1lcc26tbptt38SZELJgEebKxIS7w
 DfLna2urxPXK6pOnDlpj+wDzVSTI36zxj7ftJgXkzYWIIesy+af5oZI5ZyqLmJNzIRcr
 3UoFpSTMQF3Eo02a3zXJ2/dJ+c2HG32qVqT8t5krjfGp3wvh8hf3wqRFGyscG3A6OYJc DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35tgsknkva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 18:34:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104ISlkh093775;
        Mon, 4 Jan 2021 18:34:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35uxnrjkvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 18:34:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104IYPml003598;
        Mon, 4 Jan 2021 18:34:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 10:34:25 -0800
Date:   Mon, 4 Jan 2021 10:34:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/388: randomly recover via read-only mounts
Message-ID: <20210104183424.GA6919@magnolia>
References: <20201217145941.2513069-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217145941.2513069-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040119
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 17, 2020 at 09:59:41AM -0500, Brian Foster wrote:
> XFS has an issue where superblock counters may not be properly
> synced when recovery occurs via a read-only mount. This causes the
> filesystem to become inconsistent after unmount. To cover this test
> case, update generic/388 to switch between read-only and read-write
> mounts to perform log recovery.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> I didn't think it was worth duplicating generic/388 to a whole new test
> just to invoke log recovery from a read-only mount. generic/388 is a
> rather general log recovery test and this preserves historical behavior
> of the test.
> 
> A prospective fix for the issue this reproduces on XFS is posted here:
> 
> https://lore.kernel.org/linux-xfs/20201217145334.2512475-1-bfoster@redhat.com/
> 
> Brian
> 
>  tests/generic/388 | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/388 b/tests/generic/388
> index 451a6be2..cdd547f4 100755
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
> +		_scratch_cycle_mount || _fail "cycle mount failed"

I would change that third failure message to something distinct, like:

_fail "cycle remount failed"

To give us extra clues as to which branch encountered failure.
This looks like a fun way to find new bugs. :)

--D

> +	fi
>  done
>  
>  # success, all done
> -- 
> 2.26.2
> 
