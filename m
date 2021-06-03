Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACB8C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE5C613F1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFCE7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhFCE7s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 00:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9937E613EE;
        Thu,  3 Jun 2021 04:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622696284;
        bh=fpxmeuddJDlHStgochd//zgLoVyFw6V3j2W7DirBnYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCYxiR5QXHcBiA7lUGmhzaf5cbHPlQzd3zGcc5ZgsqP3GB1AsSmZhDfIbknl+pJlF
         hFJ3nNN4alrmlCavqUCDQeOl6o+hSvPW2uIc5M/0NOOUVCzzIzzIR75IcPnL8zXhoP
         E4SmQFw1/3sNAueKWVIKCL9NHsHWUx9htNyuZ56HewODms3ym55h94t3EoxvTRzRn9
         RvXaCxDh1m6HbQG3XQ0idMdt0l2ueklxB+KzVshDTBKF4oeUUhDoa4+tQ0YuvxLEyF
         XOR0p0xrJUWo9eoLq+nND7Rj6hc8jlTxULDuzYCD9VP+ppdmADcIygC2D3GWCzrl9/
         oFoA78xuHEvoA==
Date:   Wed, 2 Jun 2021 21:58:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 04/10] fstests: move test group info to test files
Message-ID: <YLhhW17x/Kq0Bnq3@sol.localdomain>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <162199362461.3744214.7536635976092405399.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162199362461.3744214.7536635976092405399.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 06:47:04PM -0700, Darrick J. Wong wrote:
> diff --git a/tests/btrfs/001 b/tests/btrfs/001
> index fb051e8a..2248b6f6 100755
> --- a/tests/btrfs/001
> +++ b/tests/btrfs/001
> @@ -6,13 +6,9 @@
>  #
>  # Test btrfs's subvolume and snapshot support
>  #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> +. ./common/test_names
> +_set_seq_and_groups auto quick subvol snapshot

The naming is a little weird here.  This feels more like a common preamble,
especially given that it also sets $here, $tmp, and $status -- not just the test
groups.  Maybe it should look like:

. ./common/preamble
_begin_fstest quick subvol snapshot
