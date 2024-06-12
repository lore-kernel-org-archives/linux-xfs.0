Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920591DFF0
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718209755; cv=none; b=XmxKA0mE3yFeQGKGsmXhZxtBsGoBwR5wZCcx7n4WK19Gn/9VwQAFDn+PwlmlzDxxMSRHX9YDG8HP3PafjJKyGF/6BEKVK2jZEtYolQ73RI/WcGfTjLM51RpzN6sqJDxR2mx04niE5kL4nniedf6cbtb4ymI6NvieAFgIqqUqsRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718209755; c=relaxed/simple;
	bh=1THzU9EpfQewaCtYnTUvUZVEc5LdFhIQeE/mVknXsrc=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=ZXjuJQJ9iRpOBEo1BPIg/B5svB+AwZ46VnsaB7w465lc8eUR/CaJYb71RyGmQfzhVBHl2naPP+sdxbpwrSGwid5nWTdhBrdwgbzguINsnZ4RFu07khYHYjW3Z7PwHMaO9AILDRbOuaiG1mxbalAKATYicz6XWyPfCMvanDHyJHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=PItCwVuQ; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="PItCwVuQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=1THzU9EpfQewaCtYnTUvUZVEc5LdFhIQeE/mVknXsrc=; b=PItCwVuQP+s5LyCpRbtqFywHcf
	vqq7/+aBiVbq7k/50S49+ExwNCLmi4zWZKdC1xAad39sVGLSAH1LaNehiVsDnwx/vOj2PHLZ6biq/
	IT2T2V9+qSG90XsNTHTBajSa5Vdd9QrohN8Ki3nLq4YqRmYHHFNMe6kRfdFQyw38QtJTsLVs56JRu
	Crh0Vp6bVzc/rLHwo5AvHdwck7K0GYiG4NVWv0yrbns+B0FVsINIiSDQN5GbOIQ9dH/iOC7nEAhFp
	pI8gaLgYeJZK6xpAtS4UaXxQroMMm+Xq1VQkoV+9MFr/v0Y+NomiAusMUK+f5AQ79hgUXWCkP36BW
	OQM4fp/Q==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sHQLP-008bLH-Q2; Wed, 12 Jun 2024 15:57:03 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Chris Hofstaedtler <zeha@debian.org>
CC: linux-xfs@vger.kernel.org
Subject: Processed: xfsprogs: diff for NMU version 6.8.0-2.1
Message-ID: <handler.s.B1060352.17182077542049929.transcript@bugs.debian.org>
References: <20240612155550.gabqzku3mz6pq2pw@debian.org>
 <20240109215755.6qcrx2w5fckvyz6t@cl.home.arpa>
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Wed, 12 Jun 2024 15:57:03 +0000

Processing control commands:

> tags 1060352 + pending
Bug #1060352 [src:xfsprogs] xfsprogs: install all files into /usr (DEP17 M2)
Added tag(s) pending.

--=20
1060352: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060352
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
