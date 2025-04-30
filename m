Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48693B640;
	Wed, 30 Apr 2025 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746024732; cv=none; b=JTZRg6ape+l0jTGwhJNXQR0MscOiQxMBmM0Razq08K//Et6EUlm7nsAFUxSdPI5qOpDzsI2As86E26GomEjsF0g4xV0f58stCMBIdpEdPtxpmAqVlsjywzb1W9wZiPJrMz3kKfbfBWtw9PpfTiigG3zaReibm82xWvDc/hJ9Y+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746024732; c=relaxed/simple;
	bh=7oH08iBbhWeaVEAX3Nz5oGAjBUUzwzZ4pRTL2mgqUvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEz1WsJjux7vl4SwyLHvlnl1ZjX8DObTXirRlx3WWz0mM02BZaZ1ruGWSPwkXnkWfLkb53prMjve1E/N6zqnYvwurfd5d0NKoa74IcJnJ4qHlQLTGnedCISAb1ZE8a3kucJbpulRDRZX+JHqzeiJ5u67viAqMTYca5rMrOK8e6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLzf5bmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLzf5bmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3933C4CEE7;
	Wed, 30 Apr 2025 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746024731;
	bh=7oH08iBbhWeaVEAX3Nz5oGAjBUUzwzZ4pRTL2mgqUvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLzf5bmtRpsv3BmY3l9hygoGP/QZchNmxd911TyjQa7q73wNkU7kQTQggt6g1Zl5T
	 JEa0YRIj6SO1R1ZnrTQoSlWceOfUZZ/bbEVuUMB8WpqErCwHn2fcuEa+x3TR4xzYeQ
	 uYG/idWBC6MKTTQdsX0KI2Jp6rtCPqfJedgEhTQtn5abV0R9FRWxAHDd3PPv+yjTL4
	 67P8AybBYYVLBiXrRaCYjR7RDH+Wne+ECPFFp9VMrFB5LxVvIPtw9RQRw0DCUhCpl7
	 kiMArpmYj7tuOe9p9RnrBtE4fx8mwqIl7OwnOnpIMx0+9jbVwrZNlze31O7wx/5t/U
	 yX9lqyWqr91wg==
Date: Wed, 30 Apr 2025 07:52:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Message-ID: <20250430145211.GL25667@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
 <20250425150504.GH25667@frogsfrogsfrogs>
 <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>
 <20250428155842.GR25675@frogsfrogsfrogs>
 <99b99047-a24d-4a75-aa5c-066b92b3a940@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99b99047-a24d-4a75-aa5c-066b92b3a940@wdc.com>

On Wed, Apr 30, 2025 at 08:26:00AM +0000, Hans Holmberg wrote:
> On 28/04/2025 17:58, Darrick J. Wong wrote:
> > On Mon, Apr 28, 2025 at 12:16:34PM +0000, Hans Holmberg wrote:
> >> On 25/04/2025 17:05, Darrick J. Wong wrote:
> >>> ps this test should check
> >>> that a readonly log device results in a norecovery mount and that
> >>> pending changes don't show up if the mount succeeds?
> >>>
> >>> Also, ext4 supports external log devices, should this be in
> >>> tests/generic?
> >>
> >> Doh!, actually ext4 has a test for this already, ext4/002
> >> (also based on generic/050)
> >>
> >> With my fix, ext4/002 passes for xfs Should/can we turn that into a
> >> generic test?
> > 
> > Yeah, it looks like ext4/002 already does most of what you want.  Though
> > I'd amend it to check that SCRATCH_MNT/00-99 aren't visible in the
> > norecovery mounts and only appear after recovery actually runs.
> > 
> 
> So I added this check to ext4/002 and while this works for xfs - the
> touched files are not visible until log recovery has completed, it does
> not for ext3/4.
> 
> For ext3/4 the files are visible after the first successful (norecovery)
> mount, so even though we did a shutdown, a log recovery does not seem
> required (dmesg tells me that the log recovery is done in the end after
> the log device is set back to rw)
> 
> ..and I presume this is fine - for a generic test can we really assume
> that a log recovery is required to see the files?

Nope.  I guess that's an implementation dependent behavior.  TBH I'm not
even sure we can 100% rely on it for xfs, since it's theoretically
possible for the log to flush and checkpoint in the very small window
between the creat and the shutdown call.

If hoisting ext4/002 to generic works for the three main filesystems
then I'm fine with just doing that without the extra tests.

--D
