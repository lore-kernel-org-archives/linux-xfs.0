Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5680618C02E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 20:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737665229; cv=none; b=m0XRDDkZPIxLXWZ7zTdni2FZ826X6NNty1PsbyJu46l39S5n4IM4KbWnXRZCfL2KXiJeMzFjdRmdLAWlA7duT8t1fOdaDFJAfQWhk6BnO/aNwaz5a0suUO//rUATevMd3EAG/5xU8khGyXcSxpDrGJAYaO+cqHfURTS2qKTPcL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737665229; c=relaxed/simple;
	bh=KSB8Kp7EsHfrVZQY+SXlup88JVP9yyybJ/L/QaYGigQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kzS0G5Of/2QS4JJbuZrabazJX5phSNlZrdN3lP6o9dcRcxyqvrrllRyDJ5LOI6tCmsNCZ+N95YQU7A9Br05xW1g/iA8FHWXgHt0ivL9u3HdOk3UJRZTZuoWKp2DvfY1kAwJylmJNCC8oHEbwFONvjviRHqjD6SLGkyh1MLHQvXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZmRbWAF8; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZmRbWAF8"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so2659825a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 12:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737665225; x=1738270025; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=swhkuw2IJC0VH7sw/GAoE4rlKpYnSdAW6AVRyqLV/Vg=;
        b=ZmRbWAF8udZCxT6foOmi18uulQHZBFWYrqVuzGwFsUUZacZmqL7GzZYWMej/sKGcdy
         hGYhvxbmdS8JiVkRsjsRdAAkHrpZXYW8ViQfVEHlQIggwgnQL/ymSYvMN4n6RZ38MoJI
         TO9V2Z5XLFSlp2o/nx2ytxAz7Wr7A2tjjawt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737665225; x=1738270025;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swhkuw2IJC0VH7sw/GAoE4rlKpYnSdAW6AVRyqLV/Vg=;
        b=kd2zJlk+xOvqUV9Ca4c1loArTaENj3Umxo5sPQRetAYLsoeytcS07oqwOkHVRCG/Rs
         qBmhzAtRnyVR2xf001z4XwOvkNnjC/jygP7eyVBc3VCRh2cVCEoYzetYskMQ9/dLyZYC
         u07fwLa+1TyjXkM0Vr0sDeRoiCRXPGi1z9A+ht6+B4SjX8GKqjYfX8KRj4kUGKGR7rbc
         KXYXyVEvusHkitGGWm4yg7PeyVzrjCQ8VTvCjWvaAv1ejxSPlConlFeB2Ehbt5IEEeBQ
         vwz1+wJn8J74l8VmG1jgUumwPjD1qdZW45R++3EOwyhYyVJNSkgxd1/RHk1gAfhd7yCP
         Dhdw==
X-Forwarded-Encrypted: i=1; AJvYcCXemzOZ+hbOfoFO/g884uHXd/sQoLqO7op59QqNWN6nDrLjV0cCBwCsFQtxG7sZcc6iG0IkSOMufd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU+jFmtfL+GVJcGOWeWK/5PH0TW+EvwpowTEQiYxWN/Xpz5Dwu
	nsSk7s0kH+mHrpsD8O4pBXoy1km3cL6U7zdvbaNNZ8Lm5W05HrybKEBviN9ARY8WhrI1eoALr/D
	2aPWAEA==
X-Gm-Gg: ASbGncv9MyHQ1vNhTQkLxnuMtFqJX/MWKgvZ4vZz2LGZss98M998ecfaPxORVzSdGHy
	PWb8CqN72PdNLZ9UcYt0yr52ZcZfoxOo8Rg4ZCSnBs835Wy/xgnnb9uFz4fb5b481qOdMKupX6r
	sHQhppwaiJq++1CWKZel3trmlKbNjpVS8PMSoSv7OpFU9c+hnNMRzCMeuLNt/yeMA4tMf/jGUD1
	F7aOZZUUu/PWmkWSwx9ZRW81WZZ9t1ipFW69oWxtHXvB1pYcsTRw2R2SXV632gkPrRyH7ramuVL
	YNNToDQB++vD1mT52PApnG5ZirtsN60SOgajw7XsmSY/C7uMT2FALFz6Ftmhx4aeEQ==
X-Google-Smtp-Source: AGHT+IFYaoqQu8y3lPg09GLSBMGzNswjmeDYWp1AdtZzdOwYaSi45VUJevMyNvGgaqnsnrbIe9zbiw==
X-Received: by 2002:a05:6402:4306:b0:5d0:efaf:fb73 with SMTP id 4fb4d7f45d1cf-5db7d318b68mr26267785a12.15.1737665225391;
        Thu, 23 Jan 2025 12:47:05 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186d8ad3sm134685a12.71.2025.01.23.12.47.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 12:47:04 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aab6fa3e20eso245075866b.2
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 12:47:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVY1+bqRTHX027Gf97fOx/xMur35kltvmTVRQKphPvW86iIVtJF809uaWqP12sPb9T+YIy3yMrgkCI=@vger.kernel.org
X-Received: by 2002:a17:907:1b15:b0:aae:b259:ef5e with SMTP id
 a640c23a62f3a-ab38aedb10amr2909641966b.0.1737665223126; Thu, 23 Jan 2025
 12:47:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <i6yf5ledzs4qdt5zhrpg7nz5neyygktthupap6uulpuojcx7un@phdanup4alqb> <20250123183848.GF1611770@frogsfrogsfrogs>
In-Reply-To: <20250123183848.GF1611770@frogsfrogsfrogs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jan 2025 12:46:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>
X-Gm-Features: AWEUYZlD8a5D9sz4IXksbiDpEwskwuldR2mzMQR5r4tlOyWh8uFjh53AEtyDrzI
Message-ID: <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>
Subject: Re: xfs: new code for 6.14 (needs [GIT PULL]?)
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 10:38, Darrick J. Wong <djwong@kernel.org> wrote:
>
> It's been a couple of days and this PR hasn't been merged yet.  Is there
> a reason to delay the merge, or is it simply that the mail was missing
> the usual "[GIT PULL]" tag in the subject line and it didn't get
> noticed?

No, it's in my queue. You don't need to have the "git pull" in the
subject, as long as it says "git" and "pull" _somewhere_, and the xfs
pull request email does say that.

But I tend to batch up merge window requests by area, and I did my
initial filesystem pulls on Monday. The xfs pull hadn't come in at
that point, and then I went on to different areas.

I'm getting back to filesystems today, but since I have great
time-planning abilities (not!) I also am on the road today at an
Intel/AMD architecture meeting, so my pulls today are going to be a
bit sporadic.

               Linus
