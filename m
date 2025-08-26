Received: from trent.utfs.org (trent.utfs.org [94.185.90.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00579280CC9
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.185.90.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224394; cv=none; b=dpoNur6MxfcICALJYRP9Lz3XX9NpFAOobYLQst6nM3qMhYQEggBgDkhlKIciQSdSEonF1nr3xcl78AI83mCyYw/41nv8iGCEG3BsNguepPwavxTJjtvUPdDRT0BuAokR2VXiFriMHvmpLuS5Cp2fS7ssMB7BvIJdCBfXoi9Ah3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224394; c=relaxed/simple;
	bh=6J7bqC1QI/BRKYDXC1hTw1PP+CKUBZmWJAWCEE5QVhU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=prciQEAJflZmQiTu45fnczaHyUyNlwfQj5ROyAFr1HSOSzOZ5UiYJoyIyxacRsTqBomWruUN26Ojb91Fx2AlxY3Zh+YrwMHjjJ5IbnT+an179ORQQOLEWIHLqU971M9XqGM1q6S2pr0Y52HmWzY4m2lRtcHcs0+wYSIxJtBfWJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nerdbynature.de; spf=pass smtp.mailfrom=nerdbynature.de; dkim=permerror (0-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b=xZfUEsQQ; dkim=pass (2048-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b=i3OXQPDo; arc=none smtp.client-ip=94.185.90.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nerdbynature.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nerdbynature.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b="xZfUEsQQ";
	dkim=pass (2048-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b="i3OXQPDo"
Authentication-Results: mail.nerdbynature.de; dmarc=fail (p=none dis=none) header.from=nerdbynature.de
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/simple;
 d=nerdbynature.de; i=@nerdbynature.de; q=dns/txt; s=key1;
 t=1756224386; h=date : from : to : cc : subject : in-reply-to :
 message-id : references : mime-version : content-type : from;
 bh=6J7bqC1QI/BRKYDXC1hTw1PP+CKUBZmWJAWCEE5QVhU=;
 b=xZfUEsQQ29Zx9ViNN6vnRJTy1wArZ+SGUkyHRin2Ycbov4CLfvhCMAo+Z/k6CPq1/Rner
 Yn1C7wDB5tBCiaUAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nerdbynature.de;
 i=@nerdbynature.de; q=dns/txt; s=key0; t=1756224386; h=date : from :
 to : cc : subject : in-reply-to : message-id : references :
 mime-version : content-type : from;
 bh=6J7bqC1QI/BRKYDXC1hTw1PP+CKUBZmWJAWCEE5QVhU=;
 b=i3OXQPDo5dE9Dtpulytjqh+TYL+RetcqT6PT8p8KsZWLcHebs+t6zBR/Ehr20KH8pA5hd
 B8SPKnu9bYhhMLG9XmBFU2HsKztaIHn9bX+VumIP+nBNfIQ7T9im8emHLBtNWSjTPmVKe0z
 UjQzUxBuv+vMsodOtetupPvQd/IwEK6H8pakXATdNBSd1rVdYUR08UyMSI5hAe0C1jYcDM1
 jXYiWrmSVVGGYRjF//47TSB1jIG5AUUATEeazh/yRg/+2ZkbvcQ/5VmlkteoSt0icnl8Nbt
 1JdeEMqZfalEgOrWuyaRB77rPDwxUJlOzmIAR34gwjlYxEqtawB4tpg2OPzQ==
Received: from localhost (localhost [IPv6:::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by trent.utfs.org (Postfix) with ESMTPS id 8D3765F7A7;
	Tue, 26 Aug 2025 18:06:26 +0200 (CEST)
Date: Tue, 26 Aug 2025 18:06:26 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
To: "Darrick J. Wong" <djwong@kernel.org>
cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py
 [v2]
In-Reply-To: <20250826155747.GB19817@frogsfrogsfrogs>
Message-ID: <9ad33531-f8c0-07cf-59e4-7e6bbb173ebc@nerdbynature.de>
References: <ce844705-550d-3eb2-0d08-d779f9ebc029@nerdbynature.de> <20250826155747.GB19817@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Aug 2025, Darrick J. Wong wrote:
> Heh heh heh.  That old code was for compatibility with RHEL6(?) back
> when I started writing online fsck.  That's indeed no longer needed
> because even RHEL7 supports datetime.now, so thank you for the update!

Thanks for providing the context. Scrolling through that whole script I'd 
say the helper function is not even needed anymore. So, if it's not too 
much hassle, here's a version 2 of the same:

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

Thanks!

diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index 515cc144..ce251dae 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -493,12 +493,6 @@ def scan_interval(string):
 		return timedelta(seconds = float(string[:-1]))
 	return timedelta(seconds = int(string))
 
-def utcnow():
-	'''Create a representation of the time right now, in UTC.'''
-
-	dt = datetime.utcnow()
-	return dt.replace(tzinfo = timezone.utc)
-
 def enable_automatic_media_scan(args):
 	'''Decide if we enable media scanning automatically.'''
 	already_enabled = args.x
@@ -515,7 +509,7 @@ def enable_automatic_media_scan(args):
 	else:
 		try:
 			last_run = p.stat().st_mtime
-			now = utcnow().timestamp()
+			now = datetime.now(timezone.utc).timestamp()
 			res = last_run + interval.total_seconds() < now
 		except FileNotFoundError:
 			res = True

-- 
BOFH excuse #72:

Satan did it
