Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE951C2E
	for <linux-xfs@vger.kernel.org>; Mon, 25 Dec 2023 08:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="q5FIagLs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=7zyiM3sg+BgaQtbWdzT25cuTDRhHS5SbJ3JZH7RzKkc=; b=q5FIagLsI1i3zi/F5s4tyRpfuf
	nG1yLVsBmip3eAS2+57L0lWFBuWLgC7feu2KdNJ8DLTRJpumf5O/R73O6V56BV+bD/GFS8f3uIju0
	Mg4DOf4UzK7HP+2t+V3QiH5s5jOxhxUW1H6W4mEu6I9IPo/XmsVDxhqQLlBgI43Oxtto/8jTeF+qU
	ztT4nT1zXqVz/EjLgZFXBrNR/G87Hty8GdYulLoA1T2NYm8HNGwSifJVMonsCGou5VWJNzyZ+vG1B
	F8seKGAidSQymWZB3QVoCiPPt8VzYvubWKVZvIzw04Ufx8k2XEoDBTjSiq76R7awjtQy48vC+qa78
	yprq20tw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1rHgip-000vyu-4l; Mon, 25 Dec 2023 08:54:03 +0000
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
CC: linux-xfs@vger.kernel.org
Subject: Processed: Re: Bug#1054644: xfsprogs-udeb: causes D-I to fail,
 reporting errors about missing partition devices
Message-ID: <handler.s.B1059424.1703494244220347.transcript@bugs.debian.org>
References: <20231225085034.lmhxyhfgfvfrfanp@jak-t480s>
 <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Mon, 25 Dec 2023 08:54:03 +0000

Processing control commands:

> tag 1059424 patch
Bug #1059424 [xfsprogs] xfsprogs-udeb: causes D-I to fail, reporting errors=
 about missing partition devices
Added tag(s) patch.

--=20
1059424: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059424
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
