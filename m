Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358032DB785
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110784; cv=none; b=McKhLeouo3as2STPzHaZ7zXhg+lC8XgeE3cEBKM1mP4cVYpLlDCYn53KiR5Wc7MEKG/Z3fWRJHSBvjLlrqp8NiQBELVLuWNITWQljVR+PcvNDzPNRFOb5PA3GKuQhgtRsRLpINKJdg3QgjwBG6+oWBPerhQbIrUMSNwO5Zfkum4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110784; c=relaxed/simple;
	bh=8ZNMtwqLNIT5UifIf2TLPsjrgzNV+w/idgbtt6gen4c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=Ti5vQpQClNesOEfVwcGZDHCSMccJemUtftbS/bslXfbJ8sKHBvRt4zfQzeWC3V8VTAIEaSaO/zkc6xoRiHtfPXk6OPBkxiMHHsZpKELwXmnm1aLqdLE8wlKoLWccUQHmPn02FniqRs6fkay9OiHFWAYvkxs0rAyx6bQRIvnrUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDlvwXe+; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDlvwXe+"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c6e191c4b8fso279023a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 04:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110781; x=1772715581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkyxfBart7AjDYDw5c6XtRbP25hY/UHBSwJPC48FLp8=;
        b=lDlvwXe+jUW9a5/5IENQ64OMnymxdYJGluhUhZejMMcxwbA3kJ2ezMzXDElGFDeyOL
         oHez4PrwnqjZE3mbahd/GqeOlWO+CTGPj/pHrV2mM7it5WFwoeIVWJn/L+U+gSXz2e+5
         Jf4E9xV7PbleE6x58QcVh5Rdlub/Xfyr1FcbhFgMeAM4DR7TqORCtYkHEGRkujuGZKZG
         ORGTdr1atXcGwlOM/udO7hlDkcRe1lFOjtgVNxQcQ7LOwnz4fTbdR8OIpU1CDMQtAL8H
         9cFkOH574dipkOzSZVPYof7ijnd+9z8qSS6CRDWRbJzoPniiIqk0n5SoIVIfboHk0WWl
         23aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110781; x=1772715581;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkyxfBart7AjDYDw5c6XtRbP25hY/UHBSwJPC48FLp8=;
        b=HaalVGkfcOQIxcKBHQC8/E/dx2JTysk0bE6sg7xGnB3IQJ4ErRwiDC1twrLiKwz5H5
         eQ6syKIdk9AHtseo0RlOgcmYMm4NWQ24IrieMbAaRUsXus5wfGOK/DlHtiA9/T/0zFRo
         kUPg+6MvTepGgSjgRAiR9Zrp0zVoZD0/vh/PekjKOv4Cf0vDRKFpnD7INNwZNfd9QJ3g
         zkRMJdkwHf23uLbqmvsx1ZS+zlakfgii9N9vjFsodYHelymXURD5hdFXTnsKPh2gCP8D
         2pLeOKDAfzKF+OJQ0+jxCFc6m6aah/bqgJhARtDoAv4Zs8kWycApSqMqhpMdnjRR6O+B
         76lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqG9RtNzktesrrmiV5BGUJplb7fqq95+JHH0lnkSmuNTuqC96ug+0Kvdq0c8kmeLiHqJQ5+xpVnBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxQjepIwt3rSSw0Y//MtdtcA6TPsT912hPV0LUDapvL3ZsP7dC
	lIKJ0ILoPHvUk6r5/zlVrgIjFE6qh/0XhdC7c3Z1L55xb+LZlsKhx2/3puehyg==
X-Gm-Gg: ATEYQzxR61eoiO8ypYOypjprvY5iOQEAhex0X0DcKhrOqcRcqPwuiLT4v0KIg2VFPpd
	sUiOjRmhvmFRLs9b96BoRdohZopTS6iqMy6OxXdvAAGYL8U18Yg0MWOXL1xdiq6ESclRCvfatHE
	fZcQAbdY7XCuXZ5BHORC+GzV6Y9kLJoeiv1LZF1xUWB/7IIS2+8UnQl/eaUt5lKQCotZ5jypUe0
	PACBQcJyYjhz6All3FOmXnt64gfRZDG7Ij9CxQ9HWohUpWNXJtszKvP0xYsV3MzhnaSR/tkhyoe
	IhAJ9DQ2W17i2Kbq21vXplZJq32IHQZjjkKD52Tw7J4jNDwAzclqQUF2nxfbqSKZ4Mobu9j4E3I
	tEefKcEPgG/uPkKD6U92bGuEnXliZX5HWDsgpagoGc7yrwkxX8tyrjru+ZyjM/QTGCmko9jF9Il
	DCG8TCNP/WxYaYlBj/j6YgIaZKbQPTNagqA3ts+/qIhYdF0dxevTs9b3awBhJLZ+DUrDNdMJN2W
	Z4=
X-Received: by 2002:a17:903:2f04:b0:2aa:e3c7:6048 with SMTP id d9443c01a7336-2ade99a6871mr34212375ad.23.1772110781482;
        Thu, 26 Feb 2026 04:59:41 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5c9f79sm24602525ad.33.2026.02.26.04.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:59:40 -0800 (PST)
Message-ID: <33666a698483b57349a10df3418cf750a06cd769.camel@gmail.com>
Subject: Re: [RFC v1 4/4] xfs: Add support to shrink multiple empty realtime
 groups
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, david@fromorbit.com, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Thu, 26 Feb 2026 18:29:35 +0530
In-Reply-To: <aZ8GJGpEwp3Ihclh@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <aZasXfB-GUiGT4yc@infradead.org>
	 <d7853e26511631b9ca9a28bb691bbe82765640c0.camel@gmail.com>
	 <aZ8GJGpEwp3Ihclh@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2026-02-25 at 06:24 -0800, Christoph Hellwig wrote:
> On Wed, Feb 25, 2026 at 10:47:40AM +0530, Nirjhar Roy (IBM) wrote:
> > > Highlevel note:  this seems to only cover classic bitmap based RTGs,
> > > and not zoned ones.  You might want to look into the latter because
> > 
> > Okay. So are you suggesting to add the shrink support only for the
> > zoned devices or extend this patch set to cover shrink for the zoned
> > devices too?
> 
> We should support all devices.  But what I'm trying to say is the
> zoned version is both simpler, and will actually allow you to get
> to an actually useful fully feature shink much more easily.

Okay. I will start taking a look at it.
> 
> > > they're actually much simpler, and with the zoned GC code we actually
> > > have a super nice way to move data out of the RTG.  I'd be happy to
> > > supple you a code sniplet for the latter.
> > 
> > Sure, that would be super useful. Also, since I don't have much
> > experience in zoned devices, can you please point to some relevant
> > resources and recent zoned device related patchsets that can help me
> > get started with?
> 
> You don't actually need a zoned device, you can just mkfs with
> "-r zoned=1" and get a internal rtdevice configuration.  If you are

Oh nice!. 
> interested in the actual hardware and ecosystem take a look at:
> https://zonedstorage.io/
> 
> If at some point you're interested in hardware samples contact me
> offlist and I'll connect you to the right people.

Thank you for the pointers.
--NR
> 

