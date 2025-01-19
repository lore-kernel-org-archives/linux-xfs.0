Received: from vps01.wiesinger.com (vps01.wiesinger.com [46.36.37.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C41DFD8
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.36.37.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737289002; cv=none; b=tpY6nI17UuRBXSeug766Y/p5iN+6DeIGau6iBfYLCdV4K59yjGTotBkoflSMc4tJlyw8ffPdy1Q5RLslWYvdD7vmwgvRAcxC4InieZdhXJTVueEecXeodEbexqEFNbHSgnGzo0ETlqF5ZUdIu1+oewOtyUwUB/HKss1VZeUu58w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737289002; c=relaxed/simple;
	bh=zD8D7QR+dDkR6/hRy+OJ+NB+Gsg0AqlZt+J4JDgLWfM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=VIqGSel3giY70zDlPJ7ijQrCZYuwm6Frh+RRSDMdmUA6kNUMIJiRZ1KzoGBHURK8RjUu8qhYsvklV3Hes/Tq92wPMQ9Zpkh8vXqmNBIb35RZi7NmakPcdGlgliTsA4MWrPH/6Cd6XYHluY+jwNafopxW0/Y1wVyRIseJOmRIdCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com; spf=pass smtp.mailfrom=wiesinger.com; dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b=la8MU0e7; arc=none smtp.client-ip=46.36.37.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b="la8MU0e7"
Received: from wiesinger.com (wiesinger.com [84.112.177.114])
	by vps01.wiesinger.com (Postfix) with ESMTPS id 59BFD9F247
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 13:16:38 +0100 (CET)
Received: from [192.168.32.192] (bgld-ip-192.intern [192.168.32.192])
	(authenticated bits=0)
	by wiesinger.com (8.18.1/8.18.1) with ESMTPSA id 50JCGZtg683517
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 13:16:36 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 wiesinger.com 50JCGZtg683517
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiesinger.com;
	s=default; t=1737288997;
	bh=sk9a62SV39A0Yp/kE3h8VmErbOm6IJvfAXWv7/nTy6U=;
	h=Date:To:From:Subject:From;
	b=la8MU0e7D8lNrI+2VO44ipYhIsKmm5rIdaqEoc6rPdga1re/sNWzov37CB+yUFtUo
	 OCqh/mOEjhgdRmCxPBbiQEgK40i4Dy9H8yWBiZf2t0qBzyCqe2rmgCRF4mdIL73sHG
	 QnTjX9Ls/ZPqzOWQIJnUcAK+xqcllcfMbc6fRNzWl67w15aylwMA/Ha+9uSBjO0qAs
	 SQgtK1kVpPUowtBJcpg8ZHHyzLVP7JOSGGx771LtvV184I/LIrZSGbZ4f0ONBfxeZq
	 9q9ccaLcwc19x/umKlDaTkN7/a89UaUlMLNZ+Gex8GzmVqMaTLp3wUjqpVHbt/5MK+
	 yk/1a891a0VGbH6Krh9uxJWv5NICddyFyWNTgbwklJ1GO4ziHbqdBx9PTyCu3rZgBD
	 PEXRIHmXKIwdaTm/d0/IYhIW+5Mk3A5jTBMHvpp33u0x8/Ime4uxzlzN1s/t0WMoDw
	 1UHfDVax3YNPrqyhZW1aWW8OD1iDP8jW7AEZrabRDv0QLxLdMqHq3BXaE9Gtw65ojC
	 Y4Nb6/KPh6s7jwyx122yzOAFDldFM/Hqha8X/hOWKJxv3v5vMZ3EvPGbUgy5tUIFxp
	 HEvZPJTXgKhOEMCFe6ssrexjWB6NosZ+2M4jwCOZPS/k63q1aieL0CpaJBqGxCK99h
	 Pz/vy5h04hq+9FMCMoQ+s7Jw=
Message-ID: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>
Date: Sun, 19 Jan 2025 13:16:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Content-Language: en-US
To: linux-xfs@vger.kernel.org
From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Transparent compression with XFS - especially with zstd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Are there any plans to include transparent compression with XFS 
(especially with zstd)?

Thnx.

Ciao,

Gerhard

