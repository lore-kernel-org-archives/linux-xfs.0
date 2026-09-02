Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527F366042
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371153; cv=pass; b=sf7GohTe3arb93jNqtcoDt8UvvhHB3vxvVTfHUe1VSWOx6krbPCyhwL8Aze/Nt2DlFqW56ZcUodDHoVi1Co097YzuxNQHM3qz8smCKveKvApWVb+Kcri7EMNV/5XdrZhMkkHJ9fzWWLnVeUZ7QHqAv3Hp7stWexZRQKk2Ebv1QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371153; c=relaxed/simple;
	bh=K0HXSYdoGd6S9dM22plvKSCWPk9aEGxVwTcguAvww6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuyDvRnbFHWX8luevU+cCciHT9YoezWqrb4AF2gYdlN9+DKQYbSkeCFvRXdr+UCHIBdck3g5SNTK6rHa2SmxytL6xJGW5Kz79Dv+gxtb2neDDkUv8+fvurVCXLy86lCsUZ3TiTWn8EgLqI+W/H6z35IbBql6OOR7nDoJqVIXuWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlsTot0D; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlsTot0D"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48436216a98so916676f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 10:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788371150; cv=none;
        d=google.com; s=arc-20260327;
        b=eFAF0aLwVa57VipYibtew70xug+73uHmbKwi0H8wmTnwmy7Z/6+M8Qt+Zle7H/xFlG
         nby2jBEywqwX6gQKmkV7GuRH0Ot7E+vJzJ6tlmbEiZScD5DCsTSZLOwLR1FqwXxZoKfl
         vqYZTRvJ9ixGunr703nqhI+ApxmHOjMHEFDnpNwPnhegRoMJ+qjF/2RroOthpGWZ4cBW
         DdypsRtCd7nGnSZmQSXqlE+m8i2VK6R+403b6wGAZ5P1cKJO7sBWK66LxQF24tcfkZAj
         K3oD8Uin1q4kH/ytX8s2skP/kmVUCW5Je4TjlNsR08aACbWt5cfNKNS99dZ+OSJ4stTr
         4WeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        fh=HvDlXY4zMmqKbuVey6kXFj8PicxEIFEsqN3jV0JYbqI=;
        b=Y1vyrPqxq+iFIp+ceXPnr1lKWry0IAAFdRPtxPoI9FWg2JJdBKQsR1s8SuKvN+uyt0
         zXRHxr2GXuB+l+b0ZPbEr3ea0vlfk1HCcGoL2i66XVOYgK+2eMVyNBCicMrnUXLxL3ug
         Kie1I8YzBjmQ7KNUJkK8RWB0V/eGEyUORutpbq5VVCiKxnzLSe+nz6k8LZiRuXwcltRo
         MtGBOfde1qj/n/UvGbr/oSUNyopeQjfFDlk+sgr7tXFpirvGnfVFwxajIi7JHxObdFbr
         GFN77x9V6s88vbOBy3ZCJIPOW7f920gclLDS/bqeMg5uWPMwJTA7vV1BV86tRGIEOGwK
         w9og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788371150; x=1788975950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        b=VlsTot0DuYqoC1uVS0+e46rqEw54gX/8RoJftJey6uS4qtgDyq2L42tIag4JLFES8b
         e3SxHmU3++trX1P8SBayIhCmUWHGU2UfEmpfswvTXYROB2pyACACd1td5jpy6hx30FFF
         NzjzBKb74P9EIc/I72L/cR+5J7mkkJSphddDr/VBQ9edji6L5bp8n9Zwqjldd6kD8pG6
         n9eMbLMjt6OgCbjxzXQeiVMlGFXar+2+n3PQqV4/mQCgH6Nm2Oe1cUxp/Fb8h7bNSekx
         kSU91cyvRwriwlXN9VvExNqQzsVNKDHJkn1KmM2X9ovsVYdbd/22I6sZeNs6L6/BkgBW
         ugOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788371150; x=1788975950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        b=X+E66iKj+qWHFH/ifjxaDWoC7Yx410pExavXIW31DAeAlQFOpXvTH2qzImgtcm8I+o
         IVT6q+mDBoA5RdFvlh4SNZDk4zTsjrGLG8FYaMZTK72SnUk5EZbFtlxp/C0JRsiyalGd
         dXNMRd/GGT1iMLtHSZ+JjewvNIWvJygxg8y/tWSUtls7Sv3sboywEQGzYym0wRXUgBAn
         0tgIwO+/FV/PsAO0as+OYyldL7q5GBTVsIlz7O5jE6FS5LbJ+6KY5lw9Zl/YS/upkzc1
         Iw2oa4HeOh5CUM76DFRPYihSr4m4TahvKKYoFR8FSeoi0MlJHopBG1U4mUpFcHz6uT8z
         MvHg==
X-Forwarded-Encrypted: i=1; AKwUvBwT8f7dL6tUYc64e6au/eKC4FJXi3tmDgV1rcwVeFH6nv+7o7el4dvLE/62lBlCwTr6OUonDS4DHBU=@vger.kernel.org
X-Gm-Message-State: AFuF++m44gGjlopg0iIC+jBNVTByknfoHmsW+KMaVGXdYPMDDgk+AfQE
	nTkEzSw0qlggol3Q+BybHTMFEpjr4yMpXBInViXaE+6gwAl0XoKoN71I3QtVJzEdZcOlogPIplz
	ygJ2UG0u+PgFpIX9GXPupvqxdzm0GT7A=
X-Gm-Gg: AYBFou2NaKZ6Y0jZUL2szaiGEWWdiinLkME9nHcmtol8Dlmi86jiLyHYJ1HiJ24NssX
	0tBkqO9p86BhyMA2RRxi/82sc8Il/SiRu0ejHIot3zLfcwDPn2sqtcimtbiFeP0XTcWZSxuqTWX
	D/ixjE5zrub6xmZVPb/LIp6dm8pilWtfJGtv84XQlJ4H7Yz/AsPxa65OtUGdbNI3DWdi/yPUet8
	/OPZs4LtPjBFidSKabTJrJ+G0bd4xoHlD4hq5Tb5eSm0Imjs69UhbRgEl3vmNLqEazeVPXUUfbU
	/LPAcNPqutkaLO4Cwi4ZS8KDyre6v1MdY2BQQF/t/5k2UW1NT8wIy6axpsqjeY2aejIV+ewi3MY
	AfP90/Ugzua2DUrphWnmXEC3lr2U=
X-Received: by 2002:a05:6000:b8b:b0:484:4874:db4e with SMTP id
 ffacd0b85a97d-484913b96damr9005716f8f.17.1788371150252; Wed, 02 Sep 2026
 10:45:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
 <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner> <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
In-Reply-To: <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 2 Sep 2026 10:45:38 -0700
X-Gm-Features: AcwNN1VeQfLr-lGWKTHuj31ux7CqT9nCh6MBY2zMFOnFauLHmsLD9R1qSF4ix5E
Message-ID: <CAJnrk1aX__NiZs-RE1N1MzDVeCsRt12d_mwX_K7Eq2bHtNfdYA@mail.gmail.com>
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter iomap_next() model
To: Christian Brauner <brauner@kernel.org>
Cc: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, 
	changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 6:40=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > [20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
> >         https://git.kernel.org/vfs/vfs/c/0210c4ba2547
>
> That accidently slipped in. I have not dropped this from the v7.3 merge
> window. I'll get a v7.3-rc1.iomap ready with the last three patches.
>

Hi Christian,

Hope you're having a great week so far. I'm not seeing the last 3
patches as part of v7.3-rc1. Do you think it would make more sense to
have it be included in rc2 or to have it be part of v7.4? I'm happy
with either, just wanted to flag this in case I'm missing something.

Thanks,
Joanne
