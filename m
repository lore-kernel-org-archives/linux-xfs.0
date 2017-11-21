Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdKUF3v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 00:29:51 -0500
Date: Tue, 21 Nov 2017 13:29:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 1/3] generic: Adjust generic test outputs for new
 fiemap imeplementation
Message-ID: <20171121052949.GI2749@eguan.usersys.redhat.com>
References: <1510747821-13270-1-git-send-email-nborisov@suse.com>
 <1510747900-13440-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510747900-13440-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com

On Wed, Nov 15, 2017 at 02:11:38PM +0200, Nikolay Borisov wrote:
> With the new  range query support for the fiemap command,
> the command also started printing hole extent for files which
> consist of only a hole. So adjust generic test output accordingly.
> Furthermore, this change breaks tests which are executed with a version
> of xfs_io that doesn't support fiemap's range query. Fix this by implementing a
> function which will fixup the output of tests which are broken by emulating
> the output on older xfs_io versions
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  common/punch          | 23 +++++++++++++++++++++++
>  tests/generic/012.out |  1 +
>  tests/generic/016.out |  1 +
>  tests/generic/021.out |  2 ++
>  tests/generic/022.out |  2 ++
>  tests/generic/058.out |  1 +
>  tests/generic/060.out |  1 +
>  tests/generic/061.out |  1 +
>  tests/generic/063.out |  1 +
>  tests/generic/255.out |  6 ++++++
>  tests/generic/316.out |  6 ++++++
>  11 files changed, 45 insertions(+)
> 
> diff --git a/common/punch b/common/punch
> index c4ed261..9c39183 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -218,6 +218,27 @@ _filter_fiemap()
>  	_coalesce_extents
>  }
>  
> +#This function allows for tests which print the fiemap of a

Please add a space after "#" for comments.

> +#file, that consists of only a hole to pass when executed with 

Trailing whitespace in above line.

> +#older versions of xfs_io's fiemap that didn't print anything for
> +#such files
> +_fiemap_range_fixup()
> +{
> +	#check if we support ranged query
> +	$XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]"

regexp doesn't look correct, either use fgrep or escape "[".

> +	local range_sup=$?

I think we can return immediately if xfs_io supports ranged query, so we
don't have to do the "$range_sup -eq 1" check later, which results in a
shorter line.

Thanks,
Eryu

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
> @@ -363,6 +384,7 @@ _test_generic_punch()
>  	$XFS_IO_PROG -f -c "truncate $_20k" \
>  		-c "$zero_cmd $_4k $_8k" \
>  		-c "$map_cmd -v" $testfile | $filter_cmd
> +	_fiemap_range_fixup $testfile
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> @@ -470,6 +492,7 @@ _test_generic_punch()
>  		-c "pwrite $_8k $_4k" $sync_cmd \
>  		-c "$zero_cmd $_4k $_12k" \
>  		-c "$map_cmd -v" $testfile | $filter_cmd
> +	_fiemap_range_fixup $testfile
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> diff --git a/tests/generic/012.out b/tests/generic/012.out
> index ffbf8a3..8045471 100644
> --- a/tests/generic/012.out
> +++ b/tests/generic/012.out
> @@ -1,5 +1,6 @@
>  QA output created by 012
>  	1. into a hole
> +0: [0..95]: hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
>  0: [0..95]: extent
> diff --git a/tests/generic/016.out b/tests/generic/016.out
> index c45a44a..1371ce7 100644
> --- a/tests/generic/016.out
> +++ b/tests/generic/016.out
> @@ -1,5 +1,6 @@
>  QA output created by 016
>  	1. into a hole
> +0: [0..95]: hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
>  0: [0..95]: extent
> diff --git a/tests/generic/021.out b/tests/generic/021.out
> index 1137741..791b78a 100644
> --- a/tests/generic/021.out
> +++ b/tests/generic/021.out
> @@ -1,5 +1,6 @@
>  QA output created by 021
>  	1. into a hole
> +0: [0..95]: hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
>  0: [0..95]: extent
> @@ -34,6 +35,7 @@ f4f35d60b3cc18aaa6d8d92f0cd3708a
>  1: [64..95]: hole
>  d8f51c20223dbce5c7c90db87bc221b0
>  	10. hole -> data -> hole
> +0: [0..63]: hole
>  bb7df04e1b0a2570657527a7e108ae23
>  	11. data -> hole -> data
>  0: [0..63]: extent
> diff --git a/tests/generic/022.out b/tests/generic/022.out
> index fbffa59..6dbc192 100644
> --- a/tests/generic/022.out
> +++ b/tests/generic/022.out
> @@ -1,5 +1,6 @@
>  QA output created by 022
>  	1. into a hole
> +0: [0..95]: hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
>  0: [0..95]: extent
> @@ -34,6 +35,7 @@ f4f35d60b3cc18aaa6d8d92f0cd3708a
>  1: [64..95]: hole
>  d8f51c20223dbce5c7c90db87bc221b0
>  	10. hole -> data -> hole
> +0: [0..63]: hole
>  bb7df04e1b0a2570657527a7e108ae23
>  	11. data -> hole -> data
>  0: [0..63]: extent
> diff --git a/tests/generic/058.out b/tests/generic/058.out
> index b15308d..3bbc2a4 100644
> --- a/tests/generic/058.out
> +++ b/tests/generic/058.out
> @@ -1,5 +1,6 @@
>  QA output created by 058
>  	1. into a hole
> +0: [0..55]: hole
>  cf845a781c107ec1346e849c9dd1b7e8
>  	2. into allocated space
>  0: [0..7]: extent
> diff --git a/tests/generic/060.out b/tests/generic/060.out
> index 909b578..210af74 100644
> --- a/tests/generic/060.out
> +++ b/tests/generic/060.out
> @@ -1,5 +1,6 @@
>  QA output created by 060
>  	1. into a hole
> +0: [0..55]: hole
>  cf845a781c107ec1346e849c9dd1b7e8
>  	2. into allocated space
>  0: [0..7]: extent
> diff --git a/tests/generic/061.out b/tests/generic/061.out
> index 78d6c6d..6d95680 100644
> --- a/tests/generic/061.out
> +++ b/tests/generic/061.out
> @@ -1,5 +1,6 @@
>  QA output created by 061
>  	1. into a hole
> +0: [0..55]: hole
>  cf845a781c107ec1346e849c9dd1b7e8
>  	2. into allocated space
>  0: [0..7]: extent
> diff --git a/tests/generic/063.out b/tests/generic/063.out
> index d828ff6..10db43f 100644
> --- a/tests/generic/063.out
> +++ b/tests/generic/063.out
> @@ -1,5 +1,6 @@
>  QA output created by 063
>  	1. into a hole
> +0: [0..55]: hole
>  cf845a781c107ec1346e849c9dd1b7e8
>  	2. into allocated space
>  0: [0..7]: extent
> diff --git a/tests/generic/255.out b/tests/generic/255.out
> index 217ef3e..441fde8 100644
> --- a/tests/generic/255.out
> +++ b/tests/generic/255.out
> @@ -1,5 +1,6 @@
>  QA output created by 255
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -42,6 +43,7 @@ daa100df6e6711906b61c9ab5aa16032
>  3: [32..39]: hole
>  cc63069677939f69a6e8f68cae6a6dac
>  	10. hole -> data -> hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	11. data -> hole -> data
>  0: [0..7]: extent
> @@ -79,6 +81,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -121,6 +124,7 @@ daa100df6e6711906b61c9ab5aa16032
>  3: [32..39]: hole
>  cc63069677939f69a6e8f68cae6a6dac
>  	10. hole -> data -> hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	11. data -> hole -> data
>  0: [0..7]: extent
> @@ -158,6 +162,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -240,6 +245,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> diff --git a/tests/generic/316.out b/tests/generic/316.out
> index 383f0d1..5506198 100644
> --- a/tests/generic/316.out
> +++ b/tests/generic/316.out
> @@ -1,5 +1,6 @@
>  QA output created by 316
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -16,6 +17,7 @@ cc63069677939f69a6e8f68cae6a6dac
>  1: [8..39]: hole
>  1b3779878366498b28c702ef88c4a773
>  	10. hole -> data -> hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	11. data -> hole -> data
>  0: [0..7]: extent
> @@ -43,6 +45,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -59,6 +62,7 @@ cc63069677939f69a6e8f68cae6a6dac
>  1: [8..39]: hole
>  1b3779878366498b28c702ef88c4a773
>  	10. hole -> data -> hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	11. data -> hole -> data
>  0: [0..7]: extent
> @@ -86,6 +90,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> @@ -133,6 +138,7 @@ eecb7aa303d121835de05028751d301c
>  0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>  *
>  	1. into a hole
> +0: [0..39]: hole
>  daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
>  0: [0..7]: extent
> -- 
> 2.7.4
> 
