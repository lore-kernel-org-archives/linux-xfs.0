Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B12E23BD1D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774280522; cv=none; b=ecXPVSLgWYmtw5sNOUbphkspMFwoh3aZz9XbqrQjdlhcGrMgRVcpId/vWAst4IwRpUfWS+ndwuq9pS/WCxohO+nlkNCNvzSUJXzsWcQfG4LJVU4RXstP3h/VDOMz8waUev3Tw+6Frqg/inwDrfrkrn1CdlNaBUo4BAzfZjw0H58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774280522; c=relaxed/simple;
	bh=G0iEyskgYFiJJiPSQ4A29LWYf606VVmNVt75ke+W7JI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:Cc:
	 In-Reply-To:Content-Type; b=oM3kzVGkCFGA45GhAcV3oE43yTYBeZUlHJSOj16MeXmnWa5webdATILEkTalOuHrSmalsnlV5kGr+uZDEx3MiglPVDbHGMGDL1T5c0RkRJ/3e42Fpn21tCt4D7YrHdpnZtI0deWLmgFAsmSNgtjzjHzcNvzNKYHBaH9pjIKbP/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOAIrZas; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOAIrZas"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad4d639db3so12829825ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 08:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774280520; x=1774885320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YoImiZTZK9N2ji1T/Hu9es0UV7jPW/Nj0ifX24VqaCA=;
        b=YOAIrZasw2dFF8BiVnyWzRBiSEoUZpkroWlo/4nmXBLN40yHMA9vGZTYnwuiv5rSlO
         qQR1XxRu1dJdPm/JbDZR3aKpttrlXqNn1rnu8kUJFMlloEL+vQOHDazeKSKo1+l+PsqG
         4X2akiIy9wC1hx8W6e7cFtEXPlswCfq6mgFZcfC/qlXLrc1R5t0QiJi5t5xas/4ol9K2
         G85SMbG786gCmpTSVpB54BU9dH3gypEWC4lMZdtXSZ6kp9KV4dITyFFTa8mmcRWCctl3
         MyJO9ivMNmEVvneOZ9Ijyn9eZDkYg5Zn2kaCEW2+fI0KTtp6zklv7F6yoIHm3CxMEN4m
         Sauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774280520; x=1774885320;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoImiZTZK9N2ji1T/Hu9es0UV7jPW/Nj0ifX24VqaCA=;
        b=Ul+tR1ihJ85FZLe7ez9RlqFurdKUNLdDZKsGd7muSjBmZolL8imtiovyKCP97axCZg
         5jOO6/NAWXqYbgZMf6L9fs7XbOsW91mwxHhEFFfAx+hEENsRGFF4yckV8wXsgsVieZu0
         TPruM01EKZ0VsLjGxw0YFzlBcDhc+108LtR6S/cPoQeFED/6izZ6XRff/sZkBFgFeb2l
         5/p9Ec49/Q1OPQk8LLubZ9JLglJQ96wbJ3XljOpL2wcgCM99IPKcUJsDgQESwof1I6aU
         Frfa2WNuXjJFc7G4Ya7PJnL6CfFX2OWBDlXUjDEI2lxkDsLqthLcTBSQ7B8/swrgLNH5
         XtwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNWnsjL+GOI1JaHsweUumenbbkMnlO9TAiz3Hh4XVlAWzdvXHsQfF5ku0ThmOEUKRkMrwp3j6lZn4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdjUC3WTopvVhrRuBXGE4ML93/k1EAlHoGFQfpPlEUVZHc5eaH
	qciGsE/YqT/as/wXlQRiBzy5C18f0/CSi5eb2k0E4ibQEpiPKYJ7DBWB
X-Gm-Gg: ATEYQzwh9WCl6vi6pgZqNPZOBtAeTf3QSfL9UYT19rPjOdFroLq6do3nvX2v6MwS/dR
	X0eDYoEVl85NHv2HNkGXP2rb0JlZoi1ctzmC6G/rx8okFXgrqheiVjn03h+guXIgWILIe/VYCK1
	P33oaa7Oy2mMTBnUhv874mEG3UcD0EIJ86V5Aa0wmHf6SiAVebjNeaOUs3R9QjuSkdt+kshzfFw
	o2qb2Iwqx0i6xaHu5Br6urftDciwtTRsCLsbPD52K60ZBA6WwDyVssqihsj60L4mxoFm2p/ZT1I
	g9Wsi9/c8lQPWGuaMijrmt5h+vZlf7m2LW2Kh/4u96UksLO1kV7zInGB6EAmRHcj9anPBvnhx4y
	nlV+akVXdfQUc1MTdliIn2OlxtMsp1UmE6Tp01veQbno2IOuHTANrh6sAthQeRodrqbWe8cLao5
	lK6oS5Ccv4PSG7yeSomncYko5tm/A=
X-Received: by 2002:a17:902:ccd2:b0:2b0:5682:6973 with SMTP id d9443c01a7336-2b08273d0d4mr113011925ad.19.1774280519745;
        Mon, 23 Mar 2026 08:41:59 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm119018765ad.33.2026.03.23.08.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 08:41:59 -0700 (PDT)
Message-ID: <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Date: Mon, 23 Mar 2026 23:41:55 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Jain <anajain.sg@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
Content-Language: en-US
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Anand Jain <asj@kernel.org>
In-Reply-To: <20260323041624.GA11453@mac.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Thanks for the feedback. I'll try to address the points raised
here and in your earlier email [1].

  [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/

This work originally came out of a Btrfs issue where a cloned
filesystem ended up using a dynamically generated, mount-time
UUID for sb->s_uuid instead of the on-disk UUID. As a result,
OverlayFS (with index enabled) started failing mount-recycle
tests [2] for the cloned filesystem.


 [2]
https://lore.kernel.org/lkml/20251014015707.129013-1-andrealmeid@igalia.com/

While looking into that problem, I also noticed that different
filesystems derive f_fsid in inconsistent ways, and in practice
many of them base it on dev_t.

On the question of the 64-bit limit: although a 64-bit value
is not globally unique in the way a 128-bit UUID is, f_fsid
has historically been derived from dev_t. Since dev_t must be
unique within a running kernel instance, 64 bits are enough to
safely encode its effective ~32-bit dev_t without collisions.
The number of concurrently addressable block devices is also
bounded by the 12-bit major / 20-bit minor limits and
/proc/sys/fs/mount-max. IMO, within a single boot, 64 bits
should provide a collision-free identifier.

I've also submitted new test cases that validate expectations
around both sb->s_uuid and statfs::f_fsid here [3].

  [3] https://lore.kernel.org/fstests/cover.1774090817.git.asj@kernel.org/

> As I observed in [1] this leads to collisions when for removable block
> devices which can be used to mount different file systems.
>
> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/

I agree. A straightforward f_fsid = f(dev_t) will collide if a
removable device is swapped but ends up reusing the same dev_t.
Theoretically, I see this can be reproduced with XFS, and with
my current patchset on Ext4. That’s clearly a blocker, and I plan
to revise, btw Btrfs does well for this test scenario.

> And even as you've proposed to change
> things, it's not consistent across file systems.  In particular, your
> proposed solution mixes s_uuid into btrfs-patched, but not
> ext4-patched.  Why?

The discrepancy exists because Btrfs must distinguish subvolume
mounts as separate logical entities. For Btrfs, the derivation
requires f(s_uuid, root_id, dev_t) to ensure that two different
subvolumes on the same device report distinct f_fsid values.
For Ext4, a simpler f(s_uuid, dev_t) should suffice to ensure
both cross-device uniqueness and persistent across media swaps.


>> Place this change behind the new mount option "-o nouuid" for ABI
>> compatibility.
> 
> I *really* hate this mount option.  It's not at all obvious what it
> means for a system administrator who hasn't had the context of reading
> the e-mail discussion on this subject.
> 
> As I stated in [1], I think the f_fsid is a terrible interface that
> was promulgated by history, and future usage should be strongly
> discouraged, and the wise programmer won't use it because it has
> significant compatibility issues.
> 
> As such, my personal preference is that we not try to condition it on
> a mount option, which in all likelihood almost no one will use, and
> instead just change it so that we hash the file system's UUID and
> block device number together and use that for ext4's f_fsid.

The decision to gate this behind a mount option followed feedback
from Christoph Hellwig. The concern is binary compatibility:
applications that manually derive an ID based on existing behavior
might break if the kernel changes its derivation logic.

I agree that -o nouuid is a poor name. If we must keep the mount
option  for ABI stability, I am open to better nomenclature.

If we agree that f_fsid is already a problematic interface and
should simply be fixed without any special options for example by
always hashing the filesystem UUID together with the block device
number for Ext4, that would be my preference.

Thanks, Anand



