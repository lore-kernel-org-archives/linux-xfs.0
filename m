Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949D678B4C
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 22:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718834949; cv=none; b=GQ1JzVJi5ggnwkbrKtldGG+v6vYmtYVE7eJ9S2RXcOBpFddoapX94EDZOA2TikelPZnKCI1QoGX+b3hy9oWUbaxEJRLQWgYdj14wMEGv2TA2TeND9/QzNOQ2cXvJzPOWt2I68CxvpocDP9sYgdZKMLCe1hiaYY/hjS3LtJyZOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718834949; c=relaxed/simple;
	bh=1Ku6yYJ6o/MEjJp1P4COEL9iPG3DF104aXJidZUiXAg=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=BJCkzb9ON50mw3UtsKgHqzRiYE6g+HG+ogtKciTJ6LP/PeweQoWSwWz8beT1cS0J2FP50n/x2JIXydkG2kTcKDlOt3RYJO7AMm2u5stjP63mqYMR8M3RCAsgg6prrUxePL3TNL++GgsKFE8Rn+BFZv6zs/PrRFnBw7RBkI6XJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=ndbBrpeJ; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="ndbBrpeJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=1Ku6yYJ6o/MEjJp1P4COEL9iPG3DF104aXJidZUiXAg=; b=ndbBrpeJ4Iim4rHd4FvGlJuNs1
	lhVzKByIYsHZ7cVwhDvBSb8HAgdQIDEyICvUmdijKdBdsTbwXUeLXusjPk+ThNUtu58RdWFpEk87Y
	X8CjvlDADjX/9JVuCF8lgKXWX4dOGtgENB6lLuWOgylcNWK7wRA81NRaFYOpy6mB8ucsix3yYpOjZ
	AhpbtKp8rkF4C5ZEDF5QKtI4CSSAip/vUwm9kZUim92sPpxCa+UeXIuSAf8Y1AEQufw+C4Qbq4rZe
	VTfLof5xMriUr84HcJF4zKY4yBLyFDXQNL15T7AXtDUmNmf76Z+rYoiwoIACKYDdRCft6WlOamOd/
	jqLxd/mg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sK3UI-00BwKw-Ln; Wed, 19 Jun 2024 22:09:06 +0000
X-Loop: owner@bugs.debian.org
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
Subject: Processed: tagging 1073831
Message-ID: <handler.s.C.17188348112844082.transcript@bugs.debian.org>
References: <1718834772-2889-bts-zeha@debian.org>
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Wed, 19 Jun 2024 22:09:06 +0000

Processing commands for control@bugs.debian.org:

> tags 1073831 + ftbfs
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Added tag(s) ftbfs.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1073831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1073831
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
