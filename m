Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506CD2BE026;
	Tue, 16 Jun 2026 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616724; cv=none; b=cjoMg3J8MaLUXXzR+dxvPX1AR0/OZnzdVvIGOQtkQb9efD5rsLeXO2DUgblwpX+ztq961Sb/JJx4rJckMVmyCFd54rchIHlVTVGrDcCUq93s+HCGcVebp/gjQsOL7pUCRlEyTSyJLjSqUuGY9/NpndhMGAGqQ0n0mxtSC14YhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616724; c=relaxed/simple;
	bh=9Lg1J7A4O8tyIczW9feMfYwxsXwLwMsgsLPQDTWGkPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJMywr+mTo0l9x8SMr0J4XpgtiOEZ+fJQflTMgVejF93M5naR0pJm+BpFPWH94s+7HeBpfYNB7jRkweYirGeojhmGw0hSdll95iXaSR062zn4HTXSUmWin6i3jbYqKshoMcf4fQVx1CVNb0Q09ljFgPApS4GzM5lFrIYzapS1dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nMSzF8R3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nMSzF8R3"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id EA72620B716A; Tue, 16 Jun 2026 06:31:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EA72620B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781616701;
	bh=1L59/F0MlY1PyEzER7lNpGooBsayOF3108pPWJiREgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nMSzF8R3JSbBi1eOF8Be5Wy4X8vcUC7njNyiUG+qm9C5qEoEqbSs1iZvQ6oC+mu+f
	 SmPhvl1pt/2//CrxP0CuSUbSjru44o/8wWC2/PYUpbhHiUh43Wf0ZGVVv5cF/fZVH0
	 zI3e3jHR7HFsk9j4HM+VB6U953Rt/VvCuMr+1KI8=
Date: Tue, 16 Jun 2026 09:31:41 -0400
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, Fedor Pchelkin <pchelkin@ispras.ru>,
	Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org,
	xfs-stable@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20250322143418.216654-1-pchelkin@ispras.ru>
 <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org>
 <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>

Cc: linux-xfs@vger.kernel.org

On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > Cc: Carlos Maiolino <cem@kernel.org>
> 
> FWIW I don't maintain the stable trees I really don't have time for
> that. Darrick/Leah have been doing a best effort case for that, but
> again, this is mostly a best effort so we shouldn't expect them to be
> looking/picking up every single possible patch suggested for stable.
> 

Now that you mention it, the xfs-stable mailing list seems to be pretty
much dead (i.e. the last time fixes from it were merged into stable was
almost a year ago). I guess no one is really working on it anymore?

> > 
> > On Fri, Jun 12, 2026 at 08:20:34PM -0400, Sasha Levin wrote:
> > > On Wed, Jun 11, 2026 at 02:39:03PM -0400, Hamza Mahfooz wrote:
> > > > Any idea what happened to this series? It resolves an issue that I've
> > > > hit in a production environment FWIW.
> > > >
> > > > Series is:
> > > >
> > > > Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> > > 
> > > Thanks for the nudge, and thanks Fedor for putting the backport together.
> > > 
> > > We generally don't take XFS backports without a maintainer signing off on them,
> > > so right now we're waiting for one to do so :)
> > > 
> > > --
> > > Thanks,
> > > Sasha
