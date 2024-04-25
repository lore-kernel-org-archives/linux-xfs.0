Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E802599
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714087811; cv=none; b=I8nUN0XMvX+GWT6r67tChX54n2kRIl5neBcaC44z3dDl5OvSSDedz8d3H1aP/qq+9YfJrtprNBy+cRhuvZ8ILPNq3/ElKZG3W2QOVOAw3kha5Ct8F00pynAzgO0/auaXbuAKB8FNdkhDeRqCT4in2ALzxOCwP7U6/iZAXvWyfao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714087811; c=relaxed/simple;
	bh=mNmnYI8ZX9ToNqn+4yvvr2Xf/XOAit97Ly8NwVa2KDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSIYqDdbAOujFRUiX5UgICzKNx2Y1ykvVLQmpQVqUtJ04DShnJ53qu4De32rVG1yl9QZ+4pmfL1Y8yK46SovCLKfrZ4LD9LdfgabqZcs3SxBqd2dB1zCuNCj2BQQKvYGLxWB0qJn2z18hDdjBa8gNkNh0K6uRkgntOMWuugh4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=z6eYqpcK; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="z6eYqpcK"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a54fb929c8so1134313a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 16:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714087809; x=1714692609; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cXMcedxU3o8BAZ3NwgNX3q6oAlC7C5KnfWFQs/vc0o=;
        b=z6eYqpcKLugSZBPPmzIEtfTzpEi10I+KRc61kJBOWpnin1mPCcimeagZjB7xZLSJWc
         StBAOkH3NeuBAXdhhoqN9oSn0g/i/C2AR/3mIKx8+VoMNDe98Hn821Pcq3UKwNhveyuw
         6iCUVFz2l93voAlGZUJiNGEqNnvFtuM+2HSG6IiCIHJjD9GSg7EH0LkwJu0fTEPCfZpj
         rOc83hJIMBCbhbLODnutTF2fixUR0YYB5nts+RqQd32ODPCiP2DPZ8r0rNhovbtaGawd
         e8Y/nA1FweFKtQDrRHu/nV3bgthyPLn5MGKMhaNFyd3neOSb79pqCYBXilBWL8Gas/R/
         2kqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714087809; x=1714692609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cXMcedxU3o8BAZ3NwgNX3q6oAlC7C5KnfWFQs/vc0o=;
        b=IkdQ0zLjYvakFmpmgzUFskIc2JH/xXDVa70ACaSJRr/MhWHS9R3JfIIc675LOdegwh
         E23YspuUnaCmXLubG8VFR0wfLb6NN5Arj4dO8gd+md9QhPNw653MdmHfaSDXWG8UyNsr
         P95x/AcBseMSzcF1qvXxaxm0+h5/Lq0/AP98GDRxXTmWk0AP+LKwOAdYxz0TfRv07FHj
         u5bWf14b4XxyD0FCuGi8TrbIY5ao44d90DS5sBFSJaR7dm1thipNzYsxYK1z5w2pwPP6
         CPTfkL+9NMIvj87KEuuPXJ6oQ5+Xey8M9Gt01oadahh3egQV1ow61zkeJfsxtPMI8REN
         8JIg==
X-Forwarded-Encrypted: i=1; AJvYcCUTEo27kPk346OATm1hx3fkNpF6UqEljNp9oEib9LlYBdGpFa+igjwjq0SeveeUyGQ+BYgWdjWHeFqlAvai/DACNTDsGURWPZcH
X-Gm-Message-State: AOJu0YyPxABmggrMaWSO+OzABS1EJrp+9WJ7YLQ3DRJMR9PzDhhyh1Qh
	mjIl+Iz8srohDo+jtM3qtP0ZbiYlpkie8PuIQMC7dedGKEQyuZmrInW9BfURUKA=
X-Google-Smtp-Source: AGHT+IFAj1+qrRXMReD519Auiz+VmMbjLUN9V6BCXHT5D52lbJ6674ZOpHAs0q2j9zhSCOx512n6Dw==
X-Received: by 2002:a17:90a:4a92:b0:2ad:f47b:3e31 with SMTP id f18-20020a17090a4a9200b002adf47b3e31mr1121740pjh.28.1714087809262;
        Thu, 25 Apr 2024 16:30:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id q11-20020a17090ad38b00b002a076b6cc69sm13622292pju.23.2024.04.25.16.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 16:30:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s08XV-00AwZ5-1s;
	Fri, 26 Apr 2024 09:30:05 +1000
Date: Fri, 26 Apr 2024 09:30:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, chandan.babu@oracle.com,
	djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Message-ID: <ZirnfaFFqqyaUdQv@dread.disaster.area>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
 <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
 <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>

On Thu, Apr 25, 2024 at 04:37:25PM +0100, John Garry wrote:
> On 25/04/2024 14:33, John Garry wrote:
> > > 
> > > (it also wasn't in the original patch and only got added working around
> > > some debug warnings)
> > 
> > Fine, I'll look to remove those ones as well, which I think is possible
> > with the same method you suggest.
> 
> It's a bit messy, as xfs_buf.b_addr is a void *:
> 
> From 1181afdac3d61b79813381d308b9ab2ebe30abca Mon Sep 17 00:00:00 2001
> From: John Garry <john.g.garry@oracle.com>
> Date: Thu, 25 Apr 2024 16:23:49 +0100
> Subject: [PATCH] xfs: Stop using __maybe_unused in xfs_alloc.c
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9da52e92172a..5d84a97b4971 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1008,13 +1008,13 @@ xfs_alloc_cur_finish(
>  	struct xfs_alloc_arg	*args,
>  	struct xfs_alloc_cur	*acur)
>  {
> -	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
>  	int			error;
> 
>  	ASSERT(acur->cnt && acur->bnolt);
>  	ASSERT(acur->bno >= acur->rec_bno);
>  	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
> -	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
> +	ASSERT(acur->rec_bno + acur->rec_len <=
> +		be32_to_cpu(((struct xfs_agf *)args->agbp->b_addr)->agf_length));

Please think about what the code is actually doing and our data
structures a little more deeply - this is can be fixed in a much
better way than doing a mechanical code change.

agf->agf_length is what, exactly?

	It's an on-disk constant for the AG size held in the AGF.

What is this ASSERT check doing?

	It is verifying the agbno of the end of the extent is
	within valid bounds.

Do we have a pre-computed in memory constant for this on disk
value?

	Yes, we do: pag->block_count

Do we have a function to verify an agbno is within valid bounds of
the AG using these in-memory constants?

	Yes, we do: xfs_verify_agbno().

Do we have a function to verify an extent is within the valid bounds
of the AG using these in-memory constants?

	Yes, we do: xfs_verify_agbext()

Can this be written differently that has no need to access the
on-disk AGF at all?

	Yes, it can:

	ASSERT(xfs_verify_agbno(args->pag, acur->rec_bno + acur->rec_len));

	or:

	ASSERT(xfs_verify_agbext(args->pag, acur->rec_bno, acur->rec_len));

The latter is better, as it verifies both the start and the end of
the extent are within the bounds of the AG and catches overflows...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
