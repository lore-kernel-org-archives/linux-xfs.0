Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F56E145B16;
	Sat, 19 Jul 2025 08:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752914013; cv=none; b=cZJW/KLY9Jg79fWOr8i2ZkcfnTQKiraTBE++H9ssnlKe4hvOuuYKVObL7UcUBJB3YBa7+tlreRqsavkprM1xSAEA4vrejiVOp2gC+C2j7PeOwmnWBcrHpRy6NVeU5k4llNFPKAq011NlOYpNCWP+lQkGhSGaRZaWfjZ5uLi5Xi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752914013; c=relaxed/simple;
	bh=oUv9EZNrCY04o/8N3IWZcvvSZ73ECWcgjXKvclVdQ/o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=OJfenVGN685ZAojJkxJU76AFwwMLzGU4y/1vMMl+UQpe4BVpmOnHqsE9Q1RcbmKJ5n+gdgjheh4fLd6qOtMdZtA2MG7nE8uRJ5fQxIdE5tYEL9WGifWcCGcBrE7sTLWtWhg9hLFecwIrIB3sSRIcyULFMJGLfGhutJQGQaQC2Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VWUUGgGg; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VWUUGgGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1752914008; x=1753518808; i=markus.elfring@web.de;
	bh=tiNyI2TBl7oFyBSx0FnTRP4cdh5GnjH6vlhrxHWeduY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VWUUGgGgznzvGMMS7xKE2VMSWsRXci0skO23JaCP7KBT/LuJYb8cdMdUXIsKBps5
	 +stRY+FBDWkCsXVjKla9dcZhKJqCMvgWPulrdeQxpkkYfhBLa6qMt96g9ICXpQOZt
	 ToH5MzztrjOPP8uHYSDlkAl/mWxpBXzQgYI+fjrhbGMQvemQR2LT81MQmGnN06Ivx
	 iOKnsNubu8Z1zZfrmHP8EInVI8y3+RnzEVg4WiIZ3bG4QUzdTZ+qKMu9p4++KBwy1
	 KMqeJnsTgBmOT/IVOVwDEnS5T+utzuD5O/YvHKWn701UxbCuvnsP91OFrC0rcl8hT
	 WPYeDaEXTtr2X43agQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.241]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MGxQV-1uP2mh20wt-002fqE; Sat, 19
 Jul 2025 10:33:28 +0200
Message-ID: <f12a445e-536b-44e4-9291-a10dd16f227f@web.de>
Date: Sat, 19 Jul 2025 10:33:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Muhammad Ahmed <muhammad.ahmed.27@hotmail.com>, linux-xfs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
References: <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_xfs=3A_scrub=3A_remove_unnecessary_brac?=
 =?UTF-8?Q?es_and_fix_=E2=80=A6?=
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:dw+HJU39wCeeVQoLypY19FOqbUZGUpxWWEhbeh3FLXQT94rFYbV
 aLwcicZz++MrQNNrCuTDNh5FDsgperBQJ9dQBPj2t1CwcY+YOfVLUw8mAJMnwQaZMoHJC5L
 b/jDT2WxhzzLsyA9AQy+Jy75mfUZKNfFDfkKvD382fvUSAh0iolKHD880HMZRwdTbhKAbXC
 KFLjPWI5Wjff5gJGiOLtA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rZahnqEanmg=;RosM0od0MvDlZHOdwc3vA6cO5pC
 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
 t35n6jDRNMHl67g9T

> This patch removes unnecessary braces around simple if-else blocks and

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16-rc6#n94


How do you think about to use the following code variant?

		xrep_findparent_scan_found(pscan, p->delta > 0 ? p->dp->i_ino : NULLFSINO);


> fixes inconsistent indentation in fs/xfs/scrub/findparent.c to comply
> with kernel coding style guidelines.

Please split possible changes into separate update steps.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16-rc6#n81

Regards,
Markus
