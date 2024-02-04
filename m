Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADD92C68A
	for <linux-xfs@vger.kernel.org>; Sun,  4 Feb 2024 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707083792; cv=none; b=YcoQbcaJcUFRKegM7rUJvuJ0pBu3j4zFYmhnE0gZNaoSpPiu6HOKTvSQXPvHeFXishMQS/oqpsp7xafTI6+T5Z3rgUNgrqgfcAaoDmoFMUVtvhIK+Zp/9xgC1YlPwNWfnVYvXlEcvdW1twFKrBqFCJ2kgcAiYG0Y95FUzoFjxFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707083792; c=relaxed/simple;
	bh=z6lhWHez6twbOS8iwDDfYzDVKQfuCWDYvj+I0TVAxQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYh9Vu/bk0HUIkh+S4emI1Lpi8yxSUkHd7kMEDKB3MWFFjIo7nAGTa+Aqt27AwqBGjPd5grq6NbRd6Xq50kRIRBU9Bk27U2UKBu4Mx8ONFFCN6AieVg1SoORi1eYG7s+T1WURbL/fhZG6fy/jVqOTi4q+4pDVIuiTdQZFCaphmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=L7q2By2c; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="L7q2By2c"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d70b0e521eso28841325ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 04 Feb 2024 13:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707083790; x=1707688590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NYgUGHSEV5G7bTmc/Dzy4/S08ihLAdaqJvIX0KncX7I=;
        b=L7q2By2cDTGBQTivLA2I8jTD78K/Z8XFGhYF/uXm8CgFB6BM3cI0JK2Cm8TVw/+KhK
         SfJCqufRwY6tBcBAizfIjCr03/hB3WNfWNkdKkIiUVf8wHzA6vg4J+ZJI63f3U/PQBl0
         Uru9xLb+s4hmY9FSaF0nLvovN8z9HShtOlB1VVuXVgyHdyxKsBOjksO2j+wQ8WnfOIH1
         jrdLG55q1P5KGkVbpivDEhauZ/yaXpZMfmGxcXWYdAmRZqoptvAYeprnbhgXGyJ2KiDb
         +fPXW0sTqMdSlQOmWh7bnxY5RsOVUfMt3LTQeW4C0AAIIxx8uVwu6S/jXnscQr5L1DUM
         jIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707083790; x=1707688590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYgUGHSEV5G7bTmc/Dzy4/S08ihLAdaqJvIX0KncX7I=;
        b=V5Eh3M9doNn4IAOwMagYQ6yY/JkFKJEFjk6C0qdsMIrGgjzIzUy7C6o5ZONpTT+Gdk
         9OkLoHuQsvgGZRjsMuFpfiSZyJeZG41o9XQ3+0GVVGJyWOjCcU1oTyDbIKfK8WKM1twI
         LW6gJYtAqYwA2TkBvP9Fe8XFKLCrnoQoeMV7pgzSlWB0JKhF/xl4lHtsKJc74uvZiDXZ
         PzH4od2okQ5d+yBBBJ3GezpWVfPXS+wa3RryqzgKSb6JokI8QzSTHe5FUaqr7OCirheR
         qOoNVXcYxvVOqZu0S6suW0VekbUW5QqT0FsIsjxiNPjCwZKqvsWDgCpuuDQt8REeLbPm
         b7Eg==
X-Gm-Message-State: AOJu0YzaAhPZzxUFYT+u86UIOiy60iUeBwvhSnJmIlMEpziaDkDmnECN
	a8FHTo8L+bG5yNkPOcLy6JH4uizKzChjlncaglUbWP2RLCX2/5lcM3Ver27dubarrgRa76tU5+y
	P
X-Google-Smtp-Source: AGHT+IHQH1SvNUdcJ2NSSjVHXbOfJUFCtGaSBH9aQgrDJqSAeKQ8m6IGElCLoNAW0Tq5jGHNOxnebA==
X-Received: by 2002:a17:902:d34d:b0:1d9:5ed4:ec07 with SMTP id l13-20020a170902d34d00b001d95ed4ec07mr9610821plk.52.1707083789687;
        Sun, 04 Feb 2024 13:56:29 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id ks13-20020a170903084d00b001d8f3f91a23sm4992064plb.258.2024.02.04.13.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 13:56:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rWkTR-0027DQ-2e;
	Mon, 05 Feb 2024 08:56:25 +1100
Date: Mon, 5 Feb 2024 08:56:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [QUESTION] zig build systems fails on XFS V4 volumes
Message-ID: <ZcAICW2o5pg7eVlM@dread.disaster.area>
References: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>

On Sat, Feb 03, 2024 at 06:50:31PM +0100, Donald Buczek wrote:
> Dear Experts,
> 
> I'm encountering consistent build failures with the Zig language from source on certain systems, and I'm seeking insights into the issue.
> 
> Issue Summary:
> 
>     Build fails on XFS volumes with V4 format (crc=0).
>     Build succeeds on XFS volumes with V5 format (crc=1), regardless of bigtime value.

mkfs.xfs output for a successful build vs a broken build, please!

Also a description of the hardware and storage stack configuration
would be useful.

> 
> Observations:
> 
>     The failure occurs silently during Zig's native build process.

What is the actual failure? What is the symptoms of this "silent
failure". Please give output showing how the failure is occurs, how
it is detected, etc. From there we can work to identify what to look
at next.

Everything remaining in the bug report is pure speculation, but
there's no information provided that allows us to do anything other
than speculate in return, so I'm just going to ignore it. Document
the evidence of the problem so we can understand it - speculation
about causes in the absence of evidence is simply not helpful....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
