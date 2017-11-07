Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbdKGFS5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Nov 2017 00:18:57 -0500
Date: Tue, 7 Nov 2017 13:18:55 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 2/4] punch: Implement fixup for fiemap range queries
Message-ID: <20171107051855.GJ17339@eguan.usersys.redhat.com>
References: <1509459011-7398-1-git-send-email-nborisov@suse.com>
 <1509459096-7585-1-git-send-email-nborisov@suse.com>
 <1509459096-7585-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509459096-7585-2-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, darrick.wong@oracle.com

On Tue, Oct 31, 2017 at 04:11:34PM +0200, Nikolay Borisov wrote:
> With the new  range query support for the fiemap command,
> the command also started printing hole extent for files which
> consist of only a hole. This change breaks tests which are
> executed with a version of xfs_io that doesn't support fiemap's
> range query.
> 
> Fix this by implementing a function which will fixup the output
> of tests which are broken by emulating the output on older
> xfs_io versions
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com> 
> ---
>  common/punch | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/common/punch b/common/punch
> index c4ed261..b20dc30 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -218,6 +218,23 @@ _filter_fiemap()
>  	_coalesce_extents
>  }
>  
> +_fiemap_range_fixup()

Good to have some comments too on what this function does.

> +{
> +	#check if we support ranged query
> +	$XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]"

return immediately if fiemap supports range query?

Thanks,
Eryu

> +	local range_sup=$?
> +	#check if the file consists of a single hole only
> +	echo "$1" | grep -q "^0\: \[.*\]\: hole$"
> +	local sole_hole=$?
> +	local filesize="$(((`stat -c %s $1` / 512) - 1))"
> +	local output_line_num=`$XFS_IO_PROG -c 'fiemap' $testfile | wc -l`
> +
> +	if [ $range_sup -eq 1 ] && [ $sole_hole -eq 1  ] && [ $output_line_num -eq 1 ]
> +	then
> +		echo "0: [0..$filesize]: hole"
> +	fi
> +}
> +
>  _filter_fiemap_flags()
>  {
>  	$AWK_PROG '
> @@ -363,6 +380,7 @@ _test_generic_punch()
>  	$XFS_IO_PROG -f -c "truncate $_20k" \
>  		-c "$zero_cmd $_4k $_8k" \
>  		-c "$map_cmd -v" $testfile | $filter_cmd
> +	_fiemap_range_fixup $testfile
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> @@ -470,6 +488,7 @@ _test_generic_punch()
>  		-c "pwrite $_8k $_4k" $sync_cmd \
>  		-c "$zero_cmd $_4k $_12k" \
>  		-c "$map_cmd -v" $testfile | $filter_cmd
> +	_fiemap_range_fixup $testfile
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> -- 
> 2.7.4
> 
