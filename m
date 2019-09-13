Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9A9C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 17:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175422081B
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 17:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbfIMRgS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Sep 2019 13:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbfIMRgR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Sep 2019 13:36:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD9B4796E0;
        Fri, 13 Sep 2019 17:36:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A75E5C207;
        Fri, 13 Sep 2019 17:36:15 +0000 (UTC)
Date:   Fri, 13 Sep 2019 13:36:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH 1/2] common: check if a given rename flag is supported in
 _requires_renameat2
Message-ID: <20190913173614.GC28512@bfoster>
References: <719f7bb3-96db-7563-56d8-56ed765fabc4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <719f7bb3-96db-7563-56d8-56ed765fabc4@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 13 Sep 2019 17:36:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 11, 2019 at 09:15:16PM +0800, kaixuxia wrote:
> Some testcases may require a special rename flag, such as RENAME_WHITEOUT,
> so add support check for if a given rename flag is supported in
> _requires_renameat2.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

Looks mostly reasonable...

>  common/renameat2  | 41 +++++++++++++++++++++++++++++++++++++++--
>  tests/generic/024 | 13 +++----------
>  tests/generic/025 | 13 +++----------
>  tests/generic/078 | 13 +++----------
>  4 files changed, 48 insertions(+), 32 deletions(-)
> 
> diff --git a/common/renameat2 b/common/renameat2
> index f8d6d4f..7bb81e0 100644
> --- a/common/renameat2
> +++ b/common/renameat2
> @@ -103,10 +103,47 @@ _rename_tests()
>  #
>  _requires_renameat2()
>  {
> +	local flags=$1
> +	local rename_dir=$TEST_DIR/$$
> +
>  	if test ! -x src/renameat2; then
>  		_notrun "renameat2 binary not found"
>  	fi
> -	if ! src/renameat2 -t; then
> -		_notrun "kernel doesn't support renameat2 syscall"
> +
> +	if test -z "$flags"; then
> +		src/renameat2 -t
> +		[ $? -eq 0 ] || _notrun "kernel doesn't support renameat2 syscall"
> +		return
>  	fi
> +
> +	case $flags in
> +	"noreplace")
> +		mkdir $rename_dir
> +		touch $rename_dir/foo
> +		if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> +			_notrun "fs doesn't support RENAME_NOREPLACE"
> +		fi
> +		;;
> +	"exchange")
> +		mkdir $rename_dir
> +		touch $rename_dir/foo $rename_dir/bar
> +		if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> +			_notrun "fs doesn't support RENAME_EXCHANGE"
> +		fi
> +		;;
> +	"whiteout")
> +		mkdir $rename_dir
> +		touch $rename_dir/foo $rename_dir/bar
> +		if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> +			_notrun "fs doesn't support RENAME_WHITEOUT"
> +		fi
> +		;;
> +	*)
> +		_notrun "only support noreplace,exchange,whiteout rename flags, please check."
> +		;;
> +	esac

... but it seems like this could be simplified to reduce (duplicate)
code. For example:

	mkdir $rename_dir
	touch $rename_dir/foo
	cmd=""
	case $flags in
	"noreplace")
		cmd="-n $rename_dir/foo $rename_dir/bar"
		;;
	"exchange")
		touch $rename_dir/bar
		cmd="-x $rename_dir/foo $rename_dir/bar"
		;;
	"whiteout")
		touch $rename_dir/bar
		cmd="-w $rename_dir/foo $rename_dir/bar"
		;;
	...
	if ! src/renameat2 -t $cmd; then
		rm -rf $rename_dir
		_notrun "fs doesn't support renameat2"
	fi
	rm -rf $rename_dir

Hm?

Brian

> +	rm -fr $rename_dir
>  }
> diff --git a/tests/generic/024 b/tests/generic/024
> index 2888c66..9c1161a 100755
> --- a/tests/generic/024
> +++ b/tests/generic/024
> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 noreplace
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo
> -if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_NOREPLACE"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -n
>  rmdir $rename_dir
>  
> diff --git a/tests/generic/025 b/tests/generic/025
> index 0310efa..1ee9ad6 100755
> --- a/tests/generic/025
> +++ b/tests/generic/025
> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 exchange
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo $rename_dir/bar
> -if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_EXCHANGE"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -x
>  rmdir $rename_dir
>  
> diff --git a/tests/generic/078 b/tests/generic/078
> index 9608574..37f3201 100755
> --- a/tests/generic/078
> +++ b/tests/generic/078
> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 whiteout
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo $rename_dir/bar
> -if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_WHITEOUT"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -w
>  rmdir $rename_dir
>  
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
