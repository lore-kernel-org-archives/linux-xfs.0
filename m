Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4B539280C;
	Thu, 18 Jun 2026 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781780674; cv=none; b=nmh6ozfoV1b7VDg4JA+FOkmKWoVvQuUxpjnIObGBx4UO0w8mV1SbnIaePGdq9BHQzELRAdcqhwid0Sr1BiuXyzwfjV5N/m1S9ej2npxs7R8LQZyltsUrdfPeyK9ssayvzbKxLvm5L8PNvaW4h8KFWZUT+7fmtvGX/7zd73ELEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781780674; c=relaxed/simple;
	bh=k4e8VI2O6aCir3gLj+hc1Yb89ZGIrDT4hvPm/oW85R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpu7l4wIQhBC/el23shggUoStJE+ZsZDjeDDbBMRCwhjq5psOFmOYXAU2zMAxXzrFWQNKVkR9SVLnNbBRQOeHIdbv9egYt+i6jSTtJ9uNnb6J17SKrpGBPTs2aopz3lNnzpPcOtxDvTDWlPBCK3vNoRidR2zjjvhoGFtFiBk55o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=I/suEA3E; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="I/suEA3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781780620;
	bh=4Uv/pgyvmN9X6UsDOCog3Tj8FogTWj8HbhKGBVSsB9g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=I/suEA3EW1RxiXHHXDrm7FqEwmxnC8Wqvt5jCePTky1r5hSKxjc9TFAzfCcDk843K
	 cZmaX9RS4l974jbceBeONi9btSIJ4z5j3+yZ9azYFnJ3BRhV3Ke4PfFQSKk+uMmvDA
	 oBozza2iU4ToIhB3DrRYkXbC0/b1u4BPNqpGSfUk=
X-QQ-mid: zesmtpsz2t1781780602t0fd0fe5f
X-QQ-Originating-IP: 7lbwlNd0ySkfmwckAiimiktunjYCmQadgslhkgnGx+I=
Received: from uos-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 18 Jun 2026 19:03:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9547551119723904798
EX-QQ-RecipientCnt: 6
From: Morduan Zang <zhangdandan@uniontech.com>
To: hch@infradead.org
Cc: brauner@kernel.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	zhangdandan@uniontech.com
Subject: Re: [PATCH] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Thu, 18 Jun 2026 19:03:07 +0800
Message-ID: <B234832D26F10C59+20260618110320.545750-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <ajO1fOJZlmICeSAv@infradead.org>
References: <ajO1fOJZlmICeSAv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: Nr7dWBUWFJSOKMB0cPljmrF9awokqYZJ4PBpVkGQOFoNZnD260hIF0Wl
	Ka8rvV8o0KaWnm16+bF0AtmSo5yvsJ/z9ML8YN10wRiyIve6DRrVKiSrU8jPa/LjJC8kpgC
	7Vx45CGaTknPZ+Xf9hX7ALCWbTMQ/6HSVRTB6OkUQZZMeNHAa6uX18hsgZ9litqhHdv/biF
	wzz8AvIyKA5N+qrfBekDtJox+F287IFiSZd329M1H2krrEqDW55pr0mZS2g83Ccunpu8HVV
	e4UWZd/LypM3WKrJ5wKoHoKieRw5xGNObuHbMfGZshDTUy2efyYNiq62R1byI/rF/X0N0ZQ
	tMJ0EP0IQlaF0tFxc7uTEBKfYIP0Sla0Eux8XGfcKaWGleKPTP2S4fQTrw5J/jfpvFmskOH
	gZXbEcqLvtIdeoJOihGmVuPVIpVXO7n31kyom4OxCi/n5bbSlKyg/zR3+1LweOb5X8Agxhn
	T/mtL46UHAZYXYA4Uwc1EfnwDlDIAviEmSwlmUxDsYRhpvnQlebBOpHv7xOq0hYrLp5zZ3E
	0fqu7UBIP64I0o2wOK8A84zVxIzzNarpl8Uj9nIe9S+0senG90zzdapFV6SJ+J6Rwn0h7Kd
	gunQ2oJJgDjPCCjj1A/5wVsRQVBlZGPm5RmeddSEKg8mFCE20pe4Bto3u3unh5SQfDI64mO
	75PiXHkFS8LN2yGF44jV58+kw9z3YDSwr/tUwFE30P34U8czNqGd5vIOI5xDj9sZ7ZmGMHM
	TpFEP39FIDSEO/VjGYIHdoElTWa/NyEe1Oy2DBCAKZo5xfLYUt6oeq6VdtPCbFkHR7VFEcT
	of/1ufUJ5FSgVZjv6rTjDpL/7IfJ1RW+7iRl6WVir+PvRwORrAdZHjj5yWk7MC16I3Meq/r
	3SFyNjtmDZfgtMZsxCQZpPGGKUXd7RPb2MwE/l1UvWu8nAbEyp7y82eabWkvjFe6BbYFs1Y
	bCvhQfdim3SQ9zPiwTBZjUUQFh4WMPT3DR9AOPLnlJ3VRkEu9vaAA4gm8VQj2K4g5ocixhF
	Q9QdqpCFoadQPWtjqF1vmFNAmJRbmraqkt6ghn8Vc7u7fVb2Wc3jnJdxaSdc0=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

On Thu, Jun 18, 2026 at 01:38:20PM +0800, Christian Brauner wrote:
> Do you have examples for this?  I.e. did you hit this with a workload,
> or did you just look over the code for issues?

No, I do not have a workload reproducer. I noticed this while reviewing
the EOF trim in 51d20d1dacbe for backport — our static analysis flagged
that end_pos - ioend->io_offset is assigned to size_t without ensuring
end_pos >= ioend->io_offset.

I have not been able to trigger this in testing yet, so I do not want to
overstate the practical impact. That said, once the trim path is taken
with end_pos <= io_offset, the current code clearly wraps io_size, which
seems wrong relative to the intent of that commit (io_size should reflect
valid in-EOF data, i.e. zero in that case). Filesystem completion paths
also use io_size for range decisions beyond a simple EOF update.

If you consider this path unreachable in practice I am happy to drop the
patch. Otherwise, the guard itself is small and only affects the trim
branch — I can send a v2 with your suggested ordering if you think it is
worth hardening even without a reproducer.

> I find this a bit hard to read due to different paramter ordering,
> i.e. why not:
>
> if (ioend->io_offset + ioend->io_size > end_pos) {
>         if (ioend->io_offset >= end_pos)
>                 ioend->io_size = 0;
>         else
>                 ioend->io_size = end_pos - ioend->io_offset;
> }

If you are fine with this change, I will send a v2 with this ordering to
improve code quality.

Thanks,
Morduan Zang
