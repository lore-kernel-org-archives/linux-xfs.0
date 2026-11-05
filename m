Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876191;
	b=MhPGNY9upwWj93zayG0cO5jAnOion520ByEuF4+aW7ctlXkps4ctBPj1NJm5XXj9YyZC
	 J8jFNDh2s96xYGSi1DkiqQAqM7Pk44eGgMHFXdDGxC1QoAH1MIQbzTNmUP/fAdpLowsXm
	 vE5BkBRdvRqN5bTYDBCEE9xiAIa3kv9gdHmzLI1Tyy3PojyZ8rzYVKEmHjYO1IDIaBEs7
	 vMLD8LkuztSaEepmfwpczw5GVNbE6KLVxI0v1H2fHvAN8pC+E+3dO800pAE8fv0TKKSe0
	 OrcQMMuutyGbSlZaAbC0mhDmzRQRM+LZOjl+Q7lgeiSzv+sZwixTer5xg3tDSYW1BUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876191;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kIGFat1YPpHm6A50US9FPElDUzbSDilNLMTmvulOH6Y=;
	b=oEpJg8Lm1R6ps+Ibg36bd0LVgPSafsKUZaL7Lcg4mAR9FGoOJLfYIxiwX+Cv8g56kmr3
	 PW4s9cBUU6E0h2fEeUfimdo3rk5HHSstAeLIz/c1r5MieWo8XhBxPJVxWjEDSX8xS2+yU
	 YySINQxWVABClcP+hMsDjsoOgsYdgVOhPcGTJBt1C8n+GKfKt3MPHQZMygfIG4OnIKZ6l
	 l6ASaDTWpD88JCKeMLOHioFbcXEf8ocMBYR0j4Dj+uyzrKkZtn68Gmf/Tl1dOnjYAMJ49
	 TBHymJMyKxx9mDIq2/gnyrd8zovjfJtljXkdullk3kK34jmr5lGuGafNMK0Gr1VqzSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g7fvykx8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BBC606D803;
	Thu,  5 Nov 2026 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g7fvykx8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D21D1F000C1;
	Thu,  5 Nov 2026 10:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793876191;
	bh=kIGFat1YPpHm6A50US9FPElDUzbSDilNLMTmvulOH6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g7fvykx8Ix7cTEWT0bAjqJg/gY8/ovVJxpBlsvj2Tt7NloT1HJAeW5AlaJON46r9F
	 cfpMdQh6MQENydfLq+Q8Bkqveli/Sk89/R34mvGQrKJw0dsq2YE/sjpYhpcWwSIf54
	 /9jGLdK5yCh1S7lsmW/oLGZqLgYZ9uiWZ7Dl0WGOMAWfcbpfUnB6RwX3sDkfkqHJej
	 EumqusUmUrmqAvl6Cl74CSXhTJEUK5c+h+m6n2snl3zEbwlOMnoboEDi5nMkixI2T9
	 nb7VvvfxOJPwzDNMTIgSlUQRJYmOtcz3Au2p2msBq0fS6B8Mz/GwVMfZIh5UkJWSss
	 +hhWsrEtRUK+w==
Date: Thu, 5 Nov 2026 11:56:26 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/5] fsverity: lift ioctl() input masking and runtime
 inode flag to VFS
Message-ID: <auxSTGvdG-UPqL34@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104215749.GA3648616@google.com>
 <20261105075244.GB17923@lst.de>
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
In-Reply-To: <20261105075244.GB17923@lst.de>

On 2026-11-05 08:52:44, Christoph Hellwig wrote:
> On Wed, Nov 04, 2026 at 09:57:49PM +0000, Eric Biggers wrote:
> > Changes to 'struct inode' should be Cc'ed to linux-fsdevel as well.

ah, thanks! Will resend shortly

> 
> Yes.  Except for that and the two btrfs/f2fs issue reported by Sashiko
> this looks sane.  Please try to do a full fsverity xfstests run for
> all the touched file systems.

-g verity passes for all fs, except btrfs/277 and btrfs+generic/574.

The btrfs/277 seems to fail due to difference between what kernel
and userspace versions support (btrfs-progs v7.1 doesn't seem to
support latest streams v3).

The generic/574 on BTRFS fails only for 1024 block size no matter
the change (fails on v7.3 too). I haven't checked why.

-- 
- Andrey
