Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392E3314AC
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486042; cv=none; b=OWPygWbLo3Lui/cYjLuTyPCP+QjasRcofYZ3y3bb6pS53Jg+Z+EeA7MrX5A0eeVd+hJsJUcWuLar0aQKE/IpF2lbAOrDI3HmTMKsqEtEW2JhyhuDk4O/ko6CSsfhSaNCjaGfLpw7gRVnKqf262NzEjCqHWli2A4WTVK/OzotGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486042; c=relaxed/simple;
	bh=8eJfAb0yPGD/VckujfWsVRNh8GWEld8S7f4oirJvcPU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GBpDSQJ9EmTFEz14zqSqRBxrUgn1Y4JPXkfLcqg0hrqKRxxJnFDEPAxe6xLmIDJLoOyr7j8tEVHgA+bPnObjHZB6fb66xgJxdDxE2nLc/L0MdgVIP35rPAdGYP0/tT9N+oSmk4Ay5HdGKBQIRsSjOYsK7HX+/C9sRRjdMz34zEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXyoJJSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXyoJJSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2871F000E9;
	Fri, 31 Jul 2026 08:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785486041;
	bh=7XDiGB3tM/kfbE8/F7O2Cc9jWGnCzjoE7TsUz55Tzp0=;
	h=Date:From:To:Cc:Subject;
	b=UXyoJJSoh5bYvK5rxPxS3gHVfEXWAqxWq73cbaNkplXTLeOGcqj5oSSsVYA3jiOlF
	 R1YrNsxvL6s+VLK1KyvYgg+CCB6OrGJLJlPzacT3dIMl0FrtPWpMD/RXNAetnbUyh3
	 qScAcD/Ro/HYe5xdx34L0VxLiyhrKuJy4SC4o3B60158hv14w3lWI7FhStMfqPqoxS
	 5NXiCkFU5X89zdGTu8DwOQLd3v9aGlXp5EoE45n/arRtZoBiZms1K4B/vYIZ7VHafN
	 J79Nr/971XHhbohBo4RRSwJSh/+b0qi3DOvEYoy8E4cdFntKyy3DWWLumdvY2eAZo5
	 MFBgTzo8ljOwQ==
Date: Fri, 31 Jul 2026 10:20:36 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: avinesh.kumar@suse.com, djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to d6d4236027e3
Message-ID: <amxax3JLMt4oFeaw@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

d6d4236027e31e9a54fd3916ff130b1d41e78027

New commits:

Avinesh Kumar (1):
      [2d8d811c789f] libfrog: make cmn_err() emit each message atomically to avoid torn output

Christoph Hellwig (2):
      [b7876c0e11a3] copy: log the error number when failing to write
      [d6d4236027e3] copy: always align to at least page size

Code Diffstat:

 copy/xfs_copy.c     | 8 ++++----
 libfrog/util.c      | 2 ++
 repair/xfs_repair.c | 2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
- Andrey
