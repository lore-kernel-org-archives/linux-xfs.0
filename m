Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DB34D9F2
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707774395; cv=none; b=NkRUuwtslZDIo+UrJPxJ0H62D9qTBKWjUhCl5/lRf7bELP+Gs15WucVYgNZl3sTR2TTlqrwyDKdoYoQZVYzf6rfGIWbu97orGXHOji9VdYX8jQHhaLHq0m8WpzzmT0DV8+Z5ZhhoivETKEjOfeixKb/YPys/zQbEu/yogHJ2flU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707774395; c=relaxed/simple;
	bh=b6q6rxBxy/pfV15UR8BuGJKyk4adJP1LkSILnVt2Tbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kIXdygJP+imUsJzyqv7RWT//F5Ja2sfYp19un9dkCRmvytmD5G5lEX8CBPxzrdIddaejQV2ILz1GWnOwxPWotrAaUF5UGtnRMhNzZdMXnKGsf3YeP8I7N02/3Zaud5Ozjt2b9RNyCvy12lm5SAo5C89wFb2WSqHNOd7iePFQe14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu; spf=pass smtp.mailfrom=soe.ucsc.edu; dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b=HZhlEv9G; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b="HZhlEv9G"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7d2e1832d4dso1373776241.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 13:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soe.ucsc.edu; s=soe-google-2018; t=1707774392; x=1708379192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6q6rxBxy/pfV15UR8BuGJKyk4adJP1LkSILnVt2Tbo=;
        b=HZhlEv9GSEjt3AntwZZXscN1CXjHc/T/qUlEgCKSPC1N6gsWduxV0SVrre2xJBxd4b
         BCUgekJLfLliK1YGinBvs3DQQLED4odt88Ij9ZZHmswtOwF4wbWHtaWYwubtk59iAp94
         PfSvRDNL6AGs2qio3hcvmZRYbXbKvky9Z77xs5R9hzmOQr/P6aRGq0JOLFZaj6xYYO4Z
         1GW/WyiCgQk+ojPTKzRECW0rZt6qayPwQAKLOlzVvXkeuCVqx1L3CghgHXX4ufQNwI2C
         TAwdqZtjTz+29Zf3pVcOkp/hO4ZaoK9FT6ZLBmkAhWRmfGoygqrJYXvGyzJbbmbc1Idw
         YL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707774392; x=1708379192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6q6rxBxy/pfV15UR8BuGJKyk4adJP1LkSILnVt2Tbo=;
        b=TQ2I25FXDjzp+QWhn3LzQqL8109XSTh78tEGXaZOtnDyrmdrJtiPmdKheg2Cq2bSjG
         zjd67ePNcY3YfgICs3MnKKb1qILDhQB+nbBvEFOF7EApY549AySs5jIqXNRW+qgau9jN
         HEVuuE+DQ6ayMPAKPgmOV/xQTzqPxLKscFkPxtAvEuEjlhmB2ymGhwkBmcKjjO4Uh0iv
         ppAtrxkBSmlIQkmz2Koue0cvFp1wfjVCpkcrDYkSnLKLcRABSbumc8RjakfAUQnclfcY
         +3fYpwnJ70k7X9jdwRbHQlIZpxqCCuTmAqnqjq1wFqbyE/vXCgiXAleRcJzSrNI2Tkhv
         C8sg==
X-Forwarded-Encrypted: i=1; AJvYcCW19WNvyEdZ6GkbTxnPJzhxpfXkU92rgmBINkIEPsX05r78NgkryqOHpLJ2AEURdTGByPMF7X2WvaNPjE6tMQwyh8VrMHCUQ+hw
X-Gm-Message-State: AOJu0Yy8vtY3oSBV3zkMMIhCCLNrhzpHP2PoeP1ydfLs5/REAlxUAkEC
	JyTfdZvIYpZBxkEMwqDUS9231ANNYNYgy8Xy64LSH19ZcdRUua3MVJjzgPwsfbAFR8A23eYpDV/
	eKD/+eMdscAvCkx1+lMWu0lPB+Ke0WBI/dVL8GDhis9XPJ5gg
X-Google-Smtp-Source: AGHT+IFQbY5+30ui3XMzuLCbg1SG3TDmYRa9SB/Bb+PsGKpwNSEoPPkStgRmw+OzW4Joy7c14hA/ZkuUGsuPRnzf+jY=
X-Received: by 2002:a05:6102:4406:b0:46e:b801:ded6 with SMTP id
 df6-20020a056102440600b0046eb801ded6mr2423940vsb.2.1707774391991; Mon, 12 Feb
 2024 13:46:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
 <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net> <CAMz=2ccSrb9bG3ahRJTpwu2_8-mQDtwRz-YmKjkH+4qoGoURxQ@mail.gmail.com>
 <ZcqITqNBz6pmgiHJ@dread.disaster.area>
In-Reply-To: <ZcqITqNBz6pmgiHJ@dread.disaster.area>
From: Jorge Garcia <jgarcia@soe.ucsc.edu>
Date: Mon, 12 Feb 2024 13:46:20 -0800
Message-ID: <CAMz=2ceGo3UL-mKmuqXhmfQmhUg0+H=-4f4W7_FvcA2MJh3Zww@mail.gmail.com>
Subject: Re: XFS corruption after power surge/outage
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2024 at 1:06=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:

> Ok, so they don't actually have a BBU on board - it's an option to
> add via a module, but the basic RAID controller doesn't have any
> power failure protection. These cards are also pretty old tech now -
> how old is this card, and when was the last time the cache
> protection module was tested?

The card claims Mfg. Date or 01/26/20, which is not too old. The last
time the cache protection was tested? No idea.
The BBU status for the card reports battery state optimal.

> Indeed, how long was the power out for?

I'm not exactly sure how long power was out for, but probably less
than an hour. The data center is supposed to have UPS power and
generator power, but a breaker tripped, and we lost power. My guess is
that power was out for less than an hour, and probably more like a few
minutes.

>
> The BBU on most RAID controllers is only guaranteed to hold the
> state for 72 hours (when new) and I've personally seen them last for
> only a few minutes before dying when the RAID controller had been in
> continuous service for ~5 years. So the duration of the power
> failure may be important here.
>
> Also, how are the back end disks configured? Do they have their
> volatile write caches turned off? What cache mode was the RAID
> controller operating in - write-back or write-through?
>
> What's the rest of your storage stack? Do you have MD, LVM, etc
> between the storage hardware and the filesystem?

You may be asking questions I'm not sure how to answer. Most of the
settings are default settings. RAID controller was operating in WB
mode. No MD or LVM, just 24 disks in MegaRAID RAID-6 configuration,
then seen by the OS as one device, which was formatted as XFS.

> > Somewhere on one of the discussion threads I saw somebody mention
> > ufsexplorer, and when I downloaded the trial version, it seemed to see
> > most of the files on the device. I guess if I can't find a way to
> > recover the current filesystem, I will try to use that to recover the
> > data.
>
> Well, that's a last resort. But if your raid controller is unhealthy
> or the volume has been corrupted by the raid controller the
> ufsexplorer won't help you get your data back, either....

The controller is reporting everything as working, all disks are
Online and Spun Up, and no errors reported as far as I can tell. I did
get ufsexplorer, and it seems to be recovering data, but it will take
days or weeks to recover all of the data. Still would like to know
more of what happened and how to prevent it from happening in the
future, and what would have been the correct sequence of steps I
should have done when encountering a problem like this.

Thanks for all your help!
