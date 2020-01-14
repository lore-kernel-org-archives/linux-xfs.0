Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E495DC33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE8020678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0QTaClT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgANGfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:35:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727072AbgANGfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578983736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NuWxAQh15vARTejqn9h6NUEZk+H+pLSpG0/gToNKllw=;
        b=V0QTaClTz0afSshU0ETwa2GXaYJbUIuh+RaHF+EvmVwTp6ZEjRCWSeZT7jKYCul+7V5ZEG
        DKsAyQAZKAVzNCjM1R1r7cHrx0xB+LTX4qU7hbf9cOHoVoIiLCtsIUOil2YcogpnbZSYCb
        sD1df+ekFId0kIxtG4iU82Thw9T+aOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-Lxp5_hzpOHi21wOpFuxzcQ-1; Tue, 14 Jan 2020 01:35:31 -0500
X-MC-Unique: Lxp5_hzpOHi21wOpFuxzcQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FD33800D48;
        Tue, 14 Jan 2020 06:35:30 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19F66A4B60;
        Tue, 14 Jan 2020 06:35:26 +0000 (UTC)
Date:   Tue, 14 Jan 2020 14:44:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfstests: xfs mount option sanity test
Message-ID: <20200114064433.GC14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
References: <20191030103410.2239-1-zlang@redhat.com>
 <20200113180036.GH8247@magnolia>
 <20200113182356.GJ8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113182356.GJ8247@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 10:23:56AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 13, 2020 at 10:00:36AM -0800, Darrick J. Wong wrote:
> > On Wed, Oct 30, 2019 at 06:34:10PM +0800, Zorro Lang wrote:
> > > XFS is changing to suit the new mount API, so add this case to make
> > > sure the changing won't bring in regression issue on xfs mount option
> > > parse phase, and won't change some default behaviors either.
> > 
> > This testcase examines the intersection of some mkfs options and a large
> > number of mount options, but it doesn't log any breadcrumbs of which
> > scenario it's testing at any given time.  When something goes wrong,
> > it's /very/ difficult to map that back to the do_mkfs/do_test call.
> > 
> > (FWIW I added this test as xfs/997 and attached the diff I needed to
> 
> HAH I lied.  Here's the patch.

Thanks Darrick. I'd like to output these informations.

But your original problem which blocked this case is this:
https://marc.info/?l=fstests&m=157247745012095&w=2

I don't know how to deal with it, and don't know how to reproduce either.
Is it still a issue for you?

Thanks,
Zorro

> 
> --D
> 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH] xfs/997: fix problems with test
> 
> Fix problems with Zorro Lang's new mount options test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/997     |   19 ++++++-----
>  tests/xfs/997.out |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 105 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/xfs/997 b/tests/xfs/997
> index a662f6f7..9d59b4f4 100755
> --- a/tests/xfs/997
> +++ b/tests/xfs/997
> @@ -65,7 +65,8 @@ mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
>  MKFS_OPTIONS=""
>  do_mkfs()
>  {
> -	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> +	echo "FORMAT: $@" | tee -a $seqres.full
> +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
>  	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
>  		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
>  	fi
> @@ -99,12 +100,12 @@ _do_test()
>  	local info
>  
>  	# mount test
> -	_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
> +	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
>  	rc=$?
>  	if [ $rc -eq 0 ];then
>  		if [ "${mounted}" = "fail" ];then
>  			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> -			echo "ERROR: expect ${mounted}, but pass"
> +			echo "ERROR: expect mount to fail, but it succeeded"
>  			return 1
>  		fi
>  		is_dev_mounted
> @@ -114,9 +115,9 @@ _do_test()
>  			return 1
>  		fi
>  	else
> -		if [ "${mount_ret}" = "pass" ];then
> +		if [ "${mounted}" = "pass" ];then
>  			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> -			echo "ERROR: expect ${mounted}, but fail"
> +			echo "ERROR: expect mount to succeed, but it failed"
>  			return 1
>  		fi
>  		is_dev_mounted
> @@ -133,18 +134,18 @@ _do_test()
>  	fi
>  	# Check the mount options after fs mounted.
>  	info=`get_mount_info`
> -	echo $info | grep -q "${key}"
> +	echo "${info}" | grep -q "${key}"
>  	rc=$?
>  	if [ $rc -eq 0 ];then
>  		if [ "$found" != "true" ];then
>  			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> -			echo "ERROR: expect there's not $key in $info, but not found"
> +			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
>  			return 1
>  		fi
>  	else
>  		if [ "$found" != "false" ];then
>  			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> -			echo "ERROR: expect there's $key in $info, but found"
> +			echo "ERROR: did not expect to find \"$key\" in \"$info\""
>  			return 1
>  		fi
>  	fi
> @@ -154,6 +155,8 @@ _do_test()
>  
>  do_test()
>  {
> +	echo "TEST: $@" | tee -a $seqres.full
> +
>  	# force unmount before testing
>  	force_unmount
>  	_do_test "$@"
> diff --git a/tests/xfs/997.out b/tests/xfs/997.out
> index f2fc684f..c6624925 100644
> --- a/tests/xfs/997.out
> +++ b/tests/xfs/997.out
> @@ -3,4 +3,98 @@ QA output created by 997
>  ** create loop log device
>  ** create loop mount point
>  ** start xfs mount testing ...
> +FORMAT: 
> +TEST:  pass allocsize false
> +TEST: -o allocsize=4k pass allocsize=4k true
> +TEST: -o allocsize=1048576k pass allocsize=1048576k true
> +TEST: -o allocsize=2048 fail
> +TEST: -o allocsize=2g fail
> +FORMAT: -m crc=1
> +TEST:  pass attr2 true
> +TEST: -o attr2 pass attr2 true
> +TEST: -o noattr2 fail
> +FORMAT: -m crc=0
> +TEST:  pass attr2 true
> +TEST: -o attr2 pass attr2 true
> +TEST: -o noattr2 pass attr2 false
> +FORMAT: 
> +TEST:  pass discard false
> +TEST: -o discard pass discard true
> +TEST: -o nodiscard pass discard false
> +TEST:  pass grpid false
> +TEST: -o grpid pass grpid true
> +TEST: -o bsdgroups pass grpid true
> +TEST: -o nogrpid pass grpid false
> +TEST: -o sysvgroups pass grpid false
> +TEST:  pass filestreams false
> +TEST: -o filestreams pass filestreams true
> +TEST:  pass ikeep false
> +TEST: -o ikeep pass ikeep true
> +TEST: -o noikeep pass ikeep false
> +TEST:  pass inode64 true
> +TEST: -o inode32 pass inode32 true
> +TEST: -o inode64 pass inode64 true
> +TEST:  pass largeio false
> +TEST: -o largeio pass largeio true
> +TEST: -o nolargeio pass largeio false
> +TEST: -o logbufs=8 pass logbufs=8 true
> +TEST: -o logbufs=2 pass logbufs=2 true
> +TEST: -o logbufs=1 fail
> +TEST: -o logbufs=9 fail
> +TEST: -o logbufs=99999999999999 fail
> +FORMAT: -m crc=1 -l version=2
> +TEST: -o logbsize=16384 pass logbsize=16k true
> +TEST: -o logbsize=16k pass logbsize=16k true
> +TEST: -o logbsize=32k pass logbsize=32k true
> +TEST: -o logbsize=64k pass logbsize=64k true
> +TEST: -o logbsize=128k pass logbsize=128k true
> +TEST: -o logbsize=256k pass logbsize=256k true
> +TEST: -o logbsize=8k fail
> +TEST: -o logbsize=512k fail
> +FORMAT: -m crc=0 -l version=1
> +TEST: -o logbsize=16384 pass logbsize=16k true
> +TEST: -o logbsize=16k pass logbsize=16k true
> +TEST: -o logbsize=32k pass logbsize=32k true
> +TEST: -o logbsize=64k fail
> +FORMAT: 
> +TEST:  pass logdev false
> +TEST: -o logdev=/dev/loop1 fail
> +FORMAT: -l logdev=/dev/loop1
> +TEST: -o logdev=/dev/loop1 pass logdev=/dev/loop1 true
> +TEST:  fail
> +FORMAT: 
> +TEST:  pass noalign false
> +TEST: -o noalign pass noalign true
> +TEST:  pass norecovery false
> +TEST: -o norecovery,ro pass norecovery true
> +TEST: -o norecovery fail
> +TEST:  pass nouuid false
> +TEST: -o nouuid pass nouuid true
> +TEST:  pass noquota true
> +TEST: -o noquota pass noquota true
> +TEST:  pass usrquota false
> +TEST: -o uquota pass usrquota true
> +TEST: -o usrquota pass usrquota true
> +TEST: -o quota pass usrquota true
> +TEST: -o uqnoenforce pass usrquota true
> +TEST: -o qnoenforce pass usrquota true
> +TEST:  pass grpquota false
> +TEST: -o gquota pass grpquota true
> +TEST: -o grpquota pass grpquota true
> +TEST: -o gqnoenforce pass gqnoenforce true
> +TEST:  pass prjquota false
> +TEST: -o pquota pass prjquota true
> +TEST: -o prjquota pass prjquota true
> +TEST: -o pqnoenforce pass pqnoenforce true
> +FORMAT: -d sunit=128,swidth=128
> +TEST: -o sunit=8,swidth=8 pass sunit=8,swidth=8 true
> +TEST: -o sunit=8,swidth=64 pass sunit=8,swidth=64 true
> +TEST: -o sunit=128,swidth=128 pass sunit=128,swidth=128 true
> +TEST: -o sunit=256,swidth=256 pass sunit=256,swidth=256 true
> +TEST: -o sunit=2,swidth=2 fail
> +FORMAT: 
> +TEST:  pass swalloc false
> +TEST: -o swalloc pass swalloc true
> +TEST:  pass wsync false
> +TEST: -o wsync pass wsync true
>  ** end of testing
> 

