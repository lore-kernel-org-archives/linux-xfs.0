Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF74C636CE
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 13:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6029D61184
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 13:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGROAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 10:00:24 -0400
Received: from out20-73.mail.aliyun.com ([115.124.20.73]:34148 "EHLO
        out20-73.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhGROAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jul 2021 10:00:15 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.112881|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.290544-0.000469483-0.708987;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Kkr14Ss_1626616634;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Kkr14Ss_1626616634)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 18 Jul 2021 21:57:14 +0800
Date:   Sun, 18 Jul 2021 21:57:14 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] new: allow users to specify a new test id
Message-ID: <YPQzOiqnugT4MeNq@desktop>
References: <162561725931.543346.16210906692072836195.stgit@locust>
 <162561726493.543346.17291318180978776290.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162561726493.543346.17291318180978776290.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 05:21:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Alter the ./new script so that one can set the test id explicitly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me. Mind updating the usage info as well?

Thanks,
Eryu

> ---
>  new |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/new b/new
> index 07144399..51111f08 100755
> --- a/new
> +++ b/new
> @@ -26,7 +26,18 @@ usage()
>  }
>  
>  [ $# -eq 0 ] && usage
> -tdir=tests/$1
> +
> +if echo "$1" | grep -q '/'; then
> +	if [ -e "tests/$1" ]; then
> +		echo "$1: test already exists."
> +		exit 1
> +	fi
> +	tdir="tests/$(echo "$1" | cut -d '/' -f 1)"
> +	id="$(echo "$1" | cut -d '/' -f 2)"
> +else
> +	tdir=tests/$1
> +	id="$(basename "$(./tools/nextid "$1")")"
> +fi
>  
>  i=0
>  line=0
> @@ -36,7 +47,6 @@ eof=1
>  export AWK_PROG="$(type -P awk)"
>  [ "$AWK_PROG" = "" ] && { echo "awk not found"; exit; }
>  
> -id="$(basename "$(./tools/nextid "$1")")"
>  echo "Next test id is $id"
>  shift
>  
