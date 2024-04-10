Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA1537C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708875; cv=none; b=VJ4kDSQ14+Zu45r0TGGtb7BUGqlo+RKOthrjKiB0QZp69P67tQDic8LKaa2bVJaNwnB0em0PovCpjL5k8/0BvbH7h8gu2gVCqOmQHGMuhzsssQz0bH0bmpv0ojlLEePR6/eZHLevtXvzMV8KITERe2OJLqCIMLRQV/ePx/deuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708875; c=relaxed/simple;
	bh=1g3Jwd101yosBOnAamyJC+sD1SyFil7LtbqBjatinpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frEwr+WNbfH16Up9hdA1BewZk9fGzrW4K6YJZunHNFqEHWVii9ZyY/s+b2czF6DACxN58NHh54DWo+gR2AfGX8lqXo91bhHoqyy6jRg8jYbOPjvDVy3cA1994SGgDElP/LDAAercKLF0H51r5L5DrK6kybkv2fXA7VFaQK8ghqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YZ67S2aJ; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YZ67S2aJ"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56e2c1650d8so4616090a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Apr 2024 17:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708872; x=1713313672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJMJEkzZNvW9+O43vYppDJCzIvChB6Myj7KkmaC6Lng=;
        b=YZ67S2aJsxuW7ZWwhDrapvfXVU0Uv3tDTcQpvJzB1gq3eVO+2/VDwMBKTa4+Zi+1Ls
         fc9uRvM+LosX4JDX/eha18nxd7OXK+OODFIVxNKXW0DiDN9//FK27rFf+svUEg24Q6Jy
         9pxn3/4dNqDywU/1VQSXuDL5VC6Cl4rUPiH2F4OZ25MOWgLvdHzJYd7oIyc0by71ihOS
         ZkcPdQgTBV9kG9+oafaQil+2dsbi1CDKnSKNM797lZlzFZYtiVt7tRKkt9bVbAzB92Lk
         7fMPMs8v9m93E9x60R+D5LVWzKmegoYIHZboTJqWiqOx9FTHd+mnJjj07dP4jUzCDMKz
         CcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708872; x=1713313672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJMJEkzZNvW9+O43vYppDJCzIvChB6Myj7KkmaC6Lng=;
        b=YfzFx1lJbgjgdkcP5+6KlTyTV9MeyTAWv0Bn0Uhl+wqFU1ZMgk2mBFgoCIf4UQ1jcD
         RJiscIn97rhJs2Zh8d1LmzIkAWKhF5uiX2NZnV04y47xGOFj3wt1gfAydnH0aCWzctqv
         ISgwNmpeb+iAAJnENqKvC+PMRrBJhzGHna7ElLbr+twoato1bwjuiGHEzGlMeh1zrPsb
         kChpWrtdQ4CPjvALpEbldFKdphS7c4qAKV9tuDV698R3QRdAENMP6BUUhm/1f5vAVAnk
         Cesv21RnK9xZ/K1cI3ay+WrSSJIPWtS+M+2yII9Ll211FsFC+tgXgc6TWd9ZLAK67aYb
         zouw==
X-Forwarded-Encrypted: i=1; AJvYcCX9LBeNDfmHdp/y897VFGADJf9Ec4ZP3DhX2AnOlFE7+pj6eBI/edVPbSUME6PCFd/aPTKHtk0dxQ/KICiZIbJlOluQQ4JWW6DZ
X-Gm-Message-State: AOJu0Ywd8steT0XbeZXvVj/EfGMm3J2nvTK6IJF6w9ijiJDc200v+vyC
	oBN4JTa9ZXTkxaoRfWZygDCu/dftZzVMzDLht29Ym6/1v4uCqQERvX3Vrh5iuBEPATm/AbalilG
	wzzDS4XoiLQQxWeEfpiWj10H7pYGi5w9KLRxt
X-Google-Smtp-Source: AGHT+IGStqxWPH5ahxvU9bcdmddGl/48mJ9/LNQW4hznFXCzuZH/DVbrRH2nwiaQ/F1lKkgsTNqDC26Qe6ALxXgjzDM=
X-Received: by 2002:a50:96c4:0:b0:56d:f035:7db2 with SMTP id
 z4-20020a5096c4000000b0056df0357db2mr517493eda.24.1712708872102; Tue, 09 Apr
 2024 17:27:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240405-strncpy-xattr-split2-v1-1-90ab18232407@google.com>
 <ZhVDgbRoF9X7JSdt@infradead.org> <CAFhGd8pwoBSvLDRLX8ekRk+u9uX6s6mcAfTz8E15E6EBsvuSag@mail.gmail.com>
In-Reply-To: <CAFhGd8pwoBSvLDRLX8ekRk+u9uX6s6mcAfTz8E15E6EBsvuSag@mail.gmail.com>
From: Justin Stitt <justinstitt@google.com>
Date: Tue, 9 Apr 2024 17:27:34 -0700
Message-ID: <CAFhGd8qwCwycW=PpUWUGxAdU54jwi9D=k3xrNgC62CvM-Q+ukg@mail.gmail.com>
Subject: Re: [PATCH] xfs: xattr: replace strncpy and check for truncation
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 5:23=E2=80=AFPM Justin Stitt <justinstitt@google.com=
> wrote:
>
> Hi,
>
> On Tue, Apr 9, 2024 at 6:32=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> >
> > On Fri, Apr 05, 2024 at 07:45:08PM +0000, Justin Stitt wrote:
> > > -     memcpy(offset, prefix, prefix_len);
> > > -     offset +=3D prefix_len;
> > > -     strncpy(offset, (char *)name, namelen);                 /* real=
 name */
> > > -     offset +=3D namelen;
> > > -     *offset =3D '\0';
> > > +
> > > +     combined_len =3D prefix_len + namelen;
> > > +
> > > +     /* plus one byte for \0 */
> > > +     actual_len =3D scnprintf(offset, combined_len + 1, "%s%s", pref=
ix, name);
> > > +
> > > +     if (actual_len < combined_len)
> >
> > Shouldn't this be a !=3D ?
>
> I guess it could be. It's a truncation check so I figured just
> checking if the amount of bytes actually copied was less than the
> total would suffice.
>
> >
> > That being said I think this is actually wrong - the attr names are
> > not NULL-terminated on disk, which is why we have the explicit
> > zero terminataion above.
>
> Gotcha, in which case we could use the "%.*s" format specifier which
> allows for a length argument. Does something like this look better?
>
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 364104e1b38a..1b7e886e0f29 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -206,6 +206,7 @@ __xfs_xattr_put_listent(
>  {
>   char *offset;
>   int arraytop;
> + size_t combined_len, actual_len;
>
>   if (context->count < 0 || context->seen_enough)
>   return;
> @@ -220,11 +221,16 @@ __xfs_xattr_put_listent(
>   return;
>   }
>   offset =3D context->buffer + context->count;
> - memcpy(offset, prefix, prefix_len);
> - offset +=3D prefix_len;
> - strncpy(offset, (char *)name, namelen); /* real name */
> - offset +=3D namelen;
> - *offset =3D '\0';
> +
> + combined_len =3D prefix_len + namelen;
> +
> + /* plus one byte for \0 */
> + actual_len =3D scnprintf(offset, combined_len + 1, "%.*s%.*s",
> +        prefix_len, prefix, namelen, name);
> +
> + if (actual_len < combined_len)
> + xfs_warn(context->dp->i_mount,
> + "cannot completely copy context buffer resulting in truncation");
>
>  compute_size:
>   context->count +=3D prefix_len + namelen + 1;
> ---

I copy pasted from vim -> gmail and it completely ate all my tabs.
When I actually send the new patch, if needed, it will be formatted
correctly :)

>
>
>
> >
> > How was this tested?
>
> With https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/about/
>
> but using scripts + image from: https://github.com/tytso/xfstests-bld
>
> here's the output log: https://pastebin.com/V2gFhbNZ wherein I ran the
> 5 default ones (I think?):
>
> |        Ran: generic/475 generic/476 generic/521 generic/522 generic/642
> |        Passed all 5 tests
>
> Thanks
> Justin
