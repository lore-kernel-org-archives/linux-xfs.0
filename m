Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF13F5BE4
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114464; cv=none; b=FFCELlx50OK9rK2eFXyfh4iJL590t7j04HtD+5YEe72NEJ2GaT3L7Hf0Ng0yHkihb4TLtNu5LBZPZD6v2lpvObEHfV1pJ6/QG12Mc1JxaR1v/8dP2Iii8GmD/JHt2/zvKFK8s+u8Z/i+wtbdNp2DAg0Z3gYOtHWGVvNuXLlJzQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114464; c=relaxed/simple;
	bh=56sWDZSA5ZNIBjB/oNotI09lBuHC1nOmFFOAgN/NOPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZgeHOiPIyZtOkcdDquA0M9ZF3PsIApt0/3nF2TBEoUGQvbfRrDbhsDWUvcc6e6v0QZINXeZI1dhwSk0+AbJ+Eo9f3zrS6erS4C/xl/XQnNuWPpzb68R98idl18z78qgcMxfeGYE0bG2CT95xAWOfmWQATLxtzKI/znyDDseD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bu1YOoyl; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bu1YOoyl"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-368f25ff4c4so1083539a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114460; x=1779719260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=Bu1YOoylQdoXGLSRGbc+FeNPAdYEXONPajxy10NEJ9/9pem+7ErubmIHLK8qYHYqbR
         M9BcN8nJmIj9WAtswHFYnL41+vyl/oFZ5K3YYQTU6yOhp10dNa3Z1lYLr9RYJuZ8bae9
         vu8SSalIxPwdicF3Zt+ROHKsdie6pYIpImxqhwsRcK5iQifVWH2fvg0LeJdH2wnnK1Y3
         C1Wxa+aZKUHS+1rTDROoxNsFgUe33Xt078+IE71KxRQXCZnLqpzTPqUOKUhUYNFzUKjB
         0Jf3BvfUG9VhqMRWI4UEOVIk0UPl+KDa3U/n3/H6eiydgdOwxwLziIPa4atUWkdVBo/v
         GaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114460; x=1779719260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=fwzIFfomj6SgZfWbM6q/nI/uhLCgAGCypTkS2Dtdl7ua82rSkaZAyDAjrl556GetM1
         j1c23605z8giJv4Z8+7z/VuOqqnJSdY6M1p5k/QqOguA74UuNDgoSexWxqfXrgm7mjjU
         3G/lScEteiyLZE5sAcGX7QblidRdKWG7EFjdifSeRc+0hH4XyE3w8+CkCL0ypdGOFr8X
         GjyE1d5WfFMsq69drK76aP+781XZ4uyRcIphSojTnTncAC7CziAdKlVdXswrmKoFZJ+m
         P90bMuqLGc0SOq+umX7joS7lNUbZ9cLdmMAJxfgMoexJPjxafA8Sw7CCTD8RYP9dGmej
         Huaw==
X-Forwarded-Encrypted: i=1; AFNElJ83bPu8EPwdINt09sQ/MhG8B0DEjUO8XzMvsMj6N9kJfKkjioWqcUAkRH7UtrFaa/xJa/9zmeFyFx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNHfHtHo09FlLDTJGqNbIVz3EVnn2ueD1yF8UEbBb+S8vTTdhR
	IEO7Ip5Od5O24WDmm9MsUHUF23POHZC10j4+mG8v3zpnbQSxfXRSdC9V
X-Gm-Gg: Acq92OFgTnhwj/pHpq/GTh7Q9r7gHFtNbrgowofJTVBuzPXWy3n6gSLJIxyssUElox1
	Xn8S2gr/lD7fbcPpMk7tX9MsaK414+7Am1+OshCgZRZU6AZb8aZbUGWJbJojBa4EWFYdp79ldFM
	CS9Kpl8eo1yA864o+7KA+cRWPO78uPlgpLjuSnXx9q8MIGFELhmSQOBEsYNbX6YyZkQfSlTyQi4
	PKZJTg8oOsr9RJAdh4JH6a+XZLi0L1T3gUO1Lqk9i4kUYk0btQ5ypIVdShHIcgaVYo8i05QIayV
	vazEfF8NNSuFFHtb4W1cW+F9HNsBCwvWCzpwHPNbGEWQwv89ERrFD/1xVObw4vIBSJy0F8Jp08z
	jbAUHoAJrGDWS0rRVI9Wrq6UHUdb5prK+o6dbtLbVx8Lw6qZFYxqa22r36UyJ1DeTlKGKnpTlel
	8v3trpjv4C9HIQiGeWZvkaW+VPAaU=
X-Received: by 2002:a17:90a:a81:b0:369:73a:3266 with SMTP id 98e67ed59e1d1-369519e40bbmr10216834a91.10.1779114460408;
        Mon, 18 May 2026 07:27:40 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3695a09ed1dsm4205256a91.7.2026.05.18.07.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:27:39 -0700 (PDT)
Message-ID: <e4fcacb0-ec95-4289-a647-8e85bf432a2a@gmail.com>
Date: Mon, 18 May 2026 22:27:35 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] fstests: add test coverage for cloned filesystem
 ids
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1777357320.git.asj@kernel.org>
 <agK8gc2niqpTuHHt@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK8gc2niqpTuHHt@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/26 13:37, Christoph Hellwig wrote:
> This is missing a real cover letter saying what this series is trying
> to archive.

I should have copied from v1. See below [1]

SCRATCH_DEV_POOL support for non-btrfs was dropped in v2.
Instead, using the newly added helper  _loop_image_create_clone().

[1]
https://lore.kernel.org/fstests/cover.1772095513.git.asj@kernel.org/
-----
This series adds fstests infrastructure and test cases to verify correct
filesystem identity behaviour when a filesystem is cloned (e.g. via
block-level copy), covering inotify, fanotify, f_fsid, libblkid, IMA,
and exportfs file handles.

  - SCRATCH_DEV_POOL support extended to non-Btrfs filesystems
  - _mkfs_scratch_sized_clone() helper to create a cloned filesystem
  - _clone_mount_option() helper to apply per-filesystem clone mount options

New tests verify:
  - inotify and fanotify events are isolated between cloned filesystems
  - f_fsid is unique across cloned filesystem instances
  - libblkid correctly resolves duplicate UUIDs to distinct devices
  - IMA distinct identity for each cloned filesystem
  - exportfs file handles resolve correctly on cloned filesystems
-----

