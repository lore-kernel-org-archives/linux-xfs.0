Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6F34E771
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771603037; cv=none; b=i/ZfiBY61lFUuvKMNiHBPww/8zpaFWwboxPP8MRx2rHtDjj8JUQXvAOpfH+onjleVve3WE8YexHUU8F6XFeCPbeOMKX/+I4rLuJbjv2clfGb0WMzdvbGqNL1Ql6Qaq5e8yZ8EL9BbqjsGbVaeK/9BArpd2n1I4UPjRw2iQS6t+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771603037; c=relaxed/simple;
	bh=PgGYHDvluDEDwh42Htw50puTD9Onf6jLJr5njX3J01c=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=n8k+n2M+wLDCxmtvi/Q0YvFSfOnuq5ded0SJ26AY1Jkz/mb6nAZnE0DN71DhiXVCewJNqu9wlUS6rGWKM6/RO5TO7m5yN5bJ2QHxC6Oh1yuw0GgQAEVQiLstTkeIw89u+kFybHLxp82qZjR2ctLkDxgaqM4lBZ/e2c8wZ7XN9v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=V8ph7C2d; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="V8ph7C2d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=F/aFgDca7C5oLTN2wHjgv0ZHEfixDP0D7+nlWbQ1zNM=; b=V8ph7C2daAq1JUQz0xQmIMDqPA
	j/jB4JRn0yj2kP2FYpJ8QTwF7YaJa0FFuRdhblwMF8c37jYvOjUwTuvd2oVR0ncwXc1Y+eB/Eb3TY
	mzRgaYoRlZMZz6NlA7q7K+HDx91JAv5udni6b5N1k6B5JvwORsZjgxI9yhYGKr8LTe/KIJr2kFhr+
	ty5btz3PDyx+JgO8bhgA3zbIy75qrDZ9pRXl9x06sTGW7yTAiixaQ2fYrPAqslGsoN1o8Gr3ZZtCG
	UTGrBjIlBWFye8sTzXvkDWzf1G9qkzTLqocYPl+4oyGLZIGchqCFCrCDlpfAiWoGrkhlWj6Ow2Epf
	KW6tIeGA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1vtSsL-008NPQ-2j;
	Fri, 20 Feb 2026 15:57:05 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.510 (Entity 5.510)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Marco d'Itri <md@linux.it>
CC: linux-xfs@vger.kernel.org
Subject: Processed: forcibly merging 1116595  1128087
Message-ID: <handler.s.C.17716029431996265.transcript@bugs.debian.org>
References: <1771602938-546197910-bts>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Fri, 20 Feb 2026 15:57:05 +0000

Processing commands for control@bugs.debian.org:

> forcemerge 1116595  1128087
Bug #1116595 [xfsprogs] Packaging issue: xfs_scrub_all_fail.service NoNewPr=
ivileges breaks emailing reports
Bug #1116595 [xfsprogs] Packaging issue: xfs_scrub_all_fail.service NoNewPr=
ivileges breaks emailing reports
Marked as found in versions xfsprogs/6.18.0-3.
Bug #1128087 [xfsprogs] xfs_scrub_all_fail.service: fails to email report (=
might be similar to bug #1116595)
Severity set to 'important' from 'normal'
Marked as found in versions xfsprogs/6.13.0-2.
Merged 1116595 1128087
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1116595: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1116595
1128087: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1128087
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
