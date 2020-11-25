Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BCDC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 21:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505252075A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 21:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgKYVMk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:12:40 -0500
Received: from sandeen.net ([63.231.237.45]:36724 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbgKYVMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Nov 2020 16:12:40 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A0919324E60;
        Wed, 25 Nov 2020 15:12:33 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633668210.634603.16132006317248436755.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/5] libxfs-apply: don't add duplicate headers
Message-ID: <4bc2eb57-a5e8-59e5-9c69-0d8767df4796@sandeen.net>
Date:   Wed, 25 Nov 2020 15:12:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160633668210.634603.16132006317248436755.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/25/20 2:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're backporting patches from libxfs, don't add a S-o-b header if
> there's already one at the end of the headers of the patch being ported.
> 
> That way, we avoid things like:
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

But it will still not add my additional SOB if I merge something across to
userspace that starts out with:

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

And I always felt like the committer should be adding their SOB to the end of
the chain when they move code from one place to another, especially if any
tweaks got made along the way.

IOWs I see the rationale for removing duplicate /sequential/ SOBs, but not
for removing duplicate SOBs in general.

Am I thinking about that wrong?

> ---
>  tools/libxfs-apply |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 3258272d6189..9271db380198 100755
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
> +	tail -n 1 "$hdrfile" | grep -q "^${hdr}$" || echo "$hdr" >> "$hdrfile"
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
