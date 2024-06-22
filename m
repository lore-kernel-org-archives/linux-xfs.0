Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFF682492
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719072293; cv=none; b=smFUwAPxPcJthjO+fszSTeDhjov6FTC6Ge53U53BjRnObKREzmcpkNHXJJvcdOhKl9LveX9bSoccEFtsXW/479a4KZRZGOhrO1JAj78K4LZVRrvi2p9D23hEWwxkUjzblsqUIvgX+HVMbAVRcSz4Wd6QcEbVIVG1zze6fwLTJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719072293; c=relaxed/simple;
	bh=3Lb+sNWPu4HFWDP4z1goC8OUUM/o8GRMbZm5+jw0fQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QsgICLyvtgROkOZHO68LlFDE2E6VVtwoLnK5SjpU3a6MSlg1FVA3m8XFIVv5Fce4iSqXEZGtRaBRUV+s4ee9RECNV32AvQ+GYieJ2XyQ6FO1vPlI7cSot9XED64aWp/tI4EVezlHUMjaIXTyejE7hMkM9I7kUfRrII6+I1/O/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzZWtfGf; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzZWtfGf"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57d1d45ba34so3237675a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1719072289; x=1719677089; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WFzhLDArXIiKbzwErxgVnPt8QBdINKCk7LHSAqqpCVo=;
        b=fzZWtfGfH0/ymOZSt1+o27YyY/DBEMxv2Ls0ATAroRG1f4nlq8e+7vM/otAXepNCu1
         CNv+XZx0FBUDJ+iQkKyYIsDAJEmNUkBG5RkFENHZl6mbCgvRN1NGW8sluM/PedMxiG0K
         zX0/iEV+/L7ZypiDzrUqPPlGYxMzEDaKGalHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719072289; x=1719677089;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFzhLDArXIiKbzwErxgVnPt8QBdINKCk7LHSAqqpCVo=;
        b=xTp3XCdGQrTbyo7GqPP6MpwH2663pPB9goWINkmAh+ZzIRfobefst++6JRpviAV4JJ
         S7QC/zKucU4Q9ZHFTMkWAFkt8Vs/CScheKpunT5933+3LKyqd6CPRhAxZQAU/fCFW3FF
         1kOit80yqbMZ1rQaZfPkmdllX6RSjO/1ScWnUve7rAn0tzGF8LtDmZekA5KltsU6XgBc
         JyilVdcKJORlQOLuMbQ6y7kFf6g1lxRXQddqQZ1LvVy38KkqEmTcl6cgiBHd+5Bg+YvM
         RgzeyGniWNltzgZ0UAZdS/IzdBN1klzpiibmt3a6LlcB2PES9YFVeDp0anFM/hHW9MP8
         Mbrw==
X-Forwarded-Encrypted: i=1; AJvYcCVm26dtc1Iqyh9q8fSW0xPeH0gJMw8YU3Qab4cag38uG+3+K5xuaArAYnNznK/3wiMD1pDfDla0tK6iaUdJ+K09p3P1InfF/Y2h
X-Gm-Message-State: AOJu0Yzk+3qpPllgfL9ajx1l8DBkwvzVRoIJ+BwP1fAMv2uFANrm0V6p
	2G8RnLlGeJXK1OY2mmmS/Ok2+oMYChsJooQKiz8LM7ICyzkGrZO+3TVL0mdpl+q1K2JqzXXuDMo
	EvGeBQA==
X-Google-Smtp-Source: AGHT+IHqce8nJ/fDvhomZM7qCXACRQp4AG+S2IcuHidAVpBaAIjl5XJfmeCNLyYRCRU97h+XLqGbog==
X-Received: by 2002:a17:906:1d53:b0:a6f:64b0:1250 with SMTP id a640c23a62f3a-a7245cf26fcmr9965166b.35.1719072289292;
        Sat, 22 Jun 2024 09:04:49 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a71ddbd3479sm57515066b.189.2024.06.22.09.04.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jun 2024 09:04:48 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57d280e2d5dso2644173a12.1
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 09:04:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUvAxNrfeADzP+gEJfRzTB9KuMmEhD5FIh0qT8/knchEnZXhuR8Xuix5r+jWC48/wJLpXKzKeEl3/FtSijvn3yjFxUsD1r8ZRMZ
X-Received: by 2002:a50:d653:0:b0:57c:74ea:8d24 with SMTP id
 4fb4d7f45d1cf-57d4bd71891mr210438a12.18.1719072288320; Sat, 22 Jun 2024
 09:04:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87r0cpw104.fsf@debian-BULLSEYE-live-builder-AMD64> <20240622160058.GZ3058325@frogsfrogsfrogs>
In-Reply-To: <20240622160058.GZ3058325@frogsfrogsfrogs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Jun 2024 09:04:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=whJjJhfK_gFg=ZcQW837m0bfSLCxewLaAZPHa8gVJuiuA@mail.gmail.com>
Message-ID: <CAHk-=whJjJhfK_gFg=ZcQW837m0bfSLCxewLaAZPHa8gVJuiuA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fix for 6.10
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 22 Jun 2024 at 09:01, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Sat, Jun 22, 2024 at 07:05:49PM +0530, Chandan Babu R wrote:
> > Hi Linus,
>
> Drat, I ran the wrong script, please ignore this email, Linus.
> I guess I now have weekend work to go figure out why this happened.
>
> > Please pull this branch which contains an XFS bug fix for 6.10-rc5. A brief
> > description of the bug fix is provided below.
>
> Chandan: Would _you_ mind pulling this branch with 6.10 fixes and
> sending them on to Linus?

Ok, I'm confused about what just happened, and I had pulled Chandan's
PR already.

However, I hadn't pushed out, so I reset things (and had to re-do the
bcachefs pull on top, no big deal), so it's gone from my tree again
until clarification...

             Linus
