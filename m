Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FCD3207
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 03:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718939355; cv=none; b=RHtofH92T3TIOpYva80ogpsikQydT/biRgVlB+EqTYaBiwnkfe7vm5x1XYLF9g5VuVSmAgk6z6AV4mqyApBUSd5WOSDcogkP5GBY+Kv0nH3pMGNeccxPZvlCkTcC/fmxKpvIF42md6yR8EqYFdRAh7QWM6hbpM5a3cbJF3GH5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718939355; c=relaxed/simple;
	bh=fVfRjk+dF9YVaKbu9nx76f1cZMUkpMpanHZf9KDDAkw=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:Message-Id:
	 MIME-Version:Content-Type; b=QGZcLysgloSSUE1zdyHVYZV3sle7pzMOkK1Xo1MD/X7YXHntKSA3beGeXexHybpNtD9onNb/FpuUjgtrjvK/yLV4FWO10be/9Zmw1rY5u7tOB8Xq6siY8RAm7VS0dwfNd8DU0qKRLNPyXNWKz+Dwo/4J2Lq45quHQN27xb1wW9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mh+dx6LO; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mh+dx6LO"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f44b441b08so12240805ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 20:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718939353; x=1719544153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :references:from:subject:cc:to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbL1AO77r1EUbppI/v7MmeuVUKO0UeDK+8WIfPX/MPs=;
        b=Mh+dx6LONJT8WgikMmpHNoi23p2KL4yiQz6i91Jh/D2fg7YDQxB5G51DQK+pPP6Hm+
         pXFc0mJ34NhI2SSAITawoKGU2CxcEwXiXmNoMKtKmuH8r0czpNoLe9mBHUU5o5u3aqBC
         X6aUGyzWcLf5xXR5I4rJZYqFiKEFYzYGry1wCBDsENzfd+n7YxdJBlGGKT5/UqgycnWh
         pKOSeoihIBOm0j/Z+DgCEpnO4nHThWxQJblkCt34tVafVPHSFF7+angogrGiUVo5RyDI
         MdAFylmQbf1+Hvo5BqtojWJzKdLkARFccjLkL51UT9gC5vaYgrmSN0sdQcFtnif/QzB7
         9m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718939353; x=1719544153;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :references:from:subject:cc:to:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbL1AO77r1EUbppI/v7MmeuVUKO0UeDK+8WIfPX/MPs=;
        b=ZgjkbWT1PT6STNCJkxOSXW8fuo2ygJ+SbvwmbR8HRKt15F01vFT6A3I8Kmo+K8Bv5e
         YqYzj9CjzUjFCMi3YuDxfh/5iYZ+VV5i+1GYSVh+D4uKeNf1/0OyD+1nQ0Oa8SFBFyFE
         T2dbYe+Nu/oCNbZ1CZ4H3CGCty6nOhYujOOEedlP2d2yCCnZDXfx/Sr4iYi3aDtv4zAC
         XGAl3at01xWbMMv1/i5pvJM8zWK7iFQteRc296EZfeoF4CNuo8aQqpR1XEJH7NLRU8am
         VPD1VaAOCswiaLmeY8zNHWBTI+ToLNVbdKKguuB/HpUzTHKrATi3wOJNuQ65fJzmeQww
         uulw==
X-Forwarded-Encrypted: i=1; AJvYcCU6icBAtMJAQC13q5bsLsx6iMQHMACN9MLBVyAFUvzL0DskgvZLeIBpoyPUYX11HEl3lcjswcyeDXx3kRKiTuaIU9Tx+xqivgUV
X-Gm-Message-State: AOJu0YxupX4hR6q2MA4qpFUW9chKl/xcJL3royUqQeUCnelSansbOxCk
	Db5/0ALbi2ekzuciN79qbCb1f3VvQMbkB7sI8/KfLswdOOjOiqUaTCaZKQ==
X-Google-Smtp-Source: AGHT+IGZLza36M1m02Rfl41J9JPmNyPwoI06nAObMSZAaxU3xh2GOfSeD+fIENdYBlD8h8inlSMelA==
X-Received: by 2002:a17:902:e54c:b0:1f9:9691:7b9d with SMTP id d9443c01a7336-1f9aa3ed80bmr80949635ad.11.1718939353014;
        Thu, 20 Jun 2024 20:09:13 -0700 (PDT)
Received: from localhost (mx-ll-171.4.222-32.dynamic.3bb.co.th. [171.4.222.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5f5bsm3553865ad.146.2024.06.20.20.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 20:09:12 -0700 (PDT)
Date: Fri, 21 Jun 2024 10:09:07 +0700
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v3.0 5/5] xfs: enable FITRIM for the realtime section
From: Konst Mayer <cdlscpmv@gmail.com>
References: <20240620225033.GD103020@frogsfrogsfrogs>
 <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
In-Reply-To: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
Message-Id: <3UX9HUQVFM4SL.33XVNIAMTWYDJ@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

Thanks for the patch. Is there a reason why it is not in the mainline yet?

Best regards,
Konst

"Darrick J. Wong" <djwong@kernel.org> wrote:
> Hi all,
>=20
> One thing that's been missing for a long time is the ability to tell
> underlying storage that it can unmap the unused space on the realtime
> device.  This short series exposes this functionality through FITRIM.
> Callers that want ranged FITRIM should be aware that the realtime space
> exists in the offset range after the data device.  However, it is
> anticipated that most callers pass in offset=3D0 len=3D-1ULL and will not=

> notice or care.
>=20
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
>=20
> This has been running on the djcloud for months with no problems.  Enjoy!=

> Comments and questions are, as always, welcome.
>=20
> --D
>=20
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=3D=
realtime-discard
>=20
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/=
?h=3Drealtime-discard
> ---
> Commits in this patchset:
>  * xfs: enable FITRIM on the realtime device
> ---
>  fs/xfs/xfs_discard.c |  252 ++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  fs/xfs/xfs_trace.h   |   29 ++++++
>  2 files changed, 274 insertions(+), 7 deletions(-)


