Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5126379D2
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 00:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732582295; cv=none; b=qzSmPjggnTTnRxx9UVKH2lhXP+IRMktIPjk6dnkAes5+RTUJKMTsKnav4dPcwE1SNkN9SU6PLwxbGMU7QkQgn+mdxhT1DAfCf6wOrCTfZL+UTFjgjivd484keh//OcDcuHAnlVvFI2RHf8xbksdzzHeTBUKSQlUJkKu9ngMj4Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732582295; c=relaxed/simple;
	bh=/OQSXRLx7GQtNqvobkAl3y3kuyrJ8L0N5ubKivVpQ6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGjZ+E0Rtuno0blCeR460U03cOWmOcX3f2ZN8vV65U21ApXQrmdg5lPhuqYgA+xDuOWzXiNMxDIMZzencSg4+LXJrgH0SImpQozMWzNLcVtuPy7IHGyOXFI3tv6+T7qI2QX3YEn6RfHLgvzPrFYjG2sgVPFeCUCMkrBgMweMMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Eahlmu2g; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Eahlmu2g"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-724f383c5bfso2192221b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 16:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732582293; x=1733187093; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ux69X+49eIpiVnBg8k3UNWWpm1EHkYEBNcIyQUwAV4w=;
        b=Eahlmu2gtn/W1g0d8fWA045C43zX2g9Gx8Q3AD7FOoCC80PtJ6joSV5SnSEgxKvLZ6
         ikb6bEL8TmZ+quaQFLoVP85qDHHBaWlGwGMTPdgSAN+yN8bzgurlwXKvPwB3cJDJkg7a
         bk619E+HHOcfpFy8rtsAh6oVj+b1ifcjkb9OAlwfch4URXPAaiuBGfWYEqMRWa1i/L44
         kP0DxorwX1ceMneiyDw6jGEOxCt7W9WAQqAc0n04Z0s8Be1d/Ilh3p6FaejBq0jpyNSh
         a2vgsuZa+jhNdCyb0JXxUslFXzmmgQP7ddGV2L35HjFhdPqm7oZZQv8F8QsLwP5eu98v
         p+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732582293; x=1733187093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ux69X+49eIpiVnBg8k3UNWWpm1EHkYEBNcIyQUwAV4w=;
        b=vJ4zKkgSTx6uiY6JtqKRw1KvHS6m0YhubdCq/6Qg+YFF0d0m2MyljuuxONZwetVDsT
         PvO9+HxWUJOJKBsscqqAKrtV7zTtwAw1GqlrR/s04Blx6SQZoJEGKnVnPlWBpgyoFFV1
         2l99HuVXn43A/UO/KFmjWGFqGZRmOGo+kltdhv1my2uIJxvxj5HpVLzK/H15c/nK1vLT
         6LxpemGAL7jkPHfPxCza+gfyOtWhzdUolbikRahipfo0KGWlHDqd9V3XIF1ziPTkfVLS
         3Kbz+/HtkuQ+j5E1TzosZq5lTazbpZuqeuAMu7Jjy8JqBkFlgEstZqjS0iCwFAajH1mJ
         X31g==
X-Forwarded-Encrypted: i=1; AJvYcCXUU9+sLwgM+8Qpqwaue+dZcgauKKfYSAFJooiS7ejc171dKW//XzEkwec5lMnh0SdUN8cPHHFgEvs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz23266+fikKDCSCWAvcEXekyBDXa8XaIaLIjiDUN2UkDDYcuhj
	hCfByR+CcshKH0MfHvGbanhf8CiFZcdzk6nWQlMf+tjpgf1x4XpEvZvGbU1Q8ps=
X-Gm-Gg: ASbGncurK9kNLUbOq+hKbSj/mfeevLfstiNc9uqEdRJt2If8lZKFa69zeoVQhA1LW1D
	YVpks+Iha+EUZ5OL0bpMu7HlHuTvYNSqsSbSlhVLxzBiJljGiSdsSp1U/3/msivvbk96Wt18Axj
	3/kEkPNzGaVxcy1xiVfa1Xkyc+WqEoXC0XxM/lVUk3hRpPs07/4G1V+Q9ZZShFTOucTzmcEq/d1
	35QB5YB/OdUUuabrn7utNfiNg0mqPvVmqMFiCZ0AVfqWrUlNFTbYfccSktfrovB8mncAQRvoquH
	XssWAGqkX7TjiaIdjWJnAzN1hg==
X-Google-Smtp-Source: AGHT+IH2nmNjHpizxTjMNZv5LfLtuqpHTB+V4VE1ngUInkz6TiVhPxUSlkR6a23BR+zT8t0GYrd2zg==
X-Received: by 2002:a05:6a00:4294:b0:724:e5ab:eda8 with SMTP id d2e1a72fcca58-724e5abf682mr17348842b3a.1.1732582293485;
        Mon, 25 Nov 2024 16:51:33 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de477e65sm7082459b3a.53.2024.11.25.16.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 16:51:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tFjnd-0000000368t-1RBT;
	Tue, 26 Nov 2024 11:51:29 +1100
Date: Tue, 26 Nov 2024 11:51:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com,
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
Message-ID: <Z0UbkWlaEuH9_bXd@dread.disaster.area>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area>
 <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area>
 <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
 <ZzFmOzld1P9ReIiA@dread.disaster.area>
 <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>
 <Zz5ogh1-52n35lZk@dread.disaster.area>
 <CANubcdX2q+HqZTw8v1Eqi560X841fzOFX=BzgVdEi=KwP7eijw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdX2q+HqZTw8v1Eqi560X841fzOFX=BzgVdEi=KwP7eijw@mail.gmail.com>

On Thu, Nov 21, 2024 at 03:17:04PM +0800, Stephen Zhang wrote:
> Dave Chinner <david@fromorbit.com> 于2024年11月21日周四 06:53写道：
> >
> > On Sun, Nov 17, 2024 at 09:34:53AM +0800, Stephen Zhang wrote:
> > > Dave Chinner <david@fromorbit.com> 于2024年11月11日周一 10:04写道：
> > > >
> > > > On Fri, Nov 08, 2024 at 09:34:17AM +0800, Stephen Zhang wrote:
> > > > > Dave Chinner <david@fromorbit.com> 于2024年11月4日周一 20:15写道：
> > > > > > On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> > > > > > > Dave Chinner <david@fromorbit.com> 于2024年11月4日周一 11:32写道：
> > > > > > > > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> > > Hi, I have tested the inode32 mount option. To my suprise, the inode32
> > > or the metadata preferred structure (will be referred to as inode32 for the
> > > rest reply) doesn't implement the desired behavior as the AF rule[1] does:
> > >         Lower AFs/AGs will do anything they can for allocation before going
> > > to HIGHER/RESERVED AFs/AGS. [1]
> >
> > This isn't important or relevant to the experiment I asked you to
> > perform and report the results of.
> >
> > I asked you to observe and report the filesystem fill pattern in
> > your environment when metadata preferred AGs are enabled. It isn't
> > important whether inode32 exactly solves your problem, what I want
> > to know is whether the underlying mechanism has sufficient control
> > to provide a general solution that is always enabled.
> >
> > This is foundational engineering process: check your hypothesis work
> > as you expect before building more stuff on top of them. i.e.
> > perform experiments to confirm your ideas will work before doing
> > anything else.
> >
> > If you answer a request for an experiment to be run with "theory
> > tells me it won't work" then you haven't understood why you were
> > asked to run an experiment in the first place.
> >
> 
> If I understand your reply correctly, then maybe my expression is the

You didn't understand my reply correctly.

I asked you to stop repeating the same explanation of your algorithm
in response to every question I asked you.

I asked you to stop trying to explain why something you just
learnt about from a subject matter expert wouldn't fix your problem.

I asked you to perform an experiment to confirm behaviour was as
expected under your problematic workload.

Your reply:

> problem. What I replied before is:
> 1. I have tested the inode32 option with the metadata preferred AGs
> enabled(Yeah, I do check if the AG is set with
> XFS_AGSTATE_PREFERS_METADATA). And with the alternating-
> punching pattern, I observed that the preferred AG will still get fragmented
> quickly, but the AF will not.
> (That's what I meant in the first sentence of my previous reply...)

is simply restating what you said in the previous email that I
explicitly told you didn't answer the question I was asking you.

Please listen to what I'm asking you to do. You don't need to
explain anything to me, I just want you to run an experiment and
report the results.

This isn't a hard thing to do: the inode32 filesystem should fill to
roughly 50% before it really starts to spill to the lower AGs.
Record and paste the 'xfs_spaceman -c "freesp -a X"' histograms for
each AG when the filesystem is a little over half full.

That's it. I don't need you to explain anything to me, I simply want
to know if the inode32 allocation policy does, in fact, work the way
it is expected to under your problematic workload.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
