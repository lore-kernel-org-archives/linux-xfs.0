Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D702D0602
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778128476; cv=pass; b=QH4L9i+ikbyaiqQEsJq9qJI+lMUyJdb3ZLcBl5eU73HBfXR4cHiXx2siks28fND125+9Vzi9vGlRpb2i8gOYnsJ5wz2dy9zQqmL1S5df+RpUSpOnb4MxKtB72nA1JSLat8zCpbZyIP7ENmPT4VN28ZR5lJC4aZlaY4HTLr3qxT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778128476; c=relaxed/simple;
	bh=EorYpq9wF/HdrjYHA1tzcq8jWoYkNPShOhC9yniOCDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gMUpTSQa99cO7cq2n/TUNK6TMGEwyAOiYZOH5DeBRH5qkj4AMz68m8g+nBUw5riu6dtWavGZ1q5DiqLiDCHC0e4qSoXp4WuJgHvlt6KYbdVk37V55mJCjAS+/W5TxBpBPQp1D5HUaUbz1FrsOKfXQEKc+I38Gr8QHQEeCKJJ/Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOn2sUvu; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOn2sUvu"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so3409517b3.2
        for <linux-xfs@vger.kernel.org>; Wed, 06 May 2026 21:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778128474; cv=none;
        d=google.com; s=arc-20240605;
        b=JeA0iglYu+JTAoJytah4tMyvdVIYQyxLFIhQjZdcDJOWv6ub5A3yiK4vs1DrKglGzH
         i26ffUSBszuDPUMwCj8oRgyjb7h5/lyUhrMxpSS0OWilXbJAyn591IJ4+VM+s1a03Kq9
         n6xVa0qEOc17PvCceYaN2+fAsY4wh3C7M7dgRN5jIuekX6Fc2iLcYRwGmt0MauDkXfap
         aqWKVB/0162smxXOSi5fTJunHJxTpwr6j5w+52SVoygw9CgdTANI+wvaGDKVd8bxDOgn
         xTFxAXND0+AW9fITEDTFv1beV56NtA+5UEueF16AMf4Skxo5nFNYIerYGIZfq0/A2xSA
         0oew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EorYpq9wF/HdrjYHA1tzcq8jWoYkNPShOhC9yniOCDs=;
        fh=S4bIYNUcIKXICphJHKcxEWtPPSMQEEhLNr1urIxLzUM=;
        b=ZuJi7uOQUz1Rr+f8p7KgDy/fOzXXp3BjcOlQuXJxePthcttCgrL4fSOZJy+/BioaKE
         5gr8fQDxgiys/5b6yURWy4+Qdb7fxaMYOiYDe4hlKRS9YAymLFOeSi43d8MHezCAoRvM
         xAmA4tYgW+4NZ1KRBFzaA+LWud0mLyRV6wPwccEyXaVPxR5n4f7W66DUwquGCExBqryc
         BsjYQ+ex8YRCVg8xU2BUl4IrzPfs5lnbSBTf3WhUg+klJsV4RGXTGDOw+3NY1IER2ouj
         Z+7B62yJD6QmG+R4G2x3np1mJ4mrfkg6hw4DQ0OSPiWoyf15kn8RvDXisx3DDf5k5ZhW
         MeGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778128474; x=1778733274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EorYpq9wF/HdrjYHA1tzcq8jWoYkNPShOhC9yniOCDs=;
        b=pOn2sUvusexLMCj2L2lef1oM5AtB39aL4dHRuAKB00tuk3MHaA407OfBXf12qcPVli
         DLtCHIeMTrjbFRewXkvGFmCOkHK1mEbGDxjz/crRXA8XUEFRK7xaPUYXSWikEERhKfMU
         pQiZZTML9OYFFvDPI/mhDhDueQrBeMyHbb5yVEw8BIRaF18os0v9/m3Hg40XaxEeqbB5
         b8z96ZbesoLGfk0iCIvgWPGKDhup4OxifnJLgs4R+Pz7n2uE3hDSXZG6Wq7s8MdOdo6M
         KOzrvVhGbCRFk6/XEAo/q+HE/zLLZV/K2Mqo4FAPUyE0DgG8ZK0bkOhvSnvQ8fk8T7si
         v/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778128474; x=1778733274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EorYpq9wF/HdrjYHA1tzcq8jWoYkNPShOhC9yniOCDs=;
        b=b6Iqj62TYg80kE4kmQapmX6JjbwGxXeLnH68T3rIRNUAoWPqzN0wtd2Ubxp/hJ2XYv
         pCuOylXTrFfzalMrjmx5R+jHhk9zi5MZP/w3gvGSXokd2c8nxw7j0PjvtSKeeM9AwpFb
         A3UmqZDaBQWoiDwUwQYGsDzPO18m9z89StS41XwT/dpdgxR1lAwRY+KqHrwIAkE9NpId
         9+5ztp8eTb8QGLwsR3WVcpbNqx8nr0JruIpzxlVjWoSnPTNddQ5UYCf0NdTDVJc990+q
         5vy8x3qPYwqv20O/rq9WDFZ3FfSbQIzdKOUa7GXjoynq08KrxNR298um1QuZ9Tgxuc4k
         rG8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+fIxN3qzmGbfqAPTNBsxRs6ISCQQMAorwrnfAZXbZDJ1a1G8+BE2cs947Ub7B6XpmYa6nxrlf67n0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBKXBcZQYQkecDZAckydfaozcSdlMXYZ11SMOvpuzSbRBzgkuh
	peE7Y2lapWoiUfqFjG6f3ISk/YVs6v9cVhd/JSqoMCKR/zA2/nF9OLevp0vIVNW1tN0Q4MfHUja
	9hyzWfYNNWP9qu2+31zOsqAfSUZNWBWM=
X-Gm-Gg: AeBDievDBlcZP/fCkxVJ/tfUob58CCzPlPs/WKXHeyDbuelUJBOmKrm3N3mBTLbr9Tf
	fK5Jcdhf0yrLISsZuq0cxmg0xcqBliKoQtPYLzkwPxiPhNNGOwjwoORGC1UgKa7W4aEDeRrwv8E
	1En0PPyA2Ij253z/L2vMZ7iWkVkh3M5VgdzqECIlNLwjq1aLBwBwfSeG9CbbchhwuBrtj2u5SHA
	SyvyoAEammU5sk2ZpvwUulp7HqRSPFhMYPl5BWisQxvzX1BALZoQkupPHiZKEeF1CVmZm0bsjJz
	r/wU3IPC736o4AJROqA=
X-Received: by 2002:a05:690c:630d:b0:7b2:6177:2acc with SMTP id
 00721157ae682-7bdf5f3b3c0mr68418377b3.46.1778128474190; Wed, 06 May 2026
 21:34:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260506015811.3420895-1-zzzccc427@gmail.com> <afwJ-eNE-NbSjRU6@dread>
In-Reply-To: <afwJ-eNE-NbSjRU6@dread>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Thu, 7 May 2026 12:34:23 +0800
X-Gm-Features: AVHnY4KL7csAyAF44L1et_tb-nEAP79azAuvF1-hLRiH-SIxCXsKaHpgjL50vE4
Message-ID: <CAFRLqsU-_omAuPFk+oXB1WtoH=_GZZFMg4bpXv3EhbzsjLt4VA@mail.gmail.com>
Subject: Re: [PATCH] xfs: snapshot current CIL sequence under xc_push_lock
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

Dear Chinner

>
> Which does not matter at all.
>
> Integrity in XFS is defined by completion-to-submission semantics.
> IOWs, the only thing that a CIL -force- guarantees is that it will
> ensure the current CIL context containing fully completed
> transactions when it is called.
>
> See, for example, __xfs_trans_commit() -> xfs_log_force() for
> XFS_TRANS_SYNC transactions.
>
> So if xlog_cil_force() races with a push switching to a new sequence
> number, it means that all the transactions that were completed at
> the time xfs_log_force() was called are -already being pushed-.
> Hence all we need to do is wait for the CIL context at that sequence
> to be committed. The new sequence number, by definition, contains
> modifications that completed -after- the log force was started, and
> so are outside the scope of the current force operation.
>
> IOWs, we can safely skip the new sequence number in teh case of a
> push/force race, and the force will still correctly wait on the old
> sequence number being forced to disk. The race is benign, and not a
> bug.
>
> As for xlog_cil_flush(), it is a latency reduction mechanism and not
> a integrity mechanism. We just don't care about racing, because the
> caller will call it again if sufficient progress wasn't made by the
> previous call.
>
> Hence I don't think there is a bug that needs fixing here. Yes, the
> fact that deducing it is ok requires understanding
> competion-to-submission integrity semantics, but that's kinda
> assumed knowledge because it's exactly the same semantics as we
> relyon for data/metadata ordering and integrity w/ O_SYNC/O_DSYNC
> operations...
>
>
> So the change is likely correct, but somewhat nasty in places.
> Regardless, I'm inclined to reject it based on "if it isn't broken,
> don't fix it" principles.
>
> In future, when reporting problems and fixes like this, it is very
> important that you say how the issue was found, whether it can be
> reproduced, hardware configs, etc. Presenting multiple fixes in a
> short period for a wide variety of different conditions in extremely
> complex code without any context of how/when they occur or what
> impact they have on systems smells like AI slop more than
> anything....
>
> So, please document what tools/AI are you using to find these
> problems and how they can be reproduced. I haven't commented on the
> other two "fixes" you've just posted because I haven't got hours to
> dig into them right now. You also posted a fix a month ago for a
> race condition that wasn't a race condition in buf log item
> handling, so something is clearly directing you at them....
>

Thanks for the detailed explanation.

You are right. My analysis of the XFS CIL checkpoint semantics was not
careful enough, and I overstated the possible effect of this window.

The report originally came from dynamic testing with a customized
syzkaller setup, which observed an unsynchronised access pattern at
runtime. I then tried to analyse whether that pattern could lead to a
real correctness problem, with some AI assistance during the reasoning
process. However, I did not validate that analysis sufficiently against
the actual XFS CIL semantics, and that led to an incorrect conclusion on
my side.

I am sorry for the noise and for taking your time on this.

In the past, when I sent more direct/raw reports from my testing, some of
them were reasonably treated as bot-like reports. Since then I have been
trying to better understand the reports before sending them, so that I
can submit more useful and actionable issues or patches. Clearly I still
got this wrong here.

I will take your comments seriously and be more careful in future
reports, especially when reasoning about subsystem-specific semantics
such as XFS log/CIL behavior.

Thanks again for the explanation, and sorry again for the noise.

Best regards
Cen
