Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E84D2E03F3
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 18:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758653821; cv=none; b=Yo+ETeUeis10JrFo6bdObYCkBUtoU7u/rOZ1FvJ5d+rAD1WFgMYiUBt3skijLSEQuSlHhmAGlnH2dHwHRcGvqGKYrMaQQaQ5diLx5kSM0gVDxB4vLOx5x7BH8UK5pvfOvF5i6MBphVX+59tS/2dFkV79En+BrcN1uExdffUYZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758653821; c=relaxed/simple;
	bh=uDFx+7Tt6m0KBD1tdrc8SFB3Uot3XLva9qb9ajxaWY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGlpRHHbJSM7wUdelYRMqm6BLJGUynwcIqZIuMvxVqJqI9ay7EHJ9a8gA6P0Ge3YHIQzlKqlaMPjHN5iudSpmEdbiPJ+ScERWZdPjIlje7Ii+ty1oDoJ0R13apswRRFYTfYQGuZLGIl8munpFyvZiKPsahISIube1OIsIqNOh9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qqdKydAn; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qqdKydAn"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4d16cd01907so22292261cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758653818; x=1759258618; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxNM9Mb37dbb/SiJhSt7Vl3jHZka75Af9EkUQVZtb5E=;
        b=qqdKydAnMRVCRWfWb7n1QWfudBaKit59wlqDyzIM3Tpp9Vvpk01hnlfS7Xp6ezGkx0
         Gw9iNwSR1cNxu/0KpJyR2wiWn6Pi4xY77FT+Qrx5QATIghAmuT5/scgsDqRQFprZzlTG
         jngePpRzTE8M5rK3mwYwrkLg8BhtnEHV7ozes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758653818; x=1759258618;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZxNM9Mb37dbb/SiJhSt7Vl3jHZka75Af9EkUQVZtb5E=;
        b=UoUJq+Jngncy3sM9DWHTxBPqnqGv14iHePgtxHSKvmGFJYRR/Aw9xWFkituPqYJrQj
         Rkbo90Tq+EeytLYCnvCYnIH6Hjo0iEib1BtAQdL5Tb8OrPOcyWAJkNDNxvWXK7ff4IYY
         Y/Jg5XPplaJZCfJ7BVNDg03IZmlOk9NV9mfNxwC26bFgtKbH1epoTcC20b/fzb8GDbBX
         HaHtp1BZNQSCGeD8gvteOs4aiHbCpE0AzcGhsic3u8eTU9f/34i0mNJDac/bWrU5WTVf
         F2C1pnGAdkfOg52R+XerrHvspcG5ZLZS4dowDpN16d+aj4aBYnBAGrvwwxHOqR8k06B9
         ic1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaJxMdXHd2WhwifrQc58Edh/ypiABzJAF01hNAobv5o/ritRV6TsPmgEgiyGv0cEqij9HcbeZsklM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM5jcrmj2iosUXhd41cnFaFeDtMXV+orH9mWhRohGUTIctHWRq
	lwdUJY+z1edplxK9xUruH3Kyb00KAZJmB3bNqsfqsSdBwU0SJiZ8K8ejXLOoQqpQaTWhTIaNyyN
	6vU3wSk8CzVpIYBZncXHJr6fhuFccUI1sPkYrYF17ng==
X-Gm-Gg: ASbGnct7JWrT/2Qfv5AccYd3h776hThehmhJNqtAXcrkrQJDViBIEg5r+1wfdBDjshi
	/KauD1FBzcQUnI4AnFNOyfw2ECv2EnNw+VDLn6whY5uE/DqbWpSVVXy8ZLVMkX+Wo14f5A1f9lb
	za5uzW7BtzLicT7dH4Y5saeZexElzJSTcD4t7p36Mxvsb5J46XA5F76bz8yM7JNhqHBjrf2c67h
	jIC83xW5+/5Gw98RFMbA539M111IZC/9LVWdDc=
X-Google-Smtp-Source: AGHT+IEUrKLzK566Rl7e78yFY4lfe2DvcLd+aWPgi3Hp92l/GkUmLofyjJvSU8SdP+RLcBfxgYPP7otw8OxaaoPIFgE=
X-Received: by 2002:a05:622a:1442:b0:4d3:55f7:ddcd with SMTP id
 d75a77b69052e-4d36fdef829mr46153821cf.59.1758653818451; Tue, 23 Sep 2025
 11:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150070.381990.9068347413538134501.stgit@frogsfrogsfrogs>
 <CAJfpegtW++UjUioZA3XqU3pXBs29ewoUOVys732jsusMo2GBDA@mail.gmail.com> <20250923145413.GH8117@frogsfrogsfrogs>
In-Reply-To: <20250923145413.GH8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 20:56:47 +0200
X-Gm-Features: AS18NWA3QczMUqhEwXlbmi3D0vK9ucUWZNSA6Kn3Mm_71aK-n6sNLwsJ3-6KZcg
Message-ID: <CAJfpegsytZbeQdO3aL+AScJa1Yr8b+_cWxZFqCuJBrV3yaoqNw@mail.gmail.com>
Subject: Re: [PATCH 2/8] fuse: flush pending fuse events before aborting the connection
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Sept 2025 at 16:54, Darrick J. Wong <djwong@kernel.org> wrote:

> I'm not sure what you're referring to by "special" -- are you asking
> about why I added the touch_softlockup_watchdog() call here but not in
> fuse_wait_aborted()?  I think it could use that treatment too, but once
> you abort all the pending requests they tend to go away very quickly.
> It might be the case that nobody's gotten a warning simply because the
> aborted requests all go away in under 30 seconds.

Maybe I'm not understanding how the softlockup detector works.  I
thought that it triggers if task is spinning in a tight loop.  That
precludes any timeouts, since that means that the task went to sleep.

So what's happening here?

Thanks,
Miklos
