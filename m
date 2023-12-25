Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871A10A19
	for <linux-xfs@vger.kernel.org>; Mon, 25 Dec 2023 08:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="krlvvaOe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=gQSuVPIhe7Gl2Agngght1L670p9B5FcUdxpCieVtH5g=; b=krlvvaOeztl2TfXOfkqs0GJ5yE
	hCwrIpeMWjOowHeapIs0B052pMAh/1rq+uILUVWIq8Q1nNyleNNMpYQDfCkGw82hL5MZDOtavJ28M
	sSXHU+rWgsXN9oKt7GNOQo/cToUXTBoK9xAPL91w7Dzb6q9i/XBl2ejvA8Pkw9bBpoQnLO77BHsWg
	IiNTRETBpFHGzODUSICZjf2YL1pCt7WwWvqu+XbCbenq2sx2kT+kcwMeGWWV4gIF3INIA8vNCIttI
	Vk9yR9YFOuSF0yXPPUs/1IOBbaFfHag5+6PzuTDWM5wZezUpMl5/JQj7dI21NGp/kyi6Bgh1Lgb2b
	dWxH0lJg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1rHgA2-000rCd-As; Mon, 25 Dec 2023 08:18:06 +0000
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
To: Julian Andres Klode <julian.klode@canonical.com>
CC: pkg-grub-devel@alioth-lists.debian.net, linux-xfs@vger.kernel.org
Subject: Processed: Re: Bug#1054644: xfsprogs-udeb: causes D-I to fail,
 reporting errors about missing partition devices
Message-ID: <handler.s.B1054644.1703492168204060.transcript@bugs.debian.org>
References: <20231225081559.7xwxb7qtk6obgczx@jak-t480s>
 <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Package: grub2 xfsprogs
X-Debian-PR-Source: grub2 xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Mon, 25 Dec 2023 08:18:06 +0000

Processing control commands:

> clone -1 -2
Bug #1054644 [grub2] xfsprogs-udeb: causes D-I to fail, reporting errors ab=
out missing partition devices
Bug 1054644 cloned as bug 1059424
> reassign -2 xfsprogs
Bug #1059424 [grub2] xfsprogs-udeb: causes D-I to fail, reporting errors ab=
out missing partition devices
Bug reassigned from package 'grub2' to 'xfsprogs'.
Ignoring request to alter found versions of bug #1059424 to the same values=
 previously set
Ignoring request to alter fixed versions of bug #1059424 to the same values=
 previously set

--=20
1054644: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1054644
1059424: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059424
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
