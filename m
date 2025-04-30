Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B179912B17C;
	Wed, 30 Apr 2025 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746024582; cv=none; b=dtD7MzSdZYwxVaAsZ+M8eteekIFHCZIRTP5felHRrbkZJEXCgrV0DyXh9V1AJpqB1FaCEVAHFUGXAtqvTx9tRNKBvNvTj74hxdkMEJuY3Bkj76I0QkBlD9Ikxihpf8VvoEkUy7k5naroAiqsfsTIpAERppuJgV90nESS3pAMcfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746024582; c=relaxed/simple;
	bh=HS1sKPiPIlUdpX7dz1hFcy+Gz+ZlnaCAYoOI7PyFYXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLO1o4eCNSoirGo1v7jL1f2IZfYlptluTs4JzHLr+kg8I9ThpsXXmyfmtdg4EMGC9XLtf1mp4dXNgwXlcUiFLrEuuvl4xw5kiqdtthedxtIbwIAj3KB+0Exh/QfWqUq4ebbmuxWBzy4+or/es5XBvwpQFydArcLhKvCzPdyibI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nyg8oWcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nyg8oWcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AAEC4CEE7;
	Wed, 30 Apr 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746024582;
	bh=HS1sKPiPIlUdpX7dz1hFcy+Gz+ZlnaCAYoOI7PyFYXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nyg8oWcIZzU23aosppGCDNHIvWkl3R39aJVuQ0TPXwWQDRExHTc4i+aZJ0H0jLT0f
	 w85mafA8Qg+4xHHt5ptGj6FUsiwo4NGKLdvE7+4JbeM00dT8/i45LrT8xz/caZt3Wf
	 b3ltDm5PcSNQcWpjGlSqOy9UzYVDjAq9UgpZcaNXK6mv7m+lnBPGYF0rAJCEFZWjib
	 srK+4hEWpmikBOlrbEwHtpwBLGpPKRA5IgvQcmLLpnIAXav2n73BYuJAgcRj4Xk7Y3
	 z6RLG/iQ0N5T/n3iIcKaL+CAPnOnAMa3B3HMQ9fgNOKy3HuMNukwDyPj6u3AwpQH7e
	 vzDSVKyhyTnRw==
Date: Wed, 30 Apr 2025 07:49:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Message-ID: <20250430144941.GK25667@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
 <20250425150331.GG25667@frogsfrogsfrogs>
 <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>
 <20250429145220.GU25675@frogsfrogsfrogs>
 <20250430125618.GA834@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430125618.GA834@lst.de>

On Wed, Apr 30, 2025 at 02:56:18PM +0200, hch wrote:
> On Tue, Apr 29, 2025 at 07:52:21AM -0700, Darrick J. Wong wrote:
> > And come to think of it, weren't there supposed to be pmem filesystems
> > which would run entirely off a pmem character device and not have a
> > block interface available at all?
> 
> That support never materialized, and if it at some does it will need a
> few changes all over xfstets, so no need to worry now.

Heh, ok.  I think I'm ok with this test (which specifically pokes at rt
devices) now, so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

