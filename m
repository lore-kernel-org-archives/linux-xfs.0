Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492673;
	b=vLF+WMRcAwV6zKyoyMKhWZ0hREJEXhwiQCydtOt/z/x0nJ3Wayjjh3xc41rSs3kGGNID
	 xz1PsvHoJsdiQKuzPOJ4vmr33/XS4gxS/q3O2efmzq36rHRQnF74VVKI1FH0ETtI4u1nL
	 CwFWp3RyvG+m3HTxBcwFDdpx6PuJZhtDdmkFCGfvxmUxia8zTWfHm8+dmOjrhijDYQkv0
	 Wac7iqr1xcOurc520jMF4ht5qSyV7ZQkxbcLZ7Z1pnLcF1Ob6b3z2WmGCHfaCmfKBKgJM
	 n4pG4g+G/a9eKy3yLFotVlUBjfN0M/OL8bW+QMWhswK26bKYK7TUauVwABFUocNx8Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492673;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=hATKghkMU5Sg9ujrHWra+a3YAWi7gTCAQ7CHmAmpFz0=;
	b=dGskRsS0Qa9txJ+LfpdBNbFW0etdss+TEgA/zA4G3cxGYVw19BdDmExaNK0prv9Ff1rr
	 gEgH1HM+PyjDrW6sUElIj7Donq7K4H7z7ZTR6lcKKoU/G7Q0ed2vSh2SO6HgFr/riNF9F
	 fXbwDAOlXD9T4r3Z1oBtiwJ2aO7aKTx+jbpvrEnh+jmAN0AN+tftg5C0hvloevomqd7j6
	 1GhZxRHpAXdjpNIgDRZFg5q89krJ2tC7tsSC4ukFRtWd/CuTMf6+04mCEeplDJS8VSZdG
	 Fj0NBbrd4DHLiRdsYMZ5m4ujYz74+PVOCwK5L2TlcZU5PdhKH/PDgg+VY8RVKzsUgVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdZ9GzXf;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2E7606A327
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 14:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F2E7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdZ9GzXf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794492666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hATKghkMU5Sg9ujrHWra+a3YAWi7gTCAQ7CHmAmpFz0=;
	b=OdZ9GzXf+SzU08FcZ3E6T49yJIfDEb3yNQHkroTfAP60dj7K0B9z0ye5wQceQrOnfDnLov
	JeSIyNEg298wVwVZgulb2nFtOtsNqAWzqe9tBHJGcRwcSIUr3C8ATfVjfgRbNosYEeDTcQ
	ZknyBhn8lph3k2FqEMlaL/RwblRtLpw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-mCKd3NSrMdeY-8F3AgouEg-1; Thu,
 12 Nov 2026 09:10:26 -0500
X-MC-Unique: mCKd3NSrMdeY-8F3AgouEg-1
X-Mimecast-MFC-AGG-ID: mCKd3NSrMdeY-8F3AgouEg_1794492606
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACC0B195BDD1;
	Thu, 12 Nov 2026 14:10:05 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83F671956087;
	Thu, 12 Nov 2026 14:10:04 +0000 (UTC)
Date: Thu, 12 Nov 2026 09:10:02 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/438: fail metadata writes with the buf_ioerror
 error tag
Message-ID: <avXIun_xcSUZ6ABx@bfoster>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
 <20261112-xfs-438-dquot-retry-v1-2-73149b823246@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-2-73149b823246@samsung.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Nov 12, 2026 at 10:37:18AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs/438 needs metadata writes to fail while the log keeps working.
> With a write cache, dm-flakey also fails the flushes that dm sends it
> with REQ_PREFLUSH log writes. The internal log survives only because
> dm drops that error. The dm patch "dm: fail a REQ_PREFLUSH bio with
> data when its preflush fails" fixes that. With an external log, the
> flakey table fails the log device too.
> 
> Use the buf_ioerror error tag. It fails async metadata buffer writes
> and leaves log writes alone. The test now needs XFS_DEBUG.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> On v7.4-rc2 and on v7.4-rc2 with the dm patch, the test passes with
> an internal log (3 of 3) and an external log (1 of 1). The failed
> dquot write is retried until the unmount. On the TEST ONLY kernel of
> patch 1 the unmount hangs with both logs (1 of 1 each).
> ---

Nice simplification.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/438 | 76 ++++++-----------------------------------------------------
>  1 file changed, 7 insertions(+), 69 deletions(-)
> 
> diff --git a/tests/xfs/438 b/tests/xfs/438
> index e4850ff..5c228e4 100755
> --- a/tests/xfs/438
> +++ b/tests/xfs/438
> @@ -14,9 +14,9 @@
>  # get the same IO error, XFS will let xfsaild to restart the write and
>  # xfs_buf_do_callbacks() will not be inovked.
>  #
> -# This test emulates the write error by using dm-flakey. The log
> -# area of the XFS filesystem is excluded from the range covered by
> -# dm-flakey, so the XFS will not be shutdown prematurely.
> +# This test emulates the write error with the buf_ioerror error tag,
> +# which fails async metadata buffer writes. Log writes are not buffer
> +# writes, so the XFS will not be shutdown prematurely.
>  #
>  # Fixed by upstream commit 373b058 ("xfs: Properly retry failed dquot
>  # items in case of error during buffer writeback")
> @@ -33,85 +33,27 @@ _cleanup()
>  	cd /
>  	rm -f $tmp.*
>  	_scratch_unmount >/dev/null 2>&1
> -	_cleanup_flakey > /dev/null 2>&1
> -}
> -
> -# inject IO write error for the XFS filesystem except its log section
> -make_xfs_scratch_flakey_table()
> -{
> -	local tgt=flakey
> -	local opt="0 1 1 error_writes"
> -	local dev=${SCRATCH_DEV}
> -	local dev_sz=$(blockdev --getsz $dev)
> -
> -	# If using an external log device, just making the writing of
> -	# entire data/metadata area fail forever.
> -	if [ "${USE_EXTERNAL}" = "yes" -a ! -z "$SCRATCH_LOGDEV" ]; then
> -		echo "0 ${dev_sz} $tgt $dev 0 $opt"
> -		return
> -	fi
> -
> -	local blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> -	local log_ofs=$(_scratch_xfs_get_sb_field logstart)
> -	local log_sz=$(_scratch_xfs_get_sb_field logblocks)
> -	local table=""
> -	local ofs=0
> -	local sz
> -
> -	log_ofs=$(_scratch_xfs_db -r -c "convert fsb ${log_ofs} bb" | \
> -			  $AWK_PROG '{gsub("[()]", "", $2); print $2}')
> -	let "log_sz *= blk_sz / 512"
> -
> -	# Add a flakey target for the area before the log section
> -	# to make the data/metadata write fail forever
> -	if [ "$ofs" -lt "${log_ofs}" ]; then
> -		let "sz = log_ofs - ofs"
> -		table="$ofs $sz $tgt $dev $ofs $opt"
> -	fi
> -
> -	# Add a linear target for the log section, so the log write
> -	# will work normally
> -	table="$table\n${log_ofs} ${log_sz} linear $dev ${log_ofs}"
> -
> -	# Add a flakey target for the area after the log section
> -	# to make the data/metadata write fail forever
> -	let "ofs = log_ofs + log_sz"
> -	if [ "$ofs" -lt "${dev_sz}" ]; then
> -		let "sz = dev_sz - ofs"
> -		table="$table\n$ofs $sz $tgt $dev $ofs $opt"
> -	fi
> -
> -	echo -e $table
>  }
>  
>  # Import common functions.
> -. ./common/dmflakey
>  . ./common/quota
> +. ./common/inject
>  
>  
>  # due to the injection of write IO error, the fs will be inconsistent
>  _require_scratch_nocheck
> -_require_flakey_with_error_writes
>  _require_user
>  _require_xfs_quota
>  _require_freeze
>  _require_test_sysfs_dev_attr error/fail_at_unmount
>  _require_test_sysfs_dev_attr error/metadata/EIO/max_retries
>  _require_test_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
> +_require_xfs_io_error_injection buf_ioerror
>  
>  echo "Silence is golden"
>  
>  _scratch_mkfs > $seqres.full 2>&1
>  
> -# this needs to happen after mkfs, but before _init_flakey overrides SCRATCH_DEV
> -FLAKEY_TABLE_NON_LOG_ERROR=$(make_xfs_scratch_flakey_table)
> -
> -# no error will be injected
> -_init_flakey
> -FLAKEY_TABLE_ERROR=${FLAKEY_TABLE_NON_LOG_ERROR}
> -$DMSETUP_PROG info >> $seqres.full
> -$DMSETUP_PROG table >> $seqres.full
> -
>  # save the old value for _cleanup()
>  interval=$(sysctl -n fs.xfs.xfssyncd_centisecs 2>/dev/null)
>  # shorten the time waiting for the push of ail items
> @@ -139,10 +81,8 @@ $XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
>  xfs_freeze -f $SCRATCH_MNT
>  xfs_freeze -u $SCRATCH_MNT
>  
> -# inject write IO error
> -_load_flakey_table ${FLAKEY_ERROR_WRITES}
> -$DMSETUP_PROG info >> $seqres.full
> -$DMSETUP_PROG table >> $seqres.full
> +# fail every async metadata buffer write from now on
> +_scratch_inject_error buf_ioerror 1
>  
>  # update the dquota buffer
>  $XFS_QUOTA_PROG -x -c "limit -u isoft=400 $qa_user" $SCRATCH_MNT
> @@ -160,8 +100,6 @@ stat $SCRATCH_MNT > /dev/null
>  
>  _scratch_unmount
>  
> -_cleanup_flakey
> -
>  # success, all done
>  status=0
>  exit
> 
> -- 
> 2.43.0
> 
> 

