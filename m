Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7DD2F2607
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768323072; cv=none; b=eLVFxNRyqvy6sKO9g32hhrdGyJn2z92JuseZnQmbccgv2gxplXuk7wZGxF1zgCPQxdIGVkvEU+yQd0FoiwyhMlcEGbXkScieHlzqOrJnHy59uMP4EbOsTQtWAoLXO7S9W1U/b0wbXS+d5SYouaHRi+MCg9Stfex47ZhkkdcIsT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768323072; c=relaxed/simple;
	bh=Hm+hFkCxE6lVbQx4eQObQxXAcvrq9lVQw90Wa4bRafg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CCwx7z7RFKuQoPRp9Yx+EHBkjlIjMh7OcOq1Et2voO/HLlyEhjxp5hm6PG+06U67i5fI3hLOf5dSRhuMPoxBOzFPcpuZIRUUwSlB7NVW4V/KmDy1ei06PCwOvXw7Q3wwnW8D7IsLv0qjjXQcMvuNnCqH62DqwIRau+x8FTuEM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-450b2715b6cso4520185b6e.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 08:51:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768323070; x=1768927870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gc7yqO7D0eseyKYDyefBFLldfXSHU35zlyHiXIvs8J4=;
        b=EWeahEDjgGDFyw6RxIlYwgt5p5RIZFBtk+eeX96YGZj7LGlt4gVB2xNUvptfnV/20E
         /GBU7FIQDRVbN+PDOayODJn0vEBYU2UOmochpMv2+TeXOvWVaMAleyVubERNNhdmC48P
         Zj7Y2GmuWUDSNw7gtqXlyWTrmqUdBI5cP1Wll3TTNnGs+ZT3N0TF37A7jH27VD1hZ1MW
         uryjZqmVycpZ0PKElZNtpeGZyoEO01ZuwE5ya4+0vnEIBo38nrPQtSfiBRlv1RZ/RvMN
         MSAoPFAA1UAWOzF60iLKuzcsEFllHW+bxbS4OwCjUmcPwchS7aMupIwpb3TTPM8tfNYO
         Xo0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtr/YPKK/I+t6IH5Q9B8kq8/ktkNJSHHAVXYumCd+C980c6Z1leHkRtpMhiItHzz7NbuC6hJ77pBM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9IM6o/zoJipm4t6t08Vp5eBWlf5De2zMhg2GACWfnWZBgzSi8
	jZiq0JVQHITrt9L228YWsiLQZ586g38XRSjjeSI06aqDaIzTMw1qWmkcyoZzow==
X-Gm-Gg: AY/fxX44K5BTuvwENZ3BaRWsYE/ZBxqqe71K77GSABKdmaCV4ScbQcyeoMMnQLejqWG
	fWIBFrxijGJrqtEoCwuh0G8y+NWvk2bi12fjXiWlM+U6qVIGAlt3dhU6mID2t90DX90yj4IPUsH
	7CkU/QiID84ePGV4NIW0DvotFn2hzCGv90wm5JIlHpDxjkoLLdsbtjHiw7BlLMasRUZQC5xbzwJ
	OGcUYerNWoGf9vFlip86gZBqlzTmbscI+zvJ9MMuqixdGnG/cS+ZBIvVUb1FB9LWipFBlN0U5Gj
	kX+1W/ltb0FuBraWfdmDJ386MYUF4A+ySIU3vwjXztQ5UDmSEej04XkOsi9zXoz2rfub/fPfanl
	ZLM5uPVEHBjERoa4G5bMqH6DYTqrrzMMMRCHL/nRZlAMvK7SKv03IKMxb3gc5vPHOE94mjMbcMw
	1Q0BjRnfMWaBtZ1tmv30aeeUyIp1L5rN/hqZ3YJo9cbWB3RdMJDRDI99vmI57D/HzJ7XEoL7ii
X-Google-Smtp-Source: AGHT+IHLzyvgk2SZ7Y0LwfgyENILUqtm+RUQImPcSDt89+g5QFEwqJHQKA7m7cgV1+2NjUDF8STUOw==
X-Received: by 2002:a05:6808:2016:b0:450:760b:cc9f with SMTP id 5614622812f47-45a6bde857amr11743526b6e.30.1768323069660;
        Tue, 13 Jan 2026 08:51:09 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa515f4dasm14723761fac.21.2026.01.13.08.51.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 08:51:09 -0800 (PST)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfb21a52a8so1493958a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 08:51:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWzpK2Vh4QWUGfLqH/xg/loWDxwyuE5t8viD9a3j3NGbZKRMu/M7jKLiY9iCaj41uKXQ1PZO1nHoJ8=@vger.kernel.org
X-Received: by 2002:a05:6830:2e04:b0:7bb:7a28:51ba with SMTP id
 46e09a7af769-7ce50a6def5mr10521137a34.26.1768322616531; Tue, 13 Jan 2026
 08:43:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112174629.3729358-1-cel@kernel.org> <20260112174629.3729358-9-cel@kernel.org>
 <20260113160223.GA15522@frogsfrogsfrogs>
In-Reply-To: <20260113160223.GA15522@frogsfrogsfrogs>
From: Neal Gompa <neal@gompa.dev>
Date: Tue, 13 Jan 2026 11:43:00 -0500
X-Gmail-Original-Message-ID: <CAEg-Je8LGZGGAQ3XLMQg8=XmJjvvJNShT3zkE-o2t2fv=VGeHw@mail.gmail.com>
X-Gm-Features: AZwV_QiAh8VN4kaDD2E2Q52MaqDS5cW88U1qWaL9kDfC-E_siYu-7adEi4A7eM4
Message-ID: <CAEg-Je8LGZGGAQ3XLMQg8=XmJjvvJNShT3zkE-o2t2fv=VGeHw@mail.gmail.com>
Subject: Re: [PATCH v3 08/16] xfs: Report case sensitivity in fileattr_get
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, vira@web.codeaurora.org, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, 
	anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, 
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 11:02=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Jan 12, 2026 at 12:46:21PM -0500, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >
> > Upper layers such as NFSD need to query whether a filesystem is
> > case-sensitive. Populate the case_insensitive and case_preserving
> > fields in xfs_fileattr_get(). XFS always preserves case. XFS is
> > case-sensitive by default, but supports ASCII case-insensitive
> > lookups when formatted with the ASCIICI feature flag.
> >
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>
> Well as a pure binary statement of xfs' capabilities, this is correct so:
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> [add ngompa]
>
> But the next obvious question I would have as a userspace programmer is
> "case insensitive how, exactly?", which was the topic of the previous
> revision.  Somewhere out there there's a program / emulation layer that
> will want to know the exact transformation when doing a non-memcmp
> lookup.  Probably Winderz casefolding has behaved differently every
> release since the start of NTFS, etc.
>

NTFS itself is case preserving and has a namespace for Win32k entries
(case-insensitive) and SFU/SUA/LXSS entries (case-sensitive). I'm not
entirely certain of the nature of *how* those entries are managed, but
I *believe* it's from the personalities themselves.

> I don't know how to solve that, other than the fs compiles its
> case-flattening code into a bpf program and exports that where someone
> can read() it and run/analyze/reverse engineer it.  But ugh, Linus is
> right that this area is a mess. :/
>

The biggie is that it has to be NLS aware. That's where it gets
complicated since there are different case rules for different
languages.



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
