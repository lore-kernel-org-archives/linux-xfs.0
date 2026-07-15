Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8D417D6A;
	Wed, 15 Jul 2026 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142601; cv=none; b=H6bwuvF69R8ov1CBij1hwhtGzQuo11UkCo3ahO+H/pJTkuzKBTbTTP4qNvoW3Vm2xs2WLw0xwiFA8fJPDohA3+OjUZ+vjx4MUAl0oHIxqtH6l/ilbIkAAfRC7RidO0PmSMxiHWLFn82Km1KpHQAJg1zSJlmWW3McbbeHNoJzEug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142601; c=relaxed/simple;
	bh=xeV8CeGjnmFkDwWLn6i7ZBi4+YtuhD/DtjvMo26qcJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYczLMRfyGQWvX6Vvx/3ITdjk6j1YuW93xV+h1Cg67T77EoL/17OpWfn7k8DOCs39NbbgFMYdmPAPF32xPit/OK7InWT+y9tHg4Wuxb3zo3sMP/cox0+ChzH0NzH04xnvIXbBBE92OncIVpEY2Y5njM63g0u5Q784wCioycu2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGFpyViu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGFpyViu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6237C1F00A3A;
	Wed, 15 Jul 2026 19:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784142590;
	bh=Jg8w+4E9GoiyrMiq7Smmef/Q1UDh4RmAlItKlCO82Js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bGFpyViu+4i9qqzMQIg9n9p8hw3+NOe5l2PNs8wRIYBj6cHpjiymlZ+MB9uX1P8AM
	 HBRnpQR0KsDJtpvFqvSwgnZPok98rF+uwddHWPa7yroW7+hkPdVQG0Yn2WV+L5fw5T
	 AvdTuwA6PDsuph3Qi7uCZpreVcAc+YkVTi6XzuhodmaIM2L7Aa5nWvWtbqfPTpiRQs
	 dbD2b8NZmCsxZTgegJtomwfgv9wbW4H4xkwc2n0E/mgNC+d5rirCK4cyfjKKhWsQra
	 rfw27PEmy4u3E8ARzBQ2ALDqunVFeT/mxTnwrBngdBYw0S04JzOviYwQDcQfP1HofP
	 bdOGjmS9oOqPw==
Date: Wed, 15 Jul 2026 12:09:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Avinesh Kumar <avinesh.kumar@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, cem@kernel.org
Subject: Re: [RFC PATCH] libfrog: make cmn_err() emit each message atomically
 to avoid torn output
Message-ID: <20260715190949.GP7380@frogsfrogsfrogs>
References: <20260715173114.359368-1-avinesh.kumar@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715173114.359368-1-avinesh.kumar@suse.com>

On Wed, Jul 15, 2026 at 07:28:21PM +0200, Avinesh Kumar wrote:
> From: Avinesh Kumar <avinesh.kumar@suse.com>
> 
> fstests xfs/033 fails sporadically with a spurious blank line in the
> xfs_repair output:
> 
> - output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
>     --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
>     +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
>     @@ -103,6 +103,7 @@
>      Phase 3 - for each AG...
>              - scan and clear agi unlinked lists...
>              - process known inodes and perform inode discovery...
>     +
>      bad magic number 0xffff on inode INO
>      bad version number 0xffffffff on inode INO
>      inode identifier 18446744073709551615 mismatch on inode INO
> 
> Root cause is in cmn_err() (libfrog/util.c), which emits a message
> and its newline as two separate writes to unbuffered stderr.
> xfs_repair's threads all share stderr. If one is preempted between the
> two writes, another thread's line lands in between:
> 
> (snips from `cat -A 033.raw`) -
> Phase 3 - for each AG...$
>         - scan and clear agi unlinked lists...$
>         - process known inodes and perform inode discovery...$
> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
> $
> bad CRC for inode 128$
> bad magic number 0x0 on inode 128$
> 
> which should be like -
> 
> Phase 3 - for each AG...$
>         - scan and clear agi unlinked lists...$
>         - process known inodes and perform inode discovery...$
> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
>         - agno = 0$
> bad CRC for inode 130$
> bad magic number 0x0 on inode 130$
> 
> _filter_repair() strips the noise line it glued onto but not the lone
> newline, which then fails the golden diff.
> 
> Make the two writes atomic.
> 
> Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
> ---
> 
> Hi, please give feedback if this should be fixed in a different way.
> Thanks!
> 
>  libfrog/util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libfrog/util.c b/libfrog/util.c
> index 5bae5bab..3b6df917 100644
> --- a/libfrog/util.c
> +++ b/libfrog/util.c
> @@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
>  	va_list	ap;
>  
>  	va_start(ap, fmt);
> +	flockfile(stderr);
>  	vfprintf(stderr, fmt, ap);
>  	fputs("\n", stderr);
> +	funlockfile(stderr);

I think do_error() in xfs_repair.c is going to need the same treatment
but otherwise this chunk looks ok to me.

--D

>  	va_end(ap);
>  }
>  
> -- 
> 2.55.0
> 
> 
