Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793884160;
	b=pX12PmKmbzTgcfaf3PkOYFf7cfmxjwJ/UC6zA2en0cbIBzCWqKWF/vDtW4gWO80xVArY
	 hdiQzy01yvYscoHAwML+BKOdO1VIzEcIArh4vipWsJo2G3UFuHGi1bVVumqHHhdLvF+Z5
	 Jy8PIER8/YTqgk4Iz6aH9cUjBw0kxr0oSMRLNkOkxbGw/Ckn4hwEEaGzwc3FB1lScTVQg
	 tnv2JxegVWZFyVue8eGZK1iqr6U8oITO3tLyqXAItC8SLUF8t1kCXAnhWEV4eBhGVOHkP
	 LHkxkQhEXwHyoZJWa2/PfLa0LNHcw4fUjVeuj1jG9VF8qy5pciqH1a/9p0wh76xdwmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=jkmvscXAvNWOCA/eo1FekQ65BtW98C82Ndf/rsHkNE0=;
	b=AdmDs6xYP10WUzHTsriN8SO9oupzy9A2eYBMvFUZ2sA+3TSrdccnWjzeEeuy7VmUjZY1
	 aFyp6RXndEqCsHf+kI8XN3Ywi3NHxHvXvgVDSj0jsMnrpd4/ZrqXfx8zatHrK/Ds3UfkE
	 Ankn9RUFpHlP2qefzM7EYNp5Rn7KnEqnjoQ/28dW5Xe05Pu128Kik4wUarCGa6NoxfA7N
	 HqqV48lLHoRKNEF+MpprRZbx2OCRDhKC8JtM5nEUSgkYoSY4I+cebouk8pTMiFLrDD4+D
	 mq5pL5BTTslYCrlk/OUEkjqQq/E09tB/uhEWhfj0XLsCxkTV0Tu0vmVow9B4XlD5VZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JUs1lRhO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31185606A31B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 13:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31185606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JUs1lRhO
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so666265a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Nov 2026 05:09:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793884158; cv=none;
        d=google.com; s=arc-20260327;
        b=Kz+e/Bw6aPsMHmfo6Nne0fcTIG6N2M4x22nMAkm0JBTgi7HWdafcasuUm6AS3FTkRp
         XPvk7eO87VOqkTGeZyiGNuZGnxYt6qAVjwEg4bPHVX2eyULreVoI11HIYiYFN2HhcdY3
         Cvwpkzyl21kSAWjqMlJ6Ph5/UJgODMVpmeG2pbdHIQzkcjBWvAc9e0/U7KT2KlulMNao
         6Iftvf9/j5HDzucI9uSef2oJ3gi0NeC0lOUbbDfJSwwNHam6VOF9i3+c6pU6FW8YrdXv
         L/sVPK6rA1SbSM5sEKWCTH6wmNCiPEEpoODRC7gRCtRA2vIyyaKXjlFIT522Tisp8hx2
         wVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jkmvscXAvNWOCA/eo1FekQ65BtW98C82Ndf/rsHkNE0=;
        fh=MSh+XJSFiyrvDYy+zmLicE8jevpeNY4JUn9edgFV36E=;
        b=cXek+iQ8i/I77iLyuOqS45iXrCeaPXsIEELOx2ykhouNPErwo7OdtCX9hqe1MkLGOJ
         Avgs6ruCyuvB1I8Expo7oL9gnPAu/6AKK6FKKBvpyN+iRIfWEe8G6XzdbIJogLIdhpg8
         mX9IbXfOy597Ue3jowpnXBFhYsiSlfBUaAEj45slOrHdTLURuy65YSvGfU5VZQAozD76
         FnFNQkGSkUSMOpEb8AbUCW5n150T6TatwZj567Btw7jS/5SpAx4Kz0c+m1PJDKYP9qFs
         /erNZ8bCmcG55KbjsC4YbhtOBFOm75a0u88IpFTEiKfX4gP/fAD7mJZMFlppiooA2Ntf
         TDNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793884158; x=1794488958; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jkmvscXAvNWOCA/eo1FekQ65BtW98C82Ndf/rsHkNE0=;
        b=JUs1lRhOPCwcs9X3rlblVurVgqsvLTVfuDmx0GXYpoORcQ3pyC7i74dzdRg1aNHQLF
         AZWJITRvL5mRhtdbsr8lGM+sFvWQX61VodqJhj1l7cTCz5ICtt8F1lblo15BPA2YcWa5
         7IVbEHDilI3RbpZXWPtcu8EVTl+Anod63vvxUuyBkhVsopxvZirImRElapBH4gsNK9M4
         4RQ3uR69ZqWze+iWjxLtu/RIPaHWJz8PyGy9mgF7RgoHRhE0yE/EG/qycT1ui06jmA5U
         zCEu0LR+6OGmJov1v67QNh1fKUqIBpLl1KpYeBAZPuINq/cHk64oQ2RyaCCSyafwTcu+
         4lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884158; x=1794488958;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jkmvscXAvNWOCA/eo1FekQ65BtW98C82Ndf/rsHkNE0=;
        b=KDF+uTSrzNsloV+Z6ZiwSdeP4BSARpDmBEDiBw/b01Snl+BxTB3cuxXCo2q0BWyp5P
         o8rIypNE032PiW/41wbA+7Frs0R/YmnENjdr6SccFgNs2DUBLl/eInXJXFW/aUi9PzpN
         ycKFAb0RQPjz0iqtLERDjUWmfKyYi3PXCvDxW+FLC2WItFLQQjsylLgxIPH9z5IiCEDP
         5nppLJUy+I6226SjvZC+XjYgBBk2bDD8hCsnAY/QuNgcxISkD+ZWePu6gsYveQCTSisb
         VtXUjIpyt5PSlqQqzwiI4kwtTsT4jHl1gNXndYVmecJsHc91KlBFcaOPEeDkva7JP0rW
         O5bw==
X-Forwarded-Encrypted: i=1; AKwUvBx7ytH0yW65UlkTgzCEKjZ+k5Mnz+oBIXUNl1jY+q+an4NWgQsjTqoqf8vFjNQPw7eR9Ev132xcK1E=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ahAGLgyK/F5VvK3EZpBZQy67i+ZaPO1M5yEaUZB4sFV2GM1pK
	SjfnW5y6Efl16SVuMGbhtGtWYfF3jmlvpt5EWk5F/HS3vrAj0wd3AZBZiDFdD+J9t0c7CZ79n74
	imVuXCWL46r9IveDk6Y+7P7DXvIZK8Q==
X-Gm-Gg: AYBFou129/GE0oOgASAnYkn1vQI17ewwAI9yuZxqkS6hMr6xWfLzb1GvnRK0nNJDV1P
	kope5ps6Ur0jXgTjtdgO5WXCRNHUS2+y464Z0IWloDitI4Rsaeg9Guo2bzre95xRc2MERzUGL4m
	0UG2lXvnIy0s7hjHAHccOj8e0T9uYUslIwb2Z4bKyxM5cJIHm9R/Lf6dIqS+WE5SDPl/NViIGf5
	AfH1tHnOI64TLQRMoXgKYKecNy+8Yt8DtpkD8vTiKj/HtMMuJOu45Gb2vxnF9y2cpyYkXhNWggw
	qnh8nFFXl5AkEmzUu2VFHSUa9RLMtHZ7zeIUyBpCXlcTDTaBM2KIM6nWMIkKK93t4Ufbg4BQoq+
	HRC4JLyMtnP/I/M7y4bNV2DDHahBgmxVPG8SNdpYz5A54p/4WdfD7VA/v51FpAF3eLaFKu0OZOI
	1PdNSiZ3MpR8rx2Ei0gpFBq5kNbcpwZYmNStzocYH6ZE8N
X-Received: by 2002:a05:6402:428f:b0:6b3:e89b:126a with SMTP id
 4fb4d7f45d1cf-6b4d428fa3fmr14003060a12.12.1793884158312; Thu, 05 Nov 2026
 05:09:18 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CGME20261103111022epcas5p4df6a10b70dd9a92992c117669c7227fc@epcas5p4.samsung.com>
 <20261103110640.1000095-1-anuj20.g@samsung.com> <2003152d-5d33-424a-8191-badbe137e37c@wdc.com>
In-Reply-To: <2003152d-5d33-424a-8191-badbe137e37c@wdc.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 5 Nov 2026 18:38:40 +0530
X-Gm-Features: AclHuK_IE3Nm_OtgyVou8Yme1bSHicg4bAvJGhKSCtpmlcsXrhW4foKGrcUBnBQ
Message-ID: <CACzX3AtMO31MfQpxp_YyTqCqza6+NnPOMa4sGpjM90pd7cSi+g@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] xfs write streams
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, brauner@kernel.org, hch@lst.de, djwong@kernel.org, 
	dgc@kernel.org, cem@kernel.org, jack@suse.cz, axboe@kernel.dk, 
	kbusch@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"

> This looks pretty reasonable but I'd like to do some prototyping to see how this
> would integrate with the zoned xfs allocator and run some benchmarks.
>
> Are the RocksDB patches publicly available somewhere?

Yes, the RocksDB write-stream changes are available here:
https://github.com/anuj7781/rocksdb/tree/write-streams-v7

>
> Cheers,
> Hans
