Received: from trent.utfs.org (trent.utfs.org [94.185.90.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33BD139579
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.185.90.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214573; cv=none; b=jFiSpqaM2wwgHnvy1QwfyHO8rB808VqrYec5wEyFc5HiBVkEuDTu9R0HKioGtSWmGubJB4AKOi0BDnosuQkoiOaKUPEABePvd23vW1+Y3/TQrRgYBejbopunkpjRFWRDK5Rx6ArcLyZ1+83/GqdoXx7+mcpcb8Gh/TLBpfXqx9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214573; c=relaxed/simple;
	bh=VJ/q/jbbNSamEaDBMkge77mKJlNf7zt+n6EtTi7+w8o=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=sz9RNKvoq6NacDP6Hopiu9o8a4VuNS4Jsm3cG2Jsyj4rmXSTmiimYqXbl+R5UZnOaPdJNQEgUwLU8En9RozQpaEeK3u3JS0kRrI6j3xkc6xXx2ttAMcwfUR8dp8yog7PEHzE+gd7SoHN7o/7Kzm3InOlez9tFEOO27n6oiA1AUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nerdbynature.de; spf=pass smtp.mailfrom=nerdbynature.de; dkim=permerror (0-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b=6Gyt/z+B; dkim=pass (2048-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b=Cb3RGTnk; arc=none smtp.client-ip=94.185.90.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nerdbynature.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nerdbynature.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b="6Gyt/z+B";
	dkim=pass (2048-bit key) header.d=nerdbynature.de header.i=@nerdbynature.de header.b="Cb3RGTnk"
Authentication-Results: mail.nerdbynature.de; dmarc=fail (p=none dis=none) header.from=nerdbynature.de
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/simple;
 d=nerdbynature.de; i=@nerdbynature.de; q=dns/txt; s=key1;
 t=1756214142; h=date : from : to : cc : subject : message-id :
 mime-version : content-type : from;
 bh=VJ/q/jbbNSamEaDBMkge77mKJlNf7zt+n6EtTi7+w8o=;
 b=6Gyt/z+BZ3HqZ/5cpRK0bQNxA23/gsyOKVPQ/Ue2/7Vq7zH9Kc11SZDi9DxkxSUh5jwcn
 huR1iLAyC0yY8mxDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nerdbynature.de;
 i=@nerdbynature.de; q=dns/txt; s=key0; t=1756214142; h=date : from :
 to : cc : subject : message-id : mime-version : content-type : from;
 bh=VJ/q/jbbNSamEaDBMkge77mKJlNf7zt+n6EtTi7+w8o=;
 b=Cb3RGTnkrfujJ2xP1a/FST57OggcPMmLvIe5E4NeDHqPhVDeieeWBPuNd3PfST5Ah+UbL
 IwIrMVM7wik1W6pjTeupn47VchyyYZ2Nm0PVjPuicz7u9lljPJ3zFNilM7ejnLsbJmMwH3O
 6j5j2dx0SjIY/urTj1N8Xre73an/gvIljlQ+odgTVTxfM1FBKUmNUj9r1yDZy9CgLCWpNjy
 /3WuX0NNDN2wI0/46G1JBPa+zWpGgupB6OYW9t5sdpm50WX9Dtrlgs73bFKu3HBEXqFOC2M
 iDtMV5qCJNmnslRvbcxAfNwYXNUyImm11Mcmr6hl1/HbZ3ilQlFL2OiGpJhQ==
Received: from localhost (localhost [IPv6:::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by trent.utfs.org (Postfix) with ESMTPS id E3BBC5FEFC;
	Tue, 26 Aug 2025 15:15:42 +0200 (CEST)
Date: Tue, 26 Aug 2025 15:15:42 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
To: linux-xfs@vger.kernel.org
cc: "Darrick J. Wong" <djwong@kernel.org>
Subject: xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py
Message-ID: <ce844705-550d-3eb2-0d08-d779f9ebc029@nerdbynature.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Running xfs_scrub_all under Python 3.13.5 prints the following warning:

----------------------------------------------
$ /usr/sbin/xfs_scrub_all --auto-media-scan-stamp \
   /var/lib/xfsprogs/xfs_scrub_all_media.stamp \
   --auto-media-scan-interval 1d
/usr/sbin/xfs_scrub_all:489: DeprecationWarning: 
datetime.datetime.utcnow() is deprecated and scheduled for removal in a 
future version. Use timezone-aware objects to represent datetimes in UTC: 
datetime.datetime.now(datetime.UTC).
  dt = datetime.utcnow()
Automatically enabling file data scrub.
----------------------------------------------

Python documentation for context: 
https://docs.python.org/3/library/datetime.html#datetime.datetime.utcnow

Fix this by using datetime.now() instead.

NB: Debian/13 ships Python 3.13.5 and has a xfs_scrub_all.timer active, 
I'd assume that many systems will have that warning now in their logs :-)

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index 515cc144..a94b1b71 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -496,8 +496,7 @@ def scan_interval(string):
 def utcnow():
 	'''Create a representation of the time right now, in UTC.'''
 
-	dt = datetime.utcnow()
-	return dt.replace(tzinfo = timezone.utc)
+	return datetime.now(timezone.utc)
 
 def enable_automatic_media_scan(args):
 	'''Decide if we enable media scanning automatically.'''


-- 
BOFH excuse #360:

Your parity check is overdrawn and you're out of cache.
