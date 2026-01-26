Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A1329C6A
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 10:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424951; cv=pass; b=ic7cnk2KbweSUvyj+rz2CtAZ4Yn3YNEonEWXYclGK2HO/zGSxqrpXzQfsPdXtZPe8+phLMf7Z6yuA9FDturqcu27EEkrfbcwcFoJnku6O/OFlC7VRtWkT7tLPI3rhmKdqaj1et+hGOL/O5QD9AYoIoY5im5FYLl6agpPq4KBmiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424951; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SzAc+bxxWwMftO8HlxGnzwXz8eHiRQPA8p9tPlNf2T1e95CbpEIjq0u5PYoYzeIbRSW/Hmz0PTBRoGXSsjM0+/Gpt3oblZU5qTD1cvyfdSX6sJ+/OkGqiPDJyz8yNte3HtA5U3kU3Szc6ITZe20e7h4l8kB6pc2Dof19jRoKK3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3iPKmcd; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3iPKmcd"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65815ec51d3so7867727a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 02:55:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769424948; cv=none;
        d=google.com; s=arc-20240605;
        b=NrSQclNsBC2tzCWRuJvMkJti4Nr71FttnemmR62kPv2xB74fRYo9EfHu7p95jrzbOx
         sZOa38v9MrFwjTUJPME+uaEv0Ntgtaht9vrnnFjdpI+F6CF7gtgCwvg+cvJfMGIeFlqf
         e32u1w5t4jE1UnKhmxb/7bLvI3S2N72gewHCmWw8r0QzTeuT8gZKUR5Ne1fUpXENtc1Q
         q3T1G1A9it4JLugX8pFW+ZL0dousTwwwCAEDeVEcu+7mnANXDioTRuI7jFMS1tOMxnn9
         OYFDvFXO3E0Tq/X4c1qLp5wa72sOLxMrIAC+dS8vnk4Zru5a0fdSuhEVJsLq7ez682Eg
         cf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=Vv5M3RqwLgCgsbmnCjtbMD5r5Mg+9vShqy3osqxvRrw=;
        b=EH7fyggnkf3/5TgJ9X7cfkUorgHxVwipN6FstXkts6E4WOPFmLZb4ZMTP5dYCluWmr
         iEb9hSs3lZ8Cp79uUY1zJp8VLk9NTJRqq1Yqt7bCcAdhs9+lRhGYMyItZRk7es6Mg2+o
         Hbg7r57t/OAWSVBCUUd7UNRnic5qE/TNH9KbeJWbBIberg83EWYMUgaXTh59QVCR2HRG
         Jy7QPIy+piJCKvoC1DTPuwXILqXUxA15rsoL0bA/ZeHuCVMCA7HoH99p84FpqDI9fbZx
         5bcFJjZWP/QHdxO9kysvnAXhDkiyiUrZUXedzxj/xdpsO1aIYVts2Gg4H4D8lBUXdyvw
         TNhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769424948; x=1770029748; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=c3iPKmcdWcrKJaAj/tOAIo5py1TPzrNQ5pnCQBDB5cDKZBqdHFmbS2cqW9rU4pd1BZ
         xo3+8zTVQNLKxD+hOyRZmewYR3RYRC3SyibdkCCyBnF7cuRF5YucN15R6RtEEWQlFxAy
         NpVZAC2tc0lG0F1smKvYG4EBrF/KdDlLJliGkZQgEFBs1rPPMFhas58k6dZf1FKOUDZ5
         7Ync/FiSACF5NS+fns8XGi/3p5YOQPPZGHI8gPSRF0EU/oz/phSYciODICKoCqgDNwSk
         +D+AXYHRfBa//b7v0zpEPo8lK2n/F4uwg0lBf/jxL/b7TlGtN1oAEnNixJE2uEk1k2e+
         S5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424948; x=1770029748;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=q6q5OmT0Gxauq8ZJBSeaDMH/9hgnCF8curoOfwqPjtd1vhib4pXqyAB+vIYFLy1r9i
         eVCdqzddYidA2aNl4xICprZuRIYYXB+GJojz2zvXXc5DsjCT8SYeXWUFpKQ0C0F960BA
         CNU/Rq7uGaHTRK2QL1fCe2NStKxd4+Xcl8+9GHGr+B3qpeudOhxIcH0PrAU4ZvrjEPTc
         9bMkHC4KiJL0OuzFy2Af6UPdrrAOH+x7USy/wx3W6r3PrMkb8Ex8QP0fLloBMa0OUfP6
         IjalQmvvfb9W7l+2d8eTln6yxTjk9vSGU44gq9fGPDOLjlQbnyrDprs40ah6SF6tCOF2
         D43w==
X-Forwarded-Encrypted: i=1; AJvYcCU9E84Ek+n4sp1vgL0FVTqDPdmOJUTo3/ZB4VFm9XEI9kDONM2BCOTVNlJiMnZKcSUt1JzdKQNMaEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YymMF8Qtm9G0ZnaLWhvEd8UjacMPT9iov+KJ7DKBzQIrJ08akOl
	L5KrT+YvhXqKyvsQT7lXMNZ88idHAnhnqd8gWl+Xgl0d8O0rENdbPLclfReFYvCwGWCWWzZE8qn
	rOirg2WWt9khBGUbDXvnqWs5RgDUMxg==
X-Gm-Gg: AZuq6aIkvo68yA2RWGSPINw4ccJELPWltTqipKv/b1/O7bCGUgt/A4BLEXYf9HGfOc4
	CQ0Z0lM3bZJmtMx9jJFvE/uoAEas1trJunLsHK63YTONEqLfh7RPxIxbt0kKI0JH2FerI/SFPkK
	L29ftssgFea8R6qXPkeI2syYUdwE/Mg7kt6LeHrut5N9RD+AuooIiPPqGFVacklCPyrQC+PV5F+
	5epwDOL6vQbZVRUj4zG2BUJtMo5WfzuZVihmWJg4Nro10ZhEXTGiHyMhxCTZtNwSfx3YSuByMaS
	4QOtC6CTs27OxjQEnDTWdrTuJkkJGrNxnC4t024G0e+cXKjFaGfg8GKP8g==
X-Received: by 2002:a05:6402:380c:b0:655:a20a:a258 with SMTP id
 4fb4d7f45d1cf-6587069c213mr2486327a12.10.1769424947707; Mon, 26 Jan 2026
 02:55:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126055406.1421026-1-hch@lst.de> <20260126055406.1421026-2-hch@lst.de>
In-Reply-To: <20260126055406.1421026-2-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 26 Jan 2026 16:25:09 +0530
X-Gm-Features: AZwV_QjUgod4A74r99ZxhhMNDurfLjL6lQ1hQ8sz2YOsyYFIfGBA-FWn3r3zY7U
Message-ID: <CACzX3AuJb887ish66TQLWyDezFBW0-XiuOaq6E624s9hxEBhUg@mail.gmail.com>
Subject: Re: [PATCH 01/15] block: add a BIO_MAX_SIZE constant and use it
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
