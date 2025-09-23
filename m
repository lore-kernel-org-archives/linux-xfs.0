Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DFB1F5846
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639464; cv=none; b=JbrkR8LjWAGsZ5+Q1sc5LEDSArjnPsHGpwcDD+dmbHb+545NpEqJ3pBiIr5FRQsg27DN4OGkq/cFm1i3qsoI2SujD+MqZaipB411Vva4AMjojO95I+s/b5xXeSyPdOd4r0aKxXa4Lz4RNcBxHTsmj39mlSqgYG+z9QP+Oal2mJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639464; c=relaxed/simple;
	bh=ado0gGMNGkne3XnnLVKZD75EJqaXJcCVpV/965Q2kqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lORBFhgA5m0gOb+c7RUpw/Du08sUqc1xCjReDm5XnTJ7FnBqRAhObIQCNRRqHfg1gWskU0Y+ZlFV1NKtX3DTGmIHZ9zzdVc+aH7JAzlAJKPiYq7FoBoFjq5wuaqA9q/0m1UsLN15axn6jMTE7/LMhLDazd9EasCo1mwMVQyronI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=d2yb99Pd; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="d2yb99Pd"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4c7de9cc647so28971121cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 07:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758639462; x=1759244262; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S/1Ra3b4AxJkZwWUJJmBUWhCQcrAccc9TuqzrD5b54U=;
        b=d2yb99PdNM8yv2FIKwXObjYYTO4DGwtSceXqyFrb0+GKhSqFw/WomWP1DOmhyGMGg2
         VU8KPfMQI5gXsMfpcZ7sBL++FPFGe7KLlTrRQW73u7iL8+LVSqM1MxPM5skv30/wORM8
         TiqBKw16XLF/tdQn+HxWdRnIXJqOMsNNMYnjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758639462; x=1759244262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/1Ra3b4AxJkZwWUJJmBUWhCQcrAccc9TuqzrD5b54U=;
        b=WVavxtobT8T0HOyybof2fKCP9jzxIzXVSJiKYeRH/m+QtBHBEyHn7iyURF/jwk3QnD
         lsynMzJiZ8v7NUf33YUekDdTTOCzafHndIR/2cBbvedc+vWKxNAtSV2JCZ0YEebAGFji
         QJaaVpyfH2gWK71HXafniKssa/AdxkJYAi3CwoH6zbX5ESi/jsBCDad82D+sf/SEJdjN
         RntDB/giZc2xiLOnRcVyYCjIFKt2HSCXjNSnDAFcP51uyH/22WBeUVcCZ6c6agL5xksN
         rjIma/x74Y0Uu9E/02iXxOIybw3+rD5FzDhQYXcAIbt99YKq+qyKkWR397HRb3hIFCcK
         /dZg==
X-Forwarded-Encrypted: i=1; AJvYcCUfywysr5ViTOyQm3ATAcWe7jNZgP/ccxgeAXNNgco72gQGttjcqMqpf2m/R6iti+r7nWFAXU8uO7o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWRllZeCuXFKBP2GjmI2gkFI48nkoHKMNz0HdLBU9uJDvQ8EAY
	+kR7psKZ5d9D6UTHEJPmF7PmWSivtp2ffnZZd83ktOKAxRbVQtmdH9WnbAXpR6G04AxJ2ShknSr
	MyU6ufokJF7V2ReA7mSJvvCVvK0unvWCyb62Fu/KBeXcBRkmtes5gAOI=
X-Gm-Gg: ASbGncuHa1XHP7+jj8AuBlpsnPw1AgC8Luux4J3OTo5iR99M+uy6HG4USInYJSo27mE
	N8xwfa6ZRJi51MBLcNT45b57VjAozK4ir3mp8PuFVO6ZPcWI4KCuL/NErZicv3Q0rS/Bqcyso5p
	XQ0bWcaEZj/gb2WAUFceU/gt5gBstQLxiwl2CQ6wPKNTVGn5TZYuHrSDfql9hTtMsM2BS8hVzF6
	f/Kee9q/S3om0xJMfX1UJgDAra0y4txwkxf9dg=
X-Google-Smtp-Source: AGHT+IH0eM92WwCDRahzcw/O4eqi/MmAUuqF6p3lIqnlhgVoCsqGzUctXBm/mnNB75hLW/j3SDqa2DEtFDBpHTUWSYY=
X-Received: by 2002:a05:622a:2b08:b0:4d1:9467:dbb7 with SMTP id
 d75a77b69052e-4d36fc02d24mr38698411cf.38.1758639461660; Tue, 23 Sep 2025
 07:57:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
 <CAJnrk1YWtEJ2O90Z0+YH346c3FigVJz4e=H6qwRYv7xLdVg1PA@mail.gmail.com>
 <20250918165227.GX8117@frogsfrogsfrogs> <CAJfpegt6YzTSKBWSO8Va6bvf2-BA_9+Yo8g-X=fncZfZEbBZWw@mail.gmail.com>
 <20250919175011.GG8117@frogsfrogsfrogs>
In-Reply-To: <20250919175011.GG8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 16:57:30 +0200
X-Gm-Features: AS18NWCQpKJJBOwPqVorO2NGt-XmlZBAK8wWQiyLzvCGZrc4s0l4d18vx3t_7WU
Message-ID: <CAJfpegu3+rDDxEtre-5cFc2n=eQOYbO8sTi1+7UyTYhhyJJ4Zw@mail.gmail.com>
Subject: Re: [PATCH 4/8] fuse: signal that a fuse filesystem should exhibit
 local fs behaviors
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Sept 2025 at 19:50, Darrick J. Wong <djwong@kernel.org> wrote:

> /**
>  * fuse_attr flags
>  *
>  * FUSE_ATTR_SUBMOUNT: Object is a submount root
>  * FUSE_ATTR_DAX: Enable DAX for this file in per inode DAX mode
>  * FUSE_ATTR_IOMAP: Use iomap for this inode
>  * FUSE_ATTR_ATOMIC: Enable untorn writes
>  * FUSE_ATTR_SYNC: File writes are synchronous
>  * FUSE_ATTR_IMMUTABLE: File is immutable
>  * FUSE_ATTR_APPEND: File is append-only
>  */
>
> So we still have plenty of space.

No, I was thinking of an internal flag or flags.  Exporting this to
the server will come at some point, but not now.

So for now something like

/** FUSE inode state bits */
enum {
...
    /* Exclusive access to file, either because fs is local or have an
exclusive "lease" on distributed fs */
    FUSE_I_EXCLUSIVE,
};

Thanks,
Miklos
