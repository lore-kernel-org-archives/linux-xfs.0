Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391EC2D7DDB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774250941; cv=pass; b=fmCaw/GCOwo3H4xnwIqIKMiZ7a5AT231tJFCdVMI/w9A3JRUkKnnfvuHj2WQmicx55MWsDZbnE+xPQJVIcu2G3N//jvOmtdu8Y2e1KH1xHGpP1YcK+0eVOjP5/qyAnfCgx2+Tq7V0WLeXV+nCbIFCKAWritfBbG5IWP9vuVd+EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774250941; c=relaxed/simple;
	bh=wvHVZAd+Fi3HPZRrGjELFIAC/7TxYJUw5Ev2XiIBQmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1k/S9TDvBJ9ft/NpO2nJyrXxe6furukdICCHfym22EgQbID2C+fJjGa/Ab70WmHEeSrV7Vn8HEaO0+RkFZGSwIGmO0BjwgYZKN0NFgug5s3UUGwCzL2HfDLkcW8pCKP37GAE0R8D3pxv3rqyvonm+zNs9yF8Z/wxw/CXsblU58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RewE6ygh; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RewE6ygh"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64eb84d1e37so1307736d50.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 00:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774250939; cv=none;
        d=google.com; s=arc-20240605;
        b=kbvsdy3EF17tjcibAhR6edzMf4gOZcVKFDEnnBOCS/KjFoGWm2/O37pKMhkKXfcVAP
         IvHuvQK9byndRJ1T6aLviqLtV1yPhRdX6ru4xbD7REeHQc2Qq06ovzZDtJL2T/BsXMes
         QG6mj9hAFLfEXTVFxpXjNxZ299rC1sMmAdUlUIBYORxZm1df9l72jaowXqRa1ufR7kHG
         61gcwBk5pazdM1IkXOieMR4+UZ9NTA1emfGmJd6wJhY9M5G06gtfKo+evtaJfv0tHueK
         Iyse0LA0QJXK4vY7rRCoX1+jj0mFPjD7L8AERYmvQM+sDKNXWd09xgbECe9OIdZve+bQ
         EONg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvWPIFy7Sr+a63qZxUwJP9iWaDI1gTywKMYkqyTwgs8=;
        fh=5XwIl6hR3No5dd9yOhLPVh6R7sTSXM3RN+9R29YFIAw=;
        b=B0BX3S/kExvDogv9BWw1nZlJpZ4mBA4t97NU+wugUrCS3xGTD8yoz23Fpn+HnnPGnq
         5fbWSJScLu2nTUoNCmCTUxrZVcxkd36GgIBoxptcM0eNMsFyVdyipcpFiDF7IN9oNfFc
         qinuq2MFV9MoVPIzbySJaq3q8zH3oy3/SWouFYvQOb+fSECpm4YZpq5gWvz9prxpBwUT
         Il4DWqT/04oqxQfoyUnzvbLMiJF+XQqakkuLYx5n+yQqsgzrksIbAYlskjNJjE6JoV8o
         0gYB6T9FmfNu7945I+RUK2QZi/oFAuaow2IjVSkdGi4TZ2jgQEvcwbAYghFpNAwankDo
         mOAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774250939; x=1774855739; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvWPIFy7Sr+a63qZxUwJP9iWaDI1gTywKMYkqyTwgs8=;
        b=RewE6yghKYz5X30hMNXNPOqyHsywiCVGM82Y4+rXNVIYEEbfpKwQcK96II6QhdR3Qo
         JhclLchGVH5qUxr4gE8BGz81D5Cosh0mFhdGdxX0ejKCCZ0QFiF7O7H/yI3EpZ3UD2dN
         ernwEMjhV5j8RKGWuVI4YwngjhO8OVXLBzzKbNfrZBd9oSM0MZIOLotN1O0fEn1rahJh
         vlZQzsoE/EJ4ERcQEhOfJ4YP5emyIySLqLx4PvYVPssqJeKLhDo9moJkHgU8Wp4V4yD+
         Jdc2w0N68j8LB2ePvUmTRAjbRO8fW2w+fcUZ5PGqxNHNiSxRmKPhpBGoTjg2b8mfvvl+
         Q93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774250939; x=1774855739;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvWPIFy7Sr+a63qZxUwJP9iWaDI1gTywKMYkqyTwgs8=;
        b=sR3Kg3ShRn9djFDFkNzRmw9BGPEiWasiMlMViAWatis48HMiJvA2hiG73Gb2vcbpgh
         Xo9RFJjZCU+JbPALzZZkFRdyhekA8a8BbeRGQC4yTldtGxG5RH/8bibZqkWuILR2OREA
         ahLx1qPSned72rrFAazKNtTvG3HfEVy6oor9JHMQ5MJ3/OKc2pcln+bd2wzUQCk46C2+
         L+EfSM5BNSIW6ojnSOGsM9sL4sKLpJ4IRgm5wTcvuw6IcNOJK8Bi310oMGeqRD+nn6pJ
         LKMoJc/jNcZLZMPlopxl/PUws3HwbDvHuCL40XOxEpFl75dvYTxnRsxa0UuiVnCdTOvW
         OU4w==
X-Forwarded-Encrypted: i=1; AJvYcCXDfs86ko4yx+fbuAQ8ApOwS8EEUFCk48pFdsfmQM3SQLTJiIEQhnO4/QcGJfCY3GoySHmgGudsaCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg0VG3Jhfe3JB3XXHTtqfqdCXuotnDZsedmgGYGu9gWWOJSicA
	CKL73WiUl67JRng9g5rCsQsdkSeLG73UyUSDj0xrpR/shJYvLTgDabrNseQ+gIG7PrnEx2iCQZK
	5hLr1wgXCzpyTXU0/d4gXoCuSwbrOPfiXL0LoLDjlv7M4
X-Gm-Gg: ATEYQzxHM3JUAWmVISm1LZc9uxWUX0gzrxCSZnFPIZjwKRAzy3NPl16uJ9+2BImS02L
	mynR9Z6AnLW7kvTp+UsWuIRYfEnMm0juZ1gu+k8fn/7j4KIykcUfeNI42MTI99aP1ek/C0uLBl6
	QzUM1QrkTjUoqv6Dcd5nfisvpmLZ62F3f4RHLtQgD3OySJwpzxawrPpbZEIEPxxvJ8/OmdkrXXA
	q1+ueA5AUlCt5bQKglH0ZWho1snmOUPLHgrMWPC3u3JhrBz6f+Qj5wu17MiW1g+RyHMgKga/kZo
	4IXzCBDZ
X-Received: by 2002:a05:690c:1d:b0:79a:b245:f8c4 with SMTP id
 00721157ae682-79ab2460c5dmr33281607b3.54.1774250939273; Mon, 23 Mar 2026
 00:28:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260320025507.3331221-1-zzzccc427@gmail.com> <acDaQ6DQ7ehMji4r@infradead.org>
In-Reply-To: <acDaQ6DQ7ehMji4r@infradead.org>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 23 Mar 2026 15:28:47 +0800
X-Gm-Features: AQROBzA4Vz5OqSije-jDYcg7Q9h2EUb79CdWV3qLpnnFumua7OffByRbOEQbquk
Message-ID: <CAFRLqsUdn4AMsvnVopHuK3zX81FRFQj+GGdCGO9KgyBxckhWOQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: annotate data race on li_lsn in CIL formatting vs
 AIL insertion
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

> Well, xfs_trans_ail_copy_lsn pretty clearly documents that we actually
> need a locak for the 32-bit case.  Assuming we don't have lock ordering
> issues, using xfs_trans_ail_copy_lsn would be the right thing here.

Thanks for the clarification.

> .. and either way please avoid the overly long lines.

I'll update the patch accordingly and also fix the long line in v2.

Best regards,
Cen Zhang
