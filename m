Received: from fred.zcu.cz (fred.zcu.cz [147.228.57.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE3717A2E6
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=147.228.57.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449487; cv=none; b=YGqFmL2jf8m6f2dybh7EjI2lvjx+Ragg9RGXXM1oxPqWGFfHNAfKH+RQMnVR1GyWEcdf2BPQl32mShjyi4S4GoKGjPy1Ce5uhExnJowtm8yo0czjJhBwl1iHQILXmUy7vpEV1CZ5OeoXSfRNms3QjARz7FVlUir6+6c4t1kHHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449487; c=relaxed/simple;
	bh=nxOiuwnnRWZJN59cFFOkDBN5D16EM3ffK0inl/+Lvco=;
	h=From:To:MIME-Version:Date:Subject:Message-ID:Content-Type; b=JQ/qBfNU08/NU/hTTozKF2By5X7Ud6Cybk9W4c5RFZfSifejQx0aV73SIr8NwTqpxyzX5n3rVeN7qPf3akSRujCkQ3qcD0X1SRqZRh1WaECOi9RvNXFXnrYgAe19ZZlySkUQGKHyZq5zqnwG2IqrWefeOZr1lyVuvmn6RLcQ3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ntc.zcu.cz; spf=pass smtp.mailfrom=ntc.zcu.cz; dkim=pass (2048-bit key) header.d=zcu.cz header.i=@zcu.cz header.b=Usn596N9; arc=none smtp.client-ip=147.228.57.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ntc.zcu.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntc.zcu.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zcu.cz header.i=@zcu.cz header.b="Usn596N9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zcu.cz; s=20230108;
	t=1746448942; bh=nxOiuwnnRWZJN59cFFOkDBN5D16EM3ffK0inl/+Lvco=;
	h=From:To:Date:Subject:From;
	b=Usn596N9O/lw5uNxjxQy4dhZjpr9DEITWbKCcHq/BtjT4xAGhKdDVd5Hqj2wyrLE1
	 bnQMv3uuiJjngQu5migxqp+SQorMqCXa6gsye4noWa9NkjZA3n12Pdlb+0SqCRMqDI
	 7VDHFazIs5IqPa2y0zaPcp2O6oEhc5Z3b/x/85VeZlZO71B6dzussZf8sn5K+F4nae
	 K517n5NqA7NPkzr9Y6w+kYyMize4aaPRUNmkCm5cLc97xGF9KEc2Smf8UkWtNR5nzk
	 MWaaveNL+YZT7ERxE3kQv17XizPl8IdZFrfo17szJTxOL426P0B2CdQEBRGwPE3wQa
	 c23vWtNaH+6zg==
Received: from webmail.zcu.cz (webmail.zcu.cz [IPv6:2001:718:1801:1057::1:30])
	by fred.zcu.cz (Postfix) with ESMTP id 18B2C80045E8
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 14:42:22 +0200 (CEST)
From: =?utf-8?q?Bc=2E_Martin_=C5=A0afr=C3=A1nek?= <safranek@ntc.zcu.cz>
To: linux-xfs@vger.kernel.org
User-Agent: SOGoMail 5.12.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 05 May 2025 14:42:22 +0200
Subject: =?utf-8?q?Question=3A?= Is it possible to recover deleted files from a 
 healthy XFS =?utf-8?q?filesystem=3F?=
Message-ID: <18512e-6818b200-1ab-59e10800@49678430>
X-Forward: 147.228.239.240
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 1.0.7 at fred
X-Virus-Status: Clean
X-ZCU-MailScanner-ID: 18B2C80045E8.AC210
X-ZCU-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=0.001, required 5,
	autolearn=disabled, DKIM_SIGNED 0.10, DKIM_VALID -0.10,
	DMARC_PASS -0.00, RCVD_IN_DNSWL_BLOCKED 0.00, SPF_HELO_NONE 0.00,
	SPF_PASS -0.00, URIBL_BLOCKED 0.00)
X-ZCU-MailScanner-From: safranek@ntc.zcu.cz
X-ZCU-Spam-Status: No

Hello everyone,

I have a question regarding XFS and file recovery.

Is there any method =E2=80=94 official or unofficial =E2=80=94 to recov=
er deleted files from a healthy, uncorrupted XFS filesystem? I understa=
nd that XFS does not support undeletion, but I'm wondering if any remna=
nts of metadata might still allow partial or full recovery, perhaps und=
er specific conditions.

If anyone has insights, tools, or suggestions, I=E2=80=99d be very grat=
eful.

Thank you for your time.

Best regards,
Martin Safranek

