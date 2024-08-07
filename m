Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153BD81751
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042606; cv=none; b=Ipftqn5AN9W+tJH/251SV5ZY3FU9JMFAmXAB51Cp0GHRWM4KqQnGn0+cJMqWIrlH9xH46aX4aOhd4Z+W/sYnM+nYK2cMJBAFvYipS8v0xIyUH7JziD8iN+SkFnhC6bzQhSZx5stxc6yVPvN84NErYJN9Z15zy8VlR86fXVl5bzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042606; c=relaxed/simple;
	bh=llMadhOXR8/1hsqQ2u6fm9lW2E1j1viNsOaWVN0BuNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCnn779Ehhp5jUAm7mfmZYMrJU1I7hSI+JsdNhYuO6WnZUxUjc8ewupYsv9V9Gp1zwH54HvfcoOIM/DpqMxmThps8D/7lysg5l254mXFgHMValnclfUELkEm0z81lXTk2l/n70vaGFv2sfQnysQ40NMkUqHxiwhdjVlbWj6VGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxEqxWme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxEqxWme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B1C32781;
	Wed,  7 Aug 2024 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723042605;
	bh=llMadhOXR8/1hsqQ2u6fm9lW2E1j1viNsOaWVN0BuNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UxEqxWme0Iyf1F3ApGj7fa0qlu80svyOuGSBnW/jqfMeEU54A7Wne76NGfieLw5LJ
	 B+TB2L/65gU0oVsIr4XQdUvnm5ym4Zf6v86QFYw08YwXRCpuQJVm6t2uew4nvH1L4D
	 m09mYZ1BzZQ+dkF012zM1ZJAAaV1nJGQPfvZEo+vCmnhgHESsRlFAPtwUGQJ5zrYg3
	 HybqWBO9RKVGPjAWxChfJDbSr3nrvS0E7e4vlJ+W5RbAb8FYVlowj9cA8rIGZ7mGg+
	 hDxJRq1YcuGSLOkNStkustXlGCEzS2ougudbz0bYlxdQQLsnLKhdT/mWv7xATRvNjG
	 N00Dg0U5MhWmw==
Date: Wed, 7 Aug 2024 07:56:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Mateusz Guzik <mjguzik@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: xfs_release lock contention
Message-ID: <20240807145645.GC6051@frogsfrogsfrogs>
References: <ejy4ska7orznl75364ehskucg7ibo3j3biwkui6q6mv42im6o5@pzl7pwwxjrg3>
 <ZrMJmfYfaT4fxSNM@dread.disaster.area>
 <20240807143759.GA3175@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807143759.GA3175@lst.de>

On Wed, Aug 07, 2024 at 04:37:59PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 07, 2024 at 03:43:53PM +1000, Dave Chinner wrote:
> > Hmmm, I thought I saw these patches go past on the list again
> > recently.  Yeah, that was a coupl eof months ago:
> > 
> > https://lore.kernel.org/linux-xfs/20240623053532.857496-1-hch@lst.de/
> > 
> > Christoph, any progress on merging that patchset?
> 
> I expected them to go into 6.11 but they didn't.  I'll resend them
> after retesting them as there weren't any actionable items except for
> a few typo fixes.

Heh, I think there's like one patch out of the whole bunch that didn't
get a RVB tag, so that's probably why it didn't go in. :(

--D
