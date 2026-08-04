Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2843D9526
	for <linux-xfs@vger.kernel.org>; Tue,  4 Aug 2026 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848260; cv=pass; b=KJiDGUjOzu0CHhbKE0HBHgAB8wgbGyIoswkZsB0gChAIUvuUbldVugWRiiqjVsP09qm0e1bamdTQm4qQsJcrcXsg0LGsFaFe2dwQpd4Y3tRei4jZ3RgC3IhMxyF0UUPevUWdWJO0WgvyWn4fdb/0fS8X5wr5gym0DVpZTo24C2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848260; c=relaxed/simple;
	bh=+WmRghJef1r5J+QMpdMAEUZ9j2c1Uw767yzVkm0wDNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KPAnTDGijYBfPXyasw5N35vbynP2V8WioxxwcyaHF6K5Zu5ZoLzKA2HHKaqkoMpwlnF2cKro5wnySjfDcjy+l6rnuFS//I/brUGZDBCpwQImGtp9iwA3ffTerQaIMLIvSdOxhK2jkTmxjUEzT92hZmrGp+kWe0weTqM5R+49ddo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/sIO0rM; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/sIO0rM"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a10a1a4b11so3171678a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Aug 2026 05:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785848257; cv=none;
        d=google.com; s=arc-20260327;
        b=j//NGDAaUPweLAG+WAEQQ2IDOUcbbx7QGFmZ2vizf0yOs6ou09+4my5r54uNyKlm75
         MVBxPamP1/E5NwHBaBSLxq7s6j/s7W6I+NSAieeH9uOTGIzWyWALp6lBIqbywgx/PzGz
         B2A+tIwhSgzTKs8pHESpJ/BhUCoap88a7Pe2mujnX0q+oT82dQZ8ooRT3Khp5LcAWjKx
         XIhrtSJMRFlLwozQ+4byhg1oa4h7UXBDLRIe5MQiE4zZt0sD9N6nypAF5d7vhUIjDxUM
         R0beB0FaqgepFoEqdxYOu2N1eHIk2PSHgE4mGG0Jw6LJHOqVYzb3/AkLWyHj4nfKfVzx
         B+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+WmRghJef1r5J+QMpdMAEUZ9j2c1Uw767yzVkm0wDNU=;
        fh=yUqccJyWNuF/C0AMDaZr5M0SVsRnpJi/XsvZFKvN3xQ=;
        b=rRoglBVFp6JNJOb4sh+/aKzh3E68I/bF+rO8W8KpkuQa0u3287W6E6e/ViiFW/DfEG
         Wb13R4HXbSXWVgITMFMAU8zXR2kx023MtxZxQKPxMRvtWRMG6I0QWAmx0GAfoK8qTUE4
         +BQ3VM1x3X2gAFMNpIjWkpF2cLDxLbwQkKlLDJrAPLIHdFuUGHU7AI7bwRoStDvfDYuM
         hx3lL15BcM29QslJkBOUcaZv1MoY7t0ccqNpdDqoZhky2Qe/1YvCCIpHM6O1DWC1dv6V
         XRGWLFUiF4InZTcUD+xzkhW9fFDeki+puc7ETB9XSTMBVMIZe4tGy2ltPhGO8CMznkKt
         y+8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785848257; x=1786453057; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+WmRghJef1r5J+QMpdMAEUZ9j2c1Uw767yzVkm0wDNU=;
        b=C/sIO0rM8eRwvBwCBzyXbcxX35ZAfc61TSZrb/dx5BqgNWgqdPL7xgJLZMyPOIuZmB
         sqZiezOg/NnvVOaxZUuV+jCD6nJifdwyN7Do+W3eOhv58cQgmv8MceGSQkMP6W5CnKEx
         Duc/NomN1WwNXBpS4eveyrcbt/LfN/Rr2DG0TIAfDctsK54Gfz2VC+afAThD2vSFPOOq
         Q1cXDb1Ttorw2kKIqy2jTaTOTXsZu38aOEAtvST7SRKgjNN+J3NWoOu5ONaKc+GRY3TV
         d+hAwwMjWIfP5b+rv3EPRdj3Kgb5w1JOGKhl/XRP1nNAob8EYc5F1mF8sbR2s/Ga/fir
         WUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785848257; x=1786453057;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+WmRghJef1r5J+QMpdMAEUZ9j2c1Uw767yzVkm0wDNU=;
        b=e3ix87azupWWklG3fPWb4SrSLVOLRZlWAkJbL+fjn58DqgG+iiZ97RSyzT23neMOdw
         tmFQyqB2gkoJc23T2xXFaQZ8C1AydfKBBMwxLZFM6aPAhjUKEJOe8/1+aluBJ5s8f/fQ
         z2w6ZHoIPO0Jwa4BRxO8FM7hGS50PgnXNYxQCZRoxBfgDJVnv8YdrynlFcdf7W6hIgM7
         QKCrkTpXasDTDIcb8nbQBDwgZ2nuDnvkaMECo5DEQkoAgGNbx0o2n3UJxBBSoU07xgAL
         WNkAouj/ieRsTstp4TXeMQvv50UAFczg7ePDfKCsPiBS3YpeBLRiN0j5LE7fs/C2oeeF
         kRhw==
X-Forwarded-Encrypted: i=1; AHgh+Rp2NpXgeXBmnFqHVpBCV66uOOiBYM3pRk2jtCxG1RtLa75O/fJKU/tGbavdE67CJ1G5a1F9b6uOtbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnME7niyG7U69NHHE8Opy24y3Ge/Mb/QoJXqZR1YOsahM5sIUi
	ECeQwc4yoay8x1/0ezPgZWmsbXWtsFP2Ow9f4AjGG5UsNFM8JtHI7whJRhYahY0XE98ZBLgO6Rw
	xoIyj2z/5DcM/r2M7oh2dUZ23F9cVsQ==
X-Gm-Gg: AR+sD138d9289EA61tKyztl1ZRxPPeL7UN+ttZkXdxII8RH7n+vk4aJYakU+p/Ej7/5
	GND8YEELGDIwhxStvRSusoURuk87dgmKSOeUZQpbaCqXWcJBOU3cTpFnJEOdd5dJk4CW/qOyJAu
	kiePBnhK99NezvTfN81tSvIl41rS/hqJojssIcnWVWu5oW3n2Xf7Wm9BFyr3Lr+MEXdtBn8rZp8
	iRVNKUQ978kf87ptN8LjpS251G7SpNou9pf7oUnZEKEUaUywkVRrhfKhTKCBcBLsHIqBZTsyETv
	kc+RojQmzlc7IIioz1rp7cnJIqnuS6VaqKcAVRicp7oVEl2TJ5hjGt/Wo88Dr79bo88p/thB4Tu
	oI9uJtnUWhsBEpUo=
X-Received: by 2002:a05:6402:3241:b0:697:e8e1:d3c0 with SMTP id
 4fb4d7f45d1cf-6a0a7c60f6fmr9974383a12.2.1785848256625; Tue, 04 Aug 2026
 05:57:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804123928.736596-1-hch@lst.de> <20260804123928.736596-4-hch@lst.de>
In-Reply-To: <20260804123928.736596-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 4 Aug 2026 18:26:58 +0530
X-Gm-Features: AUfX_mwFmmpC_U35ny59wFjG-bBG3cjk5l5jGDZtPGJTJ13E215K0Y1Na_HqAxM
Message-ID: <CACzX3AtEvhTmX8aGVi6zrWWu1=Cfoi8z9=Z17RsZB+pD0LU=9w@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: handle nogenerate/noverify properly in fs-integrity
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pretty sure I reviewed this patch before, but FWIW:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
