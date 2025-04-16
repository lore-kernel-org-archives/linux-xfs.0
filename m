Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD413B7A3
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 09:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744797051; cv=none; b=VyeCW8XZEX8cyCGc0isPvzZKKlh0NAR9SmQUFk636m0llQGgLxlRtWn0c+RO4i7xH7iERV2Ui6S4dsIvFJyg1MHCZ0lhXA6iCofYAIk7kS1g9gtq6CkqPTFhMD+L+4iNFAFG8TRjMPdVgoHsg1rl1ngnPi/n1Cu4BDAmwL1fdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744797051; c=relaxed/simple;
	bh=kFqtxcarV3KtYm655vomS9H100rI9IArF81V1lPrt8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vfy2zVeeChLQBla8LBKNF3p1cSVSfr+SDEokpA4HbI8wOvCkVAAe7va88ILlR5N00v80CJcI6AHpixqmt+sD8EuDNOYwXza8jhU2SpDLOVz1K3RyFvD9EpBAqigcDJ3XwxiChhkg2mFuotXwPCEXJk2sGH1yap55+aLJZL38uUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5EQXOiR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5EQXOiR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744797048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFVe+fkA7rT0vXjfXhe5awl8sI4ZAqqcqRirCuXjisA=;
	b=N5EQXOiRBvqZpcYKmWQdYwOl5oEFY9KLiMo0Xmy7dDwKf95IiU0J1bWpXYEufZjz23D1iX
	3Rf8EyMVfC8oi/TfLMhTB9C3/J7rags8crF96ErQCQUkJVfeEzYWgg705agFYMWw0s+NpF
	LafUsl5B2mZSNt7uDoAipUeAhjd/q+U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-oIbVHwvJNWqGHwno6qFmEw-1; Wed, 16 Apr 2025 05:50:47 -0400
X-MC-Unique: oIbVHwvJNWqGHwno6qFmEw-1
X-Mimecast-MFC-AGG-ID: oIbVHwvJNWqGHwno6qFmEw_1744797046
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso50889015e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 02:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744797046; x=1745401846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFVe+fkA7rT0vXjfXhe5awl8sI4ZAqqcqRirCuXjisA=;
        b=Ek41rsfTXIHJ3G/GXdfmo4ucuuXF1hq4MaG1uMj2KmTkYMEdnA+Qvt9DcFPCCAs5zG
         HHz9u/05JWNTT1uBwm17b0HJUiStPWrXTgTBMd+I1jn3iu5+n0z21PFNTnS6XB9ombeE
         dYZD+R/8SUWilakOZYWzPcel8wDn0zqcNugs/btRFo1QVJ1/lpR5Vwa2HDBRxBqZMwn4
         DRR+0HiIBz+uWcVgtV2DJ6/JbvKIp/oY1gu6R8rM/N8YIIFw3PyP6XLmJ8hoC/ujjXFf
         uudRV2T/x19GsZpMki54OK7dyRO6EoJeaEGjxqcFydroYQocXo6FApivxPv0Ik+1L6tq
         RDyQ==
X-Gm-Message-State: AOJu0YyRkBO5Pm9HbRcis8auVl/hfOOQZ50DL6xxDrpD+lSP4Bl+B3uw
	S2TCuPKY/HmPJ8yozMj9ljRTWlKyl1WV5ihwrB1GEw67FtqElEQqcVysoxLfl6kuuVM1MPwcze6
	PnZvTxuY3Ldg9jjR64TRyIE4aTso0GvtaWB25ylwjc7zWd9Kw6dq3GHXt
X-Gm-Gg: ASbGncssQzpPZP+VxeLyEt1f+/DZII3rnwioRZ4Yqu/uTBCspRFb8enAkGT24ReyPTV
	frfuzyeP6HMI4tz35Jznddp9XN+l4+jYvyXQkIV3c1rV5HiajL1HXNUvqasXml3XG9Nys0XHsa4
	gfSYwTfxdUdt8SwnGbIt3oOi3NK7YahZYNn+X/MpqxHIh8I0NvLEDQWAhlnNkFJ51SnV+RKpBAk
	hPU1wnaVu9SbUsdsj3FlVqfnR0vlWFnjUgvy6DaZAISTDsPOhtiiZ7M0YeOFW5o3wQEWbbfqgg1
	0s7lAAyg+F0bOF8Uw3kTD9cvcByi3vw=
X-Received: by 2002:a05:600c:1912:b0:43c:fee3:2bce with SMTP id 5b1f17b1804b1-4405d6ab5f5mr10494835e9.26.1744797046240;
        Wed, 16 Apr 2025 02:50:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXnTvw4h4/6h9KyIUjtNsqQkm8e+2uz1mNDY1TMRfEKAgr4XFuzDMqVg3oVjiXK6rqkdFbkA==
X-Received: by 2002:a05:600c:1912:b0:43c:fee3:2bce with SMTP id 5b1f17b1804b1-4405d6ab5f5mr10494535e9.26.1744797045722;
        Wed, 16 Apr 2025 02:50:45 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4404352a5f0sm31367035e9.1.2025.04.16.02.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:50:45 -0700 (PDT)
Date: Wed, 16 Apr 2025 11:50:44 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_io: make statx mask parsing more generally useful
Message-ID: <t7pb3gyzvhnww3sts4bkyxpkew7opgslk7du5uafifxlsc3s53@qphubms25zq7>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <20250416052251.GC25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416052251.GC25675@frogsfrogsfrogs>

On 2025-04-15 22:22:51, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance the statx -m parsing to be more useful:
> 
> Add words for all the new STATX_* field flags added in the previous
> patch.
> 
> Allow "+" and "-" prefixes to add or remove flags from the mask.
> 
> Allow multiple arguments to be specified as a comma separated list.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  io/stat.c         |  120 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  man/man8/xfs_io.8 |   11 +++++
>  2 files changed, 116 insertions(+), 15 deletions(-)
> 
> diff --git a/io/stat.c b/io/stat.c
> index b37b1a12b8b2fd..ebc085845972c4 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -321,10 +321,41 @@ _statx(
>  #endif
>  }
>  
> +struct statx_masks {
> +	const char	*name;
> +	unsigned int	mask;
> +};
> +
> +static const struct statx_masks statx_masks[] = {
> +	{"basic",		STATX_BASIC_STATS},
> +	{"all",			STATX_ALL},
> +
> +	{"type",		STATX_TYPE},
> +	{"mode",		STATX_MODE},
> +	{"nlink",		STATX_NLINK},
> +	{"uid",			STATX_UID},
> +	{"gid",			STATX_GID},
> +	{"atime",		STATX_ATIME},
> +	{"mtime",		STATX_MTIME},
> +	{"ctime",		STATX_CTIME},
> +	{"ino",			STATX_INO},
> +	{"size",		STATX_SIZE},
> +	{"blocks",		STATX_BLOCKS},
> +	{"btime",		STATX_BTIME},
> +	{"mnt_id",		STATX_MNT_ID},
> +	{"dioalign",		STATX_DIOALIGN},
> +	{"mnt_id_unique",	STATX_MNT_ID_UNIQUE},
> +	{"subvol",		STATX_SUBVOL},
> +	{"write_atomic",	STATX_WRITE_ATOMIC},
> +	{"dio_read_align",	STATX_DIO_READ_ALIGN},
> +};
> +
>  static void
>  statx_help(void)
>  {
> -        printf(_(
> +	unsigned int	i;
> +
> +	printf(_(
>  "\n"
>  " Display extended file status.\n"
>  "\n"
> @@ -333,9 +364,16 @@ statx_help(void)
>  " -r -- Print raw statx structure fields\n"
>  " -m mask -- Specify the field mask for the statx call\n"
>  "            (can also be 'basic' or 'all'; default STATX_ALL)\n"
this comment     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
then probably can go away, as it can be any of the above now

Otherwise, looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> +" -m +mask -- Add this to the field mask for the statx call\n"
> +" -m -mask -- Remove this from the field mask for the statx call\n"
>  " -D -- Don't sync attributes with the server\n"
>  " -F -- Force the attributes to be sync'd with the server\n"
> -"\n"));
> +"\n"
> +"statx mask values: "));
> +
> +	for (i = 0; i < ARRAY_SIZE(statx_masks); i++)
> +		printf("%s%s", i == 0 ? "" : ", ", statx_masks[i].name);
> +	printf("\n");
>  }
>  
>  /* statx helper */
> @@ -376,6 +414,68 @@ dump_raw_statx(struct statx *stx)
>  	return 0;
>  }
>  
> +enum statx_mask_op {
> +	SET,
> +	REMOVE,
> +	ADD,
> +};
> +
> +static bool
> +parse_statx_masks(
> +	char			*optarg,
> +	unsigned int		*caller_mask)
> +{
> +	char			*arg = optarg;
> +	char			*word;
> +	unsigned int		i;
> +
> +	while ((word = strtok(arg, ",")) != NULL) {
> +		enum statx_mask_op op;
> +		unsigned int	mask;
> +		char		*p;
> +
> +		arg = NULL;
> +
> +		if (*word == '+') {
> +			op = ADD;
> +			word++;
> +		} else if (*word == '-') {
> +			op = REMOVE;
> +			word++;
> +		} else {
> +			op = SET;
> +		}
> +
> +		for (i = 0; i < ARRAY_SIZE(statx_masks); i++) {
> +			if (!strcmp(statx_masks[i].name, word)) {
> +				mask = statx_masks[i].mask;
> +				goto process_op;
> +			}
> +		}
> +
> +		mask = strtoul(word, &p, 0);
> +		if (!p || p == word) {
> +			printf( _("non-numeric mask -- %s\n"), word);
> +			return false;
> +		}
> +
> +process_op:
> +		switch (op) {
> +		case ADD:
> +			*caller_mask |= mask;
> +			continue;
> +		case REMOVE:
> +			*caller_mask &= ~mask;
> +			continue;
> +		case SET:
> +			*caller_mask = mask;
> +			continue;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * options:
>   * 	- input flags - query type
> @@ -388,7 +488,6 @@ statx_f(
>  	char		**argv)
>  {
>  	int		c, verbose = 0, raw = 0;
> -	char		*p;
>  	struct statx	stx;
>  	int		atflag = 0;
>  	unsigned int	mask = STATX_ALL;
> @@ -396,18 +495,9 @@ statx_f(
>  	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
>  		switch (c) {
>  		case 'm':
> -			if (strcmp(optarg, "basic") == 0)
> -				mask = STATX_BASIC_STATS;
> -			else if (strcmp(optarg, "all") == 0)
> -				mask = STATX_ALL;
> -			else {
> -				mask = strtoul(optarg, &p, 0);
> -				if (!p || p == optarg) {
> -					printf(
> -				_("non-numeric mask -- %s\n"), optarg);
> -					exitcode = 1;
> -					return 0;
> -				}
> +			if (!parse_statx_masks(optarg, &mask)) {
> +				exitcode = 1;
> +				return 0;
>  			}
>  			break;
>  		case 'r':
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 726e25af272242..0e8e69a1fe0c22 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -999,6 +999,17 @@ .SH FILE I/O COMMANDS
>  .B \-m <mask>
>  Specify a numeric field mask for the statx call.
>  .TP
> +.BI "\-m +" value
> +Add this value to the statx field value.
> +Values can be numeric, or they can be words describing the desired fields.
> +See the help command output for a list of recognized words.
> +.TP
> +.BI "\-m -" value
> +Remove this value from the statx field value.
> +.TP
> +.BI "\-m +" value ",-" value
> +Add and remove multiple values from the statx field value.
> +.TP
>  .B \-F
>  Force the attributes to be synced with the server.
>  .TP
> 

-- 
- Andrey

