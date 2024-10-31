Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DC222097
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417617; cv=none; b=iCW6aXwj7oV2YrimZ1ldH+WscmsX6sQXE7OVWMd0GDV6cLC0dxuS10hr1uVbaC3yiazZW00wz7/lJrEa8U5H6WLBlQmK9wOWweoe3cbdaPoxWNDnbhpIzCqeS+D7IOP1W+weYf0mr3eq1xC96WRRuJZ97CUt1DiLS1P5z5EyPXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417617; c=relaxed/simple;
	bh=YaFCOZcyunb/jpqQV+uYI4UeS0VB/BA1pn993AV0Bj0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lhMp5BfjHwH7LP/eqcf7U4jnkVu5Kv/EtGwt793MS7xnBB9Ec3VzAcO4d60biebHb59htQqjNRDX1qBvip9pIA2uRjl6MxiEzq9+10UUsuRn6mitwEGhkeksEO7BMIobu18Ud/PDFfHIsIt8J5Z4QkCxBs9CUeTM2yiq/Fa2e58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WG1PXAnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WG1PXAnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323ADC4CEC3;
	Thu, 31 Oct 2024 23:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417617;
	bh=YaFCOZcyunb/jpqQV+uYI4UeS0VB/BA1pn993AV0Bj0=;
	h=Date:From:To:Cc:Subject:From;
	b=WG1PXAnFXo9bFK5jDUVyfTC4M3dD4thqgUj3RftyHKzSpVMZlZVNF44tnztJ7uFHn
	 guqhW8p7PeX4C60NkC/uMh6h0feqL9mJbCfDw/h4yqxmcBLCfHfGzAicfswoNb5nze
	 Qum4Dj+fzLyZtb4vEeBcyuuZ4/0eSTV4OC/8COwX40is+0dfOK2AGUBhfYRIOrX8lP
	 nJgDMHSUoRJ6lf63w9OHniGIYLOlvy0d0OAb6uSJtviQ4/rCu3KmW5kQ3Y2A8XHMqH
	 0XD3qlDvjo4rpWAjuOFF6UrbQ4Hi+sv0zfwmWwLnecXNst4n3qUiRc62ThxcsqHB4W
	 f77IvVBUZ/GVA==
Date: Thu, 31 Oct 2024 16:33:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB v3] xfsprogs: everything I have for 6.12
Message-ID: <20241031233336.GD2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

Please pull these patchsets for xfsprogs 6.12.

--D
