Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5342192E5
	for <linux-xfs@vger.kernel.org>; Tue,  5 Aug 2025 04:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754369422; cv=none; b=ANpYHC+yB57WNnA6lym1+ACDpgHKz2K9+UX1vWiiHXjMeBGyObNL/1bR6xdIgLzXtZvWftTfJkNUnjVwQ1ucvN4kuMOWP9jJTPTPWXpsAvkuWgMTV3pHEl1tqkqN4PRxp5bX26DBtER1WMA2Yj+tS7IBZw5+ZfGjux4MMe/GjBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754369422; c=relaxed/simple;
	bh=rbLiQOufiJaHIio8u9t9ktEh8unj3ho1YWq1RYHrny0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=OvuhuUZ7Sv6jVvWOF1Cq4A9VKGhJA8VD2svXroC2pVwE0JFD3rWdJxuXHlSIIm0/RFKeK3avSbWHh7D2XFY6cdfxYYWHs7hVV63p9jm8fUONP6mxg0FLhs8ptcVVelMx3K2k/CzgUVRLGA0ldaCes21d9UMdtCkSF9DjWfHZA+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aR6Y90Tj; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aR6Y90Tj"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso3996827a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 21:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754369420; x=1754974220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oZz2Ou8wZUIItrqA5BpcmIfhKphsw8UsqRsbuLimLZo=;
        b=aR6Y90TjL5UoX4oNUap7Lsls8R1kND1j+MqmS+QrAXbLjVj1DdxDyat2sjqC33m2kw
         SSRep/QJnlq50Umd9Q/vxhyks9X2w7PN8H/7vB9pWIsiXLYfUZ37TccIE5SsSSOa/N4h
         SZDYoMQqpglEi94tE5gTOrt/Qdc7eN9Bd3JBldU0ocr/qabgIIjMpFnCSOKA0hyvx9N9
         OASmDLGwxcr0NsDpkffvRCn7VpJi6iTjzYdMdOAmwFAIAwOeYnv5zLxDsOZT0JPD0+nw
         tQSpDBTe/EZrnct5hzAM5UYF/N6euCfb6CrjzRSL0QsGvENGsne+861xM76OPpCo72FH
         eEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754369420; x=1754974220;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oZz2Ou8wZUIItrqA5BpcmIfhKphsw8UsqRsbuLimLZo=;
        b=ulBo3szKIBh0GespTs8wvRUEwvhcIXrMTY6jHUAT5fTP47utCbJhNmYqjDLmmolUrJ
         WJD5UTapnDzo+HxusKP09CMVD1HuSasxRuGVMlrLV8wmuIkTsK1dIXfbH1Z0tCBsWD6y
         npU9icReNt1kHNkOqShFcnlE9InNCnSYbF5bGIDoIdLlNG2TPMZzcBB/bTy5xO3+G/+J
         gNS9jPr5jyRRinCsJyadHqBDdohEw6hK5ZghdYIMXpo8xUo3QdbrCi8oXy7YRNboTzmW
         OmLD+ZATn5sm7RO3YccKDti4akrQbUrEj2eyC482rbypjaGMEuY3q6deTBj3+LdQsdkY
         ooCw==
X-Forwarded-Encrypted: i=1; AJvYcCWoiK3kjiv5H8De9fmfXKlhnwqEZm3q+ZtQ7MvLTo812T9FOzB0fnUOvdxT2LPor5wTiFLWg188WkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBfBZNRLDPQM6h0DZXm+RJ0h5SBIdS8UuZ+6Ym2lD9XRGbFc67
	Fo6fnfEraBlaGn5nfQgZ/ZaggcjsmDZw88nakYZcpiKnsnBcZrzVBbQq7xS8gA==
X-Gm-Gg: ASbGnct6Ur8/95KbO+5IJy1aB9gyDtj6Hs09JOkEf92zTGm8aPN1xha1M7kInzvbo5p
	r0S1sau1xBjB+pmToJbEUCvCf7zA10YDC/o2uFh56HL8lH1DRbIY9lfrYRAS4BRyETPaoWytIM2
	Cz4P7wYXyeTN+AVwFsyW90lHurVab/eJ5vpDKl6IVwWe65wRLsvbzmq3WIj0sJecoEinRRrlVjC
	7cGfn0p1PWCOiWeLqyxufn6Fa/HRgDQfsrWDcqMK3PNxM+RUqqVHQMkgylTbKmjcJGRqSiYKlac
	dOTEUoJG/iLNp17C5N8MG28fvxaV9k+VmwBMa/rXrVnU+fcXvCybPYbssabfcxvVzBUFEuY0uy0
	sOh+4S27lHAuRW0trxOcYXn+AIxTIgL6Aj7Udil60aSq/MhajlGQWbHG8FzsWvQsLte0Fkf8bb+
	c=
X-Google-Smtp-Source: AGHT+IFDv8riI0KkOmm3u9ZZI550JBl7ZGzCoKIoVQCrk0IOhdvALGrOXWo7h3HEq4XdaFRc0hsTiA==
X-Received: by 2002:a17:902:e84f:b0:240:5c38:7555 with SMTP id d9443c01a7336-24246f2cd33mr168276095ad.5.1754369419794;
        Mon, 04 Aug 2025 21:50:19 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.198.59])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aa9257sm123491995ad.153.2025.08.04.21.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 21:50:19 -0700 (PDT)
Message-ID: <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
Subject: Re: Shrinking XFS - is that happening?
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
Date: Tue, 05 Aug 2025 10:20:15 +0530
In-Reply-To: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
> Hi all!
> 
> I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
> 
> roy
I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
given by Dave Chinner.

[1] https://lore.kernel.org/all/cover.1752746805.git.nirjhar.roy.lists@gmail.com/
[2] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
--NR

> 
> --
> Roy Sigurd Karlsbakk
> roy@karlsbakk.net
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det er et elementært imperativ for alle pedagoger å unngå eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate og relevante synonymer på norsk.
> 

