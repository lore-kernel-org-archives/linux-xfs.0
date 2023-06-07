Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F750C7EE2F
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 01:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbjFGBxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 21:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbjFGBwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 21:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893CEA6
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 18:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686102715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BzbbJwBaLJR3atwlN7NB+kwVeQhF2PphFZr0MsHGIwU=;
        b=aBbqFyh3evebWVZEhItoCH6Tq7uCUxl76or/6SOYUD35aLk8RxWFbRb+p3mKC7LfqYjlL4
        7g7AzP5lHvkJ9fu0W+YLGYB/rhuVX2bEIFshr+WxaP1NUW+NE/DGm8k6uVc4eURpK8fGq0
        D+jes/a8FZ287JZVRCcCOAic6Yilsrw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-QqD69_GEPg-WSrThU3amqQ-1; Tue, 06 Jun 2023 21:51:52 -0400
X-MC-Unique: QqD69_GEPg-WSrThU3amqQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03BB5811E78;
        Wed,  7 Jun 2023 01:51:52 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5214492B00;
        Wed,  7 Jun 2023 01:51:51 +0000 (UTC)
Date:   Tue, 6 Jun 2023 20:51:50 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs/108: allow slightly higher block usage
Message-ID: <ZH/itoJAt/5SEbvi@redhat.com>
References: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
 <168609054837.2590724.6227482661383718314.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168609054837.2590724.6227482661383718314.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 03:29:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> With pmem and fsdax enabled, I occasionally see this test fail on XFS:
> 
>    Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
>  Disk quotas for User #1 (1)
>  Filesystem Blocks Quota Limit Warn/Time Mounted on
> -SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
> +SCRATCH_DEV 48.0M 0 0 00 [------] SCRATCH_MNT
>  Disk quotas for User #1 (1)
>  Filesystem Files Quota Limit Warn/Time Mounted on
>  SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
> 
> The cause of this failure is fragmentation in the file mappings that
> results in a block mapping structure that no longer fits in the inode.
> Hence the block usage is 49160K instead of the 49152K that was written.
> Use some fugly sed duct tape to make this test accomodate this
> possiblity.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  tests/xfs/108 |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/108 b/tests/xfs/108
> index 4607000544..8593edbdd2 100755
> --- a/tests/xfs/108
> +++ b/tests/xfs/108
> @@ -32,6 +32,14 @@ test_files()
>  	done
>  }
>  
> +# Some filesystem configurations fragment the file mapping more than others,
> +# which leads to the quota block counts being slightly higher than the 48MB
> +# written.
> +filter_quota()
> +{
> +	sed -e 's/48\.[01]M/48M/g' | _filter_quota
> +}
> +
>  test_accounting()
>  {
>  	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> @@ -49,9 +57,9 @@ test_accounting()
>  		$here/src/lstat64 $file | head -3 | _filter_scratch
>  	done
>  	$XFS_IO_PROG -c syncfs $SCRATCH_MNT
> -	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | _filter_quota
> -	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | _filter_quota
> -	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | _filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | filter_quota
>  }
>  
>  export MOUNT_OPTIONS="-opquota"
> 

