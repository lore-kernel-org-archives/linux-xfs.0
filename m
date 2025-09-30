Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D2A221F0A
	for <linux-xfs@vger.kernel.org>; Tue, 30 Sep 2025 10:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228185; cv=none; b=HbTZa/ZVYyRicdKlMWtZFZlT63vNt8jlKrOV9StkVCzDZxcyf4S3MALTYwbZjU1+toqayY8iFKsbF1dYKYVDZ6xtngOWh/R+3ZDBuvkZlF78eyCtrb+hWAR+VjD3xO/n6LhjVW2CqyNqX1+TOjz4vLwUiEKhxHXN3jsEws3PTIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228185; c=relaxed/simple;
	bh=kEkp6++hhMsukQ7Co43d2hva1/jaPJAiRZVOch3dZnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y75jaksfEnfCUOXYWf5/M9gaIph6QXKb0WrpAEhUHAeavi7oMb2l5jtyUcCn2lehH4gvylEBAmeM1Fvz7Q7lz6eDV7OPbM7Jv+LD5hpRFVBeFZSoIEG4hfgTzcKCRq6p6t9gnJeszIAwBIvBC34ODpk9HB3PxO39kLK5YIj078E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lxGFj5wu; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lxGFj5wu"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4df81016e59so29508491cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Sep 2025 03:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1759228182; x=1759832982; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bTfqprXJfvkg3sEJpNRj208d4FU4g7NixV9zMkm9LDg=;
        b=lxGFj5wu3IQ/hPnFhdpXXG9HvZxnGvWsumzK5UmyynlX1WDm/TvPvTH0cnU3QyVeGg
         QLeTMirmeAubbo87yOZWUmqXB2QGScFV311GNTpsdwI0ZtXL/mqp1WkG+HZmfsN3Gd8k
         vB47OXr327zFuR7kVp8MLeBoErMK6htBHPikw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759228182; x=1759832982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTfqprXJfvkg3sEJpNRj208d4FU4g7NixV9zMkm9LDg=;
        b=Z2PYI8xlnzg+On4aHebjeu7W7wUISIonGYjrI5kk19eLtVIODqhOas0BHHwJ+Q1UaL
         VZgqctoJnP3XnYIOgP+cm+irLmGuGjeOPJDpl0BOvboc6UCYPTq3qZacNuWvp9HxUMH3
         +wAM8WgRRSrgSQr4OUaLNC0p79OAPFaOT3xbsI/JdHbIqWbb1xbuTT+XZEgXoDXqroII
         1wII2lNMwKwSdVxaOqgwVhoSdAJdAKhVE6Y/1wUM84hvTQ9TMlvmjuJKcl2dsyl3kO+4
         Mt/FwyywWPEQ3BwZUUQjFS+jM+jI6QnxMk931+yT8u/Xam9KgF7uS4jm/l0UMObrq5Gt
         ZpvA==
X-Forwarded-Encrypted: i=1; AJvYcCU+0DYFnSIHbKUBH0IP4U/42nW6DVz9X1Py0HYjjOnm/8hcSlSKPXB78/7GEPLiRC3RbE7qSvgNVnM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0+vC6Dfbc+YDaUgXzgbCFCOGzIpjfpLokZ2T7CDn8ywBW0XZw
	8jSLOenEsl2540kx23OHdZOFDdiJOEzHH1oKF+HuRBdPloG3l5u1aSbyqa7FgE04E02Q36MVy7T
	w0KjFGhp7yecq02Lm5hiAhp4gK/Alsx9lapgMGKthsA==
X-Gm-Gg: ASbGncu/cgVQnMW/513POTLhpyjXvfNVPEc+unVykNf8kgPLaQNaxUNB1Z0bRtCcAak
	AlxgVGUZHWiRfNLw319e2NvRbujP+ah0bwvEcTe/0GXt9jdrYjaGEe4QzeRI17vbhuo6u/+gCbm
	nTfeD94hxkojcytlq3gTbYdnl0mDeX88waXuhbZvwGl06BKoVMAouwA/QqDKK9+CtbXzxp0kPUa
	9zqEwJBdVJpdaWvddlZlStkMj04eRchWN5QiTmsY09x+unGqN3YZR+zDUgBrn5KEzText8TQA==
X-Google-Smtp-Source: AGHT+IGzuMgWcMC8J1gmVuG1jhDodNPDypimmkHMqGMXQSg4mN5gSWlDIvVy/uGasgivb6Qzz8zJvmXNNDc31Qw/A2U=
X-Received: by 2002:ac8:5fd3:0:b0:4b3:4d98:cb39 with SMTP id
 d75a77b69052e-4da481d9806mr253690471cf.9.1759228182235; Tue, 30 Sep 2025
 03:29:42 -0700 (PDT)
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
 <CAJfpegthiP32O=O5O8eAEjYbY2sAJ1SFA0nS8NGjM85YvWBNuA@mail.gmail.com>
 <20250924175056.GO8117@frogsfrogsfrogs> <CAJfpegsCBnwXY8BcnJkSj0oVjd-gHUAoJFssNjrd3RL_3Dr3Xw@mail.gmail.com>
 <20250924205426.GO1587915@frogsfrogsfrogs>
In-Reply-To: <20250924205426.GO1587915@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 30 Sep 2025 12:29:30 +0200
X-Gm-Features: AS18NWD7FH2ECHsqy--ansfHcFvhFuJl9zxXuoH-_wb_I9ayFnO6DQxvIV2et2o
Message-ID: <CAJfpegshs37-R9HZEba=sPi=YT2bph4WxMDZB3gd9P8sUpTq0w@mail.gmail.com>
Subject: Re: [PATCH 2/8] fuse: flush pending fuse events before aborting the connection
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 22:54, Darrick J. Wong <djwong@kernel.org> wrote:

> I think we don't want stuck task warnings because the "stuck" task
> (umount) is not the task that is actually doing the work.

Agreed.

I do wonder why this isn't happening during normal operation.  There
could be multiple explanations:

 - release is async, so this particular case would not trigger the hang warning

 - some other op could be taking a long time to complete (fsync?), but
request_wait_answer() starts with interruptible sleep and falls back
to uninterruptible sleep after a signal is received.  So unless
there's a signal, even a very slow request would fail to trigger the
hang warning.

A more generic solution would be to introduce a mechanism that would
tell the kernel that while the request is taking long, it's not
stalled (e.g. periodic progress reports).

But I also get the feeling that this is not very urgent and possibly
more of a test checkbox than a real life issue.

Thanks,
Miklos
