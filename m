Received: from mail.karlsbakk.net (mail.karlsbakk.net [46.30.189.78])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11B52356CF
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.189.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754320447; cv=none; b=LR2kTdVLpC7Dl3kHwXb1CrNVo4v4n4iox+/Exfvw5X9SxtyFwHDt+3YsfteNMKF522XQHRFSK59jIDPUVicy84C7I7qYYVc2biYPkMJKN2O8HpG3rtnKQkU/P4S3qDPsjjQ6HnhpbWWHoYGLotGLUVV7oXt9p4PtxFyc5HZKRZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754320447; c=relaxed/simple;
	bh=2AFMBb4GJjHH/HDanoqsDQltBns5VhYqlWX+PMWy2y4=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=hUZuQyHwbYYmcNS74AllCVRGaMTtsU0AhKgksFH2mUPa5hlLrHcr6IS9KWABu8jU+bk1Sj8CKlC+cZmsf+XkuhOtDDkzdmP1Hr50seHwraJu/alTpIK+xlz9YN/3RtvBItCnoHwx/YePlUmBKfkGW7XndZzZVEhRKCemQf4uGpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net; spf=pass smtp.mailfrom=karlsbakk.net; arc=none smtp.client-ip=46.30.189.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karlsbakk.net
Received: from mail.karlsbakk.net (localhost [IPv6:::1])
	by mail.karlsbakk.net (Postfix) with ESMTP id 90ADA220
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 17:14:01 +0200 (CEST)
Received: from smtpclient.apple ([2a01:799:d66:4000:89d0:c426:3480:c62b])
	by mail.karlsbakk.net with ESMTPSA
	id AokUITnOkGizoAwAVNCnFw
	(envelope-from <roy@karlsbakk.net>)
	for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 17:14:01 +0200
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Shrinking XFS - is that happening? 
Message-Id: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
Date: Mon, 4 Aug 2025 17:13:51 +0200
To: linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3826.600.51.1.1)

Hi all!

I beleive I heard something from someone some time back about work in =
progress on shrinking xfs filesystems. Is this something that's been =
worked with or have I been lied to or just had a nice dream?

roy

--
Roy Sigurd Karlsbakk
roy@karlsbakk.net
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. =
Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste =
tilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.

