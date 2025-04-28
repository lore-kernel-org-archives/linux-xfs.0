Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF32528EB;
	Mon, 28 Apr 2025 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745855923; cv=none; b=Hg0vUTURgBmkvF4Pf7VmVfIRic0AHyRwxAgJruntrZ5kYmF7nw/vkKvfoJjKgW+78gxXAvr1uWafd49HlkvvsQEIVE8Y8lej1ewIHrfA250NKay9b9BNXUyjyDfBnqYi265a+9Q3gAWAyUUh5tKveWaFS5gpVq9lTKBA4q1q4xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745855923; c=relaxed/simple;
	bh=XfaW1XIB46Rmz8mNYMd28IIelp5Xrplwugru0kMZdhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOSY9yz0gwY7kMs/Rv9W8psuDeynwBeS9V2mW6/6qLexC7oXZUgxAEZk3MBTpifxhNxjEvRNs7EPwWb2kom3/YcjCa2s9Lzg2HMZ7lm4GcOrMBslgZy03bBAnbVGsihPjS13TpLr1l3UYOGcCZNMu4gKAwYUE2W6dSrmEahW4go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTrWuvQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTrWuvQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC263C4CEE4;
	Mon, 28 Apr 2025 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745855922;
	bh=XfaW1XIB46Rmz8mNYMd28IIelp5Xrplwugru0kMZdhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTrWuvQNVcCfjP22SZ6Km1w53TfkxkihkMVfPBGsFe63FT/c68GUbHHmBSI8B8b77
	 iSy2iBMhOQDSnDXz0XwanazgH5Tp0iql7H2HZ/jL+M2sntXL0aqaZ/QiAxt3iEuIpY
	 mwdicHPVmV2qSlqNhvspXpWgKZOeRTc0JKqwAabJw/P/3huBO6oz0p2O6ogGQ40/IP
	 8TQjNG1E9dm/olccwOinddrGt7BzmnhAkp+wf6G5VSYYv60sJ+hwaieHao9qAwwcuT
	 ROQuoQO1hOgW7s482O4C+U6e+6ip8hCdimrYJYHEicikV2Gq2wYQamkCFU1mIMt9gl
	 usZKG9SE7glLQ==
Date: Mon, 28 Apr 2025 08:58:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Message-ID: <20250428155842.GR25675@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
 <20250425150504.GH25667@frogsfrogsfrogs>
 <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>

On Mon, Apr 28, 2025 at 12:16:34PM +0000, Hans Holmberg wrote:
> On 25/04/2025 17:05, Darrick J. Wong wrote:
> > ps this test should check
> > that a readonly log device results in a norecovery mount and that
> > pending changes don't show up if the mount succeeds?
> > 
> > Also, ext4 supports external log devices, should this be in
> > tests/generic?
> 
> Doh!, actually ext4 has a test for this already, ext4/002
> (also based on generic/050)
> 
> With my fix, ext4/002 passes for xfs Should/can we turn that into a
> generic test?

Yeah, it looks like ext4/002 already does most of what you want.  Though
I'd amend it to check that SCRATCH_MNT/00-99 aren't visible in the
norecovery mounts and only appear after recovery actually runs.

> The test makes sure that a filesystem will mount ro,norecovery if
> the log device is ro but does not do any real checks if recovery is
> prevented (or done once the log device is rw again).
> That could be added though.

<nod>

--D
