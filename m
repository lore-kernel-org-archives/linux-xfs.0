Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2649B5B7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 16:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142615; cv=none; b=MgBd2Aq+UlTqnB7vFrgo1/be/+aV4tDsjJK2zS9lF9+C08jIghgrJCWr/ayYxSnL3yZ7lWaMnNQx8u18VU2uMlkjUnTKpxndQZITaTpXVrt+BEyL7WNN7PUsxjiO0MgiVFt3Qin7itOb/1i+RssDt+olPSKfN1czDBHNv4JMOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142615; c=relaxed/simple;
	bh=zjYhg7T+8cedZOv12dRei9Q7a7Ip7Ku8khLhiT31v5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8ClHKMws46yU1uuVHNOTeY3rEnQjhx72edYlJ5+4mRpjqmeMUJaciHrNxipfgxZDl72GRrSCsejwb3v+v1wWuWRzWQ4gXQv17xtx0xwcYDTjlTW7CU2UkPPJTrgDYaIQGy0S21M4VbDWo1oyYFJT1j856KApmL10Ei6XSn6jTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsnHqaVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsnHqaVJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D0E711F000FF;
	Fri, 11 Sep 2026 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142613;
	bh=zjYhg7T+8cedZOv12dRei9Q7a7Ip7Ku8khLhiT31v5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FsnHqaVJ0QntCXuA1sDQj/nJvaWyYjNefNw3mUdkKuB/Byn2j+/ihFv14xW1OWQ7f
	 pmnA7tQfPvlwQa5B4QEXLM6mJGK2XS2hlLJc7FDfQ6K/TKXb+b3u9GkQscXspGy8LM
	 N9ByMnu12hGvijAOjyIz9ZCBRMXoTTNKBULPYrxS5xNb0k0rAYAbYHnZqt6L1Bnp8Z
	 iBqHJNPOC+cvKNEX7Dmf41oarwsZjT1v3ZTi+cBcQcWdJHTIJIIuJXa9C9C1yuf3hg
	 9k4bRqGJRyyfe+yZG7txpxRiN+F5PMB5GKo+Nb3rp00Fk8fl60cedMijpTV+VPEa1K
	 A92OCjiXPfbSQ==
Date: Fri, 11 Sep 2026 09:03:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] makecfg: handle old V4 options that are almost
 always on by default
Message-ID: <20260911160333.GH6265@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>
 <aqQi9rMA7f7fCeZ6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQi9rMA7f7fCeZ6@infradead.org>

On Fri, Sep 11, 2026 at 08:49:10AM -0700, Christoph Hellwig wrote:
> Looks good, but I'd really expect this to just go into the original
> patch?

Andrey had already reviewed the original patch, so I put all the new
bits into separate patches so that (a) if Andrey pulled the patches into
for-next then I wouldn't have to separate out the changes, and (b) if he
decided to re-read the series, he could focus on the obvious new stuff.

Longer term I'm going to merge all three of these back into the main
patch since Andrey did actually review all the new stuff.

--D
