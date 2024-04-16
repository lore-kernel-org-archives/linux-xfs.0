Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06DE44C6B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301162; cv=none; b=CycHxFMdIwLPRfQwRdwCqQ1iSbN5JPxJ+ouTCaJMPc2SxGFX6hMyPbQSu8ygVQRtudOhyXStDPOMWieB5YMmWzYrBbugaXOfF8WQgzB8B7P9N/u+VwyEuvjSsakqP8nSlMcDJWKhxZbgNbBiENhnzV/plD0o9KBLlUOz5tpBEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301162; c=relaxed/simple;
	bh=trmGLwR//ZlY9FqLGaJIztnGwoPHHht3TYQQqipXXns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBbQyecwN/MfkDCMpqPJ+nlz4/ZabdYXOfQBS1jqFWUEaYnaVFFZmDKb6nM7FbDSk/YzXzZCiwCX1wEbNgqk+qV0pGdsCRzL6dLtE+9o/55H02od8Ot49/yC4kzzWKNNSC/x7MPZJI4Y0vbbtiAecfJiKrcXyT+8UWxSeFEFcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtZwIjo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtZwIjo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AE8C113CE;
	Tue, 16 Apr 2024 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713301162;
	bh=trmGLwR//ZlY9FqLGaJIztnGwoPHHht3TYQQqipXXns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EtZwIjo1OsYaV2BzCi5ikjHCtRnHk3azcPPfWvZzitQtcztJzV9KG8GsQI6nk7iY1
	 +X8WQW6Mrchd4bQipnAvaxFqFmq3a4EJfENY5jGKbc+T3/lk6EDSDl9geg0taGxwB/
	 lAuPV1Ozo1NfnzzRf+L5xqoJT05e+v/Ts4HfEr2MxT5uvqqXMNCe97yfydrPFvZ1mq
	 4UuFSzcW7PsdE0bMo7jS3YXP+zlKvdKmYMhoCaQmKF6XicpK+s5ty+0Fb1j30Vgqby
	 wqnCxKYdiusd4s/awacwvGW4aaW98Fqo4zdHExU9AkDfyGSPL2LvBKF+u6v43y6OHZ
	 RHf8/vdxuOFgw==
Date: Tue, 16 Apr 2024 13:59:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] xfs_fsr: convert fsrallfs to use time_t instead
 of int
Message-ID: <20240416205918.GF11948@frogsfrogsfrogs>
References: <20240416202402.724492-1-aalbersh@redhat.com>
 <20240416202402.724492-5-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416202402.724492-5-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 10:24:02PM +0200, Andrey Albershteyn wrote:
> Convert howlong argument to a time_t as it's truncated to int, but in
> practice this is not an issue as duration will never be this big.
> 
> Add check for howlong to fit into int (printf can use int format
> specifier). Even longer interval doesn't make much sense.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fsr/xfs_fsr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 3077d8f4ef46..4e29a8a2c548 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
>  static void fsrdir(char *dirname);
>  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
>  static void initallfs(char *mtab);
> -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
> +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
>  static void fsrall_cleanup(int timeout);
>  static int  getnextents(int);
>  int xfsrtextsize(int fd);
> @@ -165,6 +165,10 @@ main(int argc, char **argv)
>  			break;
>  		case 't':
>  			howlong = atoi(optarg);
> +			if (howlong > INT_MAX) {
> +				fprintf(stderr, _("%s: too long\n"), progname);

Don't just say that it's too long; tell the user what the maximum is.
Also perhaps print the argument that was wrong so that the user knows
exactly what they got wrong:

	fprintf(stderr, _("%s: the maximum runtime is %d seconds.\n"),
			optarg, INT_MAX);

$ xfs_fsr -t 123456789123456789
123456789123456789: the maximum runtime is 2147483647 seconds.

--D

> +				exit(1);
> +			}
>  			break;
>  		case 'f':
>  			leftofffile = optarg;
> @@ -387,7 +391,7 @@ initallfs(char *mtab)
>  }
>  
>  static void
> -fsrallfs(char *mtab, int howlong, char *leftofffile)
> +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
>  {
>  	int fd;
>  	int error;
> -- 
> 2.42.0
> 
> 
