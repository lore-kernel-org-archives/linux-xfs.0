Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FCF276D37
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740712839; cv=none; b=uTsvZJ+xKgpsWj/XxthDT9/B9PtYzZMBsaaDwQUyRKk/uoXsE+b7zqhHzSYWmo3zn/vXRONaeQnvPphwur9pxKokU/wG2TXx4UjlqIHhFRL0Dh29lE2AXP0N9kzp9/hpHKN4Jxuj4bqWV9GYGsbiNWKkifY4RCvVVidZvW0SRIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740712839; c=relaxed/simple;
	bh=0G4ycoEeVYrqwcWCbFmuZpCwQiUaWW4FERax3F3H+dM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PNmzhEexkASScZF+1wALTAqXaoOQ7sDNQvsl37GeB1C1bai2QwOaqL+TU7m2KWPQPk5WMnCon1B8mMwtNoGH2UM8KYo2mR2y3bLW9tGHhtQln/a4vvwyHJpp0JI5K4v/f5D1ZUihWI/GnfYnCQiaq7J+WLdmL/0WCu1Xlo5ppNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWj58AdB; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWj58AdB"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-221206dbd7eso34250205ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 19:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740712837; x=1741317637; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0G4ycoEeVYrqwcWCbFmuZpCwQiUaWW4FERax3F3H+dM=;
        b=iWj58AdBAM5LNIYvZ7dyrCvG7U6fEaCGX3HO8EUMamGcH7a4qABVV6u6nrDLw726SZ
         Fds/f7q2DquRz0CoDOWJdbsIrrz/TBCYrrIFzMJOaEZ2lvzs6yTduzEcyW5GuMWjIxPQ
         6qlHF0TvHcN+fCkgo1p/eNJEw6oDpgwh9absC7sNN9S8KTBa0vKTyxMJxb82lP9Nfm0e
         Rm6f6YSkiEpivSjQ2HTLTo7mzMYfv5gL7OoOUFcbmFY44zt+rdKiWIcirJakBa5rTtqA
         e6KsVad+EvyY7/QcbJ0mODQThEmuPcQ+SUfHhmdC3RrDhnhhxMOZ1prhaOReYNehXPqc
         B4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740712837; x=1741317637;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0G4ycoEeVYrqwcWCbFmuZpCwQiUaWW4FERax3F3H+dM=;
        b=pgM74bqrT/E73bsSGAt4FkN+4OXsFUpquT9mjLXWlNjwEr2dF5ubz+WLyfG+9e9D8m
         PwXT4891O588KRnAb21rpOItwLnDOCfzEVfn9USR943lYy3e2wIYQm2QWF4V1mNYTw/Y
         DJbLGgV14GU7BWs8/FzYOeo494Az/uAbACOkY2LHf8d9cTQ8FK6iiDGK8KOcOOIruOh8
         3t9SSjo5x+WmDA7lBkqbWO5oi4YjicbFe3Y0c9rU6Fk0S1h4ZEOaAZj0hPbMe+UtqLDY
         M7MG7SicqWCDg0EXJFlnzXr7w7FUcdwfA2utrrxA348SKmVg0/p4kDzk9YcamW/tNMLb
         solA==
X-Forwarded-Encrypted: i=1; AJvYcCV9Nz5aGHWG7GgwuLES0rWdBYQou8MCBU9qK4QWH7rnWp+H4zR8swZw04o7eA+ya7G+PLes3ie20WI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZgkHCSJpyvDWcveZkwxXHJkIEhvBw50pYp86Ly17i11bfrz99
	m88wPE5XGt4FPSmlp7qeKks5h21/fGKHcjX5MlR7GmK/5W10Nar8
X-Gm-Gg: ASbGncv4le//0HPh2Rshk9TAgAU5HafqBRaPxq0ldyEAhneu9ajpuVwNQXXMHnz2ZG4
	jBu/8oDzw3zkZt6DvxDyrpQM7iOTVCfXaIzlTmkpDlUL/6ekkiW9Q6pj+pywxr+zCcOUvwTedn+
	0l8RlNqk+f6y/X9dXua6hc32VGOVZN77+PkNqAfNFGHm9bQrG8HuTFjWzZfxvvuMKI3+dyDeSw+
	7FgR9cUocauzHCVGWxzvL8Ham1q3SS81K+2rjwKHrxI5/kk/NokWmbfzQV63i26lnjBxRG4qY/N
	HBZKwNGi+J7OLwTumBlDKFNlp9R8ZD2HqcI=
X-Google-Smtp-Source: AGHT+IFpDReUMBTmbb6BnoXLJXqpJ0U8l7/9e+EI1W3c//re9F0HtdS8y5y40+evpKGPI4Z7Iag0YA==
X-Received: by 2002:a05:6a20:7289:b0:1ee:6ec3:e82e with SMTP id adf61e73a8af0-1f2f4e3cc66mr2378820637.29.1740712837070;
        Thu, 27 Feb 2025 19:20:37 -0800 (PST)
Received: from [10.172.23.3] ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7ddf242bsm2337833a12.13.2025.02.27.19.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 19:20:36 -0800 (PST)
Message-ID: <55cc3ae8567f77f60a7dcac7c4f5cc14e11f65a4.camel@gmail.com>
Subject: Re: [PATCH 1/1] fs/xfs: Add check to kmem_cache_zalloc()
From: Julian Sun <sunjunchao2870@gmail.com>
To: Yuanjun Gong <ruc_gongyuanjun@163.com>, Carlos Maiolino
 <cem@kernel.org>,  "Darrick J . Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org
Date: Fri, 28 Feb 2025 11:20:32 +0800
In-Reply-To: <20250228024842.3739554-1-ruc_gongyuanjun@163.com>
References: <20250228024842.3739554-1-ruc_gongyuanjun@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-02-28 at 10:48 +0800, Yuanjun Gong wrote:
> > Add check to the return value of kmem_cache_zalloc() in case it
> > fails.
> >=20
> > Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
> > ---
> > =C2=A0fs/xfs/xfs_buf_item.c | 2 ++
> > =C2=A01 file changed, 2 insertions(+)
> >=20
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 47549cfa61cd..3c23223b7d70 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -880,6 +880,8 @@ xfs_buf_item_init(
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bip =3D kmem_cache_zall=
oc(xfs_buf_item_cache, GFP_KERNEL |
> > __GFP_NOFAIL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!bip)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0xfs_log_item_init(mp, &=
bip->bli_item, XFS_LI_BUF,
> > &xfs_buf_item_ops);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bip->bli_buf =3D bp;
> > =C2=A0

The __GFP_NOFAIL flag ensures that this allocation will not fail, as stated
in the comments in include/linux/gfp_types.h:
=C2=A0
 %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block
 * indefinitely but will never return with failure. Testing for
 * failure is pointless.

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>

--=20
Julian Sun <sunjunchao2870@gmail.com>
