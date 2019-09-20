Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62505C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 15:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3777A20882
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 15:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y/tGUO2v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404002AbfITPez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:34:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404022AbfITPev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 11:34:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KFT16g119320;
        Fri, 20 Sep 2019 15:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OrAKn0vbTufQuIDvyfe1IyfLykPmVok3HNUq2L7w7iY=;
 b=Y/tGUO2vRFDfaNG3ixBqQ5n80hXEX/DAFznbob15hwDf742OR8UyoCyxIjbtAG6yF1d8
 a3r1ADp3fenN3HgWe+7Hqo40ANst74URait8dvkOpamufNSvOyWf6wKy8RrJhWdjPu4t
 3JEeEWGM3/biCkpUr6X0/uQfDt2uN8aR3BQXXcZA5p34PppNHFmUkHLGwALOH6y78gX5
 EAqxkxBQBohewvL3OWUo4qy7iCAQTGLdmoDdKj+saDFquJiKqpwNdoEBwcRYOJMRRXU4
 ugxjphna+iuyTqDlUGxOMS4zxQXaIXEuSHTJ7DVP80/cyqoAsrY001ZXdvtIG6LqQysb jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v3vb53a1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 15:34:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KFSKgt187776;
        Fri, 20 Sep 2019 15:34:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v51as8mqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 15:34:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8KFYhdV028970;
        Fri, 20 Sep 2019 15:34:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 08:34:43 -0700
Date:   Fri, 20 Sep 2019 08:34:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190920153443.GR2229799@magnolia>
References: <20190920062327.14747-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920062327.14747-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 02:23:27PM +0800, Zorro Lang wrote:
> xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> between tests") get merged.
> 
> Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> mkfs.xfs detects an old primary superblock, it will write zeroes to
> all superblocks before formatting the new filesystem. But this won't
> be done if we wipe the first superblock(by merging above commit).
> 
> That means if we make a (smaller) sized xfs after wipefs, those *old*
> superblocks which created by last time mkfs.xfs will be left on disk.
> Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> will go to find those *old* SB at first. When it finds them,
> everyting goes wrong.
> 
> So I try to get XFS AG geometry(by default) and then try to erase all
> superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> 
> Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> V2 did below changes:
> 1) Use xfs_db to detect the real xfs geometry
> 2) Do a $FSTYP specified wipe before trying to wipefs all scratch devices
> 
> Thanks,
> Zorro
> 
>  common/rc  |  8 ++++++++
>  common/xfs | 20 ++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 66c7fd4d..56329747 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4045,6 +4045,14 @@ _try_wipe_scratch_devs()
>  {
>  	test -x "$WIPEFS_PROG" || return 0
>  
> +	# Do specified filesystem wipe at first
> +	case "$FSTYP" in
> +	"xfs")
> +		_try_wipe_scratch_xfs
> +		;;
> +	esac
> +
> +	# Then do wipefs on all scratch devices
>  	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
>  		test -b $dev && $WIPEFS_PROG -a $dev
>  	done
> diff --git a/common/xfs b/common/xfs
> index 1bce3c18..082a1744 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -884,3 +884,23 @@ _xfs_mount_agcount()
>  {
>  	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
>  }
> +
> +# Wipe the superblock of each XFS AGs
> +_try_wipe_scratch_xfs()
> +{
> +	local num='^[0-9]+$'
> +	local agcount
> +	local agsize
> +	local dbsize
> +
> +	agcount=`_scratch_xfs_get_sb_field agcount 2>/dev/null`
> +	agsize=`_scratch_xfs_get_sb_field agblocks 2>/dev/null`
> +	dbsize=`_scratch_xfs_get_sb_field blocksize 2>/dev/null`
> +
> +	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
> +		for ((i = 0; i < agcount; i++)); do
> +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> +				$SCRATCH_DEV >/dev/null;
> +		done
> +	fi

What happened to the loop that simulates a _scratch_mkfs_xfs run (to get
the AG geometry) and then zaps that too?  You need both zeroing loops to
make sure xfs/030 doesn't trip over old superblocks, right?

--D

> +}
> -- 
> 2.20.1
> 
