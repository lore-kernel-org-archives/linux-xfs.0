Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793052105;
	b=VMcF3qOIv85BxsUEquVRs5eyH2VuhCs5gDwhpSI5hXJmbUPVsuB87LHndXxlgrXYplsN
	 jgBFSzmdrW7veIrWxymUe4kdD/RyyAWPkKVTmCjUGbZt4ddJFbWBFUciUoI4kMeNbmrL8
	 XzaQmQYCB0KlgwamH55jQklXQl4JxhrtYYg3rsyFfQ4cBES6uICXu0OWRZC2H57jtqRql
	 JpzH8IYnwwp5T9hxKVVIHaN7pBKk3bmMqZuBPFd1QgiDxabLnZtLuS9FECwyZEVBb2w7H
	 RKx4EtRjv71Qf6UFokXLs3ofptyzQ9UzZ12LQpEiFabU0expA8KKqF/q35wwq3EvPPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052105;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=oxKk9Tj1Adhv4UrmiacMORaWHUB5Oq69Nm81ehGNNQw=;
	b=dKwt3gr9QCK2JS/odKT6bjitb1u9BSYsRjTcaNxaFg40ULe7D3w1/7NV+M6wyhdniLZn
	 9idXcwjbMjsg1sN4y4+gFd26VWb9ySBXiSXM3B7fZQwnmCdp+pQid3XMfzUdlct73e4Mz
	 26i/XEi4VFsntaUAz8Uu46Zds4msShMEAVuoX4KH+KKMm9b7IRNK1u/zHGQtA5PeNZ1vP
	 jmcVbhT8Fw7+rUd71RC2q0jH+Vl8VqDy/UO4KrUMQSAs8brOZnDVrjal8QxNfYD0Yjv1z
	 8G2GHOCFLK1QCkjz9tzRe3P1HGf8ZIPOMToy2jidwpOr63DmoAEvpbJY9Y1tOdfMbbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OlWjglVu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B3606A31A
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 22:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 436B3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OlWjglVu
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c468bd799ecso446989166b.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 15:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793052104; cv=none;
        d=google.com; s=arc-20260327;
        b=eOpbExJUSr+I5HAqH4fuvjNG3rREqveBJGa7dzIwUk763EGbzcGTZHUsa2S/ngsBkc
         G0Ztx2w31b3mCgWYxtymFj9RzGoSH/2EmfmHSUTBg92kYi5RiagC2EN2nd//jw9RYuhv
         yP5+nQh4jsWo1rgoZbcT3Q+8Z/Vbcudi0hbmBzv5BhYQ9oNzNCnpHiX/nwrBEBEGCzjX
         At092lIoLgyI/bW+TLkwkLVE/uMBKtfGzEf2Fh0gnX9lqGiZZ6XzUhlYXFPSsO0vG3cL
         mQgX35tfzjT/sAo0dBhPhMsEnyZtvGcjYaUvzDIb+up76AHIZQiJ0qti+7xd2v89dT0d
         XTsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=oxKk9Tj1Adhv4UrmiacMORaWHUB5Oq69Nm81ehGNNQw=;
        fh=lpz+QntCmijI1P0vV7yD5V+2uaOVOElwMegvF/cm2pQ=;
        b=kBBBnDanbvzBv03Z7/lYavlPKss6PRhscs4uWl7wmWS6sfSG2O9y8PW2+BP9vK697u
         lDuXj5KTrgOrZXINXrZ20a5U45T5dr3IZ9pYdIEQuTDbXwzispVCVeEkHHo0BAL3t6j0
         nDjgi+0nS15c4IpBYRvn4IQNnxmkG/BwL64rGjKjBgVVwnt16gql66E2v8mWXiNYgxbn
         lfrzl/+O8VcDkIFcp8cNcNJt6GsLxe7lG2zci+XvJ0RkMfs/w5Dq+W5/KzZlji52VKMh
         yVOIsIXvzV6DtLSOCcDpjggsF37BBKMbYt13Rfrr4ffHOlRHe5QjNSmPtxjB8CCoBLqj
         WPGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793052104; x=1793656904; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oxKk9Tj1Adhv4UrmiacMORaWHUB5Oq69Nm81ehGNNQw=;
        b=OlWjglVu0jmgrLyQK7Xmz6jA9YSXK5MFRUyw8Cmto8jc5Dav4MSoG8l3FXL5VHIcTn
         AvcqfRYuTN/N6EWWRozOjqh9rZl7YZ5cukH5wkbnHPyWXXLd/Dcr+lw3tWKZwCPKJDOy
         LxNitvZ8DHApawzZNvVo1dH+7yn8U8n6R6B0sWvDrP0+36aZCz7ybOeWfKAhVEIBx0jq
         mAukS0vshinUhJvU180k1JOnEOQXpcwsl0htm99Wft9C20fEEiuVuoR9lFdWI7Htc3/L
         reb6NPP6FeAJjVoCEXRezraCifxVgxwLfYUYHjHvCCCH5dVu4NIlzu+XLPjwPtBEmXtT
         yiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052104; x=1793656904;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oxKk9Tj1Adhv4UrmiacMORaWHUB5Oq69Nm81ehGNNQw=;
        b=t09lCkGrC17yOMnMKW1Q1fToOg13hW4a1GqmVPH+pQ5fKWwsIzYwBM0kWUUILGzlkW
         fl39yryt7igz6IdZVeA6uc+HUAhsTqYIJdJWDSpyKpTyPaX9u4hgglKx3ruxT2H3SVj1
         UvD1f/H/8OwxbyoWR23y6jvItXNAno1Fs/cZbPCx0ZRR7rBPAeeUT/zJn4VT4V/JC5qN
         iM9OMIr4J4xmkwbNXZ6OGoYM/WE2DwyBFlsJNs7Ch4fHCksABrUFf4hCo7vgwAWtOiCY
         ZIutTzj+wCY2+C3MtmyYgYBv1TXPPW1BEZJYed1CLDwhv+sskiWxF9pbBuQPPjA1hOCq
         g4sQ==
X-Gm-Message-State: AFq9FYIF5JIVuADGWT3P0ub2WFxlsD4NrDFEABGlIajozzjCknjcu6VF
	/qJA7+gvNZBclpvSub9ZSWfYk+OQ7wmwG/xG6JtQeG4hak8uaw+4HyGdjd0lH0Aix6g2a1Xgdda
	Sdnf1GQa/TotuSxy2iOIx+VRYRg9NixMoOYYB
X-Gm-Gg: AYBFou0D064CR9/4wV/5PVkZGUMW2Kjqqt63TRwsJF6P8Rxqt2LIfI/csz5qs2tfBxa
	8Z+WUol/qoql0IxZFQCMD4UXkisubfE+mY/JgAtyLTfMo/SpFJj2+g6cYmxUPQrEcvqGKpNgr6z
	+Ldd9Kpwmn7gfSFokX7wBgd012bdGyiYBE4GODVRBIHOp0m2QmqDrqYQfo72KXUEHBDl1qo0fQH
	UztdsgRCv0DfquMR06LXn+3oE/zAOnkAlpwYWe7xEsrIRKp6c47aeQ2u+yrh6p3PvJ/Y66EKAUI
	2UnBjgEPEaIf5uU6QCIGEmvKsj0GX3NAVoKeaIpK04TU8SgBKQtP35CgSPuxgd6C43T0+xqY6KR
	nYTojnUH1p8ijERwop7GVvDCDXMKy83E4PxvK
X-Received: by 2002:a17:907:3fa5:b0:c29:5340:182e with SMTP id
 a640c23a62f3a-c46bdac64a2mr931428466b.2.1793052103578; Mon, 26 Oct 2026
 15:01:43 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 15:01:43 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 15:01:43 -0700
From: Ivan <ivan.vin.ctf@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 26 Oct 2026 15:01:43 -0700
X-Gm-Features: AclHuK_T78vPeU0M64wk8eCH8wnipPQD4WuW0GPLPhvwhRWpkuPx7vOT8C20Aq4
Message-ID: <CA+hZKY+LQaBm_6BYW2hLhMMZNUEAAk2Dbg6a+VD4aQsDNQ88eA@mail.gmail.com>
Subject: Re: task hung in xlog_grant_head_check - still reproducible on
 7.2-rc7 (2018 report went dormant) - and on 5.15.216-stable, with a cascading
 inodegc victim profile
To: linux-xfs@vger.kernel.org
Cc: dgc@kernel.org, yangguikun@tju.edu.cn
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 26, 2026 at 01:34:07PM -0700, Dave Chinner wrote:
> "Doctor, it hurts when I punch myself in the face!"

Fair. And thank you for the definitive answer -- after eight years of
dormancy, a documented decision with a rationale is worth more to us than
the fix would have been.

You are right about the root cause; our reservation-size framing was wrong.
An empty journal wearing a "full" sign, with V5 erroring out and V4 only
warning, explains the whole 2018->2026 trail of "reproducible but won't
die" reports -- including why every one of them needed a crafted image.

We are happy to take option (2): this reply *is* the recorded decision we
asked for, and it closes the issue from our side. We promise not to send
the 2028 report.

We will skip the patch offer -- XFS internals are not our depth, and a
well-meaning bad patch would cost you more time than the bug report did.
What we can do instead: our XFS campaign is being re-pointed at
well-formed V5 images, per your 2018 advice, so whatever we send next is
in the class you consider real.

Thanks for taking the time to explain instead of just binning the mail.

Regards,
Ivan Vinichuk
