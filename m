Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C35335BA
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 09:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882572; cv=none; b=X/350YwOnRU77QtU6HrAh9c8mr8otqBN6nNzs08cY1Buexy0eqaObz6l3ymzOSTo2+b5FLhiaXtub1PRhjFSqoPzNAdf855XLYRjei8qK4o2Zwa6DTcNngVBTdwqGwRhGx4ArOfnvSnCp7Z1KAf9YFaV85d3vm3KuEIZKeAdkQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882572; c=relaxed/simple;
	bh=9s7NOR5sktGNmcAKvAlm6Z5d7kg3IIvUBD/pBOmfjsE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nuTarhTphYsYgLsZTn3V+43xu2IOaog6SpVU9XRG4F1Pze4qkzv2ROTfsB/Atraid+uzlq2bpCEcDgm8IlJGUiViuWFdjJ58QF5M7BliWx5bEf2ZA2tILtOBBihUpAsVQcAM4wQ9TO4r/+l3HXP8jNMCS8AF8MH0aw69KQkVXus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgTmtEGS; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgTmtEGS"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-acae7e7587dso84213666b.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882569; x=1745487369; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9s7NOR5sktGNmcAKvAlm6Z5d7kg3IIvUBD/pBOmfjsE=;
        b=RgTmtEGSWedUNq03wwRWOyavWJzG+kiYmYPqpg7VpPbvxAAovWWvS5ns5hsx0r24LB
         GOlHEqLAy9LSIrZw+4y9FsRLYo/KfT/F2GnGazT8zbZe9W4X0bmVCplX9YerFXPcVWu7
         nHTOlJmUmlvT0A44/u/8d1F00ehwYzRaWd2N+2uzuwwRG08hluTYcjgOLSUsZ3J2CW9B
         p/uxcw+dDCB7fnOq+mi1qvth3HL/48p4KwvgR12rHS7K9zYIkW4WRPSpcihsFN2BA7KX
         HY0FkRVfDXgWEv6gz5SSiM1RebYicly4pw7ry1QDkewQkvkfKzaoX7NHJ5D9DH8MIALF
         lGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882569; x=1745487369;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9s7NOR5sktGNmcAKvAlm6Z5d7kg3IIvUBD/pBOmfjsE=;
        b=naA+jaC0HszkDOIUqRllEiCJFNSi96VVq+CCHhMQ2pWnVcpm5QbaMAGAUTqcV7TwS8
         onepwpHN1I3NfYkJOzf+M3z7XiWBusGLVVBW5NKSdyzsENHKZiWbj+2sppN3BnZSFPU1
         kkNjAJzxq86W8ctnxmwXffSiYrLXPRdVpGvgsQ2VTqFpwp/NBzP37N9dm+72Ke02HQNh
         lDTkWayASN8e6GUR/r1ZJaxZGB1GKseY0EFQsq2Vo84WifTJXvwfeOW3EPbNqL/kT5PH
         iN4hcMbVWwV13vuIP3Yt/QZn/SJriI5ToKrewj+5PgRCeP/8ns2vg4ec6z6LZBJg+ADc
         C7lA==
X-Gm-Message-State: AOJu0YwYogO0JBQzHffeHZ4nSbkxNlINm6rbpzlS2L55a5JT7R2I2eXN
	3F9Gr8OJP2qO2N0fcUdU1oRUiOmkzHRILchok1yIuBB5yXpeu5Mg3bqoWd3hZ7nCWEPUlc6v/tL
	ctKPAbSTybFaG3UseXRZb6RmhTh38slyumKI=
X-Gm-Gg: ASbGncuEy7cyybsqZ1fpvcCusqqKzFG1EyXbcC88TDSgUESVcbN4ds5zOlt9Oa7yn8o
	nT3RmJRqBLIUE80IvF281673NLlF0Tb9HRQkNJsXcJQs22us8bupaypXqf0l5OCmNsm4urR27+z
	K39RzT7S3sTO1GmJtNxD6Un7k=
X-Google-Smtp-Source: AGHT+IHgtMYnlVh1fhVpCIQj9DeY35ces/fi/QCgMojPuBZJLE1fsbXuNItYHT1G1EIWGe5I+ju9De2E4DCkzNKyKaE=
X-Received: by 2002:a17:906:eecb:b0:abf:4b6e:e107 with SMTP id
 a640c23a62f3a-acb429900d6mr499447766b.25.1744882569082; Thu, 17 Apr 2025
 02:36:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David White <dr.white.nz@gmail.com>
Date: Thu, 17 Apr 2025 10:35:58 +0100
X-Gm-Features: ATxdqUHC_N4IjEy1VIbWMfz2tCKAKMpfinVjyICNT3nnV-3EnpNZjKRLqGrsm1M
Message-ID: <CAF9hJQszo5J=5NGuALdQW5iBrx+qB=nY__y3ae=k8P1JgbeUQg@mail.gmail.com>
Subject: xfs_scrub_all.service
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi there,

I'm on Ubuntu 24.10 which has a secondary mount xfs filesystem.

I have installed xfsprogs. Which installs a /usr/sbin/xfs_scrub_all
python script, and a systemd service and timer to run it. xfsprogs
version 6.8.0 (same on 6.9.0 built from source too)

However, looking at the code for xfs_scrub_all, it's broken. It fails
on a non-existent "debug" global, and the run_scrub thread target has
a call to path_to_serviceunit with a "path" parameter that doesn't
exist. (I'm assuming this is supposed to be "mnt")

I've disabled this service, (and the timer that runs it) and added it
to my system presets for future installs not to enable this unit.

What is going on here? What is the purpose?

Thanks,

David.
