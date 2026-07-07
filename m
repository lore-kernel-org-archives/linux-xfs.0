Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3BB3126CA
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783412737; cv=none; b=bXw9wjz6YfmKrvUvn8f3o4ZovSb0lV7A1W8n4efDL24hJ8m0Dc4E/8rURnUs6JB/HQwokCeQ/SpUMrn2gVbKSATcnsR2oX9E1hh+/Eb051K8ehCzfljXSFzVN72BoANZxA7nxryq5wqLfXDgPYWx3cjUPsTmFv4u0+iMQBM6erc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783412737; c=relaxed/simple;
	bh=+K4GXGCvopiluNaYoa1PTj8AiLBt7EJxutYVMXcQhLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1WPPUfDnO8I66swdgYhozkqaHV+V4hp5qU71H5Otwov8SaFB/Bt0kMbQ+KAO+RWLUy7yJAcjSwm8QFr6DnTX7zqkXgYyhACTo9ETKHCYF8LuwWK7phCy/1ous/T92UasOWtKEXM/cM8huhbtoFvL8WOTcpffXu/Vue1gPrbXo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ra1QvYzl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lxSxrLeZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ra1QvYzl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lxSxrLeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783412734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+RB88ts8tgiAlM1T0uWvjj+uwV7Ll7oA/Iu5zXJORY=;
	b=Ra1QvYzlb6p/WhrxHHbkfJ9Cl+ix/gt7O4E0mmaKUeqIMKViwynya8MNlnRPQecqrurVCt
	SBTkQpuz16XHKeCxn9YIefndlHExqTaghTy4p9z9ZDQrHyvznnyOSVpk4d0VrXz7UxNbp5
	ICxdcuA6dmlcDKFCKRzFowrXLOpBUlI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-G4jXVYz1MsCtxp151CMWEg-1; Tue, 07 Jul 2026 04:25:33 -0400
X-MC-Unique: G4jXVYz1MsCtxp151CMWEg-1
X-Mimecast-MFC-AGG-ID: G4jXVYz1MsCtxp151CMWEg_1783412732
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c158b6e31aaso47207166b.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 01:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783412732; x=1784017532; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B+RB88ts8tgiAlM1T0uWvjj+uwV7Ll7oA/Iu5zXJORY=;
        b=lxSxrLeZZXGZIjGEviaTfVpxm2gWnS/Rptqkjgo0v5RtE5c2EYdeGjU4qhCD/oePSo
         0qpaCy/oikCkNcbwv+iceAbkT5VvmyJgcu/s5sE4S606yZjua9bspmwW0uA56talxYhN
         erfEbvzVEVV1C9vrsqvadlApdjy8HyAVGgo+aBaEXiV52qND+v3DaVaZ8mo/HBnlfIJC
         eF98r40z5W3GB5HtERJ+dU8/7uWqWjszuserMnuw8Gun5KiEdP6fR2fZ5dPpsP6aZuNV
         kxZ7FhCZaxwfC4zYOVp3j1WKrOfPhEbzCQJYJGnUbn3D4rz7T03NYbPbLS7YhFJhdOUZ
         6j8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783412732; x=1784017532;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+RB88ts8tgiAlM1T0uWvjj+uwV7Ll7oA/Iu5zXJORY=;
        b=pdk6oHA/iIvhGVFtB4GN4YmLwKZVxsWpYk07ByZol7j7wBYv3GnVRzDVJkdWgYCXHX
         ZZpwoQkwYCpiPvwYjVKoWlqS+QsGRviS24YhHLYRRzHqgBnDwJsIzEiZY3WgHKJzpwpX
         mf+8VhVVsxhc0fCDWIOrhewTFakxlf17Y5RzYqL/lr9edDP2VUdzJwxiC8eKoMqoHXIq
         BgWB8tymJbL9u5mbT35mk4HcrSFma/Fo5cchhUzOBvbUaKpBBU2SwyaT5fwcU5Q+CthZ
         p7ApsV5ryhDhenh/xRvuAtvyizhX04vcjG0qHIOseZV+K5thLoNR4No6zgedZ/1XDaPY
         eWtQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro4Ui4PYk8lZDeL89Xj4XNDM1w0a67UDVjZowWssrK3cpJ/1u2z3eHkuko78b/sIKH9cSkt9/l3MR0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6EdZR5+xfdhzaHt78IVLg5AVNPtty6QeGsth6+VoNIO7Qp/jq
	U3vEgUb6gc7vYukFfR/Ki8peKZwN5vf3AP4xE5MDB3GdqrIGSxD2Ev5q5+jL5wsfF1bnPjohIKP
	QlWHGO4Rae77QD19VwYj/5ACjm9vm2PQxfJ43YhhbxrtedTwAT9qd3XrkeK1B
X-Gm-Gg: AfdE7cn0Af4X7bwAjgmA3NOjUspO0rrTyL5rDEs6MaEUjuskTdFJDbkwH2d8ydars4y
	NWABq9ejkN4enQeMZCZeVV1o/ieF1YJj/930UJOrNEIjWv7QCGjCZJsw570Rgf5gZMuwze161/X
	6VKuT0/vXypCNQIqxINU3myodmhYDQIZecM9HAYq9cwRBqnIB7/pex0lv9SOGT2NKavjMtpcmWb
	OA7kLhR62p0JUef/qTH/RzOhI3nCI0k/UNhYsQnfT9LgGGRSamAtyaenzk6v5wDFxm1dCObHshq
	cBxbtErSvetdqbQCzuwXyAfgtuEChvfm7KyEonSGmMiBaYeErJtxJ5rvPCl/USD4/JiovW/7qSV
	3SmukMx1YcbwvSpEfjCLIuZhghXGhCOzdyKPZx+Np4hZWcw==
X-Received: by 2002:a17:906:f593:b0:c12:5ac7:b346 with SMTP id a640c23a62f3a-c15aebcc919mr91014666b.21.1783412731764;
        Tue, 07 Jul 2026 01:25:31 -0700 (PDT)
X-Received: by 2002:a17:906:f593:b0:c12:5ac7:b346 with SMTP id a640c23a62f3a-c15aebcc919mr91013266b.21.1783412731125;
        Tue, 07 Jul 2026 01:25:31 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ad844895sm79662866b.16.2026.07.07.01.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 01:25:30 -0700 (PDT)
Date: Tue, 7 Jul 2026 10:25:29 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: liuh <liuhuan01@kylinos.cn>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] mkfs: simplify setup_proto file status checks
Message-ID: <aky20cYIiJz_mqv3@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260703084004.9811-2-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703084004.9811-2-liuhuan01@kylinos.cn>

On 2026-07-03 16:40:05, liuh wrote:
> setup_proto() calls filesize() before validating the source type with
> fstat(), even though both operations ultimately require the same file
> status information.
> 
> Perform a single fstat() immediately after opening the source path and
> reuse the resulting metadata for both source type validation and file
> size retrieval. This simplifies the setup logic and eliminates a
> redundant metadata lookup.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  mkfs/proto.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..5f7a9b15 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -82,14 +82,17 @@ setup_proto(
>  		return result;
>  	}
>  
> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +	if ((fd = open(fname, O_RDONLY)) < 0) {
>  		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>  			progname, fname, strerror(errno));
>  		goto out_fail;
>  	}
>  
> -	if (fstat(fd, &statbuf) < 0)
> -		fail(_("invalid or unreadable source path"), errno);
> +	if (fstat(fd, &statbuf) < 0) {
> +		fprintf(stderr, _("%s: failed to fstat %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		goto out_fail;
> +	}
>  
>  	/*
>  	 * Handle directory inputs.
> @@ -101,6 +104,14 @@ setup_proto(
>  		return result;
>  	}
>  
> +	if (!S_ISREG(statbuf.st_mode)) {
> +		fprintf(stderr, _("%s: %s not a regular file\n"),
> +			progname, fname);
> +		goto out_fail;
> +	}
> +
> +	size = statbuf.st_size;

This seems to expose glibc's fortify check below in the read():

    [CC]     proto.o
In file included from glibc-2.40-224-dev/include/features.h:511,
                 from glibc-2.40-224-dev/include/bits/libc-header-start.h:33,
                 from glibc-2.40-224-dev/include/stdio.h:28,
                 from ../include/platform_defs.h:9,
                 from ../include/libxfs.h:18,
                 from proto.c:7:
In function ‘read’,
    inlined from ‘setup_proto’ at proto.c:119:6:
glibc-2.40-224-dev/include/bits/unistd.h:32:10: warning: ‘__read_alias’ specified size 18446744073709551614 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   32 |   return __glibc_fortify (read, __nbytes, sizeof (char),
      |          ^~~~~~~~~~~~~~~
glibc-2.40-224-dev/include/bits/unistd-decl.h: In function ‘setup_proto’:
glibc-2.40-224-dev/include/bits/unistd-decl.h:29:16: note: in a call to function ‘__read_alias’ declared with attribute ‘access (write_only, 2, 3)’
   29 | extern ssize_t __REDIRECT_FORTIFY (__read_alias, (int __fd, void *__buf,
      |    

Converting size to unsinged seem to solve it, as size is not set to
-1 anymore

-- 
- Andrey

