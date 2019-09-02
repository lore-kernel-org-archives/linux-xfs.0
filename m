Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97113C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67A78217F4
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/K5rpid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfIBRHO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 13:07:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfIBRHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 13:07:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82H46Ta074179;
        Mon, 2 Sep 2019 17:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eRhS92OIDJH367RnJZ5tOwlp6EARZWKCaqc90ltO5OU=;
 b=U/K5rpid1Ico03wB/Ojzd0lqAhyBoG0UMzrADypwvkoK6Jy8uxqfmoZgToQVJsfdc8qm
 29i0zC53hEBFtsmE2km2sqeP1N4kbJ3RADMEsN3KqFU0SbXzWhmK+LzEkoV1yeZhFF5T
 Yiln+BM295ZB3Co+q5HJw3kiey7KuGU7XIHljNC8cYjBh1/GC4GNXmM+dBgkdPYB3agB
 GRz+zpSNaRtaW2NVLI6yj8hx+bq9Y85o4ilfwML5uarFrhLuI7VgzT8tcH6jf8PwCu6c
 i9BXtetKrF1eophciz1MVjey2B8EMf3EthIRxGmSOxPgtpFpJREZI+2VrpJZFVJRRLlu Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2us70ar1j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 17:07:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82H44tw190147;
        Mon, 2 Sep 2019 17:07:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2us5pg1vys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 17:07:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x82H71r5020543;
        Mon, 2 Sep 2019 17:07:01 GMT
Received: from localhost (/10.159.145.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 10:07:01 -0700
Date:   Mon, 2 Sep 2019 10:07:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: new helper to skip xfs_check
Message-ID: <20190902170701.GT5354@magnolia>
References: <20190902135358.22134-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902135358.22134-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909020192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909020192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 02, 2019 at 09:53:58PM +0800, Zorro Lang wrote:
> The _xfs_check sometimes need to take too much memory, some quota
> related cases (e.g: xfs/442, generic/232 etc) always trigger OOM
> killer.
> 
>   [93334.020194] xfs_db invoked oom-killer: gfp_mask=0x6200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null), order=0, oom_score_adj=-1000
>   [93334.020206] xfs_db cpuset=/ mems_allowed=0
>   [93334.020213] CPU: 2 PID: 977 Comm: xfs_db Kdump: loaded Not tainted 4.18.0-139.el8.ppc64le+debug #1
>   [93334.020217] Call Trace:
>   [93334.020223] [c0000001cb163640] [c000000001035754] dump_stack+0xe8/0x164 (unreliable)
>   [93334.020229] [c0000001cb163690] [c0000000004a77dc] dump_header+0x7c/0x670
>   [93334.020234] [c0000001cb1637b0] [c0000000004a872c] oom_kill_process+0x26c/0x3d0
>   [93334.020239] [c0000001cb163800] [c0000000004aa438] out_of_memory+0x278/0x930
>   [93334.020244] [c0000001cb1638a0] [c0000000004bd6c8] __alloc_pages_nodemask+0x1ab8/0x1b70
>   [93334.020248] [c0000001cb163ae0] [c00000000058b8dc] alloc_pages_vma+0xec/0x660
>   [93334.020253] [c0000001cb163b50] [c00000000052b544] do_anonymous_page+0x124/0xac0
>   [93334.020258] [c0000001cb163bc0] [c000000000534918] __handle_mm_fault+0xda8/0x1b60
>   [93334.020263] [c0000001cb163cb0] [c000000000535948] handle_mm_fault+0x278/0x5a0
>   [93334.020268] [c0000001cb163d00] [c00000000008b30c] __do_page_fault+0x27c/0xe00
>   [93334.020273] [c0000001cb163df0] [c00000000008bec8] do_page_fault+0x38/0xf0
>   [93334.020278] [c0000001cb163e30] [c00000000000a904] handle_page_fault+0x18/0x38
>   [93334.020281] Mem-Info:
>   [93334.020286] active_anon:93769 inactive_anon:13540 isolated_anon:0
>   [93334.020286]  active_file:23 inactive_file:8 isolated_file:0
>   [93334.020286]  unevictable:0 dirty:0 writeback:0 unstable:0
>   [93334.020286]  slab_reclaimable:1543 slab_unreclaimable:8926
>   [93334.020286]  mapped:69 shmem:15 pagetables:76 bounce:0
>   [93334.020286]  free:2756 free_pcp:0 free_cma:0
> 
> The xfs_check related code is old, and nearly won't be maintained
> too much, test xfs_repair and xfs_scrub is much more important than
> xfs_check. But the xfstests always do a POST-xfs_check at the end of
> each cases. So I'd like to add a new helper named
> _require_scratch_no_xfs_check to skip xfs_check from some sub-cases.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Maybe this patch not the best way to deal with this issue. Please feel free to
> tell me if you have better idea.

I would just get rid of it (and have tried several times) but have not
had the time to check that xfs_repair can detect every corruption that
xfs_check can.

(To get started, I think it involves forking the dangerous_repair group
tests to run _xfs_check and xfs_repair -n one after the other to compare
outputs.)

--D

> Thanks,
> Zorro
> 
>  common/rc         |  1 +
>  common/xfs        | 26 ++++++++++++++++++++++++++
>  tests/generic/232 |  2 ++
>  tests/generic/233 |  2 ++
>  tests/generic/234 |  2 ++
>  tests/xfs/442     |  2 ++
>  6 files changed, 35 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e0b087c1..86eeda16 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1570,6 +1570,7 @@ _require_scratch()
>  {
>  	_require_scratch_nocheck
>  	touch ${RESULT_DIR}/require_scratch
> +	touch ${RESULT_DIR}/require_scratch.xfs_check
>  }
>  
>  # require a scratch dev of a minimum size (in kb)
> diff --git a/common/xfs b/common/xfs
> index 1bce3c18..80e6d1e8 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -168,11 +168,37 @@ _scratch_mkfs_xfs()
>  	return $mkfs_status
>  }
>  
> +# Usage: _require_scratch_no_xfs_check [limit_memsize]
> +#
> +# Due to xfs_check costs too much memory, sometimes it cause OOM when test on
> +# low memory machine. This function is used to skip xfs_check conditionally
> +# or unconditionally.
> +#
> +# Note: must be called after _require_scratch.
> +_require_scratch_no_xfs_check()
> +{
> +	local bound=$1
> +	local freemem
> +
> +	freemem=`_free_memory_bytes`
> +	if [ -n "$bound" ];then
> +		if [ $freemem -lt $bound ];then
> +			rm -f ${RESULT_DIR}/require_scratch.xfs_check
> +		fi
> +	else
> +		rm -f ${RESULT_DIR}/require_scratch.xfs_check
> +	fi
> +}
> +
>  # xfs_check script is planned to be deprecated. But, we want to
>  # be able to invoke "xfs_check" behavior in xfstests in order to
>  # maintain the current verification levels.
>  _xfs_check()
>  {
> +	if [ ! -f "${RESULT_DIR}/require_scratch.xfs_check" ];then
> +		return 0
> +	fi
> +
>  	OPTS=" "
>  	DBOPTS=" "
>  	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
> diff --git a/tests/generic/232 b/tests/generic/232
> index d5c20249..20841313 100755
> --- a/tests/generic/232
> +++ b/tests/generic/232
> @@ -52,6 +52,8 @@ _fsstress()
>  _supported_fs generic
>  _supported_os Linux
>  _require_scratch
> +# Do post xfs_check, if free memory size > 16G
> +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
>  _require_quota
>  
>  _scratch_mkfs > $seqres.full 2>&1
> diff --git a/tests/generic/233 b/tests/generic/233
> index c49bf252..7933d4b8 100755
> --- a/tests/generic/233
> +++ b/tests/generic/233
> @@ -56,6 +56,8 @@ _fsstress()
>  _supported_fs generic
>  _supported_os Linux
>  _require_scratch
> +# Do post xfs_check, if free memory size > 16G
> +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
>  _require_quota
>  _require_user
>  
> diff --git a/tests/generic/234 b/tests/generic/234
> index dc296df8..e843dc10 100755
> --- a/tests/generic/234
> +++ b/tests/generic/234
> @@ -72,6 +72,8 @@ test_setting()
>  _supported_fs generic
>  _supported_os Linux
>  _require_scratch
> +# Do post xfs_check, if free memory size > 16G
> +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
>  _require_quota
>  
>  # real QA test starts here
> diff --git a/tests/xfs/442 b/tests/xfs/442
> index 7a5f2e8e..9e891b51 100755
> --- a/tests/xfs/442
> +++ b/tests/xfs/442
> @@ -36,6 +36,8 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch_reflink
> +# Do post xfs_check, if free memory size > 16G
> +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
>  _require_quota
>  _require_command "$KILLALL_PROG" "killall"
>  
> -- 
> 2.17.2
> 
