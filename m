Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157647D06A
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710257459; cv=none; b=poiTkR/NSvjHscFM+WRLp5JZcYanFU5e8ReNaT+VuH8jgAEWRwSvopY25i8J8ZmCJ945v0rfApT0xTW8IxHz1eOQyzgJlDVEKZYmLMD4h1H29hdLOINbIqReSV+y7nek3lWqLVKq8oMNP0mbegk2loYYEy8/7grzx42zvzt7B3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710257459; c=relaxed/simple;
	bh=Jsp9I9KJn8kCpy0UeYbTZpYiw5/jOjiQwY5R2bqjNH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiOZeyaybkCGZ2e3yK4dNK7dkUx0oucaehKhYEKoct3I2CFPmY33BglfwTDeo4yhbazy9ujYZ3Tt/hZscuRvYcWcK8Mp7iZ6sdyhJQ9JCYh4YP1SKLDjBL2zzMTZoQbiVk95TxK5VXX74uGVNd0Yb1Tyt1+ssMyGbgqk4KcL0cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XaGmoE/z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XaGmoE/z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710257457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rw1sMZMo38uoygI0s1R4qBPry1mRi70suqTvVWHYqSY=;
	b=XaGmoE/zzFc5vg59zxLTheKygUxQwCQSS5iitlv0v0gu43mXharFHQcsqBAv6SzK+Nxm4K
	mVqwyvCcRTXyqrK4auvDE2lx4xb33dm3qg1Gbzu+0xRcLHmRckTtRyZddsD1iFpriFQ7nG
	J95EJJlhzJREoRJmwzo5JAvvMAcBDqw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-IKbm46ubMK2LeH28ALUevw-1; Tue, 12 Mar 2024 11:30:50 -0400
X-MC-Unique: IKbm46ubMK2LeH28ALUevw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82C3185A784;
	Tue, 12 Mar 2024 15:30:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.83])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A9C111FA;
	Tue, 12 Mar 2024 15:30:48 +0000 (UTC)
Date: Tue, 12 Mar 2024 10:30:47 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>, aalbersh@redhat.com,
	Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] generic/574: don't fail the test on intentional coredump
Message-ID: <ZfB1J2YWg83KcMDJ@redhat.com>
References: <20240312145720.GE6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312145720.GE6188@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Tue, Mar 12, 2024 at 07:57:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't fail this test just because the mmap read of a corrupt verity file
> causes xfs_io to segfault and then dump core.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  tests/generic/574 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/574 b/tests/generic/574
> index 067b3033a8..cb42baaa67 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -74,7 +74,8 @@ mread()
>  	# shell instance from optimizing out the fork and directly exec'ing
>  	# xfs_io.  The easiest way to do that is to append 'true' to the
>  	# commands, so that xfs_io is no longer the last command the shell sees.
> -	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $file \
> +	# Don't let it write core files to the filesystem.
> +	bash -c "trap '' SIGBUS; ulimit -c 0; $XFS_IO_PROG -r $file \
>  		-c 'mmap -r 0 $map_len' \
>  		-c 'mread -v $offset $length'; true"
>  }
> 

