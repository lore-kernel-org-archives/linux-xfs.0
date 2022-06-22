Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE341C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 17:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358691AbiFVRDi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 13:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359689AbiFVRD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 13:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F934AE70;
        Wed, 22 Jun 2022 10:03:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1E761B79;
        Wed, 22 Jun 2022 17:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45282C34114;
        Wed, 22 Jun 2022 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655917402;
        bh=6srFTbkhOOJ6JFtY6VDtlWa9vH/lXRMG/43q118VDt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddPZAu5KMaEg+OUQcMZkVBaHE0RZyskProhODA+jFf73Ldbz0oxHzKXIC6FbgYrcz
         39nk21asQVYGHsJBZucNobCApFKFwOoExJnJKfnZV2y5j5VOCShAfS49WdSbVJ2/N9
         hNldiSstBoxMTpz+/w5JY+tsu6nzfC44avSoH9on6UovXE5uTKit0V4Ed9fGMStqQV
         a1Ji4Cpc/QtuCCvaY/plkwtu6TYChVxr+18HrictgpNFBYbRkI4uDTQ9z3TrVXBdsm
         YVeOArs6D3+DPqpRftTLXuMLF4rqdJNZCmPDM0pR19H7TL8ApY/Ic4j0c1E3ntTErE
         f8mAFj8QkTkEQ==
Date:   Wed, 22 Jun 2022 10:03:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3 1/4] xfs/270: Fix ro mount failure when nrext64 option
 is enabled
Message-ID: <YrNLWX0gVnl/EYTD@magnolia>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
 <20220611111037.433134-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611111037.433134-2-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 04:40:34PM +0530, Chandan Babu R wrote:
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
> This commit includes changes suggested by Dave Chinner to replace bashisms
> with invocations to inline awk scripts.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/270     | 26 ++++++++++++++++++++++++--
>  tests/xfs/270.out |  1 -
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index 0ab0c7d8..b740c379 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -27,8 +27,30 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
>  # set the highest bit of features_ro_compat, use it as an unknown
>  # feature bit. If one day this bit become known feature, please
>  # change this case.
> -_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
> -	grep 'features_ro_compat'
> +
> +ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
> +echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
> +if [[ $? != 0  ]]; then
> +	echo "features_ro_compat has an invalid value."
> +fi
> +
> +ro_compat=$(echo $ro_compat | \
> +		    awk '/^0x[[:xdigit:]]+/ {

I think the double-braces around :xdigit: were the only changes between
v2 and v3, right?

If so,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +				printf("0x%x\n", or(strtonum($1), 0x80000000))
> +			}')
> +
> +# write the new ro compat field to the superblock
> +_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0" \
> +				> $seqres.full 2>&1
> +
> +# read the newly set ro compat filed for verification
> +new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" \
> +						2>/dev/null)
> +
> +# verify the new ro_compat field is correct.
> +if [ $new_ro_compat != $ro_compat ]; then
> +	echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
> +fi
>  
>  # rw mount with unknown ro-compat feature should fail
>  echo "rw mount test"
> diff --git a/tests/xfs/270.out b/tests/xfs/270.out
> index 0a8b3851..edf4c254 100644
> --- a/tests/xfs/270.out
> +++ b/tests/xfs/270.out
> @@ -1,5 +1,4 @@
>  QA output created by 270
> -features_ro_compat = 0x80000000
>  rw mount test
>  ro mount test
>  rw remount test
> -- 
> 2.35.1
> 
