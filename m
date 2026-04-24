Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1922918CBE1
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 05:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777007269; cv=none; b=u/Qx4xk+BdFLub5rdTH8mpHnyImf0/C4OG2o78/t4UYlDrqASZcRkEYr6vwlEDzXF2vVDNqrK7pgAuS0x1AqPA7DF/C5w697wSXbDWJrCo2hK8Fllhus+jvffXPYQRmGul6zPsqt5jn9FxWeeU1gh9s+q72AhKsgD48ox+DF0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777007269; c=relaxed/simple;
	bh=xjE9giv7tBRG1qaYQTvNP0u8qwf+IGSEwMfTzYr2PSQ=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=OwqoRx6u/+rL2mj1P5yGm0UV85Impc3mhfehAOjlS8SN3zlynqBT3wr3vb8z33ncpre9FpBslu3yMJrFOklu2J2pxfRy0m/pwPsejfY+/QcisNysvD0If4Ha0bs13r2K8HTYVvD7oIpUYZsKsKq5LUW5angkoSZo3c9JvY79XBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8WhI9gB; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8WhI9gB"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d95017a68so4931517a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 22:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777007267; x=1777612067; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oUFDhoYbNqo8dXYU9en7BHWBBYUPonRzR5+Mg8X7c5M=;
        b=C8WhI9gB64nKmKFNu2IIgwL5+uw9cdtVTyVvXmR4B8Nd8TFmWQyOZdoX9kAmP2GNWJ
         cdYW2V7CqkVy/fgtjLnNvALeQJP4FxxyHEzFL3VN6LUgrWtkjqNPXV+aMGx7vdTVijz/
         jkRcDBBxfn7fR9IHLZfdQRRzF6zpHdoeipom0DQnO7KsY84TkGRzj5nEcoLONdhIv0ZJ
         BR8l7jFrbrbcl5Tx21iu4GVRsOvi9JXuATiAQOgvM/CPrtDIgAcIcOz6K0FlQeZe/gSZ
         bazq4Gjt0oKtzzvm8Ffd0X0pp7yz16y02XS5dIHphtH0sb75XrH4c6jfg6hZvonGdXw0
         yjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777007267; x=1777612067;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUFDhoYbNqo8dXYU9en7BHWBBYUPonRzR5+Mg8X7c5M=;
        b=ak+ZmsrqNGhaoggugS6MLlSTuZE2kMm1egsElypwHTWyv+H5JoQGkBGQRy5Pn7DqXJ
         t4NUqj+nIiEm5+Kln43s+it4EmuKFkKx3ijb0y18LULMUvCYD/Blrxeg6ERWJjSZWAAJ
         kgHzSXuiOHcNLEkWuxcZ+S3nz7cmx0XngZA/uOUKlTUOI9UMy59o5NBXpJeqAj5xNd25
         nGqeBUCXcFGn7j+YxCsIbA2ExTHPoS7ExmBtyvxMWInzUtbKD+HBKOiqW3zp37+j4RUB
         sEyhbmiWILZKTz+Jw5asJ6HPrb9WOASNocC9vxVTA5+xf7bJmGniPUX+iUmiAcu1mmIy
         XU/w==
X-Forwarded-Encrypted: i=1; AFNElJ+SEgr9r/rHVdvrFfn+DaU4LZeLSrjGzD9bk+SzeAzGYOwbhfV2P63O3vA3j+0oEy15/H1ADJZuyyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcSSu8TmNGHeni6kcIi0HkK16b1pxM7usQ1zeYfCPk0TYV+dDq
	hntLHaHZCyK6uFzIAbqbSostzZ9PSyF/nax3snyVSZRLcWjMFGYx+K0z
X-Gm-Gg: AeBDieve+xDyuBzzBmeiO00dzKiTn8wASfAQsg5rRGwqGO8cGotp2Jih7L4OuvH+276
	HeM9jLftpUKH0+QJ3O0sY3SQaSe/ge9NaIiaUoeCf3axYG+B1vlZonLt+dPMX105N9O2zFGROjG
	WeZfvEph8RsDCxdra28rpkVnlCHsKtcEw1OWXNL1t+/XWVMubRmQhCK65GapbsAHvUMwUBApB5p
	hFQfrN3LjHb3N5HLEy/MT5NPA8dZFgJ0X7bwwqbwCw9oaHx+2LvIqTt1gWHr6wvaxBW6BnCQDsX
	BGquRozX+Py+Kffq+/h3voMTTZQI/tRERowaYNBPkTtheaGE9Wel8bt0ixImCaAhKoGGhf3vDqa
	eV2rU1gmH8pcSdaRrmFHxg/NdPOEps0OwWd1nA299+uJ4IxiY/bxQSMJELmifKvVMX/Gsozr9Vn
	JGkFeVrTZFtv2k0F6IHZmuf9hjOgmuBP/T+fTBcWbF/g4=
X-Received: by 2002:a17:90b:5890:b0:35e:5723:85e3 with SMTP id 98e67ed59e1d1-361403f12ddmr31417110a91.9.1777007267369;
        Thu, 23 Apr 2026 22:07:47 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fab1c32sm8342149a91.5.2026.04.23.22.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 22:07:46 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <aer0wd2Ig0hjN3R0@casper.infradead.org>
Date: Fri, 24 Apr 2026 10:20:27 +0530
Message-ID: <v7dhrmgc.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
>> We were thinking if it is possible to extend the Buffered Atomic Write
>> session into two "continuous" halves of 30mins each (total of 60mins)?
>
> This is painful because you've requested me, plus both Storage and FS.
> FS has lots of space, but I don't, and Storage is also pretty full.

I see, sorry about making your (and PC) life difficult here. I know it's
a lot of planning :(

I think, both FS+IO folks will be interested to discuss both of these
topics. Do you think breaking this into two discontiguous session help
us plan better maybe? In case if we don't have any continuous slot, then
maybe we can split those into two.

>
> Do you need me for the full hour or just half of it?

Although I understand buffered writethrough is an FS related area, but I
am sure a new writethrough I/O path is an overlap for you in page cache
as well :)  So, yes, it will be good to have your feedback on the second
part of this discussion which is - buffered write-through for buffered
atomic writes.

Thanks again for considering it!

-ritesh
