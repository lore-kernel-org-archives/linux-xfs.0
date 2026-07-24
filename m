Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC9338D687
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929820; cv=pass; b=hTuPgT45JKe8QdB1e2vUYTLlU8h6lWD7IFXndasECzA8t5P7MF96RqwsH0LE14rXFKc7+0vyojXVFjJVfu3mjpXrJz6vdJKYmgcMdCzcxD7kMM2MIlUSFSZIv3N/HLZdsBNeM22h5VPEjvDrTBaHtg03oN5jTSeB18WszJnwxkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929820; c=relaxed/simple;
	bh=GONOZECKD4VhAKuWjYwwp0qP75BxUV1SGAkrOKq4bp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ek2WkWm2ZrJsP3KltPhl9s3cJXCJm4A6CQSea6jXsl6E0NUvKCcAp69W6tRzy0+Wm+UIFASk9FlXypWFZwZE7BPK+8/GPf9YoUV/xctQNKpiq4byO6BIB6wPTW/SCk48pzpZ5fya7GVSrcKkW3annTLzX8K6K0bzg5N6BNnlOu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahBrZtSs; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahBrZtSs"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954df200ddso6560515e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 14:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784929817; cv=none;
        d=google.com; s=arc-20260327;
        b=ejNYHeIqxkrVR5pnaDNuZsALpauqL1IoSZW0/XbiuTgLySSSyhsp+Ki7GNT/iiRdK8
         9TG4uWtFo2MXGQ24A9LB80/ApdWatDg1M01XPNCWFaj3uv15okUFHuFU7xakcnAjqhIA
         xodoC32lvbI+YpIw/33Vy6dDIZXoPAYjP8UrWee/MHLOfCOda59TtUMZ1SPz6ziTU6eQ
         vbGw7eSsNrDZEh3SlSvlSbpVSQKij2PNfKyPpJJu0qmCsb6Q1LUBmAJJ7jOO6aP0JG2R
         LllT4llBE3U+AZUKZs7hx7YSUwLvvbd27FYjG8NVc8JI0Byh+0ZNI2wrciLJ58innFWZ
         7sdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        fh=A2KZBPo9VYEPcER8tU+ptmjCmSkrLEQ2lid+KDIWwvE=;
        b=STGPhDZBLiowxO8jVhiLFQp40oWflcVioeQ1Rm/lUeS/TUu6aXQ7G4OUbFOB4n0kgc
         rU3tb0SXRbiHn14KSrtcHRDpaNVsMimKD+tr4FsZHV7HGo7fhOjXqmoQKjQzfYKEf2u+
         BzMxGgtXIUTfVL03d8StoYVJmj6RuKo9nwpgTPNmofCCk+ayubVYVSATxn1G+u59R0hj
         puzb/iubo8pXNKwA+dtgOCfuSjHl7pNpy0U9XqUd8eSgJPYMXqefX5mOq9Z/PCkQENqK
         wYvGnPpuOs77jyne+/PibsYpR2HZVS+sDGgoqeH7/3ydE0xDykCd46aR6Zs1f9XisEVF
         Er1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929817; x=1785534617; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        b=ahBrZtSs67kDaSkppi6tu+bKx31L3rQSeMDpDEDVWSOM482mlwVnGkh1+3MeqMFpCO
         qwyVbJN89xtMCvMRHPTYRIo+HAf7//5hh0/ex81bcERPxRuFJ20BU4hz2fL/DflhZuzj
         TEzQV3rnp3dNrnx9O5rxuHaqrahc/iMWlxqarNiqTj1qTQ8W7LdyyajfPBVITa9iXsVa
         KiQ/FKgEK5AWan6el3kuE3ZDOQnxlIESXECaunNhnkrrlocLWIyHGyE6S/qPY98dHCQ7
         xvivZBhoBDR4qLdHYCSeLYD361CthJLfjAzB/jRFHqgNJ+3ht/Rf4cW/fcl71KdmePTS
         aXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929817; x=1785534617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        b=ixqYpntpkuhSLyxScO3VUjriFO/zMPDP/+evYNdOo4CpDtsAA1i1x06jzbnHJ+UyuY
         h7JqTuhtKh2oBw0q1whUXNv1aGh/kscxE9PtWNfm3EyMzcOJCDHzkGODvb3V6PydVQi4
         d9qhrQaQlmuJuTn2l4kxAZps9vBXg/IVIfOgZPYD1wZzavroQbl6y0DjOU48FvDuKQr7
         zrHjh5H0kgXDqyGB/h4eo/jJN1pU4WdGuDvdABbjfQ5c26zWjNnsnDmVXUKd9bqayICn
         l4IqkkAqRtb6eiF4x801bTnmzQNO2mWbkTURTPA5yniFS5Qa4h/QrLmrBtMHnLcb7wNN
         C57g==
X-Forwarded-Encrypted: i=1; AHgh+RoIbi2V6QzdsPPbHM1/jkGAfmBfvqmcWf1CsypZLL/LbMIpckx0tCkdlhlkvFP51vKoKCf13r2Ss0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV1kS8Vf/fXGvqeETi2F6tY2W/q44fX5c4TtdoDBDsjEGT9tKq
	tKn+8fj/ifnMeGQLpAyWJc9ZzapHL1MIDIonpwqsmRmvOJehJ5mmTtVZrHS0oRKjgE3avbaMm2C
	cJLcQJjNUIzl8ym9KyTnsXNW+oQK2j5Y=
X-Gm-Gg: AR+sD13OdRyL82KLl7aZqQOu3Nce0dQXp2lj/VPZT/ID1I9RDt5eBvRyVxx3lwgyepW
	sFme+RATqAxP0Uk085qUqHFjmUJqibFTsOea21BpRTSU7O/AVoKWr7uPHMvfBesUtVVo6iUc4rf
	8+Nv6RiDpWpXWQq/K9e5vI/eeSntpQIkREsf18XD2xTQQCZbJj9HrJeUJ/WxITqsNCfYfLAjF5a
	iGIHuABSMbM9WNSdb2mIDydxr8UEwkFGjv+MtVWjTRC+r/AY0oXG9OOiz2czabWI2GFreZBNGSd
	T9xvBZx2aI2C8XVZuvPDQZzv6pV+Giw1UKBRpSGVYQ==
X-Received: by 2002:a05:600c:3507:b0:495:5dcc:52ae with SMTP id
 5b1f17b1804b1-496b56e6f5bmr907305e9.3.1784929816876; Fri, 24 Jul 2026
 14:50:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723050201.3381045-1-hch@lst.de>
In-Reply-To: <20260723050201.3381045-1-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 14:50:04 -0700
X-Gm-Features: AUfX_my_nPSev9bT-9Z2cTW7X3xJ7bo6cpxTit3ZoW611uMe8LHBds-augHG3Tg
Message-ID: <CAJnrk1a=83CxXxqaV23dpT_-QTYAoz1pkeGXDU5H0stUW0kVmQ@mail.gmail.com>
Subject: Re: decouple simple direct I/O reads from iomap_dio_rw v2
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, "Darrick J. Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 10:02=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> this series reworks how the iomap simple dio read fast path is called and
> decouples it from the generic iomap_dio_rw and the iomap iter.  This is
> to make the iomap_iter_next transition easier and cleaner.  It slots in
> after the first patch from Joanne's
>
> [PATCH v3 00/20] iomap: convert to in-iter iomap_next() model
>
> series, and the first patch from that is included as the first patch
> here unmodified as reference.  If the approach looks good to everyone,
> I'd suggest to include it in the next spin of that series.
>

This series looks good to me. I'll wait a few days just in case
there's more replies on this and/or the iomap_iter_next series, and
then I'll send out v4 of that series with these patches (w/ the typo
fixup Darrick mentioned folded in) included.

Thanks,
Joanne
