Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD97C146D65
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922081; cv=none; b=pKK4OgSQsm3h5OWH0NFkHQQUJOLfnuvjQkyVtHe+vJ8tSuJtSwAKuFEE6+by7YjpLoVVn0SUxoZ+vRGYU0Mgqs40GWQf1xVjYPwgBOvFHDZ8OEGhpH0V0YCDth9jqtNdAVB3+M/2k1TY1dGqNdsZ9suHURh243wh57wYHncAjO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922081; c=relaxed/simple;
	bh=C/Y2cSTeTZjUezr1wx/93NVZGRkSjUvt+wVsiNkvSXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doNsIRK/LF7D+pxhrtqskwTAL3Bey4DclySwM9Ie/WOxynKqpXzK8QRRpDcPNh8WPnf9OQ6/38H734Nq3tQgB+882Vw2IqGB8Di/5472Ds7qmRDQpfv1zc6fxgF0q6xXVu5XZ73foBbmIysFmOxPA09Zg4C/0DVYU7GX+MUeOJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AONy6ESC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AONy6ESC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad56e993ae9so904877066b.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747922078; x=1748526878; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=khBaMbs9S7mORuSKmTop7Y15GL8tKDgmLu4AtkCFPBM=;
        b=AONy6ESCORjJT+oOT53b4zYFDQ14PiMoj6aKWDPsL2A8aktJCNRYSzx3v1j6bgC5ig
         W5LMT90EHJ1yZUiO25AwFwe94WGIoMCGS1kEE+WP4EcdjnJkbl1IZo71XAq3ycCmpeTV
         6UXesNSn3nmTG0tWbdCU8u5ofz5k8n7GHO2/O3mwuFP47blrBjcPGyrwCN9OlDYkD7iU
         fG+W3Y7f8D5pWGBq+gm2WoFBpe4SCYsYNl6FcU3aZ7KXMMyOOU2xtXe7gJ17GSIR6qRq
         FaT7kD/FQ+ddyb5BeMBpNf21o101JIaq4CaPHX90Qtd/iYe7ASP/Gco5H4pHX+3njhmD
         /rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747922078; x=1748526878;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=khBaMbs9S7mORuSKmTop7Y15GL8tKDgmLu4AtkCFPBM=;
        b=YQNWlFXY5m8nvBQTiJRm4hgT7zevpxmU02kjSHypC9lJGP60HomNvOy4SmKQXiu3DI
         1J43Epst0qTqY7ZR+NwBAhcQtn6r6Rz6LOMPA8PzVDohPTRNxrCQ7zFqnITKL8qUTPca
         IOSDrlW11zd0IwJirVpUBIyAKHzjpj0GZxqKKF7I9DCY5syfrjk3+MofhEXZizBSiUBY
         P8Pg+pwOixyUiB4Gf3/Eqsc8LuD7DUI0geM4WpMvEvVBaXut7fBz/YyyGfR9yE9lD/py
         KquDc+/BnPTtjS+cc2bEBmWTDGZDMxfNNJPjWOSwju6aZKkkj5zjp/EkqF4uV0GM5X4H
         PzkA==
X-Gm-Message-State: AOJu0YwBsgYzmVlrY2B8yGV9i5IeursUwtV6Hhan6GabRO3qYcrLczYi
	se2waut8hAorci5EM4H4qPb6rq2KD0B0VlWgezXgzpiMTOo95vmF0BMsD46luO2Z3e0elKPuZ5L
	h+BMmA0piuFuuUGryPUp2DPOuTO3wmoPVfd9GYcY=
X-Gm-Gg: ASbGncs0yz01uuYvxlKgAVosxIWFC6hDCuV0/T1T3X6eW1S3FBj9F6r4YICye16pJA1
	k56Cz025t8TE/vKI0chxx1TMr4DYjCEwcDY2uhDhzY3+IbMsWYxO/ulwBe25bVks5qGw7BsHIOu
	PTP0I/GkXU3/NGmegzuc4DeTTzLy8gwxM=
X-Google-Smtp-Source: AGHT+IHF8CN0jfj+GXCiZoE7xk+e2Fh3DhTpwpePxWS22xkvk/Qiw/IKgR/mzb6CB6PGYDkEMZ0k6eBwFZPVdVVLDSc=
X-Received: by 2002:a17:907:9803:b0:ad2:541f:b663 with SMTP id
 a640c23a62f3a-ad536b7fb2cmr2201507066b.16.1747922077739; Thu, 22 May 2025
 06:54:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507164852.379200-1-luca.dimaio1@gmail.com>
 <20250507164852.379200-2-luca.dimaio1@gmail.com> <20250512163454.GG2701446@frogsfrogsfrogs>
In-Reply-To: <20250512163454.GG2701446@frogsfrogsfrogs>
From: Luca Di Maio <luca.dimaio1@gmail.com>
Date: Thu, 22 May 2025 15:54:21 +0200
X-Gm-Features: AX0GCFv2h1hpFrIRfZKyljP-2iBqLT4umZOBP5q8aem4rpjXIVwy7NkkvcMx7J0
Message-ID: <CANSUjYbSZDUZFtJ_6q4FxFScNkS3hVceRo5cQ8ozgpZOa6MnpQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/1] proto: add ability to populate a filesystem from a directory
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Darrick, thanks a lot for your review, will follow back shortly with
a new patch version.

I'm sorry for all the alignment/intendation problems, I'll try my best
to find them all and fix.

Thanks
L.

> > +     case PROTO_SRC_NONE:
> > +             fail(_("invalid or unreadable source path"), ENOENT);
>
> Where is PROTO_SRC_NONE set?

Being the value 0, it is the default value, if nothing is set
Shouldn't happen in the code flow (as we fail() if input is invalid)
but thought it would be fine to keep the case there.

L.
