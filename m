Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197051898E8
	for <linux-xfs@vger.kernel.org>; Mon,  9 Sep 2024 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.73.31.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725911467; cv=none; b=AJU2sgeiQw4ZOeyP7fevtFHCaLUv7EJttghx+La+bTTbOAfg+TPrQUdmWgS2S+kF0C/2REfBD6Ig+pEHPqA+Iy6ZcJgLvY8pe1qnB1+6q4hzMmCWzbQHSXRmIICMuWgh+8+OHhy3RcwvLgW5S9vEmCLgxi3An3UjEf8mq31/gEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725911467; c=relaxed/simple;
	bh=2B6GbIjL/dZUlfVcIaRSFnnwAAlMjrOwSXLkCnBQaps=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=In7oaGB6XC9HKaNABfrR/6J9fYAUlGkLSSQ0p196B/if3aEmsukwXwzxYjSLBCWPwAFr0F+f3cY+HCnaqYPKfibRl93FLNg2Qd0LpSPg80ICcbipzZ8G3B1TK/c+oV5vTj2sNiOYuZrfGY+QIWg+fLRrzRAESmUD67rNaJ5hD5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pld-linux.org; spf=none smtp.mailfrom=pld-linux.org; arc=none smtp.client-ip=217.73.31.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pld-linux.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pld-linux.org
Received: from stranger.qboosh.pl (178-36-30-190.dynamic.inetia.pl [178.36.30.190])
	by mail.qboosh.pl (Postfix) with ESMTPA id C73441A26DA9
	for <linux-xfs@vger.kernel.org>; Mon,  9 Sep 2024 21:42:33 +0200 (CEST)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
	by stranger.qboosh.pl (8.18.1/8.18.1) with ESMTP id 489Jhtvi014455
	for <linux-xfs@vger.kernel.org>; Mon, 9 Sep 2024 21:43:55 +0200
Received: (from qboosh@localhost)
	by stranger.qboosh.pl (8.18.1/8.18.1/Submit) id 489JhtlZ014453
	for linux-xfs@vger.kernel.org; Mon, 9 Sep 2024 21:43:55 +0200
Date: Mon, 9 Sep 2024 21:43:55 +0200
From: Jakub Bogusz <qboosh@pld-linux.org>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] Polish translation update for xfsprogs 6.10.1
Message-ID: <20240909194355.GA10345@stranger.qboosh.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)

Hello,

I prepared an update of Polish translation of xfsprogs 6.10.1.
As previously, because of size (whole file is ~628kB, diff is ~746kB),
I'm sending just diff header to the list and whole file is available
to download at:
http://qboosh.pl/pl.po/xfsprogs-6.10.1.pl.po
(sha256: 1fd88c1055d72f1836eff4871e056aea3c484e6a33d73cd3a28fe2709bb41853)

Whole diff is available at:
http://qboosh.pl/pl.po/xfsprogs-6.10.1-pl.po-update.patch
(sha256: 993b7aecd46ada0d277ce19a2b42351f2a1492efafd6d99879575b964ece72ec)

Please update.

Note that diff could be significantly smaller if files order is preserved
between pot regenerations or merges - I strongly suggest adding "-F" option to
xgettext and/or msgmerge commands.


Diff header is:

Polish translation update for xfsprogs 6.10.1.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

 pl.po |16343 +++++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 8871 insertions(+), 7472 deletions(-)



-- 
Jakub Bogusz    http://qboosh.pl/
