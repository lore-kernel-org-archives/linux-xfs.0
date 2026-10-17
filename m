Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90447F3C0;
	Sat, 17 Oct 2026 13:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792244840; cv=none; b=JlPmI1DswMLvlfU4MhgsbtR2yoxMKfJYsAOZbn/7jWhFxWPIFaXGwVI7kW9ZNF9JxxO2HZWY/aEW0Vts5CFOuMca8jIVe1if/S+cqD3rWY1PRQLBaK27Lv66f4ANQXhpWfgL6KiZKSdgRxBK+Kp0vBFbocLERWz2gsn2wwR2m4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792244840; c=relaxed/simple;
	bh=Jb2jnlzlw0/3e/ETRTrKH3iCG8qWDXvdy4fwPw2FSaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nx5e8HkKqoI/KEJiFUkltksTUShiC0Y0SDVnpM/gaXy83Qd3dLpX4NFESrmvH/7L2kCS9fCMauzancS+MSbrHcoStq1M4cFZq7KSTg9Fchnso7qmzC3JEIlwH5EH+V0T8ywG/v+c0hOo96XQCrN9xqDrhHfY1iQy5hrOBcDBlpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdC2xZWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdC2xZWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE9A1F000C4;
	Sat, 17 Oct 2026 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792244838;
	bh=bNDFgbptJ1RS3GazIg1IlNsjwjcWhKHYe43l36AnwNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EdC2xZWiqoX0P+wY2sxggGgZRf2yAT1qT0deVEgfqooaLvAGgjXI9BROZSdZ+SIE6
	 B4AHC0seSJ6SuThF+eJXLKkXQHrhIsHLsVAb0dV02VJMHeVIXL0OUNjbQ6AMJcY0pN
	 chPpgwx1UEgdBE5kcqXWhPlN0Isoz8UH7Zp3W2pYDeUnlHIRljM14OwNQfvX3azcvo
	 66JKbC0ZJuNMKvTGnObIpdDKeS8gM9ZDqiT0pUZjWsAWM7dek34J9PQ8J2PaJgg2c2
	 HhIM5hT1gHxGefBbCKGKgqmHnyBxyWL8hKVZisYd3QdnawHuE0n3RR7ij5nXaH/e+U
	 4xSfkhn/MRcxw==
Date: Sat, 17 Oct 2026 15:47:13 +0200
From: Gao Xiang <xiang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atN8YUvYy0VyvFBm@MacBookPro>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>

On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
> 
> --Darrick

Hi Darrick,

It is still a bit of a surprise for me to hear this news, although
things seem to be changing so quickly these days.

Thank you for all the chats online over the years. I've always enjoyed
them. I wish we'd had a chance to meet in person.

I hope you have a great and well-deserved break.

Best Regards,
Gao Xiang
