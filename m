Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101C0C432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDB1A214DA
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 03:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rumm5NSB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411512AbfIYDVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 23:21:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730206AbfIYDVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 23:21:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8P3Evco121425;
        Wed, 25 Sep 2019 03:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Y5040NzHNtAA2BrQC2qlPkX9T9KsIdvYvvqwEgfF/qc=;
 b=Rumm5NSBQ9lY8Rml/9wQADHzfgTRc5ppN7tw+aVMK8hIFYwPii4Q8oA3Yq2I40drfy3Z
 PzouNiCE7eyjCLh/uQ9JQn3ZDAFitqfGBdsQYQ8Zcyq8bD5NKpnA+cEqBwyC6ZmQUOq8
 BznjyiAIL6+4y8hzXQfx7GpVW0+le7fgUZ7ZYPTu0d9HSUVwJKm3/ekivxzFPVeUkWJI
 76++J0m/235QWh5PJqtXo6QYv6qUIHr9GTL3y3AnpVArfILi6S+ziuSX0H/BBO4/GEg2
 uejfhKRvLbziuhR2fys4T1KkeOIxs9pWTGtFfME1rW9AnH9del83D3sGSwSBt2pYaHk+ Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tsup6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 03:21:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8P3IsC1132006;
        Wed, 25 Sep 2019 03:21:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnx2hjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 03:21:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8P3L5hJ003746;
        Wed, 25 Sep 2019 03:21:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 20:21:05 -0700
Date:   Tue, 24 Sep 2019 20:21:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190925032104.GC9913@magnolia>
References: <20190924100919.28242-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924100919.28242-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 06:09:19PM +0800, Zorro Lang wrote:
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
> So I try to wipe each XFS superblock if there's a XFS ondisk, then
> try to erase superblock of each XFS AG by default mkfs.xfs geometry.
> Thanks Darrick J. Wong helped to analyze this issue.
> 
> Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Looks ok to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Hi,
> 
> All changes in V3 is under:
> # Try to wipe each SB by default mkfs.xfs geometry
> ...
> ...
> 
> Thanks,
> Zorro
> 
>  common/rc  |  8 ++++++++
>  common/xfs | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
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
> index 1bce3c18..706ddf85 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -884,3 +884,43 @@ _xfs_mount_agcount()
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
> +	# Try to wipe each SB if there's an existed XFS
> +	agcount=`_scratch_xfs_get_sb_field agcount 2>/dev/null`
> +	agsize=`_scratch_xfs_get_sb_field agblocks 2>/dev/null`
> +	dbsize=`_scratch_xfs_get_sb_field blocksize 2>/dev/null`
> +	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
> +		for ((i = 0; i < agcount; i++)); do
> +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> +				$SCRATCH_DEV >/dev/null;
> +		done
> +	fi
> +
> +	# Try to wipe each SB by default mkfs.xfs geometry
> +	local tmp=`mktemp -u`
> +	unset agcount agsize dbsize
> +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> +			print STDOUT "agcount=$1\nagsize=$2\n";
> +		}
> +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> +			print STDOUT "dbsize=$1\n";
> +		}' > $tmp.mkfs
> +
> +	. $tmp.mkfs
> +	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
> +		for ((i = 0; i < agcount; i++)); do
> +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> +				$SCRATCH_DEV >/dev/null;
> +		done
> +	fi
> +	rm -f $tmp.mkfs
> +}
> -- 
> 2.20.1
> 
