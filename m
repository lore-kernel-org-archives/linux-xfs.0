Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198901;
	b=KNL/rB1M4xmxXjLQnx0C35ZUroGgwzm9ZHlCsxxKx3yYMD5Zr45NfKkM/gkBSI1J0Myp
	 mKRy5lcA99r6U0akrSf47tk/9Hr8CK2VjJW8j/0mmzUsO3efxN0SyGYC8Cranjvny/qui
	 Rem3mD5c6Oam4EXKLU50FbF3q40MdiS8Os0a6BdXpKF3+WWOnTQGLYALd/tEwzmiI2f92
	 wmeHbN7YaWkAWol01xFVjOemOtAmPAT94551bZ8JrcjUr0p83jCCfsw/VvVsVJnF2mIsb
	 8l/uCv5+OHK9N3V9+LJYXskanUVJRftXYF6pIXraHtgRgI1vd5IKszMmDI2UHmq3E0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198901;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=ZTwGZs4OFocuSIhEh2tktIaLvTRSKsf1Lw12SiyVbrY=;
	b=zb02pv/wOgiSb3n1w8W93xgfGqj7qLUcpgILNXlrOewvei5r2sVHbN94vKzQi2+B/GWb
	 WpiGu7kDFG1OoEWJJLdI1Wv6OurDWVvp0Q0M0fv71wbitCB5I2ucT0nX/RpGG0lE7lZFa
	 unKsqFmTcHaAVgUoNkWG/0XphNOuaztccAAB7CXRh7iHQYP6oxrieAmcBpfuPGCPrlWa/
	 ItVPxch75L9hqYSlTSlG35AK+f4ZC1tx6r1SbhWVgmYTvl9Gex4gl6j7uKpcZYPomVssj
	 8oJd03CZJAftNTyV7G2q9CfVcT6igD63hf65mMeDFOYiIKV5UkOhaqECTU8dg7zZHAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4F0606A8BE;
	Fri, 20 Nov 2026 18:21:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA4F0606A8BE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE15D6732A; Fri, 20 Nov 2026 19:21:35 +0100 (CET)
Date: Fri, 20 Nov 2026 19:21:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, vdubeyko@coreweave.com,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 1/5] iomap: add iomap_dio_end_io() helper
Message-ID: <20261120182135.GA2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-2-slava@dubeyko.com> <20261120-flach-befanden-notaufnahme-b0a663466be3@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-flach-befanden-notaufnahme-b0a663466be3@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 20, 2026 at 02:48:09PM +0100, Christian Brauner wrote:
> On Tue, Nov 17, 2026 at 04:48:40PM -0800, Viacheslav Dubeyko wrote:
> > The helper updates i_size without any locking, so it can be used only
> > by file systems that issue all direct writes extending i_size
> > synchronously (IOMAP_DIO_FORCE_WAIT) under inode_lock.
> 
> Meh, this should really not be named so it looks like its the default
> completion handler. iomap_dio_end_io() really sounds like it.

Well, it actually should be the default handler as it does the right
thing for simple file systems.  In fact I'd prefer to automatically
call it if no ->end_io is set as that would remove a lot of boilerplate.

It would be nice to do that and remove the duplicate version in various
file systems.

