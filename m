Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492607;
	b=1NZiCHI7RBpj58X8GmjrdP9xVQZDBPrzqSMnSIeWzYvl0ibxUhhn+aOaRwo2auvj46TN
	 z5fegtwIaFi11GpbquyHSTixFW53eI+MMLUWHjRMty3w/59tJQo2aqW5hr4t+dr8eoDbR
	 P607bCjvGvIPv47lJ6uarmxphmn/IOKFZLanUQTMcDozvATqFEhF3xtg2X67F/icAzdJG
	 BaIPKa/CGNSRV3wO9CiwweaMzgEhuz7R9E656F+hauAFNHNwwk+EjctjX38kijjsafH13
	 vSkILwNqpl3fmXrirgQYl2wswx4boP7B/7JIYZJfC7DbGxNuL7gJBIemL7b9Qedx88g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492607;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=1cn2J4Owe9luXYqD/VS6uqEU03abhGoDuaXat8HVBRw=;
	b=C3Eb63ZwzOtX67OdQAbbtKzmCiACzXoNJSvfEPF+Jr3rP33SPnFBpbqNjGKhc+u2smMI
	 EA8XjYxrVu4Ouzgt7XkTQtDUAFL6Gca49aOQyH4wvBlNXTWpUqJotQmr/cIsElm2oybi8
	 ld14nK2K8QDB0FG+YEczxAvDvdxK5i4UEgfYeNjWkmYrkmWANVAKpxsJHnrFnbxJ4FVzn
	 38AxW69BnNo9rGmddyoAWJrqlYrXP41md74Baa9cOM7bvtHeoFxJS3kKxMb3PAc3lTGbU
	 oOmKXmR+Z3nYr+kxLRKx8umdsCxSlWqpXZwWwFFoUqiwvH+epFVABTD3lVnZnsr/H3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X5iScENO;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93780606A323
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 14:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93780606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X5iScENO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794492605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1cn2J4Owe9luXYqD/VS6uqEU03abhGoDuaXat8HVBRw=;
	b=X5iScENO2lHeo2DFILArErccWSSrr5gtnMR89EnKRVL836c/Dtb12RGOqbSvbgRL2KhKJy
	uKhJOkxnJd9O8w+FLBftZBiFk/kkieUv/kA00g/V+X5mGEWDBGOIVQieF/WiblFK63q9lm
	l9RQsei+2h1fYR5oEspJAvKdID1fqNU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-XZ-IWOXdMkuyNV2PYqv4Qw-1; Thu,
 12 Nov 2026 09:10:00 -0500
X-MC-Unique: XZ-IWOXdMkuyNV2PYqv4Qw-1
X-Mimecast-MFC-AGG-ID: XZ-IWOXdMkuyNV2PYqv4Qw_1794492598
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3794B1800587;
	Thu, 12 Nov 2026 14:09:58 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B95E01800543;
	Thu, 12 Nov 2026 14:09:56 +0000 (UTC)
Date: Thu, 12 Nov 2026 09:09:54 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/438: retry failed metadata writes again
Message-ID: <avXIstx55STwYao7@bfoster>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
 <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
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
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Nov 12, 2026 at 10:37:17AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs/438 checks that a dquot buffer write that keeps failing does not
> hang the unmount (kernel commit 373b0589dc8d). Commit eb2ad950ea90
> moved the test to _scratch_mount. Since commit 1a49022fab9b,
> _scratch_mount sets the metadata EIO retries to 0. XFS then shuts
> down on the second failure, before the AIL can retry the write. The
> test passes even with the bug.
> 
> Turn the retries back on after the mount. Fail the test if XFS has
> shut down before the unmount.
> 
> Fixes: eb2ad950ea90 ("dmflakey: override SCRATCH_DEV in _init_flakey")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Tested on kernels with and without XFS_DEBUG. Patch 1 gives the same
> results on both. With an internal log, v7.4-rc2 passes 3 of 3. A TEST
> ONLY kernel that skips the resubmission of failed AIL items hangs at
> unmount (1 of 1). Without patch 2, the new check fails in three cases:
> 
> - with the dm patch and a write cache (3 of 3)
> - with an external log (1 of 1)
> - with an rt device that has a write cache (from the code, not run)
> 
> In each, XFS shuts down on a log error before the unmount. Patch 2
> passes in the first two cases.
> ---
>  tests/xfs/438 | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tests/xfs/438 b/tests/xfs/438
> index 4cd0b26..e4850ff 100755
> --- a/tests/xfs/438
> +++ b/tests/xfs/438
...
> @@ -117,6 +120,12 @@ sysctl -w fs.xfs.xfssyncd_centisecs=100 >> $seqres.full 2>&1
>  _qmount_option "usrquota"
>  _scratch_mount
>  
> +# _scratch_mount turns off the retries of failed metadata writes.
> +# Go back to the kernel defaults, so that the failed dquot buffer
> +# write is retried from the AIL until unmount. fail_at_unmount
> +# stays on, so the unmount ends the retries on a fixed kernel.
> +_reset_xfs_sysfs_error_handling $SCRATCH_DEV >> $seqres.full
> +
>  # We need to set the quota limitation twice, and inject the write error
>  # after the second setting. If we try to inject the write error after
>  # the first setting, the initialization of the dquota buffer will get
> @@ -145,6 +154,10 @@ _scratch_sync
>  # the completion of the retried write of dquota buffer
>  sleep 2
>  
> +# The dquot buffer write must still be failing and retried here. A shut
> +# down filesystem means that the test missed the hang it checks.

Nit on the comment.. something like this is a little more clear to me:

# Run a stat to confirm we haven't shutdown prematurely. We expect the
# fs to be running metadata write retries. A shutdown fs at this point
# means that we haven't properly tested for the hang.

But this LGTM regardless. Maybe Zorro can fix that up if you agree:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +stat $SCRATCH_MNT > /dev/null
> +
>  _scratch_unmount
>  
>  _cleanup_flakey
> 
> -- 
> 2.43.0
> 
> 

