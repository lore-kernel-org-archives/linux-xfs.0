Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D667C3A5A6
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 01:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F7421920
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 01:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393987AbfITBwN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 21:52:13 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1378 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389787AbfITBwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 21:52:13 -0400
X-IronPort-AV: E=Sophos;i="5.64,526,1559491200"; 
   d="scan'208";a="75742071"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 20 Sep 2019 09:52:10 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id CFDBF4CE14EA;
        Fri, 20 Sep 2019 09:52:11 +0800 (CST)
Received: from [10.167.220.84] (10.167.220.84) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Fri, 20 Sep 2019 09:52:12 +0800
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
To:     Zorro Lang <zlang@redhat.com>, <fstests@vger.kernel.org>
CC:     <linux-xfs@vger.kernel.org>
References: <20190919150024.8346-1-zlang@redhat.com>
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Message-ID: <66503981-2ff3-f28b-fd06-9d6360c930fe@cn.fujitsu.com>
Date:   Fri, 20 Sep 2019 09:52:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190919150024.8346-1-zlang@redhat.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.84]
X-yoursite-MailScanner-ID: CFDBF4CE14EA.A2AD2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



on 2019/09/19 23:00, Zorro Lang wrote:
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
Feel free to add Reported-by.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>   common/rc  |  4 ++++
>   common/xfs | 23 +++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 66c7fd4d..fe13f659 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
>   	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
>   		test -b $dev && $WIPEFS_PROG -a $dev
>   	done
> +
> +	if [ "$FSTYP" = "xfs" ];then
> +		try_wipe_scratch_xfs
I think we should add a simple comment for why we add it.

ps:_scratch_mkfs_xfs also can make case pass. We can use it and add 
comment. the  try_wipe_scratch_xfs method and the _scratch_mkfs_xfs 
method are all acceptable for me.
> +	fi
>   }
>   
>   # Only run this on xfs if xfs_scrub is available and has the unicode checker
> diff --git a/common/xfs b/common/xfs
> index 1bce3c18..34516f82 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -884,3 +884,26 @@ _xfs_mount_agcount()
>   {
>   	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
>   }
> +
> +# wipe the superblock of each XFS AGs
> +try_wipe_scratch_xfs()
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
> +}
> 


