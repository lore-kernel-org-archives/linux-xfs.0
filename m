Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636653A2551;
	Tue, 28 Jul 2026 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785218966; cv=none; b=t0eRFBYmvN1JuPuTnUz/vCKlnM5hIXzM43OtMWmOU/F4i6rLnWjQKQlWp0DAUHr01Kyr2dgZJn9N8U2DlxSt5DeqIKQA/MGNFAoOjcdUSfwm2Cf6IFZvQ9mL8vZge7EdPQHpkI6o7Vx2JYUHdqX66MHmHYx0d1/YOPsjPQEUPoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785218966; c=relaxed/simple;
	bh=Ma7TRiS6vfpbL6jVuhzx/24ir1JuVN/wg5GCnRKxuzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdKBlPFEEYoV6Rg3HQ96dLFpo1+3bgmtnBvLaOYf7qn2ksZ8V6+CqHmQ+vPvjwWZVEYqMvueTMlp2mv4RfHhMjgelncTPDvu8nL/n6PXp1/RPjM1VZCukEcKtc1lTC+SkQhCIbMM2RSDJKdQ4rTG8IQ+xq4u388mDpfmpklLLM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M70NaZTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M70NaZTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1001F000E9;
	Tue, 28 Jul 2026 06:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785218965;
	bh=lDNd1D8ooHkbyGjHA6UcmCnxY9qHLFiB/wayD816snE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M70NaZTMczMcW6kreE90OnxKmFXc/B/f9SZN6hg5rS7wyYg9RSvyxAozJPNsHs/jm
	 ggZ5fFYa7jgKv3hvmxObVx9K2/++KwOB3FschJW7rqxbVSCBRrQRQpksyVIkE/qq/O
	 RCZuImHMX74Jj+HJmsytYYYzJp1aev6whaFnQeAba4Yyp9akgYnjgSov/LNANVtjVF
	 fc1hCU0L785OgYy0fxSaF5XgKlQIx9Hr/IsEhltOMy/tEOUQuxC4cSJDgBHhipHESi
	 wCrk9j4MD5NmR1vTHYLepTPzNrDQJfSjf9vOLg3aM1bBMBRVrM+vXO+vMzZvO/bePX
	 1hwL2GPGcXd0A==
Date: Mon, 27 Jul 2026 23:07:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vacek <neelx@suse.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com, djwong@kernel.org,
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
Message-ID: <20260728060730.GC99797@sol>
References: <20260724133328.1837318-1-neelx@suse.com>
 <amgfuk12imPN2XJe@infradead.org>
 <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
 <20260728054847.GB99797@sol>
 <amhGiIsvNIni_VAE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amhGiIsvNIni_VAE@infradead.org>

On Mon, Jul 27, 2026 at 11:04:56PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 27, 2026 at 10:48:47PM -0700, Eric Biggers wrote:
> > Please keep sending out the tests along with the kernel patches.  But
> > yes, they aren't for immediate merging and should be tagged with RFC,
> > and the cover letter should mention that the kernel patches are pending.
> > Thanks!
> 
> I think the split of the v1 vs v2 policy tests might actually be useful
> as-is now, but I'll defer to you.
> 

Yes, I haven't looked at those closely yet, but splitting them out
should work.

- Eric
