Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF0267386
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335128; cv=none; b=fa1fnUqEUDN2stD0C5cCjC3dqT5n8HF621HI4JhXCZUMr92pZ5l90HodrFMC3wOiid1wWzRLKy8LuL7uWHlhol27b8p0aMaIt6j4IqgUi4SfxdKSRLop3V+JHLmiRKVk3hzD7fYPAI5iUtohoR94TcdS+f5F0Zvf4ooHAzPYcIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335128; c=relaxed/simple;
	bh=S90ZNmuBnyIQdAnkd+Q9vY6n0OisVLgqcHgBMSNlr78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqvAj9JMfrL31xBNWFDnNjYwFdPZxyiszfmUN0MriDMgsS7IZTHlkB/FG2mTDtsmihtuVnKJpHIS8FbAq2m4OG59s5eit+b1/EVls2vFbfnXc3YzYR2Rqna/zDN7xKvXMs/Ra3QV+FLixxrvR6lclJPUsMlIwR391p/uF0XDzGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8yM9UAp; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8yM9UAp"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47109187c32so12244835e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 12:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761335125; x=1761939925; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9d5cV/Ds1XUvLyWw2JMn8H5lMu139pcQOZBQ5/1OKlg=;
        b=B8yM9UApfxT9nGZYjW05H7fPbrfFutCB2EwUNrZQlPTn+kG3s+DEKXgRvqeoz0wczL
         nq8XEKyBEZQMZlIpUQyN9Ie+WCQcsf0I0Ivezcs+0gt+R+aQO1eivea6o3P9Cw6qQgVH
         +mi3NjBNWHFKKZ8qrWxASoXdr/vHP848L9F4OYRqTGfYfQIyp/UD8iGcAq/IyOh9btW6
         MewVGjR/RmXB7/fxM2ppEu2ASHE0Y/GFzyFVAH3fqNxdpA6ryuOGUTPtTpomztNVjoLL
         NMyL14ZQz+ZvxEi/+ibt2QFn8TdL++vQhu5Mi8wjOESOk6NF25CP1ckn10Hb1N7uz9D/
         II+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761335125; x=1761939925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d5cV/Ds1XUvLyWw2JMn8H5lMu139pcQOZBQ5/1OKlg=;
        b=qemNrC50nLQOZqrtWpxhiTtL+VetAujh2DnwFBE26Wn49jVwEwn6B4h+dRRbhu7G7k
         krlFAj/4A0zlnT1N39xKARkfCcrtwTHi0qcph0APSSqiXGuS/96k58FriwGb9dIb4N5x
         TqLUDG8U4sd5w0zAdpHilcz8TK8QmITTfTPYwyHk/N3fQXNKebrzII0458abMhuE36Xc
         fqt7BdH0nOFIOG3suLFDqmqhandn/bXZ9fT0udCgyOGA6esLezAKM2EFI2nlgysz3YwP
         A/Jp0p/Kt1CDVtGPnZh7KFM0zrVYYepQ4UykKBy8OIc7Q5pqEPm7/wQO9bWNGJGUKZNd
         OXJQ==
X-Gm-Message-State: AOJu0YzPFrPPaAzGkeJwvuqoFfGJdcj2Jzlf44FentZuo3LgDVYqMC4W
	pt6LYYpWaBo+Oj4OEORDkkMch0mh5nGC2kqWeD81O6xfCyIfzLzIFf8DD/NbvA==
X-Gm-Gg: ASbGnculMeiLiOdxvE/ldzYkotFffLc804ajOem6m0VfS545YLpZaVniNqSNZEIZjRa
	ADDldY3td5PXggcZKFDQTI2awjY3AsmL0CtOA8/UDdwuR0wxHw9dWyMj/6jct39sYqqYsuKf3cn
	tToM4bYK+/UEVcISrbxIhoP8RchfmWXoXPx8ufGRpZHeOZJAkZq+0Y8qprL3Klx6EykG7A0rOF5
	0fq8TrMikP/3WI9QIWlMBD0qFKTG5JRwO+gHYn3dVaumUGEt4c6pGq08cARx0nvn0N7Mh2MvVYB
	OvkW1lsWQdmrspDicGPfcJAy+E2SdhROvRxgmDDgOKyVI253xXg1tEwzGSdLQUDaPfVUqYonu5b
	NrWozSKRbHKKyDVN5/HBjL+B+W29TDzEmQAd96w1EcSj761N3zRQKTDlo3003FxeLWb7Sw3cD+6
	XMW24FvxT0g/e9FoAmP5P1mPqu07oZXJskGYgQxamsYA9IUorI
X-Google-Smtp-Source: AGHT+IGStx9GBpf2iUTZ7q6JvvPUx+DmwFNx6KhMGBSJOZXlzJm1qUlKDGSRZBc7w5AKnBWoCCbbCQ==
X-Received: by 2002:a05:600c:3b8d:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-471179176b9mr257493175e9.28.1761335124897;
        Fri, 24 Oct 2025 12:45:24 -0700 (PDT)
Received: from f13 ([2a01:e11:3:1ff0:9dcd:df29:3054:53fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf4642fsm100778345e9.17.2025.10.24.12.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:45:24 -0700 (PDT)
Date: Fri, 24 Oct 2025 21:45:23 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: dimitri.ledkov@chainguard.dev, smoser@chainguard.dev, 
	djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v1] proto: fix file descriptor leak
Message-ID: <yyfsw7ftigcgodfqjudlh6cfv65ebb6a73hiouxzsmt7exftsw@65zg5awb6mri>
References: <20251024193649.302984-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024193649.302984-1-luca.dimaio1@gmail.com>

Hi all,
I apologize for introducing a file descriptor leak in commit 8a4ea727.
The pathfd was not being properly closed.

I've submitted a fix (v1 patch) that adds the missing close() call.
I'd deeply sorry for the oversight.

L.

On Fri, Oct 24, 2025 at 09:36:48PM +0200, Luca Di Maio wrote:
> fix leak of pathfd introduced in commit 8a4ea72724930cfe262ccda03028264e1a81b145
>
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/proto.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 2b29240d..1a7b3586 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -1772,6 +1772,7 @@ handle_direntry(
>  	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
>  			    rdev, fd, fname);
>  out:
> +	close(pathfd);
>  	/* Reset path_buf to original */
>  	path_buf[path_len] = '\0';
>  }
> --
> 2.51.0
