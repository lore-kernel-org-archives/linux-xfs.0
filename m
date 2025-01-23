Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEB71ADC90
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 21:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737666598; cv=none; b=lF2yRepKVmHX1wi2Qj0TmdzDC/tS2PqGBLStPxwXjQhTmt3AKdIbi17ZvWMA2skKrEkYuC2ElOixMR1z0tU4erNMNHoualHw4NSo7BYukzmAlgvjA+Dd/OU40ULjqWY1DAa6vvOZeHb7RVzew5RUUT6FwjvdTiD0tMW85GcIKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737666598; c=relaxed/simple;
	bh=vhTVOy/w/s9qOhikax5fld6x10F5t9GWo26bab2fhkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PIXbcx+EE9+PYSPTRen47uq0hg7MkjPptd2E9qT+C9Iz2bXenPl3L+izREYkVG1tIaNoLlnOfO9G5xEEJ6ff+RLbr6ETrfX1HWxFBdMerDtuc7u/DhEwoSHIBwcEBNuJeNJab9fj52IGqVjWzHp2NKgV/S9meIZMBR4E6HSuGKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b93QnSZ2; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b93QnSZ2"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa6a92f863cso287413266b.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 13:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737666594; x=1738271394; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vxCDyYLjOKBSu/9mlmuGFCp5IbSC8Ommc6IvIiMUgEY=;
        b=b93QnSZ2mQtzDmNdHVmLeTGNC1CNILYMYAFZlmw5m31S0PJ1RZs3/IzMaxxLu6rzFo
         LR6xzT9hp2wsL0qikpWZg6UMgRxOvu3mr/qO4uIio8GPpVUkESQrw37rxhvhYSmaWpVo
         deus3SsfdcrLXbRsiCZXbJ+ZMjyer/Faccg2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737666594; x=1738271394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vxCDyYLjOKBSu/9mlmuGFCp5IbSC8Ommc6IvIiMUgEY=;
        b=bmINKxnT4CIjqsLVonrVrUYedhAd2IboT1IPKroKHMKoaECD6jD4zvrSaNQGXAVeoA
         CQW1MKC1sJ5sXTSD+jdAQnr0A8JUS4POThg8rVlMUpkabhnzQN3rFFe1RRS9biuKMpoC
         Wqpc95m0Fm1vAuBHf22dN8BZZg/bDJhK6OkFZQb4FaWlMZ+SUVkndB0P87gEcOMZsUFw
         oOWdt9ZHhPtB9h1Ns8uo/g/qkqbMCKz6DQlmbr7gHmM0wEFUeh1oSZHwG8TOqLO5DeOV
         DIcKBRcmZMixNyJK7Wj80PdmZXafNx5reQTjJsBWQEBJ+oFAS1ggjBXwHFMwtlE3TKB7
         O77w==
X-Forwarded-Encrypted: i=1; AJvYcCUfeyRzKd81+Dvtev5oZVyzgu1Sxu5rcmYJSc+6yfc0q1U4vMc//pEVJQYNBCFGDf/Dn9U505LVLoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvGIzGPCaenSA1/B5VwAa9/hzJESCf4vVye2YW2MrB6sAYtoEf
	jB6qWXPUgeWK/snLfMjFprh6Z0NHZEtGznKf6ZOprVGJUZyjBKa8MAOpJwrEzkDWquRG+l4JrPz
	B1PlIAQ==
X-Gm-Gg: ASbGncvSPivEj4Tx2D2kVDW1JgBo6BUshZmvF9W0ert8SWbNoBLNiqVeXFHVLY4Ztgm
	DZHBNAbNX4C3StJouaFEFU2XMZXShR/ec6PlbkRHN+l8kz5KjSbvu+7wr524n9qpyZ2qstY4k+z
	XRzPmAK/gEjOA9thyuRfdJLzGJ9UVttZjFH/bL0aOzGRHWbsvAL+5Jalx2dyAUAA87rdru+v51+
	cqVDrY84//Xqk3DCQfSJxTXt4bz0fN3NYqaVwWSt52reqmlK5d3VfTCbiSJBLOdVwsloCblMSAd
	XjRNXX4XwEjehGSFqgCBJCxFY4hJLf6vop4Jc5BYy7ZrjiJy9zhx3Ys=
X-Google-Smtp-Source: AGHT+IFuhuvCnne9sQzwmvFVyIcegGdKNsqb7766koDdHjzADDIlDr0wXw+TufGNgnp3XBexMuUmVw==
X-Received: by 2002:a17:907:7f0b:b0:ab2:b77e:f421 with SMTP id a640c23a62f3a-ab38b25e296mr2266799766b.23.1737666594279;
        Thu, 23 Jan 2025 13:09:54 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18628a7bsm172567a12.29.2025.01.23.13.09.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 13:09:53 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so2413706a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 13:09:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWzFTgsa2Sa2axK1shVjRMzOYaicLgMyUPzG+aJHepN8L9j3DVGs+o9ZnRWxuvQVi7kSEibB8wbpgI=@vger.kernel.org
X-Received: by 2002:a17:907:9408:b0:aa6:a87e:f2e1 with SMTP id
 a640c23a62f3a-ab38b4b96d0mr2487031166b.56.1737666592031; Thu, 23 Jan 2025
 13:09:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <i6yf5ledzs4qdt5zhrpg7nz5neyygktthupap6uulpuojcx7un@phdanup4alqb>
 <20250123183848.GF1611770@frogsfrogsfrogs> <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>
In-Reply-To: <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jan 2025 13:09:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3t1jU=FKgCg_6bKe-JB9GD5PobkdHN1p0bv0Btfsg-Q@mail.gmail.com>
X-Gm-Features: AWEUYZmaxb1XRlJL2xi8oDrvjI0Di3h0amOtEaxEV2ADdSTf3PC-w66vXpRq6AE
Message-ID: <CAHk-=wh3t1jU=FKgCg_6bKe-JB9GD5PobkdHN1p0bv0Btfsg-Q@mail.gmail.com>
Subject: Re: xfs: new code for 6.14 (needs [GIT PULL]?)
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 12:46, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm getting back to filesystems today, but since I have great
> time-planning abilities (not!) I also am on the road today at an
> Intel/AMD architecture meeting, so my pulls today are going to be a
> bit sporadic.

.. in fact, the xfs pull turned out to be the next in my queue, so
it's in my tree now.

               Linus
