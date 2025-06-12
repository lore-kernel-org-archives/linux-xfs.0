Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FEC2F431F;
	Thu, 12 Jun 2025 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748624; cv=none; b=kd9P2JK9NhnuGYc42Zh+WlaFUr2hG/HlvVRV+ZVnRUui8tA1ncIWbD+0nqlN4TbrFA3wXtIrY+wi38GQvInWZAWkDJqzENm/6e/JLprpcKPmmB0wdKCXFwyZx5C8bdmr3uGt4GGV4owPuW4XECbQEJE+DvLN0HXrOyqZaX/YlL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748624; c=relaxed/simple;
	bh=aXX9z5zq7It2AaK2+lgLG+/IFmxaO6FzbUvxxZUpfVI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1yOVm2/QSfSFASQraLdlLYIPI2fxq8x/NkCDNb/NWuTTnYFlJ4D2YQcV7FPEPsXCqyOZvbGw1vltiTfFjdRZ6/jFsZxhSQuJkq6AAA4Tem7i8HpCjsB2CpSOaddxZfwh6S+ojGoEWTIG4wtJsVwkoIYqpWO9WRjicgs3pa2ENQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8D0E1A0353;
	Thu, 12 Jun 2025 17:16:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 00CD620013;
	Thu, 12 Jun 2025 17:16:52 +0000 (UTC)
Date: Thu, 12 Jun 2025 13:16:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612131651.546936be@batman.local.home>
In-Reply-To: <20250612131021.114e6ec8@batman.local.home>
References: <20250612131021.114e6ec8@batman.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00CD620013
X-Stat-Signature: ikpqjsnkzyjna5ngkpzfoxyo8bugctsm
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19a/ZhBEIQTLTGiYB/Nq3jpXPXJNOOzIQg=
X-HE-Tag: 1749748612-536787
X-HE-Meta: U2FsdGVkX1//zoY7OIXnG2a0daaJJlWSk7G4oIUVAPZOjqTh2FWBWctjUEKL93ui3OLf9fvaauz1bbuolxyHUotIcWdaWE5MNtliiM6gx/iGGRRlPDWF7F9AjX9xKkSSmxa0/Bn7FV3x5TQ7rf2coAn8nzEXtqdZZQGTbe8qXD3G1su3/GJ25L7o7dJd5lVtQnvEjY6loobotlvP7i+2/vxI6uviO/mSKt9XB28YxYxeViDO86AFAgfgbqeO+P2FItLXYk6aU4H7kC7DqNDKvbiIF5GIQQVGZo/QRyse3KbrFNeQx64qLi0oX9uSCfYJ

I also found events: xfs_metadir_link and xfs_metadir_start_link are
defined in fs/xfs/libxfs/xfs_metadir.c in a #ifndef __KERNEL__ section.

Are these events ever used? Why are they called in !__KERNEL__ code?

-- Steve
