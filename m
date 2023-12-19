Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C461CA84
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeYng2iO"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-593f182f263so72218eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702993863; x=1703598663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6arLep1APiJEoSu0zFL7YdaeucTxHeWPiPa/RnoqO7o=;
        b=NeYng2iOFAeH7rCH4sTZEItkc7nBcds7x3n4ed9ycruyvFz1RzCDBDO1w6yitgfNzn
         FapYp3YY/+tFf1Zgb8/mvyIdyWI4F3odSYfnieSNsXweNMzcwRCA2mUB5djXsH0RLUaL
         u5JMUIov7WQskUrde/FHAiFaogPZPglI1Db1yagFDUZ/q9adSAl7rZo94BpK4e60tBi2
         pEHsAm/9ZLhd0bMqKbPpcG4WD/lWZ4ogOFETD7uPnajdhUkvTORDBz6zOh8k0729jQss
         aMEXLNtZSO0Bi4vOfwixXy9m5HFLaU0nGXOHTVMAbqEI+5OQ7g/7Q5lfL/2NW3/ljt+r
         +MrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702993863; x=1703598663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6arLep1APiJEoSu0zFL7YdaeucTxHeWPiPa/RnoqO7o=;
        b=ugZKORXUCPre4td07awoRTV2WyvY9VonTjVNcxGH155gnkC0Ijawx/aLBnNhTTo7r0
         Qx8t//XmLSWKv0c+Zy3dPnj78VRqoF1xRC5ExxC64uh/f3SpWpqSbWwrUWgPTPB68HD/
         xEFGquSxsvbODNVIumzCBpy42v6g1QTxO7yK30gjTBEnQayZH+FrIuhHLnz1wTV/pwzm
         KepHgPu0B+0Fff5GZbdZTNhv2hZbz53dmdfaTuCADLmDN5hsnX26wPw87wwTCEmNxzJ/
         aeVKmXGuaAus5oQYQ1C+RkqJHIxVLP17YpVN4e9oHPL0ONJfyGLcX/Uel69+BnbFQtQ1
         tOjQ==
X-Gm-Message-State: AOJu0YzCJHV3sSP3e9CkLwz0Q9/a0mj1MkMd60Q1hFJ+2OErXvvxApf8
	1nVcKz8y/IF3x5wizieMkLKQR4Tf9NnDUd1Ee9S/iSnb7jo=
X-Google-Smtp-Source: AGHT+IEAFBOggwd91Y8g1IdA1wq84/lK8khXxa7f7Nli0Hzdkxai7RnR9LfSR9bw2O8/GFWXaDjPvVI7Ls+/PNij0N8=
X-Received: by 2002:a05:6820:2a18:b0:590:9027:7ab0 with SMTP id
 dr24-20020a0568202a1800b0059090277ab0mr26453716oob.0.1702993863226; Tue, 19
 Dec 2023 05:51:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214150708.77586-1-wenjianhn@gmail.com> <20231216153522.52767-1-wenjianhn@gmail.com>
 <ZYDBBmZWabnbd3zq@dread.disaster.area>
In-Reply-To: <ZYDBBmZWabnbd3zq@dread.disaster.area>
From: Jian Wen <wenjianhn@gmail.com>
Date: Tue, 19 Dec 2023 21:50:27 +0800
Message-ID: <CAMXzGWKYB18dbw+wWUJaDzD0Cm233WnAwjEk=d7LbErj0_S44Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: improve handling of prjquot ENOSPC
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de, 
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 6:00=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
>
> This will then give us consistent project quota only flushing on
> project quota failure, as well as consistent full filesystem ENOSPC
> flushing behaviour across all types of inode operations.

Thanks for the detailed explanation. I will try to make it consistent this =
week.
