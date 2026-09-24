Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE624D09F3
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281855; cv=none; b=DMYhrcMQQIvp3/wJmJqdM4q33Oki6MdPoNmBrZFw9vsoJSGQYUEI/21u1Ao7qtzkfnaYJRcPKTX6i0v1uxjtqrLKgFuMoAUvqKD3rk/Bb5nMCvmGpUkLL5zg3wBXOaiPWsbTqUjqEInUliHS8ciqtL08XBq+JkZVZGCebUiXi7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281855; c=relaxed/simple;
	bh=sNCLes+Nr8GdiPL1NRKJ67LtvVV78+FJjPyBdyB2wRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFxmuRBdbrTePpMSZiiP025M6RxbVwq7iCNwHz7p8ELL8a8SqYl5EAIT4/PprlJ3XJjVf6VvZsPLHcYFjzLkGDqAoZxRSAEnzatS+uXKPC2wqTmr5eN0WmDbhGVEIjX+MAixb8vRdOAFGNAXkcLlYH5j1RbcoKNPY5/7NCgtsok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AFQFiSN4; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AFQFiSN4"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so1374535e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 13:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790281848; x=1790886648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fugK9KDhlq8AsbhsMEMofQRn39cWbmYkPHkf6oOk/Vw=;
        b=AFQFiSN4LvWI3pXnzyPspPlunwCiqhh23yojo0NW77B6hhwkE3bpceTSO9OE0S1P0D
         MNZVn1JvwUZaXrRUN0G0D2ydY/0/h4RJRRAWPB9RUgMxviY119JqiYWuUUoBhCI6rwat
         qE4yHuEGAeJRhVylPUdQJV86ym0nsItbQ251YiVhaCjekyI8HB5CNlqjXLMorb5gYU+h
         akIm5fvnuUudJwY2s8GafRkcM/Udn2gAnRZxVmjGKsGnHdkyU8NjPTAUqrgll2hwtiYQ
         SsKLuqstnCyIMWy2LMal6nr8Eer3yYo9z+Y2LBcKnTqlw05tcKZdYGeJpzJ+itcuZyXT
         CDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790281848; x=1790886648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fugK9KDhlq8AsbhsMEMofQRn39cWbmYkPHkf6oOk/Vw=;
        b=iOPdscah+lUxbiHo2tXHLKrtwusohDDZ8GivU04EaWBkjkHtyrPXhznsQwBJCEiYsC
         /B4NMBJqRQQEJ7M/ylkhp5IAIN1xiVtyjcJvRN0ZIQELMUHokPN5OC7lZpJ1iBbv6ps3
         STokbPa5bX44lKtPPsZrTPJTiW+l5f3lSYJ6FRW3qvQeQ7VVPUrW79M1nAPmT9BAPhMM
         9ikDaWaeyAJRRKyz3TI8qvIBiFu0wIeKpASXM6Q9KIn0sRnbLv/ViLCQwifF4YmTE/T0
         N2Nx+QNKipJrX0SQ5K6vrIHoFH62iY/pb2VZxbj4lM5hJBzF79/6lq0ro+KK7//QnmBM
         hmLg==
X-Forwarded-Encrypted: i=1; AKwUvBzFxRYZ7RYoEucitFFzyR0dLe5FXCH8x+jkxtm7CXcMqRrGpL7kntUR3fRaH8FDb6+uDu8KMFiBhdI=@vger.kernel.org
X-Gm-Message-State: AFuF++k8L1HFNOrTg8/PdpnOgWk3GzEp8pta/UOaKzp2hqrSZxrlCpO2
	ZE2+yxGsE45leZqWt6B2fZRbNhamctnBiXSECRt7v6zCUAwknU3RuLBC
X-Gm-Gg: AYBFou17klGOSI09CqfIr3stoQAkDmlDOfgSWFC1nYiEZTLrhZzfrc6fysYhVLVm+Pi
	dawakyvffxCBvP/pTPlOpO0FoJLwr4MZUUht5UZLNywlOG9XFYP5A5QIEbAy675aajVkKsV03pg
	FCTLCvKY1uHroBygI+d1pfa/spnpfcFxT8a3kpzIfIahrCHKfAmdJtMOYDkJ/R0xCV3JGGYOFKi
	0b63MUM+O8vAFsIQqUo/EicISMAJOuFpB0wr+gfsvbiWxXMZ7wr48MzSzWItW0gGefYGgrRpEAX
	1jEwuRnONne8HHfuYAExe3/ZuW6JIPZC27qMwX79EwP1h5KZCgKQupWOpfE/LHD4efTyVyL+wKJ
	1cp2Z693/3VJwMuincAHld66t36nrFlYSFAseJAWg8lEAY1lA/TYj15J6LJ15PLxXz/4uxqc556
	Kg1QTiKh/uBDMdVkJehbyQOUHlI0YM3LxwJ4gfsnqBMaUBP3knG0HPgewB9NS7z76d1YMpQCF7Y
	8nx6o+BX+9iirJeRLlamH7Wo9UN+unw1gxfuisbHQ8/m6oZxXHUItI=
X-Received: by 2002:a05:600c:1c25:b0:49f:ce78:3561 with SMTP id 5b1f17b1804b1-49fe66f19demr69766585e9.18.1790281847407;
        Thu, 24 Sep 2026 13:30:47 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30c43asm1720776f8f.3.2026.09.24.13.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:30:47 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: exercise a failed CoW conversion during writeback
Date: Thu, 24 Sep 2026 22:30:09 +0200
Message-ID: <20260924203013.9967-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924185449.GL2705364@frogsfrogsfrogs>
References: <20260924091338.198407-1-parri.andrea@gmail.com> <20260924185449.GL2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 24, 2026 at 11:54:49AM -0700, Darrick J. Wong wrote:
> If this is a regression testcase, it should cite a kernel fix commit,
> right?

Right.  The fix isn't merged yet, so v2 adds

  _fixed_by_kernel_commit XXXXXXXXXXXX \
	"iomap: don't resubmit an ioend after ->writeback_submit() failed"

and I'll send a follow-up with the real SHA once it lands.

> > +_scratch_inject_error "wb_cow_convert_error" 0
> 
> It's not necessary to reset the error handlers if you're just going to
> unmount after.

Dropped in v2.

Thanks!
  Andrea
