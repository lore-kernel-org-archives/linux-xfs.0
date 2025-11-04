Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E962C0F7E
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 11:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255418; cv=none; b=cFLHwWvTJMqQuO6T0jfjr9Kstd3wQUtQBNSvGlBNnc3W45y7//CvAYzKnlPPAgEncdMnlYpeKiDqS5Fc7e5KMkdukZNMjWxrSarvwQHFpJ+aMkGgY7FPRzTR25h4KwfxSQFUU4+vSuh4krdyvNlfPcqc+i1B74EUyvSiidN/C9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255418; c=relaxed/simple;
	bh=8QvCktKDhf4f1u1Vq/VpczdWKHQQCXDw1Hw1+e9GXCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2Da/Pjuox3x6bH8BIAsvSoHz1OwZHOzDfwZFyEC7ODTFBLaf0A+2+EwcO2SJ2PH1bG5oVfgLLUDUxb5eVAuOoRjY3Yl2/UVEeK0sLKAeQ/AqM9ZBQ4vAO+ZTJqcU4ljwCWC08q0ZISZ4IsfgY8Z14DsWFiRArgnYpJF/3p2qwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0sRWJkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0sRWJkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491CCC4CEF7
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 11:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762255418;
	bh=8QvCktKDhf4f1u1Vq/VpczdWKHQQCXDw1Hw1+e9GXCM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r0sRWJkk37H3JkpOodMV0+EjKK9tzee9FG0AFOcfVeuiZobZN38jJk1UtSfAoqJK/
	 veTBlS1fQ6hfBYC9PJN2ZBLXv/Vz301Bwo6wgUvKHyexWQPDMFoi8S/x/JjAQynTId
	 CESpU+9qLnnCKRdp0ILU1kOFjTZMWuUgmLl9jxBrstYx/qelzzxljpG5WGHsKHyutc
	 rAZRlAZW++FOVbb8IiDk9tnwaEWuZKz0riKUYTVl/bbCEb6EqstBIh5ZZ9Nitihc+b
	 i6+BfApcP1UEAz+MqHrvxsBSnQo5gXtqFFcDqwwX7IS+x6U1Wej9gywNLSIF2nTb6x
	 zzlRAE5tGE1iw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b6d3effe106so845896166b.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 03:23:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0Wa7xsllzVDO1KuZCoose1dOX1s4737uXMq2X45o4sxjthyZHyjVT+z8Bh7qaM7xuSslUnMlXQhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYWdwpHcqEuLdKmeJ429aM/9VNDPpmKzLVxttb/eWDV/1KMd8m
	vaRh5jUCh8YUeFiBlqMM0S8NDnwepPBaydTb9u5yvqVSKxQYKXrGZhnOzTjhZRiOxR0zqbOSoUL
	C5rV5xwJIex7KL4fWM82BU3ronvRFMnw=
X-Google-Smtp-Source: AGHT+IH7LvDNSwoTpF4soNgCygU7sKSb5+rshVWIelKN+H6EyJT9JU/5OphYh+TJs6a21nLr+KJr6DuIz1aY9u05PJo=
X-Received: by 2002:a17:906:5955:b0:b70:7196:c8b3 with SMTP id
 a640c23a62f3a-b707196dce5mr1166773566b.61.1762255411837; Tue, 04 Nov 2025
 03:23:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
 <20251103164722.151563-3-yangyongpeng.storage@gmail.com> <aQndHokFr0ouIEAq@infradead.org>
In-Reply-To: <aQndHokFr0ouIEAq@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 4 Nov 2025 20:23:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-APJnAaKv+HXQQWf5eAJDV6foTxRiMAY6hUjVXn9V33Q@mail.gmail.com>
X-Gm-Features: AWmQ_blghmPbTPJSBe6UZI-JxbMb9_NX_eDplsi0aFEhQKP7xTARlzSrq5ZjKwE
Message-ID: <CAKYAXd-APJnAaKv+HXQQWf5eAJDV6foTxRiMAY6hUjVXn9V33Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Yongpeng Yang <yangyongpeng@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 8:02=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Tue, Nov 04, 2025 at 12:47:20AM +0800, Yongpeng Yang wrote:
> > From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> >
> > sb_min_blocksize() may return 0. Check its return value to avoid
> > accessing the filesystem super block when sb->s_blocksize is 0.
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Applied it to #dev.
Thanks!
>
>
