Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792714031;
	b=Z0o2UJrrt44ktzdJV7QxSUXGRUt5FImTbKtjGBMMJLWthwFmbVoDEJs5V959NS2zmR7y
	 hl7Ky0EPOY8voJ13G2lTYoMgVCIwy+nyFjJ5Pu1szC8FL3NI8rZQs0CDYhyE1SaVKwHTu
	 mZPEmPzzywXCF07yy/3PzOzC/HSfHaB/cE6kh0be5o/gpXM2cZcx7li7pyQGdf5oPKZ9Z
	 KJfKPV2Gstlvuk7mXwh3Hwcc37iRH0hE3K+PFvwWXmw882twPL27RwqaF7Y8I/BU1KnGD
	 WGkZfzthh2XxuNC/C7MyPUb/5RnPbpoADxpaLW1GT5DU4gk0osAWtRqXRBwQVrNAl1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792714031;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:In-Reply-To:Date:Message-ID:References;
	bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
	b=1q6I7BCfUhpYDOLfzsc+hT2jtTuovRKHmTMDPO/MI8kLXUFxJuTKlnWaRrf6lemuVOIH
	 /whCf/ss1/fcm4MMNQtZ7i2ny0TBIiflFbx8C3UXPbGsvK4XSly2opIyVUF1lozJgRopf
	 iJ20kPZJ0dJLEo8EoJTuEcTb7XDExs/fsfMy6aPdOIRrF110AnEj5hEan10aOCzpftLiM
	 /uw5xaeeSTfcX7c75ZKWa/m0zSXrl5MmHG1W7gmiaPbEt5SAxTKr/Xt/NNVUs4mElM4Ze
	 7Afo2lyXF120nDyQzKN4j+mJ0iYETKG3dzNnY3/ZJEMtTiVzUG5cZEOCPzs4drvk8UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+GGjTur;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8235E606A31B
	for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2026 00:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8235E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+GGjTur
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-33fb4680717so984904eec.1
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 17:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792714031; x=1793318831; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
        b=m+GGjTurIp4URWCyne0AEstlg/S/hifwoIK3vMGc3ULvXuI2/avQDamAyvbwufeGmM
         d4UTiM6MJMonBPDDNPmFRfHQX//HDuDMtMBQOazdDOj1QtK63quy3MiaQuTpH82vLprv
         vx42K36TjgoJl0Nm6EriCVLzGGvhHcMqXtjwW8oaIhWml1qbU2iKsA0CZx9Kv6qM0RT0
         AYFmvn18BC+UfLUm1pzPYGE1a3fqz2ItID5ZRGn0AWKjkP1pcGUfgbfNkzl5tf5xh0pD
         B0X6oCzteP7JrqmNHvJ0dpyaA1YvhgOmNqRL0LfSiKZ43JNbXrFuQsFque5GTTO0G3yC
         t2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792714031; x=1793318831;
        h=references:message-id:date:in-reply-to:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
        b=nb0uS4CXY3EMVYEaLj1Mqfr9YT8hcfq/MMhh2QZPwbYRLXTOC+cbZK3AkvTaFIRcG4
         8xAQZSoQZ55lVvFl+/4t8LYDlxIlsS9D/q8lzjbjrM75+dvg1uxLphNdun1ESs5raYlk
         o2EYvVegGrFDIsvMoN0tf1ABwQGto5bgwY/7sY9q1vCVsxRiHX4XdPYTaJsa8KrKIWoG
         /pUvrhDFF3GKNC1P4Pq6QJOnFfospQTf6NeZVr79x3MkPkbe+lMWhTsuusPsFl48/jN6
         iQQn9ieM79BT4aA4bq0vHHyYcOsa1cYsURmUGdxqfj4eCQ1GjU06ojTos9q5eVEiX4SX
         vfEQ==
X-Forwarded-Encrypted: i=1; AKwUvBzq0epQNGt2WBDN6KE4V3/Up4fyopMOxDJIu0VY1V6CPuH5jTxihtH3uNISGn1RCFaLSg573wMZIWY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKU3r25/VMhMSXwE9Iyf8V4vDK8cuEJZNLRD3JzUBEEvXAgxV/D
	DwoTfjdnSFlmhH4/nEAOzDq82nxPJ0dUjQAVUSWWZFw62bQj8Fw4bHyV
X-Gm-Gg: AYBFou1S4sGg7JyTWRGqE5KGQR/guJsoub2x0zKCJm+bEpcrdQS+H0EUi3Td8mMEEBt
	dTFdzVyeuKK6wwBtxDG93vnYbuEzJyp6hMuNr+dvI/LRpMP4HPDnmLVxnwWc+zgEQUds9Slfruv
	on/qhjie1ykZi+7CH65srgKMwy384poLwuIkgWkXBhGSmbM8wS7s4FelwbXU9uswAUJyQBcfv+7
	igj3nXUpU9mesFYnlac0iWsHOWsAHZv01AUOsUvZ4IgfQfQrM3BQC/FeAmfqhJUZ2rHZrNWVSMV
	McSoJyLTJXoS1VPd7i64rxqJUOQia5KmY0hYvBlfEcUvzb+0t/Ua9eMpOZ+QYY/cUjMyPhgIhin
	Nr4b7ytCIVv+CQzKGd1Nybgqh7NVKzm6yG3JSiCfqbr75hHDwzqjH724YK2zSXU7Jv/pQ+dP9m9
	AdcTg4f4wsAJNGvk5Hxg+kpm1itCzOPm2Y38s/gnzpGmwjt4GOJ8GcR1hNLZN7pnJDaCCFD3509
	YVDuYi2FoQ8m0H/vyNcrB+i1S/gEA/X2qq+gBMQ5nVg14w/LpraMg==
X-Received: by 2002:a05:7301:fc82:b0:35d:84c2:eb27 with SMTP id 5a478bee46e88-369d986918fmr703493eec.35.1792714030379;
        Thu, 22 Oct 2026 17:07:10 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9db7970sm1525194eec.19.2026.10.22.17.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 17:07:09 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
Date: Fri, 23 Oct 2026 05:09:47 +0530
Message-ID: <fqxx5mpo.ritesh.list@gmail.com>
References: <20261016160037.GA107919@frogsfrogsfrogs>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list

"Darrick J. Wong" <djwong@kernel.org> writes:

> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.

I was a bit sad to see this email :( But then I read it's an extended
break, so I am hopeful that we will see you around after your break.

>
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
>
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
>

Thanks a lot for all your help throughout these years on mailing lists
and over other discussion forums. Really admire your maintainership
style.

I also feel lucky to have met you in person at LSFMM-2024 and to have
had long chats with you on all sorts of topics there :)

> --Darrick

Hope you have a good break! 

-ritesh
