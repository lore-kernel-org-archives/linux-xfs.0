Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3831C9DC6
	for <linux-xfs@vger.kernel.org>; Mon, 31 Mar 2025 07:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407528; cv=none; b=kQXcPMcWNweyOXPU825mqZT1AfBsVwTrN1uxQuxiabbt7ltjOLHN6boxIzA+0m3eW3j13meX4/nPyHdbaquCco5zha2Fpsx16MWLE+xdaKvE3rhQwDIv0J0QwcUxuUG9CA2lO4g/epeldfxAhq+oTQOad67mF+rp9O7fYt0iK8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407528; c=relaxed/simple;
	bh=ARWyWWsjiTZ4XIcyIkslJMq1AMlyewAY9zWvgincJDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLtDJcDdy4J1fvUJrL3UMvhNxYt+5G+slIndXGxoKxFSyGvOi/Lr2A1cgmgbVoHbUPXG6NpCQOCAUObXZG5euCJTSeiLDriUohPgz86NOtv3QfRpPeWC+xnG0FxTglVLQbAADT3WHsm8ZiNxn4epgP6D3uwkXIftfrRlywbTaxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dmO1G1vQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dmO1G1vQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743407525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KfBIWJaTP7HVW5CsoEUbVZXngeoBLeJwGtffpiITiM4=;
	b=dmO1G1vQ9kfVYjrETedj/IQj/bp0NDwVKQZ1U2ghtuYQ8TCWx81TUzms4A5QSMdGf1574D
	KviDSr9iMaCjcCvZ6ojzT0C8d4C3qojBksrmk7ME9pN7nZrs+KsMTW3WbqxsKiqLGspH4z
	ccBAdBsyiYGeBXT9JXAjxfeRkLSa+hM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-iCcaisA9O9CMKd12j-q3xQ-1; Mon, 31 Mar 2025 03:52:03 -0400
X-MC-Unique: iCcaisA9O9CMKd12j-q3xQ-1
X-Mimecast-MFC-AGG-ID: iCcaisA9O9CMKd12j-q3xQ_1743407523
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac737973d03so128254566b.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Mar 2025 00:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743407523; x=1744012323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KfBIWJaTP7HVW5CsoEUbVZXngeoBLeJwGtffpiITiM4=;
        b=hG283CO/0QpcfCauEDYV5TNYR5LwL644Q7KiAcKrxxytkAfpqiCriTyf3L2kdSEMf5
         W7ygWit/4wldC0XGFqNnraFotCtSoIwk5dk+A8aeYXjpbO80uQOfMktGnHs+vX+NJ3Fi
         F9d7N5ARV0xcRWbKRmYD3W3j5pGhTDBZLirEMvmdSdFoDKe41vVZ/OQXb8VC7IgWQQJa
         x8KNYdQTSsPdIZoo/omTm7mXclpJjK7HTiue8m2MsaK6UixnbGekcxqCuB7zLpmcUWin
         jmgJb+PWcprrjin6OMJjA71+spbJyUp3z5AzLNsWYzgpha6UCU1nmgDGmiyHzLmHNxsm
         l58w==
X-Forwarded-Encrypted: i=1; AJvYcCXNKy5IlWl8vedL7rdQwpwn4AU8jdJl0DUDIA+0fhtLGoLW0LI5B6xJPcqIUL91VLJ4UB6rfW0E9uc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNGHReZaj3O2uEzb7sHh8CUMtNPZ/LY1YqarpXIB57ugySSiOC
	BWKNiu1A5yjfzTZ+dZ2JHrqlLt+eHz7Ts0niTAAdlUhJotiXomyrsECBk68xPawEbfezOG4pVCA
	nGwT6h9rj157s4780WdiRhdDWpaJPyAO9jScgNtga36SSgvMX4n1AsNLO
X-Gm-Gg: ASbGncvxaRW3bd/46ryv50kdd06kkMxNCwU7+/9tMEUSDLzTW5p2HqJ0s80QQQ77guh
	RYFn4f/LDt6rVmR6W6fMa1G7iZZDozy0/Lp9i1phWHZ68pjxjaYFTYAwoKVdTtYsDA/0JYvrM/e
	mjL9CRoJscUapskLpJUQPGzjD1zIOKoy4CafuwjfwjBxqCYqdBhUTH6J22LA5kPGKhYn15qoAkS
	yeHqtSvy0D8b11ZCfWP7sMoMXXGxJaDPVacUp60ySeVQCZvZ8rHy5Yz/af2ARsrv4wVxr7r1KqB
	p2kABFsoI2xaiYW3Ngo3aTcvZYk1pWUh/ko=
X-Received: by 2002:a17:907:97c2:b0:abf:63fa:43d4 with SMTP id a640c23a62f3a-ac738bbe89bmr579255966b.44.1743407522723;
        Mon, 31 Mar 2025 00:52:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAVCjfLakP13v9jLDHuWSBIAExWLPZekrgIpo7O3+oQ7n8WsROJdAblkQql2qojDe0+2utrw==
X-Received: by 2002:a17:907:97c2:b0:abf:63fa:43d4 with SMTP id a640c23a62f3a-ac738bbe89bmr579254066b.44.1743407522366;
        Mon, 31 Mar 2025 00:52:02 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7196ca988sm581739966b.150.2025.03.31.00.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 00:52:01 -0700 (PDT)
Date: Mon, 31 Mar 2025 09:52:00 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on
 "make clean"
Message-ID: <3g3j6c5wti336lcbemh5xdrk6avzl2hmndqfmjs6saqgmppwdj@ugr7vdco3yzv>
References: <Ma-ZKGYU7hIk8eKMYW8jlYh_Z0idBm-GTBibhJ9T1AQdH_B6PFLlAEEOXoTUJ85eBFU_fC2m0pdM3xOdcrf4mg==@protonmail.internalid>
 <20250219160500.2129135-1-tytso@mit.edu>
 <rqpluafkqedqjl3acljv3nugq3gjxpldmglon72a3j3up6cvn3@inq2q6xj5rtb>
 <20250328213910.GA1235671@mit.edu>
 <20250328214117.GF130059@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328214117.GF130059@frogsfrogsfrogs>

On 2025-03-28 14:41:17, Darrick J. Wong wrote:
> On Fri, Mar 28, 2025 at 05:39:10PM -0400, Theodore Ts'o wrote:
> > On Thu, Feb 20, 2025 at 09:12:46AM +0100, Carlos Maiolino wrote:
> > > On Wed, Feb 19, 2025 at 11:05:00AM -0500, Theodore Ts'o wrote:
> > > > Commit 6e1d3517d108 ("libxfs: test compiling public headers with a C++
> > > > compiler") will create the .extradep file.  This can cause future
> > > > builds to fail if the header files in $(DESTDIR) no longer exist.
> > > > 
> > > > Fix this by removing .extradep (along with files like .ltdep) on a
> > > > "make clean".
> > > > 
> > > > Fixes: 6e1d3517d108 ("libxfs: test compiling public headers with a C++ compiler")
> > > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > 
> > > Looks good.
> > > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > Looks like this hasn't yet landed in the xfsprogs repo?  Is there
> > anything that I need to do?
> 
> Poke the maintainer [now added to the To: line], I guess. :)

Thanks, missed it somehow, will include it in next for-next update.

*failed in restoring my corrupted notmuch db index recently, so this
probably was it*

-- 
- Andrey

