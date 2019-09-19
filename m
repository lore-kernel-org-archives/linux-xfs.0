Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7691EC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 16:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A10621927
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 16:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vy7HVRuy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbfISQCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 12:02:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387576AbfISQCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 12:02:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JFsSSY186479;
        Thu, 19 Sep 2019 16:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YtLpLLWvEuYUOgGOHsVSPZ2fL07n9dHJPdSVRmeUPm8=;
 b=Vy7HVRuyQEKlEYYVSEDm6GIouQH6wgwj/E5a4uw8GU3/s2TXxRm9vxZiTjFetOrF30vp
 g/hc8VYLSj2jMT8+APSikV5WNbeukDo+IQUMxv6Ue0dWcw5Slv5fH53pv5V/GasZrFKS
 qA190RAZIZsEIvC7Bn9LVBHiJi6iFC6hN0TeJY3ct3sNypItYHJX70nbQp0uKUYneHj7
 sLfChktAnwforHpBRHy4KmqD8lCI+01P2tOyqN+2YMl3CI5KJtFfQmXom3yx7T77CY1H
 nfGklVPBhRq/arHg9lFSOkmknvoBymqj6CcPT2Yu2+rpcEBVsTCrnblrc4XsopbkRDZz zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v3vb551qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 16:02:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JFrwFI065800;
        Thu, 19 Sep 2019 16:02:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v3vb61a92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 16:02:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8JG29V9026317;
        Thu, 19 Sep 2019 16:02:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 09:02:09 -0700
Date:   Thu, 19 Sep 2019 09:02:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190919160206.GL2229799@magnolia>
References: <20190919150024.8346-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919150024.8346-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 11:00:24PM +0800, Zorro Lang wrote:
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

One thing missing from this patch -- if the test formatted the scratch
device with non-default geometry, the backup superblocks from that
filesystem will not be erased.  Going back to my example from the email
thread, if the scratch disk has:

  SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]

Where SB[0-5] are the ones written by xfs/030 and SB'[1-3] were written
by a previous test that did the default scratch device mkfs, then this
patch will wipe out SB'[1-3] and SB0:

  000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      0000 [1G space] 0000 [1G space] 0000 [1G space]

But that still leaves SB[1-5] which xfs_repair could stumble over later.
For example, if the next test to be run formats a filesystem with 24MB
AGs (instead of 16) and zaps the superblock, then repair will eventually
try a linear scan looking for superblocks and find the ones from the
16MB filesystem first.

There isn't a sequence of tests that do this, but so long as we're
fixing this we might as well zap as much as we can.  So I propose adding
to try_wipe_scratch_xfs() the following:

	dbsize=
	_scratch_xfs_db -c 'sb 0' -c 'p blocksize agblocks agcount' 2>&1 | \
		sed -e 's/ = /=/g' -e 's/blocksize/dbsize/g' \
		    -e 's/agblocks/agsize/g' > $tmp.mkfs
	. $tmp.mkfs

and then repeat the for loop.  If there isn't a filesystem then
$tmp.mkfs will be an empty file and the loop won't run.

> Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> will go to find those *old* SB at first. When it finds them,
> everyting goes wrong.
> 
> So I try to get XFS AG geometry(by default) and then try to erase all
> superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  common/rc  |  4 ++++
>  common/xfs | 23 +++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 66c7fd4d..fe13f659 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
>  	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
>  		test -b $dev && $WIPEFS_PROG -a $dev
>  	done
> +
> +	if [ "$FSTYP" = "xfs" ];then
> +		try_wipe_scratch_xfs
> +	fi

We probably ought to delegate all wiping to try_wipe_scratch_xfs, i.e.:

	test -b $dev || continue
	case "$FSTYP" in
	"xfs")
		_try_wipe_scratch_xfs
		;;
	*)
		$WIPEFS_PROG -a $dev
		;;
	esac

and add the WIPEFS_PROG call to _try_wipe_scratch_xfs.

>  }
>  
>  # Only run this on xfs if xfs_scrub is available and has the unicode checker
> diff --git a/common/xfs b/common/xfs
> index 1bce3c18..34516f82 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -884,3 +884,26 @@ _xfs_mount_agcount()
>  {
>  	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
>  }
> +
> +# wipe the superblock of each XFS AGs
> +try_wipe_scratch_xfs()

Common helper functions should start with a '_'

> +{
> +	local tmp=`mktemp -u`
> +
> +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> +			print STDOUT "agcount=$1\nagsize=$2\n";
> +		}
> +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> +			print STDOUT "dbsize=$1\n";
> +		}' > $tmp.mkfs
> +
> +	. $tmp.mkfs
> +	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
> +		for ((i = 0; i < agcount; i++)); do
> +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> +				$SCRATCH_DEV >/dev/null;
> +		done
> +       fi
> +       rm -f $tmp.mkfs

Add code as discussed above.

--D

> +}
> -- 
> 2.20.1
> 
