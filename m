Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D414831F;
	Fri, 28 Mar 2025 01:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743125204; cv=none; b=k1iDkqitrlNQLT7e39SJNHJpr/dvt/pjPqtPajzhh/sSdweRq4M2Xaf3q4YB59mSEfsLbW0aUPJ9gfWeW6vCeO37E8ySiYUa3Quls/zMIWDLSMRntNWLP9Zbu00T04l12nZe0IyJ42aN50pYqj6amlPpjFLuE2SEDFLwwaEqpSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743125204; c=relaxed/simple;
	bh=FAPaoZSMqlpVjhPlwazrM0cgjNXzL3rw8LOa+ow+1Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPrR1QTdN+YfBcDRlFNkQqpdiZrLIDIXRi0i6Y6HUxxphNZY/6hwBHagklY2TOx2yDv4nLkOpb0yzqAHnnhlD1KXAPDT2WjTYGjZU25SqyL0nd2hRQYbhHaesxSyoeniyDMyB8H/0t6MAizkX8Xqwp/s21UMoGEgXNGvEkxXRfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJl0SKCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJl0SKCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1399FC4CEE4;
	Fri, 28 Mar 2025 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743125203;
	bh=FAPaoZSMqlpVjhPlwazrM0cgjNXzL3rw8LOa+ow+1Fk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJl0SKCA870OUyn0A3Um/uzyJcAgZs0EqpZiw9i6Mwcx7OXFZAffelzf0aiY2Kaf6
	 W8NHyX0OUfuU4nCoqaTOEJs9Hq2DtCuujBkwx7CdBRHf+fkVx+2GfTRIBmEVp3jQAV
	 Qqo0v1n7ndMMNNLrDXiNC28qw9JetVty2McnfsUG7dY7FhBKWz7tG3qncYCQLnkqKs
	 6uPgYWWt8w8caaNos9M+ElhR7rtduFjG5qGRgxrzgtJBqxrea6FtLgdK7GJApE/rWe
	 CHTXZpOJAtZkDpDR5kGRujeZMq9Ke1D/HAStuKgtfnvFgQTTeaxAs79qMxqM202Ral
	 Xv6B2f+j4O+Bg==
Date: Fri, 28 Mar 2025 09:26:38 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/235: add to the auto group
Message-ID: <20250328012638.j6ofb4qupszh4rzd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250317055138.1132868-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317055138.1132868-1-hch@lst.de>

On Mon, Mar 17, 2025 at 06:51:38AM +0100, Christoph Hellwig wrote:
> xfs/235 is the only test effectively exercising the temporary enabling
> of SB_ACTIVE during log recovery.  Add it to the auto group to increase
> coverage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Welcome more stable enough cases to be auto group.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/235 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/235 b/tests/xfs/235
> index 5b201d930769..c959dfd6e33a 100755
> --- a/tests/xfs/235
> +++ b/tests/xfs/235
> @@ -8,7 +8,7 @@
>  # then see how the kernel and xfs_repair deal with it.
>  #
>  . ./common/preamble
> -_begin_fstest fuzzers rmap
> +_begin_fstest auto fuzzers rmap
>  
>  # Import common functions.
>  . ./common/filter
> -- 
> 2.45.2
> 
> 
