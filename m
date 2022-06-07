Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40264C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 01:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiFHBMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839303AbiFHAC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 20:02:56 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0451E116C;
        Tue,  7 Jun 2022 16:51:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7792510E6F44;
        Wed,  8 Jun 2022 09:51:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyiyz-003x7L-6w; Wed, 08 Jun 2022 09:51:33 +1000
Date:   Wed, 8 Jun 2022 09:51:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/270: Fix ro mount failure when nrext64 option is
 enabled
Message-ID: <20220607235133.GR1098723@dread.disaster.area>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-2-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629fe486
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=yPCof4ZbAAAA:8 a=gh22zWRxAAAA:8
        a=7-415B0cAAAA:8 a=iyr5ntAFVU7-vM_09pAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:10:58PM +0530, Chandan Babu R wrote:
> With nrext64 option enabled at run time, the read-only mount performed by the
> test fails because,
> 1. mkfs.xfs would have calculated log size based on reflink being enabled.
> 2. Clearing the reflink ro compat bit causes log size calculations to yield a
>    different value.
> 3. In the case where nrext64 is enabled, this causes attr reservation to be
>    the largest among all the transaction reservations.
> 4. This ends up causing XFS to require a larger ondisk log size than that
>    which is available.
> 
> This commit fixes the problem by setting features_ro_compat to the value
> obtained by the bitwise-OR of features_ro_compat field with 2^31.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/270     | 16 ++++++++++++++--
>  tests/xfs/270.out |  1 -
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index 0ab0c7d8..f3796691 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -27,8 +27,20 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
>  # set the highest bit of features_ro_compat, use it as an unknown
>  # feature bit. If one day this bit become known feature, please
>  # change this case.
> -_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
> -	grep 'features_ro_compat'
> +ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
> +ro_compat=${ro_compat##0x}
> +ro_compat="16#"${ro_compat}
> +ro_compat=$(($ro_compat|16#80000000))
> +ro_compat=$(_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" \
> +					    "sb 0" | grep 'features_ro_compat')
> +
> +ro_compat=${ro_compat##features_ro_compat = 0x}
> +ro_compat="16#"${ro_compat}
> +ro_compat=$(($ro_compat&16#80000000))
> +if (( $ro_compat != 16#80000000 )); then
> +	echo "Unable to set most significant bit of features_ro_compat"
> +fi

Urk. Bash - the new line noise generator. :(

This is basically just bit manipulation in hex format. db accepts
hex format integers (i.e. 0x1234), and according to the bash man
page, it understands the 0x1234 prefix as well. So AFAICT there's no
need for this weird "16#" prefix for the bit operations.

But regardless of that, just because you can do something in bash
doesn't mean you should:

wit://utcc.utoronto.ca/~cks/space/blog/programming/ShellScriptsBeClearFirst

IMO, this reads much better as something like:

# grab the current ro compat fields and add an invalid high bit.
ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" | \
		awk '/features_ro_compat/ {
			printf("0x%x\n", or(strtonum($3), 0x80000000)
		}')

# write the new ro compat field to the superblock
_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0"

# read the newly set ro compat filed for verification
new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" | \
		awk '/features_ro_compat/ {
			printf("0x%x\n", $3)
		}')

# verify the new ro_compat field is correct.
if [ $new_ro_compat != $ro_compat ]; then
	echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
fi

Yes, it's more lines of code, but it's easy to read, easy to
understand, and easy to modify in future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
