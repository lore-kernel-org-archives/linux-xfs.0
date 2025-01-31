Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7FE1EE7AA
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738353619; cv=none; b=k89cKmowYH0EKjd67URWH+17jTjvuePqg+ZRvtXpaxa46HQHeCgrDIhBUA1qDPe5U72JrvQNzTGOOihHSo72JdH8VGLw86zCOH3KwdaJi3ASG4q26lxgPva7/SCgpkQx4QZWy8r7S9fPXh57r8W/uz0qgfAGiAXVetfJWRnvFQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738353619; c=relaxed/simple;
	bh=mESJj9WNZAGhoP88PwXyk6SgSBIq1RXBtiH16frMzTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nsR8YXCFiFM7+az30j7lNWXP0rgFr+xN8BG8WA1YMO7hwSb/h/0L8tRu7J8XQ5FWaS4auHs5ucXfqgID4hQThWiLopfoEZT7nIeo6ymjZqFLyfbA/fGcKnxPxU7kUt/w6GCFHNl63ORFqnB/of/85AiyhBU/X+ltv5v0nTFdLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dPlLFIfM; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dPlLFIfM"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab698eae2d9so469255166b.0
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 12:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1738353615; x=1738958415; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1VEMyzp2lsoEGf8wTQK/Tt97K6OMqjZreNFMoOiXZ5E=;
        b=dPlLFIfM+G/lEDPwPrinoJPSTGpf/quSRFWlHZwLTfO2iIdxA1VWUpZebWr1yuf6iz
         BdarU7DO0Hb/S0/QgTkLF6DNa6P/F7NxRb4FSHpoGRZw37Dc9Ya+o+M6mn6SCk0kcGCH
         7L39NJQjtPl8SwHIqLDrbq7guSpa8Iyio6i90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738353615; x=1738958415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VEMyzp2lsoEGf8wTQK/Tt97K6OMqjZreNFMoOiXZ5E=;
        b=GdwRjm+vpnkqlRC22UpgbQnKV5Yjk5UqHp4PpBW1YzNie4huAm7xYiZLavHEfASygb
         ntZMb+jwUQHNiHqBuQEvLHnJEEXIRpc6MdeOoZooDmuC8sHRn9kNWO2x4Aq+FXUnwuTy
         Hhzgha5fP6hZHIh6rO1sXn0MrBCIdElIa/e0MkEB77kKsCGzStCe3mv1h7Mo5ljSFUDB
         1f9FwOmGOfS8efbtDlQVL19npPUyFZQD68EcnySq1dz3I+Defm8gp2PJ3teNTAQzlLo4
         SHndIUlI+MgQkAhuzWnEKg1LLvm0HeF5QA1aod3PLVpQZ1414eYHKh0hqjnhN7bdEZ+1
         LuVw==
X-Forwarded-Encrypted: i=1; AJvYcCWBs/bbyghX/xk5Ahmmn+f0TJByo8ihhvLLe+LzTR0nH34pzvgqQbUnBIR8MKWlnafSZPKgbECxdgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YycsQIc9uYgKa6NbCtyAHVDIYffS8bmH1rPmx5CU1to+HqbBxXp
	hYsuLX+VX6pemWYBnRhmxzeeYxaxd005HgjJGxqckL1syztJuDdzCOXpMVeHBAScaEEyfgx5imQ
	w/DE=
X-Gm-Gg: ASbGncs8acxX7xNDEQwu4kZKM979WrAGXCHuPBhWh/eCCrCRr+TqZqiUF3bZxpGE74g
	A4GUij5qob+hpWLCDWaGDEmo1cPZjR1Ym3Ouqlhz0bD3mCicqRTE245WyaSpW38hHEgFtD0x7wE
	sU1Ui0OMsRdi+pjaxuZoIIK2jBC0tdiC3a7dobC/jjv8HfVXLf914ELmoHFISl5Fs44nO7zVAa0
	XawGgFqwSMFvpuMwNrMVzFcQo+923oHdF7ZYEdEWAaZ3ENRe/FDUfk+o0SwrsKgGVB4Y+BnMwpB
	4zms7XcAiV8D/ui2rX2HG/cJU/JYA+V/1Ei3pW3LAqmeP1KHJ1hzdtlwcCNXKCf2ew==
X-Google-Smtp-Source: AGHT+IFTpDbIG7YXEow9Y27fbSumwBXW731rZCHlnvMosbGKmyrEJaNoTxCYra1iBRPxd6OI2RmTXw==
X-Received: by 2002:a17:907:7254:b0:aab:9342:290d with SMTP id a640c23a62f3a-ab6cfc857ffmr1374593966b.8.1738353614070;
        Fri, 31 Jan 2025 12:00:14 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a318fasm342021266b.134.2025.01.31.12.00.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 12:00:12 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5db6890b64eso4378628a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 12:00:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUnoMurAKmK/l3DlCQhfnXjFOQaEYb2EGjYEgDJkN8OlPb+yTFXCYUQCuwB1NIR/g/rm9cFMic4E0c=@vger.kernel.org
X-Received: by 2002:a05:6402:2709:b0:5da:1448:43f5 with SMTP id
 4fb4d7f45d1cf-5dc5effcc33mr12325224a12.31.1738353612239; Fri, 31 Jan 2025
 12:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731684329.git.josef@toxicpanda.com> <9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
 <20250131121703.1e4d00a7.alex.williamson@redhat.com>
In-Reply-To: <20250131121703.1e4d00a7.alex.williamson@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 31 Jan 2025 11:59:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
X-Gm-Features: AWEUYZmJHVy_un_wj0EXjvnXlSLyiKtpaVCBTRVD7w7Khb3Vui_AFXvwFXKGqO4
Message-ID: <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults for
 files with pre content watches
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, amir73il@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, Peter Xu <peterx@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jan 2025 at 11:17, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> 20bf82a898b6 ("mm: don't allow huge faults for files with pre content watches")
>
> This breaks huge_fault support for PFNMAPs that was recently added in
> v6.12 and is used by vfio-pci to fault device memory using PMD and PUD
> order mappings.

Surely only for content watches?

Which shouldn't be a valid situation *anyway*.

IOW, there must be some unrelated bug somewhere: either somebody is
allowed to set a pre-content match on a special device.

That should be disabled by the whole

        /*
         * If there are permission event watchers but no pre-content event
         * watchers, set FMODE_NONOTIFY | FMODE_NONOTIFY_PERM to indicate that.
         */

thing in file_set_fsnotify_mode() which only allows regular files and
directories to be notified on.

Or, alternatively, that check for huge-fault disabling is just
checking the wrong bits.

Or - quite possibly - I am missing something obvious?

             Linus
