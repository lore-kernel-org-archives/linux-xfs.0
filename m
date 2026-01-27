Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971E2C21C2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525709; cv=pass; b=rjN4kPzBGc3kOMIE9kdTa0a7JFld/pWBM6PC7rM4jVCAgcdC8X+lFW3EU7DkI6yZ5rXLYQYtXRaiq1rWHLaBUqk/y5DzG75caAUnXi+WXbnkoE4kGjsyi7I9Ausm2r0vnhmyaOMWBCMx14W/62/kj+qVyB+9uu1RM2b2w6Zew64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525709; c=relaxed/simple;
	bh=t2ybBJsNWtFjQaIkqKJiX+bUT4FayuvonReDdoNdNG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Igp762FS/8FOZTJpUuQefj8HndcQPRfzzgVMRIgsqjEihbPqdXnGvZnw6sh3C7Fedp/BD7nf6H9xfFLxXn+AObSH0c46uyReIxz3fyq/mAgJQdumaufkYLIY66du0sI+7OUKsv0ZUuF9hYfz4mPeaxZAOoQgXrIqOENtLH7Wftw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvFulGeI; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvFulGeI"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8838339fc6so1095576166b.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:55:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525706; cv=none;
        d=google.com; s=arc-20240605;
        b=Gr5k6U8J1yBywhmBo8Cg7u4LibKvJz3Znj8Z0heh/ZpoH+HS6XsXGngF7Q7roaMJ8b
         kfHZ3s+Aawl33YG4mvm8ngd769fiLCOmMdr8/F2zPTdW+1Ob8ZFcWXzz+16J1QvgYeqj
         52TOPU84f2ariV6evlz9XZ1rnnTfJ2wCgllBdZbupTNiGpexvrPGHSgBkIq4m13qGU0f
         7Jf0ncxyYjRCmR4qmPnrC9LQaPMqFhP0nxyYcpbLrhLvqvGCQg9V0XAIYGSuDOaVBXU6
         Pxi9LQGJqMQQ+g0c7lexhUsvf94P7W1TuB7gAglfxn156Eo+j26TlokFP16IgOhWs4qq
         kNkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        fh=bvtZAmU7+iH7UIkwbpmBKp+et1nVtHsD1lAHsTz40HU=;
        b=ghAaXJorwuCV9lxhWoqjRoH2qQt3KiNC5gxXL3OtWyATHUtVTtzkFPME/bKmPnn4dx
         QZKlO8Glq8Yq/LsD1vLelxQ/LFuDhwXSYAUJl3GaGyWZCLejoYbjTf0naq9Ir5cr1spC
         dg4GBssJMlu2Zp5bpEnbeF42EOZpSJGD8LiQM301oB6XwQcU/cs6Y0tgx7Lo4TrtjHfR
         /IsAiN/bod95faEPRl2VG17qzEG7+7ZCJKl8ZYx0OaVs/e0CCE3ayFM4SCpWoyIiwiMV
         sstFtxUBNHaHAcvysy2Dmx6XP87BuEXBCfx/V0eciSZziH+ECDzi4HdbPcqeUvAIhxzq
         PowA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525706; x=1770130506; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        b=GvFulGeIrpJtBdSxwyjbfkhzgapKKMMVosbvI57UYBPI3aBbqCPmlDshU2BQeOeaH5
         nfKtfsgJqvSAr0xHpI+/qEtslAyIdDVwAJ8uMAL8caUYV7kCfHHx4iAthN9KunwhReyY
         PyZ9/BXHWpcqzo6bjfGxCyG+3DzRX+wtkVK+x0pz8VhEZwc4TUtpP3r9d8HJ19YJYDso
         +6utxDOUnhtIxerovJgQaRIE9joS5rywwPEeu0d+tbdGCH6OBFMiB9yw9Trq6dwJgnw6
         31xYd1sw5pCk+mkro2/D++5IYVlmCceH24urBYAVJBxqFwlS8/7GjoiiM6bDdVts6OrD
         YTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525706; x=1770130506;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        b=hWsVlEIjGk3SaQ0I22fFeK/+od3oEllHNVbkMIvH0LiV9uOhaz/7XHpq10B+ksWlGz
         ExbgScMrXvOiQSdeckSmqbXcyRwaZqxCDyz29CGxErm4RU5zJ6hXQT6tDAM76uiWxdrE
         zIVqBxt1TriiZe22UMBBTuatyld/ZKmp14BhOqwwTVDsW+KjRpPtd8dsedTv8smkocKl
         Xp6TgTysxYiB4SYV4vLyNTyksnqYTJGg0VUdKp9ruUop1kfHlkwrQYstHxVmRWLRXCmc
         seq6m1cbK1xhoGdbZPjDmjo6ITZFt7SJGD8RSSaqD7pn49lcvvBuyvuDkBIZFJxI3Eh5
         u70w==
X-Forwarded-Encrypted: i=1; AJvYcCUuyZzBze3KIduBsmJwKbyqUe9lI5N4jZR9DX6RikqxEjXJPPjsZrwltBgiWXqeh2qrorn+5wA5G8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqXtjIR2NQn2vsZ7ZY895LZWdeAPEvrttGRSPYMyFkPq6k2W+j
	t4dWWSvny+Btsffw8rPFFFB9f7WEErkUpcU3/M18tGRdtczji2cDk75kCQACSiiIK0A99/YLnyv
	gCao0HErF4BYV67dqPE8H+/cZ+Egmlg==
X-Gm-Gg: AZuq6aIjL5t0OpuYgTHzjZcHDpzG9oinv6qfcIuhOMNymWAirRddMkJWXvy4JNdaZ6c
	nQNbrZShJsvY8m13LKRZGraeJlvqNY7qAyjhvYwk3dsP3+4Fr5NXpifiasWJxtPtOpH3956O6lS
	GPnXM8m8jVkzdc6vXTMYyiN8rnNigbu1rPPkD8ee8YIOutJ9+2NK5eQgoMeQl9FDMByX/ylFj8v
	zPIFJBUJZDOFROC1OMtJQ+ID/2ZeuUMnsfGksLIEIPigbyda2HHlU6daoAu1R7i1o/nfZMtWAgC
	huheNeLmVWOQRAUCmEf5T2FU+oXuf6eH3E2UrskB8uEycrB7gNfAQvvgZw==
X-Received: by 2002:a17:907:2d08:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b8daca2128fmr161653366b.18.1769525705537; Tue, 27 Jan 2026
 06:55:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de>
In-Reply-To: <20260121064339.206019-1-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:24:28 +0530
X-Gm-Features: AZwV_QgrOpVy11EguRWdouecQbjVaZ_wK6fgRNHqWm4H5Y0Gztccb7HBO3aIMrA
Message-ID: <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
Subject: Re: support file system generated / verified integrity information
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

Here are the QD1 latency numbers (in usec)

Intel Optane:

Sequential read
  | size | xfs-bounce |  xfs-pi   |
  +------+------------+-----------+
  |   4k |    13.62   |    7.2    |
  |  64K |    99.66   |    34.16  |
  |   1M |    258.88  |    306.23 |
  +------+-------------------------+


Samsung PM1733

Sequential read
  | size | xfs-bounce |  xfs-pi   |
  +------+------------+-----------+
  |   4k |    118.92  |    91.6   |
  |  64K |    176.15  |    134.55 |
  |   1M |    612.67  |    584.84 |
  +------+-------------------------+


For sequential writes, I did not observe any noticeable difference,
which is expected.
The Optane numbers at bs=1M look a bit odd (xfs-pi slightly worse than
xfs-bounce), but they are reproducible across multiple runs.
Overall, the series shows a clear improvement in read performance,
which aligns well with the goal of making PI processing more efficient.

Feel free to add:
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
