Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96700414DE9;
	Mon, 20 Jul 2026 12:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784550151; cv=none; b=Fe3mfzpwSpyDBw9l/muUyhO6GY8m9s7/pYw2CnbhnHdQRCVBxh6B9UQDnL4zghYtES5uADfHTFaWNw3JDNbSR8QGBKwaUDd6cpe3Nk0WKOAwl8A4/nJL5CNt7vDxTg+JoP+XWc+xKlp5ibdUkPdT+YHcPn8JxpIv+U/GU5w4QHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784550151; c=relaxed/simple;
	bh=aLGXAaU53G4liHAWciP2AQL+FuzaVII7WXdNwuNh6i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EjZqTqCC0RLtzzz6I5a+CYUT44pJsGCCs0h5osP2ayEpp4VTzQnbbRbTIwYULnUAYcPu4Iydm/5zrLAUVp+5GZqzfzpIDy9kuGqqcALI3yVV77Raw8y+M46Abj+MCFzW2xSvYQiWafwJ70IH5xIRuszVuOmeLT+SdU0hb/ywoWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv0PNXwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv0PNXwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315D31F00A3D;
	Mon, 20 Jul 2026 12:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784550150;
	bh=LvN2cBCsf57ixj9+DrKKW77t6GwVzblI4LjoZXI/niw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tv0PNXwgV2OLn/b98WhcGeCGSiOtgOP61fYyX8ipd1SsXz7azSBGW0UFc5qPY62P1
	 XVpnFkKEL/G62msf++858X5sPnjaJ0fnfu0COdMIr2lnjQrIFITd0sSlnepryZSQ6y
	 FaSgsUQs9YSg2n0YqIzb+nSMQDZaMo3f0U1StAiA/Wz3L4240OSM8ucrGkTEaFv0CF
	 K1rWnqmAD5NPBK4sKmLoDGdMUcPxGQA9Op3BSvdVhrZrVQQUs4wxlKlJ0ghJ+u/tPe
	 YuA687FkXsafE4534Dd3sToPboY9wI57K4hiLa7aglvZ3oyQIsdyOK9hWTpERps+w7
	 DIrxBr9obG70g==
Date: Mon, 20 Jul 2026 14:22:26 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Avinesh Kumar <avinesh.kumar@suse.com>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	aalbersh@kernel.org
Subject: Re: [PATCH v2] libfrog: make cmn_err() emit each message atomically
 to avoid torn output
Message-ID: <al4S5aazg1G8kc06@nidhogg.toxiclabs.cc>
References: <20260716151329.GA7371@frogsfrogsfrogs>
 <20260716194723.191090-1-avinesh.kumar@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716194723.191090-1-avinesh.kumar@suse.com>

On Thu, Jul 16, 2026 at 09:45:49PM +0200, Avinesh Kumar wrote:
> From: Avinesh Kumar <avinesh.kumar@suse.com>
> 

Adding Andrey to the thread as he's maintaining xfsprogs.


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
> do_error() in xfs_repair.c also has same issue, fix that too.
> 
> Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
> ---
> v2: fix the do_error() in xfs_repair.c too.
> 
>  libfrog/util.c      | 2 ++
>  repair/xfs_repair.c | 2 ++
>  2 files changed, 4 insertions(+)
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
>  	va_end(ap);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 6b97a806..dd758ebc 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -458,10 +458,12 @@ do_error(char const *msg, ...)
>  {
>  	va_list args;
>  
> +	flockfile(stderr);
>  	fprintf(stderr, _("\nfatal error -- "));
>  
>  	va_start(args, msg);
>  	vfprintf(stderr, msg, args);
> +	funlockfile(stderr);
>  	if (dumpcore)
>  		abort();
>  	exit(1);
> -- 
> 2.55.0
> 
> 
