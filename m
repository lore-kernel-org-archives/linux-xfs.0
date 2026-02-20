Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D2570808
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771586424; cv=none; b=aqz15ahyQdZxBb/o5hYJRDwZLIgJpgTG7zExemrdCv6649bzA6ElGCmkOynyYYqwVOLXV+F675QzVDwjedWzBU39hD8EgEbzpsYe28+hlIxJMxMDsX6wvgchN4n8KzvEDQmlxLEcbg1iaGt4bq4RvdvkeObvhvseo43soyHqkUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771586424; c=relaxed/simple;
	bh=nQi19hmtDEY0gk0iFNrx0LAsaeAcE277705HTdktzcw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=HXUCj4Ya16UM/r0tPzpyrsA2mEhxtgo9GGB8wMZrKYa/+7+ZxhuT9tAW/jd512UiEix7d5mX+sCMxr4L1UficnZTKFYFq6DT3VrQxNtRX4cbMjaj7wMQn4rmlDTGAJDa3wZqmqmsEGr/x8eDm+UMR5XGC52xfCCDEpOSJu+8X/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/TykN5D; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/TykN5D"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-354c6619a07so776066a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 03:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771586422; x=1772191222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EY5+afHS80rYVstbD4jaOCXuT4DGtTHT0Dn+4Tzqf40=;
        b=k/TykN5DazAHuE5l1Pr7te/bCIZp5rZsmgnMeP8SjfM4BBxdKY+wZqjYTHqeiRJ9Sp
         uv5XyejWlTETkZNZ4oCrGwctxwajuuuKQX4HjbNuYSPqleYD9lNR/DUt38ojCIZktL+z
         ERWudlBb0x035R/ossoiS0qUKAl/t02r2Ji0871hOdG4+5sCJ0s8PvmaLidHENm0KyDz
         Ud8SP6GREtzhWB50dC31Ym+8OlKAZ2B2TP/T4ylzsu/H/jbYAlRfl+X5ebkoQ0tbZrdf
         UH64jSkqb72BSHbxakObextwynfCjJoMishfGwkSdsl52q+kmq582+MSwh61uSoysWAj
         efsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771586422; x=1772191222;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EY5+afHS80rYVstbD4jaOCXuT4DGtTHT0Dn+4Tzqf40=;
        b=dWukGARmgrKkBpRLndYGyAtBQeHsKhkhYw8xlciYV6fMH0V5RALux2C6zyErZqIzhp
         1Cv1p2vU0c9uLkk3//6sNpY5tWZ/TIPrSaGPetReI4vOka709MXamwWtUQx5WQI4KtZa
         TbSWebc3M+wiILJUBf5VlIIc7Refc0S2IkanKsPj/v8G/fzTad3VRXC2Z4Fp88p/rh/h
         T1UHyP1lNYwgkRiupK+8SpUuz/h+bo322xc3kv52VzpHXpIyZclj/InsTljytDdZSkMC
         mg8w5r6stMEGTSQvaLDVUsmHw7ZtM3SODuELW3JUHMiyBVYrnmMlJ1h4g7kYeSq0+w5S
         bk4g==
X-Forwarded-Encrypted: i=1; AJvYcCXSrqnR0KKlN73zi/3eWblt9xiQ6OKl39cnfLxPVDTN/t1TFm/J7SEtjDx0AjmIigsFw9SM6JuIoJk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4fy4KfvYWdnLCY0OCrYrmbftgh/cSJguHrl9VlSSQtk3IIT5b
	BAi209XngqvISckHleXeNJ4CMFUaDSExOIfkbeyZydUeMQ+MgIpgiU1Q
X-Gm-Gg: AZuq6aITEdemyhttHEVXm7w9goGUGLrSfA2WC3qORszEwRvWa79YQBBWM9Gn41Q7qWd
	x0gCQ5921sy+g3T6jh1pFIGDLdsOC1ZSNyAMY/AjBrnZMy5EK+f5s50KsQGqoV7H4Syszpxv4M4
	m+fMM+WTueFTQ0nwlC0+7HY4jVIurt2F5cfV03yRjeBs9pEfZkO5RtkhXfbuaKOjrCyktwUGcRX
	YH3Gqu2pJafDZb1lwUr6TMslKefjeyHnxH0MPzYQw2Gxif8GuWm4e0zQzNGSFm64lyWvJs7ENlz
	sNiZYrtLhQ/ZANK0rtYBvoLXTt1dHaigeYSFkwBET7lpuVBioXs+oeduaUIRO7XYsGecKAbWNHY
	pTs6BnnAh5Tn0yYg1r+CufbzFe3ZX2S88K+6I/3RFFd3Fh8ZN4v/wRd/pOtHW5CjcdkzBaPJf0E
	LQwsQHYhpOftdpAd0ay5PUi130k69czWBlU5W5iOPFt50O7LfTsIP9pswObF0iY5FMqAsS+XaK1
	H9U
X-Received: by 2002:a17:90b:1d48:b0:353:38c8:b612 with SMTP id 98e67ed59e1d1-358a66cd3d6mr1152109a91.12.1771586422521;
        Fri, 20 Feb 2026 03:20:22 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3589d80d3adsm2823159a91.2.2026.02.20.03.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:20:21 -0800 (PST)
Message-ID: <caf4de45aecea6ce7dda89b06c752ebfbd7e971b.camel@gmail.com>
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, hch@infradead.org, david@fromorbit.com,
 zlang@kernel.org,  linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com,  ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Fri, 20 Feb 2026 16:50:15 +0530
In-Reply-To: <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
	 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
	 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
	 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
	 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-02-19 at 15:55 +0100, Carlos Maiolino wrote:
> On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > 
> > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > shrink functionality.
> > > > It begins with the introduction of some preconditions and helper
> > > > functions, then some tests that validate realtime group growth, followed
> > > > by realtime group shrink/removal tests and ends with a test that
> > > > validates both growth and shrink functionality together.
> > > > Individual patches have the details.
> > > Please don't send new versions in reply to the old one, it just make
> > > hard to pull patches from the list. b4 usually doesn't handle it
> > > gracefully.
> > 
> > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > changes. Can you please explain as to what do you mean by the old version?
> > Which old are version are you referring to?
> 
> Sure, I said 'old version' but the same applies to sending them in reply
> to other series/patches.
> 
> This series was sent:
> 
> In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> 
> which is:
> 
> Subject: xfs: Add support for multi rtgroup shrink+removal
> 
> 
> In better wording, please don't nest series under other series/patches,
> or things like that. It works in some point cases, but in general it
> just makes my life difficult to pull them from the list.

Okay sure. Actually I have seen some patchbombs follow a similar style i.e, have a top level root
email/cover, and under that have multiple patchsets with each patchset having multiple
patches/commits - so overall a 3 level nesting. Since this work has patches in 3 different projects,
I thought of having all of them under one roof. If that is inconvenient for you, I will send
individual patchsets separately from the next revision.
--NR
> 
> 
> > --NR
> > 
> > > > Nirjhar Roy (IBM) (7):
> > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > >      inodes
> > > >    xfs: Add realtime group grow tests
> > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > >    xfs: Add realtime group shrink tests
> > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > >    xfs: Add parallel back to back grow/shrink tests
> > > > 
> > > >   common/xfs        |  65 +++++++++++++++-
> > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > >   tests/xfs/333.out |   5 ++
> > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >   tests/xfs/539.out |  19 +++++
> > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > >   tests/xfs/611.out |   5 ++
> > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > >   tests/xfs/654.out |   5 ++
> > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > >   tests/xfs/655.out |  13 ++++
> > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > >   create mode 100755 tests/xfs/333
> > > >   create mode 100644 tests/xfs/333.out
> > > >   create mode 100755 tests/xfs/539
> > > >   create mode 100644 tests/xfs/539.out
> > > >   create mode 100755 tests/xfs/611
> > > >   create mode 100644 tests/xfs/611.out
> > > >   create mode 100755 tests/xfs/654
> > > >   create mode 100644 tests/xfs/654.out
> > > >   create mode 100755 tests/xfs/655
> > > >   create mode 100644 tests/xfs/655.out
> > > > 
> > > > -- 
> > > > 2.34.1
> > > > 
> > > > 
> > -- 
> > Nirjhar Roy
> > Linux Kernel Developer
> > IBM, Bangalore
> > 

