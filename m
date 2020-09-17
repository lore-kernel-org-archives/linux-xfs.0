Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3BAC2BB84
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 01:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 713312072E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 01:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgIQBvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 21:51:55 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36057 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726009AbgIQBvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 21:51:54 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:51:53 EDT
X-IronPort-AV: E=Sophos;i="5.76,434,1592841600"; 
   d="scan'208";a="99332347"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 17 Sep 2020 09:41:03 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id ADD6848990C1;
        Thu, 17 Sep 2020 09:41:03 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 17 Sep 2020 09:41:01 +0800
Message-ID: <5F62BEAD.3090602@cn.fujitsu.com>
Date:   Thu, 17 Sep 2020 09:41:01 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <linux-xfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
References: <160013417420.2923511.6825722200699287884.stgit@magnolia> <160013419510.2923511.4577521065964693699.stgit@magnolia>
In-Reply-To: <160013419510.2923511.4577521065964693699.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: ADD6848990C1.A9777
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/15 9:43, Darrick J. Wong wrote:
> From: Darrick J. Wong<darrick.wong@oracle.com>
>
> This test requires that the filesystem support calling FSGETXATTR on
> regular files and directories to make sure the FS_XFLAG_DAX flag works.
> The _require_xfs_io_command tests a regular file but doesn't check
> directories, so generic/607 should do that itself.  Also fix some typos.
>
> Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>
> ---
>   common/rc         |   10 ++++++++--
>   tests/generic/607 |    5 +++++
>   2 files changed, 13 insertions(+), 2 deletions(-)
>
>
> diff --git a/common/rc b/common/rc
> index aa5a7409..f78b1cfc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2162,6 +2162,12 @@ _require_xfs_io_command()
>   	local testfile=$TEST_DIR/$$.xfs_io
>   	local testio
>   	case $command in
> +	"lsattr")
> +		# Test xfs_io lsattr support and filesystem FS_IOC_FSSETXATTR
> +		# support.
> +		testio=`$XFS_IO_PROG -F -f -c "lsattr $param" $testfile 2>&1`
> +		param_checked="$param"
> +		;;
>   	"chattr")
>   		if [ -z "$param" ]; then
>   			param=s
> @@ -3205,7 +3211,7 @@ _check_s_dax()
>   	if [ $exp_s_dax -eq 0 ]; then
>   		(( attributes&  0x2000 ))&&  echo "$target has unexpected S_DAX flag"
>   	else
> -		(( attributes&  0x2000 )) || echo "$target doen't have expected S_DAX flag"
> +		(( attributes&  0x2000 )) || echo "$target doesn't have expected S_DAX flag"
>   	fi
>   }
>
> @@ -3217,7 +3223,7 @@ _check_xflag()
>   	if [ $exp_xflag -eq 0 ]; then
>   		_test_inode_flag dax $target&&  echo "$target has unexpected FS_XFLAG_DAX flag"
>   	else
> -		_test_inode_flag dax $target || echo "$target doen't have expected FS_XFLAG_DAX flag"
> +		_test_inode_flag dax $target || echo "$target doesn't have expected FS_XFLAG_DAX flag"
>   	fi
>   }
>
> diff --git a/tests/generic/607 b/tests/generic/607
> index b15085ea..14d2c05f 100755
> --- a/tests/generic/607
> +++ b/tests/generic/607
> @@ -38,6 +38,11 @@ _require_scratch
>   _require_dax_iflag
>   _require_xfs_io_command "lsattr" "-v"
>
> +# Make sure we can call FSGETXATTR on a directory...
> +output="$($XFS_IO_PROG -c "lsattr -v" $TEST_DIR 2>&1)"
> +echo "$output" | grep -q "Inappropriate ioctl for device"&&  \
> +	_notrun "$FSTYP: FSGETXATTR not supported on directories."
Hi Darrick,

Could you tell me which kernel version gets the issue? :-)

Best Regards,
Xiao Yang
> +
>   # If a/ is +x, check that a's new children
>   # inherit +x from a/.
>   test_xflag_inheritance1()
>
>
>
> .
>



