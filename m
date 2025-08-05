Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84117A2FA
	for <linux-xfs@vger.kernel.org>; Tue,  5 Aug 2025 05:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754370105; cv=none; b=V1ZOCNc4uWdK2IHD29zNTNRNamypse5MPuZZ2R+qSPLOXWHkuqbxygpFBhEYT6FGLrWFplV0hCsRvw5VCihVs6peg/pxVO6shl03EC4v0ucy5hnUbVMb+kmyeBT2U6k4lepU/xvs1TlFh7mQ6d/RzNZxKR4EPWQ6C6elPjHMfBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754370105; c=relaxed/simple;
	bh=pqq+FcQQ+NEVd+1xiYm/Xmfeo5vnLdRpsqdkPhfcSvI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=bcJucKa0lZ7FK9Wooco2a2Qb4Rj0xffRCrZPv7D/NTjazK7t2mn8NC2Lit4/nJL+CHjEr5nyvF4hDvDE2sDNfZqrgJE1DI6kuOh/6603pNNcWV1fp/JkvamhGPJJcgmuFx4ZzgGN8InG2+82c4XSxm/YnxOMaS45NwUHdKh9OLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GNmltnP2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNmltnP2"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76bc5e68d96so4163959b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 22:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754370103; x=1754974903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RE7Mct/T3NR0Z3Wd9KMBh3LaJwbBGPXI9IqPsbgZHmE=;
        b=GNmltnP2BZ3n03khjpOw97ZGje/NKvBmmtVnUvCsB+MkCRlHFgimwzZroMij1j6qSy
         1jMJ7DgVgF96NgMIH7c85YKZOkgSp8Bx0W1AFCNb1aveegnq5ybKA99H3QWQQORrPt90
         sxHhVkce794FEtJARA1ysjH7EGKAXTJQr8BL6yV02GnDCRtqw+uFqUF4WMaok37WTKfA
         vz0rA4H3R15bHzim3isfswrazAS33RiSzPoUegh0oTxIO4uafnnHZFWYKWJMY1oI+yNa
         FSPTnkB3gFql3MFCLq3IF2dhecVOy051JpENAmrkg7GMqkbYQPkhx8T4CNLbnKToIjwM
         0s5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754370103; x=1754974903;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RE7Mct/T3NR0Z3Wd9KMBh3LaJwbBGPXI9IqPsbgZHmE=;
        b=ZswL2sk//W/gSGp3tzhTBIZMsF4km5T0ztz6WKZBVSBDLB7p8iLP3XrWBMMK2F30RL
         H5yZSNmAVpvNdJ+d5U8djdLOb0AQ8Mt+OOakUaShH6fhlY4LGHP/IZCxzto8jhatrmo4
         0t33TaOGRc2xOqga9QdpySqTCWK9S01OwYWW20ak97n7aroWCcfL58tgWiwGHYZTGl6e
         bmF+3l1UxtjE/DHnJKF28LVyRjhmhRSv4rhHrsxWU7CArYRmhr614L7UPq6iH6pfozVx
         hIlgCJ1HVkof+Ib4O7X6/1MzIDOKCXT136mI2V0kCrJyFP3Dgcto9CTCBgtgqkFwlzza
         Azxg==
X-Forwarded-Encrypted: i=1; AJvYcCXtvyjx+E3at/VoEZ4OKP95RHK51fMZ36hku+tZ0ej76V8vvC67DSFcOLhMpoRf1GVftWk49TsQ7CA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzriVOLJnRjzE+s9inyViKqzwrg5G5M59RyWqrGLkojaLPbWg+i
	1lOvNtbDIFj5xmlnZlqGzXdaiFLycu6IzBryaT5qTjkHPI7xDpSKZZ4KgS8gOQ==
X-Gm-Gg: ASbGncuR0dF9uqqfvnwqCYI2St4qKuej0WCTWVPigtsDkTBFOxUAagt1OfthmVOZpX/
	fLLNLTaW2iUZgs8f37GMvwRhPCHoqcX3HR+jnBITsboXt6/7oGjJIu7GRzjqSHBpCh+u3la0x/4
	bfOVBPZA98vYdjcelkK6Zp1N9Xbmp32iloXpdJCYvKvm0gr/UNRzVp/sZdR323unkV+yhTKu7Sb
	2TILCgmt9AhAfKBcBsrZSnF+enkIH15YvRwIF4qxZA8tqRNPcZJ5atWziKGLgmKl+10jqCbiSD3
	dguCq28kqTBWd3DNg44CyEY4gokb50olB4u3+GedzPtuXLq79/nF7+ZCxMGu2+32pv7YE35DGKY
	+kmdYv8XBpA8c5AlZPbq2tbXM7xZhqDBO/x8zEsRcIks8GX8lwna5SgrFhkxUON1adEJEXRpiHP
	Y=
X-Google-Smtp-Source: AGHT+IEjQO7mZlWs85w5JCpY5U05Lia0DINHalw+GnEdRv1gJQNZNPC2isdgajfD5U/2K7FWhI0Xvw==
X-Received: by 2002:a05:6a00:1495:b0:748:323f:ba21 with SMTP id d2e1a72fcca58-76bec302002mr15019380b3a.1.1754370102951;
        Mon, 04 Aug 2025 22:01:42 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.198.59])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c09adf8efsm3437682b3a.68.2025.08.04.22.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 22:01:42 -0700 (PDT)
Message-ID: <58fc5e2ae7f658863c6934260221aeb917a3b2d6.camel@gmail.com>
Subject: Re: Shrinking XFS - is that happening?
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
Date: Tue, 05 Aug 2025 10:31:39 +0530
In-Reply-To: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
> Hi all!
> 
> I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
given by Dave Chinner.

[1] https://lore.kernel.org/all/cover.1752746805.git.nirjhar.roy.lists@gmail.com/
[2] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
--NR
> 
> roy
> 
> --
> Roy Sigurd Karlsbakk
> roy@karlsbakk.net
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det er et elementært imperativ for alle pedagoger å unngå eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate og relevante synonymer på norsk.
> 

