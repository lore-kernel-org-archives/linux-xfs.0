Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FB7C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 13:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D598206D7
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 13:19:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1Nm/svr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHCNTO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 09:19:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50431 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbgHCNTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 09:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596460752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=svUdipxag+gwQu3GV/GwN/IU9O7wLkBFK/b+V74gimI=;
        b=A1Nm/svrzmGHVPYud9Ipf+w01b+F6zNaAJI2MbrHzqnAGf1AhKGUhDh03g+MY6i76kgx3b
        7cthOBv8K1VftyrxzMKbVGThnDLYY6JWsdLzkc4QJ2CiSKTx+n5zRW3kQucHluEybgXzms
        9AEofkS+wL1vdHVB4DG5vfRycH47rpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-qilVUxezO0OhsPorcumUXw-1; Mon, 03 Aug 2020 09:19:10 -0400
X-MC-Unique: qilVUxezO0OhsPorcumUXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D01859;
        Mon,  3 Aug 2020 13:19:09 +0000 (UTC)
Received: from redhat.com (ovpn-116-244.rdu2.redhat.com [10.10.116.244])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7128C26324;
        Mon,  3 Aug 2020 13:19:08 +0000 (UTC)
Date:   Mon, 3 Aug 2020 08:19:06 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/{050,299}: clear quota warnings in between checks
Message-ID: <20200803131906.GB574548@redhat.com>
References: <20200730183438.GA67809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730183438.GA67809@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 30, 2020 at 11:34:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Both of these quota tests contain the output of the xfs_quota repquota
> command in the golden output.  Unfortunately, the output was recorded
> before quota soft warnings were implemented, which means they'll regress
> the output when we make quota warning work.  Fix this by resetting the
> warning count to zero before generating output.
> 
> While we're at it, use $XFS_QUOTA_PROG instead of xfs_quota.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> note that these changes are necessary because we fixed a longstanding
> warning counter bug for 5.9...
> ---
>  tests/xfs/050 |   23 ++++++++++++++++-------
>  tests/xfs/299 |   23 ++++++++++++++++-------
>  2 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 788ed7f1..c765f00b 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -61,6 +61,7 @@ _filter_report()
>  			$val = $ENV{'NUM_SPACE_FILES'};
>  		}
>  		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
> +	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
>  	perl -npe '
>  		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
>  }
> @@ -128,9 +129,11 @@ _exercise()
>  
>  	echo "Using type=$type id=$id" >>$seqres.full
>  
> +	$XFS_QUOTA_PROG -x -c "warn -$type 65535 -d" $SCRATCH_DEV
> +
>  	echo
>  	echo "*** report no quota settings" | tee -a $seqres.full
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -139,11 +142,11 @@ _exercise()
>  	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
>  	echo "ls -l $SCRATCH_MNT" >>$seqres.full
>  	ls -l $SCRATCH_MNT >>$seqres.full
> -	xfs_quota -D $tmp.projects -P $temp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $temp.projid -x \
>  		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
>  		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
>  		$SCRATCH_DEV
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -154,7 +157,8 @@ _exercise()
>  	_file_as_id $SCRATCH_MNT/softie3 $id $type 1024 0
>  	_file_as_id $SCRATCH_MNT/softie4 $id $type 1024 0
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -162,7 +166,9 @@ _exercise()
>  	echo "*** push past the soft block limit" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 300
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" \
> +		-c "warn -b -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -174,7 +180,9 @@ _exercise()
>  		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
>  	done
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x  -c "warn -b -$type 0 $id" \
> +		-c "warn -i -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -185,7 +193,8 @@ _exercise()
>  	echo "ls -l $SCRATCH_MNT" >>$seqres.full
>  	ls -l $SCRATCH_MNT >>$seqres.full
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -b -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
>  
> diff --git a/tests/xfs/299 b/tests/xfs/299
> index adcf0e41..574a93b9 100755
> --- a/tests/xfs/299
> +++ b/tests/xfs/299
> @@ -54,6 +54,7 @@ _filter_report()
>  			$val = $ENV{'NUM_SPACE_FILES'};
>  		}
>  		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
> +	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
>  	perl -npe '
>  		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
>  }
> @@ -114,9 +115,11 @@ _exercise()
>  
>  	echo "Using type=$type id=$id" >>$seqres.full
>  
> +	$XFS_QUOTA_PROG -x -c "warn -$type 65535 -d" $SCRATCH_DEV
> +
>  	echo
>  	echo "*** report no quota settings" | tee -a $seqres.full
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -125,11 +128,11 @@ _exercise()
>  	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
>  	echo "ls -l $SCRATCH_MNT" >>$seqres.full
>  	ls -l $SCRATCH_MNT >>$seqres.full
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
>  		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
>  		$SCRATCH_DEV
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -140,7 +143,8 @@ _exercise()
>  	_file_as_id $SCRATCH_MNT/softie3 $id $type 1024 0
>  	_file_as_id $SCRATCH_MNT/softie4 $id $type 1024 0
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -148,7 +152,9 @@ _exercise()
>  	echo "*** push past the soft block limit" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 200
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" \
> +		-c "warn -b -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -160,7 +166,9 @@ _exercise()
>  		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
>  	done
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x  -c "warn -b -$type 0 $id" \
> +		-c "warn -i -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
> @@ -171,7 +179,8 @@ _exercise()
>  	echo "ls -l $SCRATCH_MNT" >>$seqres.full
>  	ls -l $SCRATCH_MNT >>$seqres.full
>  	_qmount
> -	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +	$XFS_QUOTA_PROG -x -c "warn -b -$type 0 $id" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
>  
> 

