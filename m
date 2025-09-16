Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A328467B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758065022; cv=none; b=XwaszUygYMak2FCfLyIVmsvodJJqzhK41IlcBTdRV5IG4DH0TWAKY140SFx3X1YmnF/YUicA0q1phQuww0bjRf3RhX2x8tCkoYzVNKQ05hH9zBUbKhyt14HjoU0kUF3faFL/HWsZYcs7PKJ+dKhz5SbUqsSr8oL/Ub5AI7K+I3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758065022; c=relaxed/simple;
	bh=giTIA+oN2GPG2AJcIuFo/Yqay6xFcr7uFNP4OUqU5dI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQzHjommDFF14LkLRb/Po6k2/0y7XaYYWepgmVH8uxyJklve+OnRPslhJ6G0RaUvPIgFQtKt/ZyoZWEBw3M5kB4Mccvbn5iAbpMeBNOcHddRc8Sz3MUyZdFIcJv2l+WqP/1jGK5rtmFePY/5CdJC/M1lnT8ZqEKxa9J6aulK4r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asyUZ+iC; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asyUZ+iC"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b79c8d1e39so35340141cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758065018; x=1758669818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQ3YjBHZupiI/fSqsW54w4BEZGVyy/jiIbt6znTHb9g=;
        b=asyUZ+iCHTL//+nR5gSFuJOruC4HPynL2kaTddk7PctWZ9pBCFj1rLQuo1AHwy7TR1
         fRPl3uQNKVDDIgVty2+JobV21FKfGq1F9Vo9nZaN8FLPIV7BMB6ue5fNLgNN2yDrKFZb
         hBDWXJGnaNoy+EAjno5WK7YvdOvXf3+jVe0G9YbZRa9R5cLkNcke/d6dTGrfyPj4XavA
         jv+5Y6N5gGz4o5ZTbrvx4a/EOUQrw96Ni4xSC94Ryef14V7gFonveI61b87xn9ukf1F1
         gQChejVlUnt52ZtsFiJ9IQ3sRoC2TF+l1XDUolQpdP/wkHblopAY71s4WS/3hmLSuDBU
         3x5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758065018; x=1758669818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQ3YjBHZupiI/fSqsW54w4BEZGVyy/jiIbt6znTHb9g=;
        b=VZJ7SdkBXa/bgklSVr9n8Vudi35QYggf91bKlJHp8wdvDhmF9KHtRTkyFqzInq/9Ls
         w+H5SNcLN3xmgXk9W/Qx0q+DZ/DOaO55H14gyvXSyhkh+yTOUUg7fBuxsjBc8dr3D9g/
         +4vANTKvu/uFS0y/trDF2DoFWBROeb63eUJwVCp+V/di/tcYT//cbJJuVSud9JkCD7ZC
         bE022WhYPCuogHwWqXkh6Wol4jhtX4a8cUJ/4iV4FhqBXqzG5FJJTQGRbBXSuPICDVzP
         7paQxoP6RqzWbtY/8/IS4Ry3mNCDOhHCOIBk0zQyDkUeed8IvDTJGeYSmYXEBo91Ods0
         sExQ==
X-Forwarded-Encrypted: i=1; AJvYcCXws1iTzXb2BqtgOSifBqNQtHxWt3r2kSWCm5Y6R+V5nzKpXP9eNIdCI/hz8U01T9oX6/gp5xYxc6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoRgSJW0iyeYyaWtmr7NiU6OkKn7uzxlTgFym+hhe30lOF+JgR
	ZkVtwECxo5ekUsQJoow2MizXdXFQ6r+F1gHjHpEQOOgeCMnoPTljniZprknbIJxoCd50xGsslES
	OM3ED+JVL2NtAwOVFeAv8loXbINd+fY8=
X-Gm-Gg: ASbGncteWYvZJt2gahOZCKl+TcIISsXIXisfZU8Ca47FYycEi3OmGKgHCxzD/YYxsYh
	5H/OlMI8yrVdE/eO5GlPcuZZqu7XMVtDSVh+Wyza8yD7rr0vzZpqHaTj7Kygr8yC9hamIdFTzWe
	UG7Z7o3ogZF4Qc7oLsQDcW4Kx/4ThjwhprkXDoxQOI/aNZraa/P02ch0bbACAHfDqX74URrLphH
	maena5ymrQm9UQe2LQ/d9/26cNsPMr6AHtHCKXJh1E4PLtkgQI=
X-Google-Smtp-Source: AGHT+IGKNa7p053KroFdDHY8BCrv3xAn02NwZmDseFgEiIugEgF/oIBHgUVbXPtDWUz4HmAdeW9tnpZMVTofJgWdSvM=
X-Received: by 2002:ac8:7f4a:0:b0:4b3:f0d1:bc0e with SMTP id
 d75a77b69052e-4ba66e0cbfcmr3622001cf.25.1758065018571; Tue, 16 Sep 2025
 16:23:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-14-joannelkoong@gmail.com> <aMK2GuumUf93ep99@infradead.org>
In-Reply-To: <aMK2GuumUf93ep99@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Sep 2025 16:23:27 -0700
X-Gm-Features: AS18NWBTxeNfj7HS1GZNQzeWa7wYyaeuCFdkWQy1IIWJ1KkRr7vB0nVtSJ8Auok
Message-ID: <CAJnrk1a6UYzY=t-RJtoifxfkXQe-bKMhOnKtnvoP-X1fkPvb6g@mail.gmail.com>
Subject: Re: [PATCH v2 13/16] iomap: move read/readahead logic out of
 CONFIG_BLOCK guard
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 4:44=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Sep 08, 2025 at 11:51:19AM -0700, Joanne Koong wrote:
> > There is no longer a dependency on CONFIG_BLOCK in the iomap read and
> > readahead logic. Move this logic out of the CONFIG_BLOCK guard. This
> > allows non-block-based filesystems to use iomap for reads/readahead.
>
> Please move the bio code into a new file.  Example patch attached below
> that does just that without addressing any of the previous comments:
>
> diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
> index f7e1c8534c46..a572b8808524 100644
> --- a/fs/iomap/Makefile
> +++ b/fs/iomap/Makefile
> @@ -14,5 +14,6 @@ iomap-y                               +=3D trace.o \
>  iomap-$(CONFIG_BLOCK)          +=3D direct-io.o \
>                                    ioend.o \
>                                    fiemap.o \
> -                                  seek.o
> +                                  seek.o \
> +                                  bio.o
>  iomap-$(CONFIG_SWAP)           +=3D swapfile.o
...

The version of this for v3 is pretty much exactly what you wrote. i'll
add a signed-off-by attributing the patch to you when I send it out.

Thanks,
Joanne
