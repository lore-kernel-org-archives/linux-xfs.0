Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E073587C2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525888; cv=pass; b=BYvvNVHie3nnxwNptnauh3WptJ9XEb29NsoA9xo8uCI0LsK6N+pUDLfnTerAk8951zJvGNmLl0/PcnAx1PU9kYY5ZmNCAa96JjjOGXJNNnMldGLfSE6BZiu+s1GQWti5iqF9fwsNrRiZx+0RDl2KONxJtF7DD4OfBlJDeb11ZiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525888; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WjdRpv0m9QLI7xCkgkM1IWPcvomhMOdP6b3eazr1zQacFPSySpkT9eJ6r/98jK5KMPSuNrkvsYdJVNt3D8mIYpgWN2J1OuyrXWvsA56mo7cN5OstW+ccqB/5KlU77fySwqK5Kjauf/gJQC5rbqS3k1jM7sYf7fL98vZxXmAYSWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZ1uuKOL; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZ1uuKOL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso9370396a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:58:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525885; cv=none;
        d=google.com; s=arc-20240605;
        b=LttiUtPS4WHq8RR5IaYwMjpcTYI2OWzZYRUoaWENaIlx8E0YCc7zMgI9M4NDiss8Wi
         ZBvQkqJZclhQar5YrNg1sYyGeUH+prko4ueV9moX3mFjvy/4ogHeSae1XxyGcdjPcvHU
         /TdS1n0QsPPjVmy33LwpzQHrqusXUl7WyKoYIvt6Y5pU6YB3MdYpTlNOelXz5MAZmwfw
         /2vXrBElZi2EdmG4gN2Dv1LRKQ4JlSAGkEkng2OZnOdRABuBcRra4NeDLxFdh5eyNrYm
         AkU/iimB0v0Ljl7SF/pdu+h4OOu+wHK+7A1YqP3vpYB9f0dglZJt/bCW4dB2soCKEi2f
         2qeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=02cF8Ws+23g3v3u569qidTQ1GetoOf8Xm794ug7jkko=;
        b=MNds+BQfxZ7TmEjIWA3Tn2V7h6j0IO2fvlXEKoEPCwgj/4/SGp85Zl/oq7JPMGwsaj
         AP/F2LUKMGRWBFqWBR87K09/679fZGD1+LHbcy7SsnDau7fWoy2TuFuUaCR2kqVpnLwo
         qT0hTRwSq3QCW2bF4PRHOVJ1maXF8ehzJDnq9sA8o9fDhmhsiI+38agtuA6ALJImM1gb
         BkIOhFQC2D+qMGxkcIYBzPK8nUsjAyY3rQ9S9s/jdvF6ODhqg21YWvKqj1HGWx5HBWfC
         6vxFFrvsbA0GttYMbfALTlFgGgUL+1X538gR5DtqzQRLASxRb/cQyLdqTdd9cbp/x7+z
         LYzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525885; x=1770130685; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HZ1uuKOLTv3GJ3SCTXzF2cAvg/yqb+tw2b02AlJm0yuQ/Nxqt0IoBLYbwtMkgWqyxG
         AJcyeCGAIi1aMZr/hPZzrvvVMcnN0+Lz1NJyvOlrLKvCIeYS1tE2yHf2oYDY1r5TsdW8
         GgYLJNo9lCxnXs+1jB+2eyaxsV+MrvvtkgRSL0EYS0Mm57/GJOtzWgmTlZvH2k7w5Yxs
         Cw5hOtl7RGyKlL0sQgluLIohVz6KSD2kaU2dFqT4nk1PCUdjhulLjfWqZbNSAuBU2sKN
         el4TNYmrq567bSYkZgRfj0eHb6EKvh67J72XO92eJR8VUXdSqTBWOiLwGZ4xMhC3Drgv
         zRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525885; x=1770130685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HpmWhjwpzr9DkYXYwWuBpgcHwvi1rdSvkP/X+N1gPW3edVYCvaeIb8g4icm+6oqJS1
         vco9p/6tWbczopCb8e7gW688+O8wS6kimgk3vDyyKENNhe78L5UAhpMuQPK/+MnbuHF3
         /Jn/+Eq0/BGqeWms8jjea78zdfRuoFxDAsQw0BSW/zs5sStDqp8Okewjt1YOnVavMU3R
         pJbaYGjW25zP0J/LFFrJct+aOOrD/mXjbqJ45ql4DimYJwTwdDaA/a/YRPm/UxMLgr7D
         bE/wtsZiy8tyPRHviNH4wZEMogeUbh63wN1Y2/f3lNjb7IrEl4Yg07EOwpggNPbLcuxY
         wONg==
X-Forwarded-Encrypted: i=1; AJvYcCUeBgwqpNEAAq8yDBHjBfM8aSwrA8UWBVa1R8terbKLvXqH6IuJ7YBwaKzt8XR2uQ35pLLmaqxOwhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxraJQCMa7/3NXb3aAKJsP/hHJb0U4z8W5qVw7luO+Eji45cAha
	i/bsYgbJ1/ZETqkyS0H9cjv0K5CfFrYOA4S5hIrLNCnQZIP5lMABoYAcUNF3W6ItoqPzREwiDrK
	bB/Z7LdhGOUcW7V3VLOxhYPyzNn/bYg==
X-Gm-Gg: AZuq6aLqVODqnBWBf9nz7KIkXh/iXGJLUo6Uw0SmJb+oqcUNGC0YLbDjvlROXh2Rst+
	OPaqz0sM6D4oyQRgpzXCC9xYna3ihJpU2lftvlC+xNXuZ6/yqDKibLKaGmgrmcfnUA3DblQYDWt
	ufOa395mWd7KWdvfCJXtRXvhZScyYzgGE1eiQQ9NY2GX+b6gU5uOATAdmwsVSULGWcfTp82h7g3
	K7dSBs2uSAmw/Vg/npfEuskuvZKl4+jTF8B/hx6C70lK6QvrYSyodUw8VZQD4HHPHC1HcMfkmCt
	pFIkEctaGz1LvpFtRjLMrh3RDwmE5vJHaIajEJFNNhHrJvwWIP5aBviwbA==
X-Received: by 2002:a05:6402:3990:b0:658:1b1b:15a2 with SMTP id
 4fb4d7f45d1cf-658a6015a38mr1102233a12.7.1769525885403; Tue, 27 Jan 2026
 06:58:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-8-hch@lst.de>
In-Reply-To: <20260121064339.206019-8-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:27:27 +0530
X-Gm-Features: AZwV_QiLLibbUg0iWqpfZ42-4rmvFtl9Ak5eBKgkKHdzZSGOKr8Fr4xqlZcQZ0A
Message-ID: <CACzX3AuFkVucGMbP=YQTB9AH8J2iBzzhPW98JSizDNChzV2HuA@mail.gmail.com>
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to bio_iov_iter_bounce
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
