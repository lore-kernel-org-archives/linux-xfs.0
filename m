Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95D327A465;
	Wed, 14 May 2025 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230720; cv=none; b=BgXVx9iuLL4ibvziws4DD/Li4bxMKCcuGYyxRO3LCJyvAwCYiknRVvK89IOBqFxgGdckaXZ7OivkQecAA6Uom7rFThXMsvLWh4aKaz9BqATs5cepocCAbEaSMvpvfpbj15LP/Ph6mwBNnZfgvm+/K7sGHJmJRyZmuOPNl7fUU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230720; c=relaxed/simple;
	bh=rs/y2qCidzn+BQiOCdfK57l84V553VHXEK31pa13fvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNHbq3i+rrgvZ9l0McZB40Z4FV+WjuaiRlaKeXIZ0i8YEdSor6bhuJjV3BrseRy2EIcaght8/I35ldgDjTGnhjjyOD4aqZ/H2A3VjvX/X67FI3ha4YVXLK94J6zEAs6UsHoNuSwl3diBS2T6XQX4kqeGYoqYe4qgvWE3PN2u5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uso0hJVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uso0hJVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3AFC4CEE3;
	Wed, 14 May 2025 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747230719;
	bh=rs/y2qCidzn+BQiOCdfK57l84V553VHXEK31pa13fvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uso0hJVyosXz3IX++YjTfZ7B1daXkj6DRKu30H3m/Vq19L3vG94KJosg36Su6Huyv
	 7nYPzWVafd4EAaGhE7x1f4hpX0Kyd3C9XGU5zbHAyez37Aqi6p16e7PjfPxLzDN7OF
	 j0F6SEUGETSEY/1Q/Z/aSLSimQtG8/C8GDEgTYEkeqSvdpghwlUwTa/sHVRbAsBNK+
	 tlaz/jI8q5R609eMX4Fvw3CaA2jkM/amOAcc4VOzdCOIIN2tP8cu7N7qeq8BrOOjdb
	 Mc3TfN5k5yfKK6BGyRDIeR1bPipuQMMCuTB+QRrq8gbmx0mUcnVmMBgCuAGA3R9QMl
	 ShK6vyTxxPCWw==
Date: Wed, 14 May 2025 15:51:54 +0200
From: Carlos Maiolino <cem@kernel.org>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Message-ID: <sa3yttklz3onf627vxqcjysgyoa455r3z7mgmbzmn3pgs7eawb@43tke54bauuz>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
 <crz1SUPoyTcs_C4T6KXOlfQz6_QBJf7FI8uzRE_ItAzp5Z89le5VY4LXGEG4TkFkSxntO97kOVPJ8a-8ctZdlg==@protonmail.internalid>
 <20250514130014.GA20738@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514130014.GA20738@lst.de>

On Wed, May 14, 2025 at 03:00:14PM +0200, hch wrote:
> On Wed, May 14, 2025 at 10:50:36AM +0000, Hans Holmberg wrote:
> > While I was initially concerned by adding overhead to the allocation
> > path, the cache actually reduces it as as we avoid going through the
> > zone allocation algorithm for every random write.
> >
> > When I run a fio workload with 16 writers to different files in
> > parallel, bs=8k, iodepth=4, size=1G, I get these throughputs:
> >
> > baseline	with_cache
> > 774 MB/s	858 MB/s (+11%)
> >
> > (averaged over three runs ech on a nullblk device)
> >
> > I see similar, figures when benchmarking on a zns nvme drive (+17%).
> 
> Very nice!
> 
> These should probably go into the commit message for patch 2 so they
> are recorded.  Carlos, is that something you can do when applying?
> 
Absolutely. Could you RwB patch 1? I just got your RwB on patch 2.

I'll add this to the tree today, I need to do another rebase anyway.
