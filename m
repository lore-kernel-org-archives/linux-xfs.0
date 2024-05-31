Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D2B17D374
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 20:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186240; cv=none; b=K8XQGzd5BptqaQxZqu+1rHZgdbeIlfFJtghMRT60H+75LdvLAFVZSxShQ8KX3mYPRMysKFwYsWz08MMjsMUjK0feRm5bbRCMi352HmhP18nLnAaUFABai9NS5g+0QtO45v4hIfsfXAUOFHRfc3w8nyof6TKK4NzIfVNM+KsI1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186240; c=relaxed/simple;
	bh=TPSE5AIREbBfurrspqujKLfb0HtpXacQ+H6ne+Wf0IA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OYRL9ziseYVnj3U75Gc2RJth0BTrn2ZuWaxWIAt2MEf3PWSqUl/Qb2QsFMAPU1HuchqC3vVsW4r/m3PVHQRhgdSPBeaGvqqxhHN0Ll8o6v+xnm/Xo+5fRM9A54bbJ1vwWuZQES8ouraGmGXuE3g4va1dTOZjSdw0cZSfbXA7y/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PU2qwhot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PU2qwhot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327A1C116B1;
	Fri, 31 May 2024 20:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717186240;
	bh=TPSE5AIREbBfurrspqujKLfb0HtpXacQ+H6ne+Wf0IA=;
	h=Date:From:To:Cc:Subject:From;
	b=PU2qwhotWhmqlGpcy8i0DPWKFXVTm2PGWzYmW9uj6MH8FClgPBvHy0E85bRpg9j40
	 0dB23mXWpjsgzPUrA2XP6EluzApVtZLaKxVzVQxZ+E4cLj4xphXeZTWNJZufxM5f1n
	 bM0NCJpZjtzz9UxsMumNFPk8DuVXsWZucdPBlrOjdFX0oORtS7W6bDI5i3kCXbPNpj
	 msvLaM4PmduwP0JGe0CsvsR0AAJu2VuoBb82p5FJODVw071+KUfdp6BtZosN5wyq7I
	 3J5dJeO1Tu+EMB8Yj9P4ROI9NxQZ11kgujGh1mcz9gJ3G7wgyS5Y28a9vWzbOsT/G3
	 qs9lDAEY3DWKw==
Date: Fri, 31 May 2024 13:10:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: detect null buf passed to duration
Message-ID: <20240531201039.GR52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

gcc 12.2 with ubsan and fortify turned on complains about this:

In file included from /usr/include/stdio.h:906,
                 from ../include/platform_defs.h:9,
                 from ../include/libxfs.h:16,
                 from progress.c:3:
In function ‘sprintf’,
    inlined from ‘duration’ at progress.c:443:4:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:30:10: error: null destination pointer [-Werror=format-overflow=]
   30 |   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   31 |                                   __glibc_objsize (__s), __fmt,
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   32 |                                   __va_arg_pack ());
      |                                   ~~~~~~~~~~~~~~~~~

I think this is a false negative since all callers are careful not to
pass in a null pointer.  Unfortunately the compiler cannot detect that
since this isn't a static function and complains.  Fix this by adding an
explicit null check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/progress.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/repair/progress.c b/repair/progress.c
index 084afa63c121..e13494e0ed23 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -435,6 +435,9 @@ duration(time_t length, char *buf)
 	int seconds;
 	char temp[128];
 
+	if (!buf)
+		return NULL;
+
 	*buf = '\0';
 	weeks = days = hours = minutes = seconds = sum = 0;
 	if (length >= ONEWEEK) {
