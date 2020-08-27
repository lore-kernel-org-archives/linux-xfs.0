Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB10DC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7047207DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b08A2Blf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgH0HiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgH0HiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:38:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94B8C061264;
        Thu, 27 Aug 2020 00:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B6stekAtfOiPtTZa1tjln+1mufnSLuuxZ66Xs0GNe9E=; b=b08A2BlfUBftf0cSs2+1UcS39t
        tGi8wno71Muwr1Nic5qFvUjJHpCCK3Fsv166Y8GL9wtafPYgHuHwAa8nJAgWvg7tpJblkcO8Dg/fI
        N53InFuHRdZtEDYsNOgvwYay3qkK08xTQ9JPqr1kTrXvPbFz1cRvnXB/6FjwYaknt+pLzXn4t2NbD
        PqwlacpTjZMEZgjTbGV+GFqhua3OkTF6y+wQ4yqsGwtfsm6JVULt/RgBDA2xGx5wdjj9ZbId4HB3P
        oPj6ySXwkkWlIi5EPJeWiP1BooLl6hSC4tZQerUTD4iYvkHUhBhGBuYTFbyexn1bwj77FweLd+3rG
        xz8UFJdg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBCTy-0008AV-IU; Thu, 27 Aug 2020 07:38:02 +0000
Date:   Thu, 27 Aug 2020 08:38:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200827073802.GB30374@infradead.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826143815.360002-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 10:38:12AM -0400, Brian Foster wrote:
> Several generic fstests use dm-log-writes to test the filesystem for
> consistency at various crash recovery points. dm-log-writes and the
> associated replay mechanism rely on zeroing via discard to clear
> stale blocks when moving to various points in time of the fs. If the
> storage doesn't provide zeroing or the discard requests exceed the
> hardcoded maximum (128MB) of the fallback solution to physically
> write zeroes, stale blocks are left around in the target fs. This
> scheme is known to cause issues on XFS v5 superblocks if recovery
> observes metadata from a future variant of an fs that has been
> replayed to an older point in time. This corrupts the filesystem and
> leads to false test failures.
> 
> generic/482 already works around this problem by using a thin volume
> as the target device, which provides consistent and efficient
> discard zeroing behavior, but other tests have seen similar issues
> on XFS. Add an XFS specific check to the dmlogwrites init time code
> that requires discard zeroing support and otherwise skips the test
> to avoid false positive failures.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  common/dmlogwrites | 10 ++++++++--
>  common/rc          | 14 ++++++++++++++
>  tests/generic/470  |  2 +-
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 573f4b8a..92cc6ce2 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -43,9 +43,10 @@ _require_log_writes_dax_mountopt()
>  	_require_test_program "log-writes/replay-log"
>  
>  	local ret=0
> -	local mountopt=$1
> +	local dev=$1
> +	local mountopt=$2
>  
> -	_log_writes_init $SCRATCH_DEV
> +	_log_writes_init $dev
>  	_log_writes_mkfs > /dev/null 2>&1
>  	_log_writes_mount "-o $mountopt" > /dev/null 2>&1
>  	# Check options to be sure.
> @@ -66,6 +67,11 @@ _log_writes_init()
>  	[ -z "$blkdev" ] && _fail \
>  	"block dev must be specified for _log_writes_init"
>  
> +	# XFS requires discard zeroing support on the target device to work
> +	# reliably with dm-log-writes. Use dm-thin devices in tests that want
> +	# to provide reliable discard zeroing support.
> +	[ $FSTYP == "xfs" ] && _require_discard_zeroes $blkdev
> +
>  	local BLK_DEV_SIZE=`blockdev --getsz $blkdev`
>  	LOGWRITES_NAME=logwrites-test
>  	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
> diff --git a/common/rc b/common/rc
> index aa5a7409..fedb5221 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4313,6 +4313,20 @@ _require_mknod()
>  	rm -f $TEST_DIR/$seq.null
>  }
>  
> +# check that discard is supported and subsequent reads return zeroes
> +_require_discard_zeroes()
> +{
> +	local dev=$1
> +
> +	_require_command "$BLKDISCARD_PROG" blkdiscard
> +
> +	$XFS_IO_PROG -c "pwrite -S 0xcd 0 4k" $dev > /dev/null 2>&1 ||
> +		_fail "write error"
> +	$BLKDISCARD_PROG -o 0 -l 1m $dev || _notrun "no discard support"
> +	hexdump -n 4096 $dev | head -n 1 | grep cdcd &&
> +		_notrun "no discard zeroing support"
> +}

This test is bogus.  a discard may zero parts of the request or all
of it.  It may decided to zero based on the LBA, the physical block
number in the SSD, the phase of the moon or a random number generator.
