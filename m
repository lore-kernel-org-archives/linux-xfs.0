Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753944A23
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 00:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736814201; cv=none; b=nMMzr7Lf280Kz0NC91s8sul0F5pSkpHAQ6fyTneJmqpaYVvLdxaBGCJ6blsacmMM2XWNYx1Oh/8RRXq57IM0tG0cOUfVUlwLJexCWlgc3quUrEWfMVTWZYDq3gX/j/jxoExcIJy+X+Vddae9+Hw0E/5isJI7Y4z1iouGeSb4TKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736814201; c=relaxed/simple;
	bh=Qbk2a8C6seZZ4zXjMd5UTNxoskJeP1HRanglC3+vonU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OM0hqLSJki6WCXeh0UTNGYPSCeciz0eMyNIbcTfhxhPghlOoPcjAAK3dImCaao5csBLPt+lmt8DeeSP5i1JVBJv1WxDa27FHdFsVuoZZ88hGipNG9pfv+XubwC2bNu5UpgctRE4Gnxq4BAisf4Wtm8LjjdEJHnkRp+mIKm1WKZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qgMbn7/3; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qgMbn7/3"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21680814d42so71501125ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 16:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736814200; x=1737419000; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YItycY5R/m42eXk3/qNP953O4CiBEKU/MYhnzFraZHA=;
        b=qgMbn7/3x8Q/YoIRej+rC6EEiIci3/7t1d6kXWWv57SceqmZ4OSmhCQaz+HQKQN+R2
         Hun4/Gm1gMXi4HtMk1KJeH7Ixhpmgkz2Y8y1HejHytVA04Fsu5t3cWmbsrkxrHCCd19g
         2VucND0zqWvkszCpKNLP4UjIU3TEbILy6Y8zuRUKZEB5rreUHcWWYzGQXDKqO6TOdw8I
         pysFDgid/77gjQrCXHl1cCkHdBH3qYvEHEb1+N71NTzTPRpDoT3WJpcHSTQdYHtnUNFI
         /kbVXc3t/qi3k6MO18zFVKqBf7tA4xc66g+ac0HZ66Ak+cJZ+ewvulzeiM3GoD1mqWfz
         ahDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736814200; x=1737419000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YItycY5R/m42eXk3/qNP953O4CiBEKU/MYhnzFraZHA=;
        b=KtPDBbbe2D7P7GCjO2FZUxn9JzdpWRN7YsdtVt0ZX9OGBQrBbJSet90fPAeUzPgx1O
         N39i3bbe2PqAoX+v8CgaqCOuluIL1f4/FYP4cDB0rujyqgUsRFITq9vnBy/7017Vzh5X
         hPOjHMc497dsOXYPGmtrJKNeluDgV56uDclvzgPkUfMyQnCxd5BwubCTBvTOmp3ghFfx
         PGmG1lbPUp9zo3yCHyTDx7ZyrDxtra3/tGHr6X4eN18xPLW57i6lhyPzwJdDlmilpaLv
         EpjNO3eIzl5xAr/S8V3P9JxMng8CuuEXvAnqscXg15vcioT+pUfrFmKeVzBDrtIHJ7kX
         OuQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8/Jlum/5JeNeNFy5J6MkLBG07wLG12PXwZykExUU4ex8eEKB92Zy9nnf7aj0U4qVCNDocPAMp88Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZeyyHfuhKk2LQ8lLx3VxlvMJBLCHWyg92qKA/Nrgig6WEwFS+
	4r+vti+LJHAMk4LASvgHt0EZ00bxxUYzG+Ds4YHwGCgasyjDLFXJV9I8DgZ8XvQ=
X-Gm-Gg: ASbGnctFkPb8VD9pQxaAu6T+v+KDueVbX+w3AmH8ra/ZLE0zbM7NtjPEvk86SYw9osO
	OucsFjs8BtfgB6oJEuRwgIBGT+Cp95Jk8CH7tfS4JXt8gK/I3woqJEmKHQjawGMfShPCCgkuFnd
	rn+HkWINQ5M+5GuSgzq1Eeq5jbxaUXswH9bTD+GIkO4xjVxS5XdmGVRYpiMHDvPQXdqmQjuZ/Fz
	OJT6IacJLEDiTKNqY/G2rwO5eFEBp78iSjIaVczrDO54JaVfW6U18ZwXNdXeCdprw5EidUGgoi+
	uxJEU3W7wZo+pw1HJ6otaztJysejDrUD
X-Google-Smtp-Source: AGHT+IH3IVfI5FxEBgNPeFXUDbgM7sYQEe0YP/Drzzk68NQVQ4t/Y9wPgGXUviCAgoTTCXo39JWdwg==
X-Received: by 2002:a17:903:2311:b0:210:fce4:11ec with SMTP id d9443c01a7336-21a83f42687mr360762705ad.1.1736814199765;
        Mon, 13 Jan 2025 16:23:19 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f22d13fsm58377965ad.188.2025.01.13.16.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 16:23:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXUiC-00000005Xz3-3gJE;
	Tue, 14 Jan 2025 11:23:16 +1100
Date: Tue, 14 Jan 2025 11:23:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: buffer cache cleanups v2
Message-ID: <Z4WudBQE-z3F9EMO@dread.disaster.area>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113141228.113714-1-hch@lst.de>

On Mon, Jan 13, 2025 at 03:12:04PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> over the holidays I dusted off some old buffer cache cleanup as the bio
> splitting in the zoned code gave me a better idea how to handle
> discontiguous buffer bio submission.  This spiraled a bit into various
> additional minor fixes and cleanups.
> 
> Changes since v1:
>  - make xfs_buf_submit return void
>  - improve a comment

Whole series looks pretty good.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
