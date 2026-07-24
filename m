Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BA23B71C4
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900078; cv=pass; b=mlDRX9Q8bp8XiOBw1EPkAbnvhske0dUBT7xR27k1R+wKTHAuufxNaukV8/9QU5S3lfEGwbsdJvkaEvI10KtwBsAYvRAgSk/yq6ZBKN31fnsfwHXUCPa4Nkg6Cztbr3F9YvFH0tcuQu70/AK6VGeeepZaHWxx6QiFIslndXHd4ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900078; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rosc3uxKF06nN+R/8outsXL4C6Ux4KYk/f0s2r4L0UGXMs2U5n7xv13ooTQD8bJ3gK4J/OUGsfivtwFCBqtQx15JpIuI2ViU8k5HbRzKgep0m8erIWktCq6pch7Plk2DR7rr0jF7qvu/nMVIgtmG1rwhh+tVxNg365wx02w/cSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpUbj/gx; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpUbj/gx"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15dd4b9132so66250266b.1
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 06:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784900075; cv=none;
        d=google.com; s=arc-20260327;
        b=eU1MV/W4CMlWaYiTbZtWfxjzU/U2ZvXa8l/5zaW2NS/l8iE+AGM3bZpC05JLx4jYGi
         GO+jHaGTipQ86BuUFWUMsGWm4zTZGSh7ZZAkUjvJlRjpYcvddAk+GUhWnY1EzDcmMwE8
         K7tmUpJKPysfz3D6UOw4iTovxSHSd8oeH7hnimw0lz0+rFsddXoT6dPL3m/PJtBLQEIC
         KuzDboSr8DOk0dRWE4dDP7ItEreDeRdQCmvNHvZ+j0dAzfIO0IJpyHarBiLDomRpN99N
         OsLzrsXwO2PpiyAaZ7ozs0h7r98xGIRfQrKer46zgAJr2mJROtQXZdOBVrkttpbzOh1s
         kgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=yzcciCO/jW1+AaWmZKGnOxjJ0LfX35Shuf8AC36QPLM=;
        b=XkcSD/Gkb9hVYSNjLv17jhP9ugz9Pf7VM4VhRRczo2NqfXGXD12gf/ur1ZH+eR6sF6
         dkt8TkXKsODriaIl0ch+PEuU68ILTvBwKmmborCdkOfandfe8zr48+BX25tAmXUTwrSm
         vPXl/BB0u4UIE+OS2fWPOOxy3eug99sUwa1rB172McimtBaRNkaWuvxIri8c4B9qpyiO
         Cq4ofmcTEBllSFF+Il+7ZsFpei8TQRRpg0t8vN2Pe2TdcOrWAMZCtlkgn0jjBI+0Oe6a
         FVgWpJ/rzaEZnckv62r9en3W8X6sL2AFotClj+GsXOE43qCW+vY2GSNQCyMPhtwpNeSX
         AvQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784900075; x=1785504875; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=VpUbj/gxPfu2RJKKVmjsZsjVpFXa4JvxOTc/1TcRNMnnNVefaCvfqx2/odkO9g0NTh
         CnsiBs4DgQ48FWOpJDSSiPo0E6xIq/kxYpQsS4Dbv3aZurShT/W+A9qHMjEDVCTojNe5
         5zf79qnNQjhwS1zaVKbawSHze1NF4okyEJHHH4ArW6N3YMjavlI7eyMl+xOpiqmxLb2E
         NKJ06T7BITwLjVRs4DNk4bAi3fEzM1kirP5LYLY2pSojTlhlTzeIY2DM5oDjrSJ0zXy8
         zsPTuXchjV6bQkcVQAf1IJmIjWs6rbLpwnX15kRDf5kjA369ONxgdH7bmD2X4GrAZEig
         ECZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784900075; x=1785504875;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=S2zcRaIktQyBdUMwzJuojvnehyuBqWIyX+gjfufPx8s6gHHj+ij23Z3iDOd1VfQd4/
         /1fMnUk+WV+nRN2sJ8SihjCOlfCskRfl36SBtE09fynH9CB9WBe//OXjePpygs112FJW
         7R2ll+BEgS7KOAFxOy3PfT+UzaW1zOBqMFcYY4B/oReEn9xwml04AQWCiouGF/4EZ0z5
         m+Bvn5spzagjR+LH3xErmVYdHXwXuJzb9sKRnvItuYiAEI53B6CUl1YNfh3OVroH8UZC
         JbuY3Tk7Vw4MOmeUNXngo1QrF0YHoB3qP61jk7LW3c7uu+/Xf/mNDUxJNJ1L0D5xRIzW
         QiLQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQIBlhJIKEWKw8yUZIkqvhMJNQaHu1VTDAyTCJ8ek00IvVJIvDpX8Vics6SqGXXQpY9c9Q7Ql/J+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6h2qa971uxpHQIuVRXkyO3R4wSM2rrlpqUnMkcla3R7d+3TXx
	3ASI3xFE55H7JMK8ynp+/G9vjl6DiirivNZ3rWi1IjL1vkJ4nXFv49PErKpvWAH9MfYKr1+mSrw
	JcyGknxyr+YG81VZyvrTLhFMEx5Ue3Q==
X-Gm-Gg: AR+sD12uoMhuiiljM9/RS+qpqJr8uTCQmR9TJ99370sB59X1KP20EBzcvCsAWjkUABO
	iGjlNWm8FRvj6JNq5uGZpkVIWhIsbrK8n+rbWupyK6A2MjlUAU3KeNhOh/7S0hZuzgm8FRAz6UU
	m0klZ6G9c1h6rWDpALpwFdgLEUuymIxvYiNMOSYok7CmR85k8ciGnk3QCm45Gyj/XgPVxi6Zl4c
	Xn9h3x779TTxcutNOJx+4qZzLlHEyuoRft7CNRJFhjdJqMdwnm1r2Vtlntt568L4TbpTRErOWzn
	CpyoOKlm4urrzSB40ZvC7aBUDWB5kZroyIs=
X-Received: by 2002:a17:907:1c13:b0:c12:34ed:da14 with SMTP id
 a640c23a62f3a-c1c50b6671cmr294192966b.64.1784900075121; Fri, 24 Jul 2026
 06:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724051001.202741-1-hch@lst.de> <20260724051001.202741-5-hch@lst.de>
In-Reply-To: <20260724051001.202741-5-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 24 Jul 2026 19:03:56 +0530
X-Gm-Features: AUfX_mwWTg42HDw4aWDghBP51qdfXyDKkMoJixeJkgq6b4QcQa_tMbSOXy-DN0w
Message-ID: <CACzX3AvJUPUhxCPgqOW6zSF2exawYG_okkL3xAEd=s2g=EDd3A@mail.gmail.com>
Subject: Re: [PATCH 4/4] iomap: don't free integrity payload that doesn't exist
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
