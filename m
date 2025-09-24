Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE1B19066B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738014; cv=none; b=ZPuKjjXh001/CFxoioxVL4bm9xUMNsgpbjN6dZgmopLMkwyTzw0lNu+6fTepkBI1iPj0NNM8+7nlmKY44nSUDOe76g+I2sCQAKjaH/+8ABKIAanuuxlKGduwOqLH0EybA6Uhkt/XL0AYIqL91FNBqarvOWCeVznD2WkvHe2/O4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738014; c=relaxed/simple;
	bh=in4E9Zy7xpVBsAfOLZXbK6+byp20GDDNd5NfcfkBLaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prTr4nI2FBm9Pc6U64L3dw4DGSYmnt0x3S/1twyvMpmA4yDk9QtO+oH7hnLo67n1KyLE35cm+sd75IlwlL/b/J22E2/z6XV3hz00TbqH65ZtHXQDpXsfiV7W+4YjJkzGC+KC3uW3jX+uGLGjos2d1B+AYlW5DUqjTXdxKfwFQCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Zw2ZP6mR; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Zw2ZP6mR"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4d9bcc2368eso1319491cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 11:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758738011; x=1759342811; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lmTAftI+F8KaR7MC4oKydNJ8CmVuQGfS7o64XcGJhKU=;
        b=Zw2ZP6mRtyeiWNnn4dY66S9bOcA41HxPOzeT0b0CgbNxtltr3SJTpq/t+Iw5xn843p
         lXgSexqtGjbkpGQn+OS9Vm4yDaXQjbP/D9UkqcgprXiCen6a0CeGlEQi7AlkpWrbHsuW
         PvH1MoAUOUfT1yrfG2ja9WmbMfE/7Y7YALntk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758738011; x=1759342811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmTAftI+F8KaR7MC4oKydNJ8CmVuQGfS7o64XcGJhKU=;
        b=WCJuAgE/6Db44fNq2/IWIkD/CcH0gjfpS+hHJk2bOW/Cx5QyqRWVgWLwRGA/8IVJHw
         iuFYjpqSE2M2lWkCDWe4ErqbzqJrPjlVH0a5GMwcdAT7z2GQUyJ7MU9hqMNUlqfA0+yB
         cT3vuX9nLV80gPtDQBztUxhBG7rPmn6kFpy1aQExLFyenQBFrwSVBUwfrZxC/GhCaKbX
         m9aeUFn2qjkL+K93iU+ddA6z/Sy0H5xcGD5Vn5X2StSDAMYO26FIPYE69KJlvT4Gjnw1
         LGPCnQp/RJDSns81BgwofMdnfsdLpf6wY0n6RF6Y77BZhPQmoEKaHmRzC2lFAo2mfR9f
         YuuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkGorZ4LmVmAvxvyszdOzN7PURKCe+K3RkcM9zmOGGnfwIJ230FYaMnFzFo2Fm9huBpAnOoZyalUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOMZC/3lIF7E+E0MqyM4VFFLzycNiyBOc8e+f/ZML+onHOgkaK
	tl6WTH8ku4eL4P1uJkUcj3bMAt9GlLRAN3SpV+oBSI1TxgJyB0iqFy1uhO/vapuRpCYEAIQu5JZ
	Sj+ouVfv/7kotybmuF6//avaBOA1SP1Wai5F4lxmsqQ==
X-Gm-Gg: ASbGnctuIt7ge00akGhDPLZ8XIpXLuinpwL5NCjasgxVThvHlguKAZy9lLyVkvgVtvy
	7Cm6C04uWlJst9XA04e0aSNXvHOgzRATqZnXtswKmbS3aEoYLzJ5va3nyUlxovOndUvIIwLJ4jZ
	CITZxGe67Awo1k/+gVW01s4q+k4gZ38yY9c4vM1C9EYl7wqzP7SWK3P0feq1SRPJpe+wnz3hJ+y
	DsGh3BByU0Dlqc84MoLU7xDzeKIx0DhoI8IrH8=
X-Google-Smtp-Source: AGHT+IFCS3aRGOSPFq/ffzM3/aUmf9cNgMpAiKVROWLsGxrredHR+u7VOu4bDwcet3MUoIXA9txucy+lTipv1Ouq8dQ=
X-Received: by 2002:a05:622a:1910:b0:4b6:3457:89c7 with SMTP id
 d75a77b69052e-4da4c965644mr10314021cf.65.1758738011012; Wed, 24 Sep 2025
 11:20:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150070.381990.9068347413538134501.stgit@frogsfrogsfrogs>
 <CAJfpegtW++UjUioZA3XqU3pXBs29ewoUOVys732jsusMo2GBDA@mail.gmail.com>
 <20250923145413.GH8117@frogsfrogsfrogs> <CAJfpegsytZbeQdO3aL+AScJa1Yr8b+_cWxZFqCuJBrV3yaoqNw@mail.gmail.com>
 <20250923205936.GI1587915@frogsfrogsfrogs> <20250923223447.GJ1587915@frogsfrogsfrogs>
 <CAJfpegthiP32O=O5O8eAEjYbY2sAJ1SFA0nS8NGjM85YvWBNuA@mail.gmail.com> <20250924175056.GO8117@frogsfrogsfrogs>
In-Reply-To: <20250924175056.GO8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Sep 2025 20:19:59 +0200
X-Gm-Features: AS18NWA-kQ3V8sAm81Y8PKVDIY-0we2Ockkdd9JTU5D665LNDwEU9YZHQNvE_Ag
Message-ID: <CAJfpegsCBnwXY8BcnJkSj0oVjd-gHUAoJFssNjrd3RL_3Dr3Xw@mail.gmail.com>
Subject: Re: [PATCH 2/8] fuse: flush pending fuse events before aborting the connection
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 19:50, Darrick J. Wong <djwong@kernel.org> wrote:

> The wait_event_timeout() loop causes the process to schedule at least
> once per second, which avoids the "blocked for more than..." warning.
> Since the process actually does go to sleep, it's not necessary to touch
> the softlockup watchdog because we're not preventing another process
> from being scheduled on a CPU.

To be clear, this triggers because no RELEASE reply is received for
more than 20 seconds?  That sounds weird.  What is the server doing
all that time?

If a reply *is* received, then the task doing the umount should have
woken up (to check fc->num_waiting), which would have prevented the
hung task warning.

What am I missing?

Thanks,
Miklos
