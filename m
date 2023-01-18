Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DBDC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 05:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjARFK7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 00:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjARFK5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 00:10:57 -0500
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABA937549;
        Tue, 17 Jan 2023 21:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1674018650; i=@fujitsu.com;
        bh=B7FmLw9uHjoPWLWQxQiVRhrHl0spXjFoxWmIUA4f9DE=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=VjnddL1MpmLTi6l/+d632JiWsGKY8UsKuMmbK3Y6ID4/whsYdvtGN+CRA52R3plz3
         /Td5g6a5/QB1JA7VQcOyycZxaNdJWkeSwm1lu9b96G0euMMTItdCSWU4GTnqKh4l3O
         BHtTTHGq8VRvlhNJsktxemuQNKKdMpZAcWWYdhpTv1U2sEHZ/EAUabTunoJXaixl7a
         2ztTPwXXJU8RMPpEsB1v8jJIe7V2ECatqFYbQBEB0tFyEq9HxhxhltJteFSsP34uQk
         gAFL1ZyxOLERM+axqyipEUndYD6uOztNLejrpkNV26xtYCVNybU1xlt8jKmi0YodnO
         XIXPaddk9WXQA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileJIrShJLcpLzFFi42Kxs+HYrBtZfzz
  Z4NwjMYvLT/gsTrfsZbf4e+4Nu8WuPzvYLfae3MnqwOpx/qqKx6ZVnWwe7/ddZfP4vEkugCWK
  NTMvKb8igTXj+1PhgoeiFQ09u9kaGH8KdjFycQgJbGSUaFr1mQ3CWcIkcfB8AyuEs51R4vKxG
  yxdjJwcvAJ2Et17XzCD2CwCqhK/OmdDxQUlTs58AmaLCiRJXN1wlxXEFhbwltg7ZwkbiC0iYC
  sxs+0TWC+zgJfErQXXmEBsIYEmRomHh0VBbDYBNYmd01+CzeEUcJd41nKLDaLeQmLxm4PsELa
  8xPa3c8DmSAgoSrQt+ccOYVdKtH74xQJhq0lcPbeJeQKj0Cwk581CMmoWklELGJlXMZoVpxaV
  pRbpWuglFWWmZ5TkJmbm6CVW6SbqpZbq5uUXlWToGuollhfrpRYX6xVX5ibnpOjlpZZsYgRGS
  0pxivsOxuPL/ugdYpTkYFIS5X0dezxZiC8pP6UyI7E4I76oNCe1+BCjDAeHkgTvjVqgnGBRan
  pqRVpmDjByYdISHDxKIrwnK4DSvMUFibnFmekQqVOMuhxrGw7sZRZiycvPS5US5y2sAyoSACn
  KKM2DGwFLIpcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfP+ApnCk5lXArfpFdARTEBHeJQc
  BTmiJBEhJdXAJOh9td95CUNnSa/pYdmkWtYJwrffrc7+2L36is2+hNcsJxXcfjl9kFH6GKFpF
  WXOMH3jnz1Xix9GJ55d3mHg8GndmpS95WUq9vO0bX8pOX5bwNb6c/7LTG2BlFP8enk6JlaSQZ
  qC2yy54i40TMr40av1dEJ2ye0bb5JZrIXFLYp1L5zoXt32VOewh3XJsS0fz6+Vusfp29NYWiF
  otfEO89vUg9s7i3falwp/9vSKnOuRX8Nkc2dupUgK39Oa3fGKLTtrGHr/Om5+wxfV72t02arg
  Kecx4SVTnz9OKAgPlM18ytLGnHf5+PHde6omPqq+veJYa8hHbU7la5Ndfod8WqDzeNq9nD1zL
  qZIF1opsRRnJBpqMRcVJwIAfTB+B50DAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-2.tower-745.messagelabs.com!1674018648!76892!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.102.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16980 invoked from network); 18 Jan 2023 05:10:49 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-2.tower-745.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jan 2023 05:10:49 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id C2993151;
        Wed, 18 Jan 2023 05:10:48 +0000 (GMT)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id B632B73;
        Wed, 18 Jan 2023 05:10:48 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 18 Jan 2023 05:10:46 +0000
Message-ID: <91105186-e4df-fb33-5f8e-f5aa6bf8a0ef@fujitsu.com>
Date:   Wed, 18 Jan 2023 13:10:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] xfs: fix reflink test failures when dax is enabled
To:     "Darrick J. Wong" <djwong@kernel.org>, <zlang@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <guan@eryu.me>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
 <167400102472.1914858.16726369189467075623.stgit@magnolia>
From:   Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <167400102472.1914858.16726369189467075623.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Thanks for your quick fix. It's better than my patch.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

Best Regards,
Xiao Yang

On 2023/1/18 8:42, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Turn off reflink tests that require delayed allocation to work, because
> we don't use delayed allocation when fsdax mode is turned on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/xfs/184 |    1 +
>   tests/xfs/192 |    1 +
>   tests/xfs/200 |    1 +
>   tests/xfs/204 |    1 +
>   tests/xfs/232 |    1 +
>   tests/xfs/440 |    1 +
>   6 files changed, 6 insertions(+)
> 
> 
> diff --git a/tests/xfs/184 b/tests/xfs/184
> index c251040e8a..3bdd86addf 100755
> --- a/tests/xfs/184
> +++ b/tests/xfs/184
> @@ -19,6 +19,7 @@ _begin_fstest auto quick clone fiemap unshare
>   
>   # real QA test starts here
>   _supported_fs xfs
> +_require_scratch_delalloc
>   _require_scratch_reflink
>   _require_cp_reflink
>   _require_xfs_io_command "fiemap"
> diff --git a/tests/xfs/192 b/tests/xfs/192
> index 85ed7a48fc..ced18fa3c1 100755
> --- a/tests/xfs/192
> +++ b/tests/xfs/192
> @@ -19,6 +19,7 @@ _begin_fstest auto quick clone fiemap unshare
>   
>   # real QA test starts here
>   _supported_fs xfs
> +_require_scratch_delalloc
>   _require_scratch_reflink
>   _require_cp_reflink
>   _require_xfs_io_command "fiemap"
> diff --git a/tests/xfs/200 b/tests/xfs/200
> index f91bfbf478..b51b9a54f5 100755
> --- a/tests/xfs/200
> +++ b/tests/xfs/200
> @@ -21,6 +21,7 @@ _begin_fstest auto quick clone fiemap unshare
>   
>   # real QA test starts here
>   _supported_fs xfs
> +_require_scratch_delalloc
>   _require_scratch_reflink
>   _require_cp_reflink
>   _require_xfs_io_command "fiemap"
> diff --git a/tests/xfs/204 b/tests/xfs/204
> index d034446bbc..ca21dfe722 100755
> --- a/tests/xfs/204
> +++ b/tests/xfs/204
> @@ -21,6 +21,7 @@ _begin_fstest auto quick clone fiemap unshare
>   
>   # real QA test starts here
>   _supported_fs xfs
> +_require_scratch_delalloc
>   _require_scratch_reflink
>   _require_cp_reflink
>   _require_xfs_io_command "fiemap"
> diff --git a/tests/xfs/232 b/tests/xfs/232
> index f402ad6cf3..59bbc43686 100755
> --- a/tests/xfs/232
> +++ b/tests/xfs/232
> @@ -30,6 +30,7 @@ _cleanup()
>   
>   # real QA test starts here
>   _supported_fs xfs
> +_require_scratch_delalloc
>   _require_xfs_io_command "cowextsize"
>   _require_scratch_reflink
>   _require_cp_reflink
> diff --git a/tests/xfs/440 b/tests/xfs/440
> index 496ee04edf..368ee8a05d 100755
> --- a/tests/xfs/440
> +++ b/tests/xfs/440
> @@ -20,6 +20,7 @@ _begin_fstest auto quick clone quota
>   _supported_fs xfs
>   
>   _require_quota
> +_require_scratch_delalloc
>   _require_scratch_reflink
>   _require_cp_reflink
>   _require_user
> 
