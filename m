Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948C9C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 10:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiI1KNA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 06:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiI1KM7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 06:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C792F2743
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664359976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34ah5Qx5SWB/Hj8cpIchXCXz8Ue2F2IGLqZPbERHyto=;
        b=V/icuWO1Uk5cYwIGAYdEYiLYI9CjX4ud4KtB6F0DN08FZQu0qKZGsbdSubv4Z4qFrxU5eB
        1hYuhKWZMx7S/3GfZTcqQkPCYsc8WdPNi7DlRdBNqXom0wV+zZmTK2aeYBIT5k54ygzStv
        6E1D9C//pGLsYzhNdJSyH5aMWrVo73k=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-348-ZwAxJKRSPz6KjZh9k5cUnA-1; Wed, 28 Sep 2022 06:12:55 -0400
X-MC-Unique: ZwAxJKRSPz6KjZh9k5cUnA-1
Received: by mail-qk1-f197.google.com with SMTP id bi3-20020a05620a318300b006cf2d389cdaso9076707qkb.8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=34ah5Qx5SWB/Hj8cpIchXCXz8Ue2F2IGLqZPbERHyto=;
        b=CFstt2PvzBGIHO9hqTwd5PJBQ5Un1Dd/EZ//cLkTEiHD+teHnhDimU0F67Ddkya3Iu
         jnzQPIruvcEmYrwThwohhVwedofDt3X9t3LlXZeu2dvrvn9JE8YiIy95GRug6ixsT+ub
         DAzrLIDKlZU51EmKQbvc9HWww0dCQsq73G16V0wwOSJsEQiKuXBXi74HoUGn4pWodsHK
         VnPmvxibMIhQoENja8wtEOMT8BZE5CafrFrrBAS4w68Rioi7t/D4sWVRx5fjezlnNSbD
         TpozDhyAWrgpHOtm2xrQPfmisVOjrrY3OGHkBN5rN4RvLttjyMw6eJV/yzBYb5giO84k
         T1IQ==
X-Gm-Message-State: ACrzQf1BJ4ruBdBl7TWTmeZRQCBpjdwiadEEUSFwvcuNWSGni3jX5QgI
        vueMCFd1f6lSr/W1da2oXzVkQsBZXqseNjDDN87/hFRY8YnQFCyE8VeY8DT/gLXw4Yg6cTJZObf
        XR5+YQ8lGbTaUHjP8bg+M
X-Received: by 2002:ac8:5909:0:b0:35b:ce5c:ed73 with SMTP id 9-20020ac85909000000b0035bce5ced73mr25392045qty.635.1664359975047;
        Wed, 28 Sep 2022 03:12:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4JGBVNtWy9tMXwmkgIEckWnJDeIWtEspWCYEjr0BDUO+vSzCxJn35ZnruFwmn/0lxjiUIm0A==
X-Received: by 2002:ac8:5909:0:b0:35b:ce5c:ed73 with SMTP id 9-20020ac85909000000b0035bce5ced73mr25392025qty.635.1664359974780;
        Wed, 28 Sep 2022 03:12:54 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h12-20020a05620a284c00b006b5e296452csm2448074qkp.54.2022.09.28.03.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 03:12:54 -0700 (PDT)
Date:   Wed, 28 Sep 2022 18:12:49 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs/229: do not _xfs_force_bdev on TEST_DIR
Message-ID: <20220928101249.we2numsrkpzbruqx@zlang-mailbox>
References: <166433903099.2008389.13181182359220271890.stgit@magnolia>
 <166433904802.2008389.15649565619122354418.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166433904802.2008389.15649565619122354418.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 27, 2022 at 09:24:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit ea15099b71, I observed that this test tries to test the
> behavior of the extent size hint on the data device.  If the test runner
> set up MKFS_OPTIONS such that the filesystem gets created with a
> realtime section and rtinherit set on the root directory, then the
> preconditions of this test (creating files on the data section) is not
> satisfied and the results of this test are incorrect.  The solution was
> to force all files created by this test to be assigned to the data
> section.
> 
> Unfortunately, the correction that I made has side effects beyond this
> test -- by clearing rtinherit on $TEST_DIR, all tests that run after
> this one will create files on the data section, because the test
> filesystem persists for the duration of the entire test run.  This leads
> to the wrong things being tested.
> 
> Fix this new problem by clearing the rtinherit flag on $TDIR, which
> contains the files created by this test and is removed during cleanup,
> and leave a few comments celebrating our new discoveries.
> 
> Fixes: ea15099b71 ("xfs: force file creation to the data device for certain layout tests")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

OK, good news is most of _xfs_force_bdev run on SCRATCH_MNT, only this x/229 run
on TEST_DIR. Better to not change TEST_DIR directly, to avoid it affect later
testing. Thanks for fix it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  common/xfs    |    3 +++
>  tests/xfs/229 |    7 ++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 170dd621a1..e1c15d3d04 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -201,6 +201,9 @@ _xfs_get_file_block_size()
>  # For each directory, each file subsequently created will target the given
>  # device for file data allocations.  For each empty regular file, each
>  # subsequent file data allocation will be on the given device.
> +#
> +# NOTE: If you call this on $TEST_DIR, you must reset the rtinherit flag state
> +# before the end of the test to avoid polluting subsequent tests.
>  _xfs_force_bdev()
>  {
>  	local device="$1"
> diff --git a/tests/xfs/229 b/tests/xfs/229
> index 2221b9c49c..a58fd16bba 100755
> --- a/tests/xfs/229
> +++ b/tests/xfs/229
> @@ -31,11 +31,16 @@ _require_fs_space $TEST_DIR 3200000
>  TDIR="${TEST_DIR}/t_holes"
>  NFILES="10"
>  EXTSIZE="256k"
> -_xfs_force_bdev data $TEST_DIR
>  
>  # Create the test directory
>  mkdir ${TDIR}
>  
> +# Per-directory extent size hints aren't particularly useful for files that
> +# are created on the realtime section.  Force the test file to be created on
> +# the data directory.  Do not change the rtinherit flag on $TEST_DIR because
> +# that will affect other tests.
> +_xfs_force_bdev data $TDIR
> +
>  # Set the test directory extsize
>  $XFS_IO_PROG -c "extsize ${EXTSIZE}" ${TDIR}
>  
> 

