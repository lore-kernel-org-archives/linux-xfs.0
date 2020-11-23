Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD221C388F9
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B51C20727
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgKWUbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:31:03 -0500
Received: from sandeen.net ([63.231.237.45]:36716 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgKWUbA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Nov 2020 15:31:00 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4D217EDD;
        Mon, 23 Nov 2020 14:30:56 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503144025.1201232.11112616423278752638.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 9/9] libxfs-apply: don't add duplicate headers
Message-ID: <8adce075-983b-2b3f-eb3c-10eb72bccf0c@sandeen.net>
Date:   Mon, 23 Nov 2020 14:30:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160503144025.1201232.11112616423278752638.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/10/20 12:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're backporting patches from libxfs, don't add a S-o-b header if
> there's already one in the patch being ported.

I guess the goal here is to not add 2 identical sign offs in a row.

But when I do the libxfs-application, I do feel like it should add
my SOB as sort of a chain of custody record before I commit it to a
new tree/project, no?

So could this be modified to simply not add 2 identical SOBs in a row?

Maybe we can just run "uniq" on the $_hdr.new file?

Thanks,
-Eric


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tools/libxfs-apply |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 3258272d6189..35cdb9c3449b 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -193,6 +193,14 @@ filter_xfsprogs_patch()
>  	rm -f $_libxfs_files
>  }
>  
> +add_header()
> +{
> +	local hdr="$1"
> +	local hdrfile="$2"
> +
> +	grep -q "^${hdr}$" "$hdrfile" || echo "$hdr" >> "$hdrfile"
> +}
> +
>  fixup_header_format()
>  {
>  	local _source=$1
> @@ -280,13 +288,13 @@ fixup_header_format()
>  	sed -i '${/^[[:space:]]*$/d;}' $_hdr.new
>  
>  	# Add Signed-off-by: header if specified
> -	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
> -		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
> +	if [ ! -z ${SIGNED_OFF_BY+x} ]; then
> +		add_header "Signed-off-by: $SIGNED_OFF_BY" $_hdr.new
>  	else	# get it from git config if present
>  		SOB_NAME=`git config --get user.name`
>  		SOB_EMAIL=`git config --get user.email`
>  		if [ ! -z ${SOB_NAME+x} ]; then
> -			echo "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" >> $_hdr.new
> +			add_header "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" $_hdr.new
>  		fi
>  	fi
>  
> 
