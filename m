Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037A7F7D3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718834891; cv=none; b=a1JhpuPLVEFUMH/WoAeYFd0caYEiGwrx7JmaETGYp+MbLVfmjBfVSmZNEuTZVXClEbFBaWaB3ZHdVWPSXiv88M2qgX+aMxNBzAkf5I4DY9P7cHpv38fZ8mesXmXhGAI3a6/9SOcLZg5Tar/qaGxlzQRd1U1plUYvjcyYvGkLpXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718834891; c=relaxed/simple;
	bh=5bWnWOYu+qWTkCymLQmnwWwgtNKxZ0ZJ7eTrWhMMYVw=;
	h=To:From:Subject:Date:Message-Id; b=j22pQ5juP43OeptACpAr1njUUJEs3yXEZJhP4aHFDIJpwBkRXzedWef+D4eItw03d76UKYotlDqXdNnU7aIVAs8h8+GQCxSWKhNT26x2x7kMnMnsTNS5vOzMfHiKjQl9fiWW/4dGZDaGSGkstX2ZWdFQbES0klyfM28DZ+y0AJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=tpP12d/+; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="tpP12d/+"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:37718)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1sK3TK-00Gcfx-NO
	for linux-xfs@vger.kernel.org; Wed, 19 Jun 2024 22:08:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+mjwBiCrPnt8GjmX3ITL3eS2ECd24voHrsi3+h5h+Bc=; b=tpP12d/+MVLHKFDJtYvC39Eoqg
	hJVYNpF3DGzjy6ahZyyg6iC9t1nuC74YYny9ynf3zMuWf8wkMYo+6ix0TRPRfPKha6ZDE2hlpiD1y
	73cnye91fPiXVfRWqClnNgFl9JLvOi8y19Jw8+VII7yX3/1RJAAWK96UlIOtcpbTYkTmjz0Qt4X/k
	YyA+SHnluj6iqCrLtYDxRk7eErTiyq1om4tZlcuaQFwOyYI6Iji0Q0ao7cPettEfAkJwYJr7aXX5X
	BRtUFk6fTqbQ4bJcMTAsp4GETK0qcz+3XUGoyxrFZ8iydUrJdfpRwH4ZaWtldvQ4JyOZ8nFCfW7F4
	u/sWF5+w==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1sK3TJ-000xqq-7J
	for linux-xfs@vger.kernel.org; Wed, 19 Jun 2024 22:08:05 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.8.0-2.2_source.changes
Date: Wed, 19 Jun 2024 22:08:05 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1sK3TJ-000xqq-7J@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.8.0-2.2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.8.0-2.2.dsc
  xfsprogs_6.8.0-2.2.debian.tar.xz
  xfsprogs_6.8.0-2.2_arm64.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
