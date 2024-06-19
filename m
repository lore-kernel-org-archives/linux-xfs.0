Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791C14EC56;
	Wed, 19 Jun 2024 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718817799; cv=none; b=R/WIraHmEoTfbnzz7DN3jjbEEm0UyvUDZfXqrShHOUbW/4azi/YCDg7o6IPbSUydKH1fBQ/rcKl+CWIz4FOV1F1iBc2OTZRlvLTLj1AQp9rvhPH3xMZP5X6h4xUdZfWD7KrCPwWTHwgBA4c3Vy7NbqHm/m65s4IwDu4XoUUv6rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718817799; c=relaxed/simple;
	bh=24OO11kCs4iWV3l659s0X0GmUwj8OnizkIjHce/ueOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnfumpPLRYi2An8WdaW5KvBY6uXJa9gcLVpBwQkLjPOOYzC4uE35Bu8TW3oogiuV2v/HDwDRlmY8gnH+35NdSMglWOraSWJ8M4GWBgn3a7nx9KXsSs2qoQ3F27837OHOHW+FaaZSe+aN/6dN3P+/esDKEH2QDiUctuX3n4xZcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbwNB2Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbwNB2Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CF9C2BBFC;
	Wed, 19 Jun 2024 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718817798;
	bh=24OO11kCs4iWV3l659s0X0GmUwj8OnizkIjHce/ueOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbwNB2YjnS+o4bcBT4CoxWiROUA7LD4M6OFGeOSfloysqk5u1qCWe12DME5M/yraW
	 jZN2G3L/CGc/mS6hBSSkYStuTh6Fij5A313m/YhYW3jZ5kmvjMxWUW/2+bc6INqwjt
	 J2o+0n7Xhvrb+/J+WrVJeF5D1nGCB7TSjMbO8YDEI4DMD/Tg5wlKMrhz5n7FZpxdL7
	 zi+w++VHy/g6Gs7dclr7O1GAPOcQbtuqQpkYE+b0FQQfWrRB514eRAAS8M9EpMlx1M
	 Az+utl0lV5gvdWkF2jQ4dknZYGMHZf6rgEwpd4Oj0wvB8pLQ5KJZYqCOacSU8/skIV
	 vr37NRK9mZDYw==
Date: Wed, 19 Jun 2024 10:23:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] generic/710: repurpose this for exchangerange vs.
 quota testing
Message-ID: <20240619172318.GR103034@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
 <ZnJ15ZG1nWsCkxiG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ15ZG1nWsCkxiG@infradead.org>

On Tue, Jun 18, 2024 at 11:08:37PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 05:47:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The exchange-range implementation is now completely separate from the
> > old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
> > move this test to use exchangerange.
> 
> Do we really want to lost the swapext test coverage?  Even if it is
> deprecated, it will be with us for a long time.  My vote for copy and
> pasting this into a new test for exchrange.

Yeah, you're right that we should retain this test for the old swapext
ioctl.  I'll fork the test into two -- one for swapext, another for
exchangerange.

--D
