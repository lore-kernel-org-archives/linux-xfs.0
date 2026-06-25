Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3630F543
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412376; cv=pass; b=B9M38bUrJXkNhRDiB/OX/1UrRBf06ikwX/kVGMI7ubaPmv3T8wnC0gJ4xapqKOMOj3LfBXjPmIQuwLCQNDt39bYlWaP4JARO2XZZxXY/64MCyIsU8Fuqmg6qAP0w5nEwcZl2CFyAkJxgszQw5bdxLp+sa4gwva7Ezg9JbfOJe1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412376; c=relaxed/simple;
	bh=BDX+NQmwbo8tKyIHJVU3KO5zaM+mKg+N84iqF/OWUBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kx8KT7JGTcjNesl0qwFKE93aeWgmQXLFIYvPLAoaF5H5sHrnwrYQJUpRhWqe6C9Pb4e+w1S83gX0k/5VarBFekg0OOU8cil55uqdgs+dhVCgh7S35lwH+m4APhCU5bMiiHgfLeybg9hYwDszA07z+pvQaPVZjLEDBcpM6Dgd9BE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKyJCLRD; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKyJCLRD"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-461edb387ddso45462f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 11:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782412373; cv=none;
        d=google.com; s=arc-20260327;
        b=Ldn5GWK3DEGZJKauBaOzWF/dFjxvzDku3ApmXT04rV93ZwXDGGUQLR6PkZp2xyjNy+
         uHn6fJXeEjWPwcqSkzINZnoIIsPHMWizqbDSGlAXRc3QsrEpCjaXxPzogTWupSiIrmuB
         kso54OIdY2LtYQcel0qWmK9VC8pXvjoHgRxBu9o6eG3JNPCxs9bpGm0yf5zqSeIWeNtg
         IdppsM2CR3EGbDuWDi2BQXWL02IllETD2zquUU2ZIB7FbIBI/IhdhacxRGffTZlO4SU4
         owb1mOVv3IENXPkDk6tTKiYsVGudP6Oa730TIXb66ZIPErvYxNP+VoyFdG5Uwszz+Xae
         hmjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g9V61tcEtmNSRd/wIPFD8Kzb7PIr8WM9gRz3AhdzXFA=;
        fh=6QIzRcv9qJ7W99Wkz7jTI9WLWo2HBFL8/y6m6aPm1y8=;
        b=WFiQkaXMiJDEmLeVhn7zu7UDsvtL+ODYZAsCks8SuqHeyus/EOH4sQjV1C6iBUPZho
         Y/UETh7YAdK5/9dOJwCm1QFFtOZupb5fG3vWYbGJFJYwQakKbUF/Mp/SOonDAzSHxz1r
         P61tR4nnnhq8uoN5gZrE6tsNLjeKk6M6Uz0D5AVr2HNN3bnDQwmLS38zRi903uFIyGJX
         Y13fERPzoMrrdxwwVZhCOdELrULj7qNIlEvvccGKNKUwYONYjVA4+L6kMF3iIehZKZ3w
         +8++pEAsWzUa2BarQL/tAeqSFLk/bcIXDBV4KxXok9gGuX42OkhQmPod50CSlJa1e+8E
         JRgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782412373; x=1783017173; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9V61tcEtmNSRd/wIPFD8Kzb7PIr8WM9gRz3AhdzXFA=;
        b=BKyJCLRDjTujVynHf/v+U7D/LXyTDEu8jthJww0EJEDKC8i+9SaFY3LusmUACJcTyc
         LgsRSpaUqECW92LA7Hn4GFQVwIZbNnvSQyNvcqeuniKMF0w56p/XYr9KLRsBYifLvxZf
         Qx66qkNsY6JJfTY7cahDbvaoyuV2cbn/McNNLRK+3F0FqMtLesZThd+XAkvMmB7apV/u
         7tIN2sliG74qz2u3Let5X0KvDzZPpLnh7J7Jhld83IdHbHq0Vr8/2VgeIDawWh1frjlU
         PwXi7WvYyM8zQCBnXG1dmwQlpRi5DGLP5142J2TSd5VjBASE4vadZijEafqA/m4Xu5Ew
         8uFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782412373; x=1783017173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g9V61tcEtmNSRd/wIPFD8Kzb7PIr8WM9gRz3AhdzXFA=;
        b=kfxbP3G/0OZdjWyOcwgmTR63aP5Qbm9EWl8yLzAuwtz4bn54CfC78OY0kcKejvG0Qn
         i5Y3cxi0/3UgrGRKL3dloDDwtor7P8MXjm7XyWW2rfsIG0BwrOURLrqvH7JxjUesfcaI
         slTuM2MEzb2T19JP/6tdMaotrqRBYS+Vc/2q0SKRyZBf9VJEM4daC4Mjl+wturfOPIRF
         DsvpE04yV3Mb9FnrxJ0brvt4wtegnP2snG3L86274Ito8bOa7wS8S//wk+h/8t5yml3W
         lS7XPk0hAi8zheg+DK4mnW+JwRXNxzezr/H4tiINKeJFIyuswBGQjBr7eh3fkhJfIJDP
         5Ycg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd5MFsXQ7KtkMVLxRDL6RTzns/rbzjE51XL3FYNWYg7/+snKfSaFlheFGbOUMPhAa+ArEGu0cjmmk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNH90vdZAglBYXdBYje+AgqZg4M9ddA0It3Fr5Swrttubeemub
	rQqB+UQzILF3rLgqTvK/L8VaMmZMa0vjBch7//PvDRcT6f9L5vXnOoSzC2FXjsxBqT67W+cTJ6E
	GIpTYQFhn2EIlKrdJVGGCumMVZii/fyI=
X-Gm-Gg: AfdE7clSeY/VxPrMI7lkk45s3YeD3e60QDlK+pRsWYmA+SUFOtPaGLsb7FW0JU7Hzl2
	S6+ZeCjHAYmy5l9brpwJ/0Lf7QcdeMxAG0xblwQ8PBHanb09obg5vKGaWWsUg04C+ObC5KN/ald
	ojgHJlvC3TEASwOb+D8EEWmkR2dTgzB1Kcg7jZ2QuouBxY6gxsWO2xnxkEj23SyAJPK/ULEW6YR
	8DCvVcPDMTtT9eobBvzndX+4kjhYD1iD2NifsuUIdvPpl+ny5txmi1SfhmVJMxz3lsrfgooQdeO
	FNZmlMobYIbq4HRR7kLDH5Byj9qUslgNrhxeDpGU2qYl4e8dt2aS
X-Received: by 2002:adf:e198:0:b0:469:3bd0:fa7d with SMTP id
 ffacd0b85a97d-46dc1e7d2aamr5538200f8f.41.1782412373179; Thu, 25 Jun 2026
 11:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de>
 <20260625174758.GE6078@frogsfrogsfrogs>
In-Reply-To: <20260625174758.GE6078@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 25 Jun 2026 11:32:40 -0700
X-Gm-Features: AVVi8Cft-saEfjqDMyKwAQ7hs3asCzTZsJFUliVou9sVBM1d6hPzz_2GUJ4y52Y
Message-ID: <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 10:47=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Thu, Jun 25, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
>
> > So instead of adding more checks move over to a model where a bio only
> > spans a single iomap.  Change ->submit_read to be called after each
> > iteration, and pass a force argument to indicate that the bio must
> > be submitted set on the last iteration.  Switch the bio based users
> > to always submit, while keeping the single submit for fuse.
>
> Is fuse the sole reason for the "force" parameter to exist?  I wonder if
> fuse could drop its submit_read function and call fuse_send_readpages
> after the iomap_read{ahead,folio} function returns?
>

Yes, that works. I think that's a good idea. fuse only needs
submit_read logic for readahead. The change would just be:

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -953,19 +953,8 @@ static int
fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
        return ret;
 }

-static void fuse_iomap_submit_read(const struct iomap_iter *iter,
-               struct iomap_read_folio_ctx *ctx)
-{
-       struct fuse_fill_read_data *data =3D ctx->read_ctx;
-
-       if (data->ia)
-               fuse_send_readpages(data->ia, data->file, data->nr_bytes,
-                                   data->fc->async_read);
-}
-
 static const struct iomap_read_ops fuse_iomap_read_ops =3D {
        .read_folio_range =3D fuse_iomap_read_folio_range_async,
-       .submit_read =3D fuse_iomap_submit_read,
 };

 static int fuse_read_folio(struct file *file, struct folio *folio)
@@ -1089,6 +1078,9 @@ static void fuse_readahead(struct readahead_control *=
rac)
                return;

        iomap_readahead(&fuse_iomap_ops, &ctx, NULL);
+       if (data.ia)
+               fuse_send_readpages(data.ia, data.file, data.nr_bytes,
+                                   fc->async_read);
 }


If this fix needs to go into 7.2 though, maybe it makes sense to land
the v1 implementation [1] + the xfs integrity fix now and do the fuse
change later?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260619050105.439956-2-hch@lst.d=
e/
