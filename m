Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9490D21CC49
	for <linux-xfs@vger.kernel.org>; Thu, 29 May 2025 11:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748516923; cv=none; b=Ml35x6dumt1DYUhIUzv4gZVWVoA7l/TNiBvPmuJwVT1oUWvS+kINQbwj+vvHKbmT1xgiDW66aGZvbCSeNckEreJwnAUxJ2L1ZM0XMXFuQc2K0BA15/NuDIuFvCN80pNfEqbQ+Rq08Z4hP8oRhkpqXvLmMcJGgho0mP3+AzDVHEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748516923; c=relaxed/simple;
	bh=iZXzYIN24F+pfwiPreeyCICuGYF0+gjllr5OGeYyNo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=muUqdBmGLwl2fzylGuVs1u39tm23TwY+qG149niXKO16ePDEnd/K03XlMh/1qN+EmaAFABF1JLS8CpcAwI+mDXp4NMHqAJ4rnDuuWDXypO018S1s5jVV3NNIJCp+/z8J6KWNpnEG4iTcfOyWd3Io0xpIp1C51ekrREt0XF1ktu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=SCSJn2XA; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SCSJn2XA"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47664364628so9814481cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 May 2025 04:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1748516916; x=1749121716; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSIOhXayNlFILbJyHd0DZBYxSCjybVEo0ScA6s5GuO4=;
        b=SCSJn2XA4FHAGn+eIW2a5t1NpuvwXbFNyKzfsExHoawZTjgOKmKMmxHnmrCuc9aLw0
         MQR77GwTuvusSSMvUhkoTJ27aweC5JZ6fCijJjR6wc20gWOduzVM5SeQC0j6dn0/AgRt
         0G12efR0QT0m1f6UDcCSRgtXNCl73TlREEQ9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748516916; x=1749121716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bSIOhXayNlFILbJyHd0DZBYxSCjybVEo0ScA6s5GuO4=;
        b=SekPmoRxdAg/AldJ4H5GcA/fds2mmI2sYEoMxrZQMPdyBgZIjrXS2KqX3rKbIini1J
         1JO92sQCscsiSCoSHTuWbf/ztstPtLH3qmMoOfsUxAHPbJblwWYSNQo+mFmxBhnrIhXf
         ASB4jol3mQwtPdj3I9iNVexAAUdvQDagC4vlJZmoIBwJjRMDQjAFU86KJLMUA+fyQyyd
         r6twJvcjLuWv+odDMzevcqDiscDL89NwmZxG92+wIhXB8E/55SirULNfLqmLxyWih1bO
         xJ0TAFzqrNslWfhuojCFvtz5Is32f/c2baxuvOKsyqUnvThOReD94pboYdl45ZSY4diz
         Q2Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWpHSDbt8VTIVP353dHbBbCDY4sOfsC6fvyUDAK+qpuNyFCIS43As/FY4w7dz4b6LthR9piyOzWcB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgSYxYf15tJjSEykM08j6K7zYn3o9pnwvPlJCxfRAaRLWz0oco
	4zt2UR4/Ssszf7eWg1xbYl+uhNSy3xsqDhhH6SKU5D5weiMwFhHfHYPiwrlAjf/SgYjPxFa/EF5
	ed2f6DLmJYUzQh69jNhYSQh7glgrxPAyzRMNTIf4XQgEU1H51zw4gPXA=
X-Gm-Gg: ASbGncvV8ti/QFb+S34foiZ2CaTZgtAbsseihJ3Ibpvcoskb4CJfvCiboIiY/PhpAgX
	vnXVBpzRRSzL6Yx8w7R0TxJZ7+14gHqItmwJzKZ+1XjIddew+KqmJMedLPi4RXfmD+UCRkm6tk3
	ViRmlkOfdw5AYLgtksJOaSPjsuzvqJdcT3j9c=
X-Google-Smtp-Source: AGHT+IHlzCsjSSqHlzTxy7r2hlBRho9lgiOx79Cr6d7xOtkTOusmDdlVRNa6VE5LeFYKFaq2SM0bs2rU/vrX+UKzdM8=
X-Received: by 2002:a05:622a:5792:b0:47c:fefb:a5a with SMTP id
 d75a77b69052e-4a432271477mr58424581cf.11.1748516916312; Thu, 29 May 2025
 04:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <174787195502.1483178.17485675069927796174.stgit@frogsfrogsfrogs> <174787195588.1483178.6811285839793085547.stgit@frogsfrogsfrogs>
In-Reply-To: <174787195588.1483178.6811285839793085547.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 May 2025 13:08:25 +0200
X-Gm-Features: AX0GCFuAuuVaLVkR3Pb8Pqa6RMkre6YqoMSXl4YIwBe52nOpviwbCOiM6rWjirA
Message-ID: <CAJfpegsn2eBjy27rncxYBQ1heoiA1tme8oExF-d_C9DoFq34ow@mail.gmail.com>
Subject: Re: [PATCH 01/11] fuse: fix livelock in synchronous file put from
 fuseblk workers
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, joannelkoong@gmail.com, 
	linux-xfs@vger.kernel.org, bernd@bsbernd.com, John@groves.net
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 May 2025 at 02:02, Darrick J. Wong <djwong@kernel.org> wrote:

> Fix this by only using synchronous fputs for fuseblk servers if the
> process doesn't have PF_LOCAL_THROTTLE.  Hopefully the fuseblk server
> had the good sense to call PR_SET_IO_FLUSHER to mark itself as a
> filesystem server.

The bug is valid.

I just wonder if we really need to check against the task flag instead
of always sending release async, which would simplify things.

The sync release originates from commit 5a18ec176c93 ("fuse: fix hang
of single threaded fuseblk filesystem"), but then commit baebccbe997d
("fuse: hold inode instead of path after release") made that obsolete.

Anybody sees a reason why sync release for fuseblk is a good idea?

Thanks,
Miklos
