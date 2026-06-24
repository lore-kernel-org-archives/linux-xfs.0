Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B2B3859F3;
	Wed, 24 Jun 2026 06:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281760; cv=none; b=QFm0BZd7C81DwTVBRJElqtvmKsXTB+AwoHKP1dSUQfl4B9dfmpYDCT+QnyB1kpbpy984pvcK13hpP7/Z4ijfE2APTxyxVCSInkxzFLCrjAt/NXiOT0T97jY2uN6hFH45BuS5Q7WKoTcMYoIo/t+UQQPS0utHZ57TpJgxvvMRGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281760; c=relaxed/simple;
	bh=ISavOCsJ5s6EAAmBPCxuGtVHdnBdLbeA/FPnmEfnrGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYhvS50+APWcptYNNHWGzRiBYfb6NoaXo4GDLy5TY6kdWyCx6G66gWtRX/NVlwe63j7EQ/lnnlDAFbWPdot0Ur3ngKSUJJzgR1BpXiHRTlHQV4cn84FL4CwcKzs2iT7MXZ2M2MUGlbBEIi0Xl4LFl+1wYC+aqaSJ3YiDK5t8RzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HFfh1n6R; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HFfh1n6R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782281705;
	bh=fpbe1JN9ZvDS8UTfkp8FGkJ6ipG2DalpccrWzAxDrrI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=HFfh1n6RmFG8tCg0B19PzRxeeNGLASTBK2iGsMXWCmTWxVzPgnW3zxvZGz2ZwRgnw
	 MOAfMYc3D6GrKlYAAinpAY9aBI1ujXDC5BvT8ChSuvOyIGoU6SUhOBPzW8ZP+XMf1e
	 JAGR7QpjsnN8XF4v0YmAjqd3kqMQMcnma/BoOIHA=
X-QQ-mid: zesmtpsz8t1782281687t38dd2568
X-QQ-Originating-IP: 8uaH8IbcEvO9zhZI+ODGtHVcj8BRD1jvA/XLo/deHGQ=
Received: from uos-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 Jun 2026 14:14:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6367711312974084351
EX-QQ-RecipientCnt: 6
From: Morduan Zang <zhangdandan@uniontech.com>
To: hch@infradead.org
Cc: brauner@kernel.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	zhangdandan@uniontech.com
Subject: Re: [PATCH v2] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Wed, 24 Jun 2026 14:14:43 +0800
Message-ID: <7E50BAC0CE4E3BB0+20260624061445.333492-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <ajP0TDAkqaO5Znyv@infradead.org>
References: <ajP0TDAkqaO5Znyv@infradead.org>
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
X-QQ-XMAILINFO: MiFvYTC1scQcU8xTMivJI7OTyGJmNdPymoBFGDohAdDy5gd3vns+NP8j
	uufYX7FHjpCykutYW+EPPV8BwxPTzdMc8p/ZmdZDoH3tngjGSWCLzJ4XFOYcPDnjcj/FKyu
	BNBSUa6z6tJ3oqUBCR0e+7vco9d6k7q1wjHQLJct+Ot9wvWPGpK6Aha7oqhBxafgM0A9x4P
	rBA/QjiZeZPUHxo9Ds1bV7+cIoBp1EO4w+fHGsreRp+m8/sVf/G4hnNjBDorWG3ucJgxcAV
	cIOKDHQuvwn1PE/FQj1L2oBQ2YpfPsMNJrQojs+uBEDezk46wAaAh4I8rnQjtZOokIwNJK0
	kyii+R9GJGemt6WyXZQP0LnK87zbfNHXMKcSki8t2OiLmk+RH/1eg75MkCCm82yyjGW/b2W
	X9Cy7Q6vpL5ycLRbsqav2oHqHC2aZpbczVbWWbyJo4NMtGV7AtrW9QacN9y5TyofCdsMldp
	ayTkz+8wOFmgTj7Db66rh5o9bCPkqxPcRexLOPyWPg/MDDc5/6X7pRg/QvTQs6DDDzZ9aUm
	84tm2fZSxYbmQLULVouOR5QSZZZO+yu/+H0ylooWVyBvo/uoPFH58uJa2bmiXzOmBQPreyy
	3jGLDnbyeNormbnlxHPPAgZSSw1aq0La3yGuMJg/Dznx6I7jar5kIQU0DR4awPL+fpSnrt3
	MyYe2aYTmMQo1FfgwuCiMdOW955w3MJDNBHDyZCtCsbnkdlP4C08+aVhWftEzl7ie8hxJS6
	BVgZKV/XE7xlnozV7M9ietywvNJ4NNdlHhoJ6aRoEtYR7avHNc6nZxCoviFDp01E6wruZoG
	vM/5hTia3DRlJPxtgEfnuGlcLNrzzTTqaqtQ2IaeVaDGDtGMSE2fvf2Z7yBgH+w/PnFwQpF
	N9AuHyTxlg9yVrpsfwDleRlhYZ8Hi+j1KmDNKlaHa8IVwe+5WSi7OUGEc+9I1eM21q8fxKS
	PuJNr2oyCvDU0ylCwoBO5s7RCtBz9oLvzmxArdPRusm8JroUuok/y8OhDKA5bwo3zkqID7+
	FCkAAn1fQW2uv6/YVI
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

On Thu, Jun 18, 2026 at 07:03:07PM +0800, Christian Brauner wrote:
> Ok, makes sense.
>
> I don't think it's impossible.  Just curious where this change comes
> from and hoping for a reproducer if we can come up with one.

Thanks for the feedback.

This came from our backport review of 51d20d1dacbe — static analysis
flagged that end_pos - ioend->io_offset is assigned to size_t without
ensuring end_pos >= ioend->io_offset. I do not have a runtime reproducer
yet; I am still trying to set up a test on XFS with bsize < PAGE_SIZE to
see if writeback can reach iomap_add_to_ioend() with end_pos below
io_offset. I will follow up if I get a concrete result.

I will send a v2 with your suggested ordering shortly. 
If I manage toreproduce the issue I will follow up with details.

Thanks,
Morduan Zang
