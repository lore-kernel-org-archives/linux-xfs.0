Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D95A19D072;
	Fri,  7 Feb 2025 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738956438; cv=none; b=fHSn8FaAkJY2O84shT6R2kVJw71EMDHO33wBM036QlGl6nGEhxKndQM0nPaldWzIpD6Xi+cmeOSputsE/kzVKfOBnaTH6Qx7E4AspYnk5vArtAExBOUUJslCEWI0SSJaL1UOojT3gN2hfu6dKIsE2l7PJI3kr3oVU7RQ7tfAH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738956438; c=relaxed/simple;
	bh=z3xoqMMMda5suYBfxMjs8okCGL2VmRVbOHMyyMa1JQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRL5sTUAncRqvrXotSHXoqnsejH7JVXjYHG9W6iZtFmWuZYP3/ES2QiWNXoUkXiUXJy+xDej0Ivb6AI3VCU5DyjOm0xz5SvB7Q/iBfdZoQLWGBLHQlzlzF2aFDmQDRlLXXSsrNR0kXqW2hdT5yrxwSnv9K52PpdHT4xqyZ0bNO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1bPf6WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1bPf6WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDAEC4CED1;
	Fri,  7 Feb 2025 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738956436;
	bh=z3xoqMMMda5suYBfxMjs8okCGL2VmRVbOHMyyMa1JQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V1bPf6WD+16FbN25mSO538u8+JyfrvrUYMFBwmykVz3aUbgEncUBzbYNd3gf3QeBl
	 GuzHblBcl0pHb3tUZMQTk/fU+88eLgx59uB++3axxI29X/kWtHSIypyo3NYm5CfchE
	 3HmCouqzkQAkRl0AOZU60bMh/9WPSfooPWaa7D+NdAFF26jxYv7/mgo4kbfMHPz9gh
	 v60aSkqdz7qx07i+IeishQDnQRAIBVh6E/S+9MEg496syVTFQzzyR+kVcrZOR+256I
	 UpsqUtXgVOixvOwqjtOmjpyS3lrM01aiQUYA/1uf8yg7njNu7j7ihw5OWmfdj/iNfe
	 YNVUkJsqLY09w==
Date: Fri, 7 Feb 2025 11:27:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org,
	syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	eflorac@intellique.com, hch@lst.de, cem@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCHSET RFC 6.12] xfs: bug fixes for 6.12.y LTS
Message-ID: <20250207192715.GU21799@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
 <2025020556-bagful-cosmos-2a72@gregkh>
 <20250205155634.GG21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205155634.GG21808@frogsfrogsfrogs>

On Wed, Feb 05, 2025 at 07:56:34AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 05, 2025 at 06:55:19AM +0100, Greg KH wrote:
> > On Tue, Feb 04, 2025 at 10:51:15AM -0800, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > Here's a bunch of bespoke hand-ported bug fixes for 6.12 LTS.
> > > 
> > > If you're going to start using this code, I strongly recommend pulling
> > > from my git trees, which are linked below.
> > > 
> > > With a bit of luck, this should all go splendidly.
> > > Comments and questions are, as always, welcome.
> > 
> > Should we take these into the next stable release, or do you want us to
> > wait a bit?
> 
> Let's wait a day or two to see if anyone has objections, and then I'll
> send this series again without the RFC tag.  Already I think I see that
> the first patch needs a cc:stable tag to capture the version.

Ok, it's been three days and nobody objected.  I'll send a proper
patchset with backports shortly.

--D

> --D
> 
> > thanks,
> > 
> > greg k-h
> > 
> 
