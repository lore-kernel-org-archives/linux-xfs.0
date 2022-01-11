Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94438C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 01:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbiAKBa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 20:30:28 -0500
Received: from sandeen.net ([63.231.237.45]:35518 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbiAKBa1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jan 2022 20:30:27 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0FEF44906;
        Mon, 10 Jan 2022 19:29:24 -0600 (CST)
Message-ID: <a3ee5c0b-5507-395f-30f5-db3340b46e0d@sandeen.net>
Date:   Mon, 10 Jan 2022 19:30:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210713235330.2591572-1-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libxfs-apply: support filterdiff >= 0.4.2 only
In-Reply-To: <20210713235330.2591572-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/13/21 6:53 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently require filterdiff v0.3.4 as a minimum for handling git
> based patches. This was the first version to handle git diff
> metadata well enough to do patch reformatting. It was, however, very
> buggy and required several workarounds to get it to do what we
> needed.
> 
> However, these bugs have been fixed and on a machine with v0.4.2,
> the workarounds result in libxfs-apply breaking and creating corrupt
> patches. Rather than try to carry around workarounds for a broken
> filterdiff version and one that just works, just increase the
> minimum required version to 0.4.2 and remove all the workarounds for
> the bugs in 0.3.4.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I had missed this, sorry. I'm using it now, seems to work fine.

Darrick is still on the older version, so we probably need to come
to agreement on requiring something newer.  Thanks for working through
this!

-Eric

> ---
>   tools/libxfs-apply | 42 +++++++++++++++++-------------------------
>   1 file changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 9271db380198..097a695f942b 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -30,21 +30,22 @@ fail()
>   	exit
>   }
>   
> -# filterdiff 0.3.4 is the first version that handles git diff metadata (almost)
> -# correctly. It just doesn't work properly in prior versions, so those versions
> -# can't be used to extract the commit message prior to the diff. Hence just
> -# abort and tell the user to upgrade if an old version is detected. We need to
> +# filterdiff didn't start handling git diff metadata correctly until some time
> +# after 0.3.4. The handling in 0.3.4 was buggy and broken, requiring working
> +# around that bugs to use it. Now that 0.4.2 has fixed all those bugs, the
> +# work-arounds for 0.3.4 do not work. Hence set 0.4.2 as the minimum required
> +# version and tell the user to upgrade if an old version is detected. We need to
>   # check against x.y.z version numbers here.
>   _version=`filterdiff --version | cut -d " " -f 5`
>   _major=`echo $_version | cut -d "." -f 1`
>   _minor=`echo $_version | cut -d "." -f 2`
>   _patch=`echo $_version | cut -d "." -f 3`
>   if [ $_major -eq 0 ]; then
> -	if [ $_minor -lt 3 ]; then
> -		fail "filterdiff $_version found. 0.3.4 or greater is required."
> +	if [ $_minor -lt 4 ]; then
> +		fail "filterdiff $_version found. 0.4.2 or greater is required."
>   	fi
> -	if [ $_minor -eq 3 -a $_patch -le 3 ]; then
> -		fail "filterdiff $_version found. 0.3.4 or greater is required."
> +	if [ $_minor -eq 4 -a $_patch -lt 2 ]; then
> +		fail "filterdiff $_version found. 0.4.2 or greater is required."
>   	fi
>   fi
>   
> @@ -158,8 +159,7 @@ filter_kernel_patch()
>   			--addoldprefix=a/fs/xfs/ \
>   			--addnewprefix=b/fs/xfs/ \
>   			$_patch | \
> -		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,' \
> -		    -e '/^diff --git/d'
> +		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,'
>   
>   
>   	rm -f $_libxfs_files
> @@ -187,8 +187,7 @@ filter_xfsprogs_patch()
>   			--addoldprefix=a/ \
>   			--addnewprefix=b/ \
>   			$_patch | \
> -		sed -e 's, [ab]\/\(\/dev\/null\), \1,' \
> -		    -e '/^diff --git/d'
> +		sed -e 's, [ab]\/\(\/dev\/null\), \1,'
>   
>   	rm -f $_libxfs_files
>   }
> @@ -209,30 +208,23 @@ fixup_header_format()
>   	local _diff=`mktemp`
>   	local _new_hdr=$_hdr.new
>   
> -	# there's a bug in filterdiff that leaves a line at the end of the
> -	# header in the filtered git show output like:
> -	#
> -	# difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> -	#
> -	# split the header on that (convenient!)
> -	sed -e /^difflib/q $_patch > $_hdr
> +	# Split the header on the first ^diff --git line (convenient!)
> +	sed -e /^diff/q $_patch > $_hdr
>   	cat $_patch | awk '
> -		BEGIN { difflib_seen = 0; index_seen = 0 }
> -		/^difflib/ { difflib_seen++; next }
> +		BEGIN { diff_seen = 0; index_seen = 0 }
> +		/^diff/ { diff_seen++; next }
>   		/^index/ { if (++index_seen == 1) { next } }
> -		// { if (difflib_seen) { print $0 } }' > $_diff
> +		// { if (diff_seen) { print $0 } }' > $_diff
>   
>   	# the header now has the format:
>   	# commit 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
>   	# Author: Eric Sandeen <sandeen@sandeen.net>
>   	# Date:   Wed Jun 1 17:38:15 2016 +1000
> -	#
> +	#
>   	#     xfs: make several functions static
>   	#....
>   	#     Signed-off-by: Dave Chinner <david@fromorbit.com>
>   	#
> -	#difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> -	#
>   	# We want to format it like a normal patch with a line to say what repo
>   	# and commit it was sourced from:
>   	#
