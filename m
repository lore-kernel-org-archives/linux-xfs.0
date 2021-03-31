Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82531C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8A661028
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhCaRoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:44:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234461AbhCaRni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 13:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617212617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cpp7QxY9/an/scdCD/JNUzLOu93g5WzRkcdok8p4WVo=;
        b=jEKSziIIzBfgXdUVPQctcwVX72nMKPenZAJVlcRnUlJcDIdDGtC/d1qs7qCrFGISAHDGd7
        1J7UYiYh18ebEIDz2JDxtotdI9Tb1o0iT4eMa/8lBAiAi91le5SRgrQxaFW2owPa5LtASr
        AhQLN1WSSvxUtUbmmQD3VVafFKk8YQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-_xdsb403MHGXKcxa6w3mGA-1; Wed, 31 Mar 2021 13:43:35 -0400
X-MC-Unique: _xdsb403MHGXKcxa6w3mGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D38B801817;
        Wed, 31 Mar 2021 17:43:34 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B40CD19C44;
        Wed, 31 Mar 2021 17:43:33 +0000 (UTC)
Date:   Wed, 31 Mar 2021 13:43:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs/23[12]: abstractify the XFS cow prealloc
 trimming interval
Message-ID: <YGS0w5QePsZeYAKZ@bfoster>
References: <161715293961.2704105.12379656102061134645.stgit@magnolia>
 <161715294506.2704105.18365101912825541162.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161715294506.2704105.18365101912825541162.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 06:09:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a couple of helper functions to get and set the XFS copy on write
> preallocation garbage collection interval.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs    |   23 +++++++++++++++++++++++
>  tests/xfs/231 |   13 +++++++------
>  tests/xfs/232 |   13 +++++++------
>  3 files changed, 37 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index c430b3ac..ade76d5a 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1165,3 +1165,26 @@ _require_xfs_scratch_bigtime()
>  		_notrun "bigtime feature not advertised on mount?"
>  	_scratch_unmount
>  }
> +
> +__xfs_cowgc_interval_knob1="/proc/sys/fs/xfs/speculative_cow_prealloc_lifetime"
> +__xfs_cowgc_interval_knob2="/proc/sys/fs/xfs/speculative_prealloc_lifetime"
> +
> +_xfs_set_cowgc_interval() {
> +	if [ -w $__xfs_cowgc_interval_knob1 ]; then
> +		echo "$@" > $__xfs_cowgc_interval_knob1
> +	elif [ -w $__xfs_cowgc_interval_knob2 ]; then
> +		echo "$@" > $__xfs_cowgc_interval_knob2
> +	else
> +		_fail "Can't find cowgc interval procfs knob?"
> +	fi
> +}
> +
> +_xfs_get_cowgc_interval() {
> +	if [ -w $__xfs_cowgc_interval_knob1 ]; then
> +		cat $__xfs_cowgc_interval_knob1
> +	elif [ -w $__xfs_cowgc_interval_knob2 ]; then
> +		cat $__xfs_cowgc_interval_knob2
> +	else
> +		_fail "Can't find cowgc interval procfs knob?"
> +	fi
> +}
> diff --git a/tests/xfs/231 b/tests/xfs/231
> index 5930339d..119a71bb 100755
> --- a/tests/xfs/231
> +++ b/tests/xfs/231
> @@ -22,9 +22,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  _cleanup()
>  {
> -    cd /
> -    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> -    rm -rf $tmp.*
> +	cd /
> +	test -n "$old_cowgc_interval" && \
> +		_xfs_set_cowgc_interval $old_cowgc_interval
> +	rm -rf $tmp.*
>  }
>  
>  # get standard environment, filters and checks
> @@ -40,7 +41,7 @@ _require_xfs_io_command "cowextsize"
>  _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fiemap"
>  
> -old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
> +old_cowgc_interval=$(_xfs_get_cowgc_interval)
>  
>  rm -f $seqres.full
>  
> @@ -74,7 +75,7 @@ md5sum $testdir/file2 | _filter_scratch
>  md5sum $testdir/file2.chk | _filter_scratch
>  
>  echo "CoW and leave leftovers"
> -echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +_xfs_set_cowgc_interval 2
>  seq 2 2 $((nr - 1)) | while read f; do
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
> @@ -91,7 +92,7 @@ done
>  $XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
>  
>  echo "CoW and leave leftovers"
> -echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +_xfs_set_cowgc_interval $old_cowgc_interval
>  seq 2 2 $((nr - 1)) | while read f; do
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full
> diff --git a/tests/xfs/232 b/tests/xfs/232
> index e56eb3aa..909f921c 100755
> --- a/tests/xfs/232
> +++ b/tests/xfs/232
> @@ -23,9 +23,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  _cleanup()
>  {
> -    cd /
> -    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> -    rm -rf $tmp.*
> +	cd /
> +	test -n "$old_cowgc_interval" && \
> +		_xfs_set_cowgc_interval $old_cowgc_interval
> +	rm -rf $tmp.*
>  }
>  
>  # get standard environment, filters and checks
> @@ -41,7 +42,7 @@ _require_cp_reflink
>  _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fiemap"
>  
> -old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
> +old_cowgc_interval=$(_xfs_get_cowgc_interval)
>  
>  rm -f $seqres.full
>  
> @@ -75,7 +76,7 @@ md5sum $testdir/file2 | _filter_scratch
>  md5sum $testdir/file2.chk | _filter_scratch
>  
>  echo "CoW and leave leftovers"
> -echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +_xfs_set_cowgc_interval 2
>  seq 2 2 $((nr - 1)) | while read f; do
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
> @@ -93,7 +94,7 @@ done
>  $XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
>  
>  echo "CoW and leave leftovers"
> -echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +_xfs_set_cowgc_interval $old_cowgc_interval
>  seq 2 2 $((nr - 1)) | while read f; do
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
>  	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full
> 

