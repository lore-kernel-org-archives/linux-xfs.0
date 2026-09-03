Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D6D3F8257
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 09:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428696; cv=none; b=itHmxZ7eVQC3oiGTdkuFGeJeKOYNYzJUR9ci1jNyTkanYV1u4fFf8sngb6k+jNCndpyJTcoDb45/pZc0YBOmRZ2WuLrOsnhUHY+zuKdYgPjpgkV/sz4DYiFzL8idCaeU6G+KJhedgcrEyyvuuDguUWH6QoSE3NJy1NntX+JxM7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428696; c=relaxed/simple;
	bh=yJmNz9L7aPzZmZ+yDdWddN8NI8A4/IbhgszS34ZjY6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fv0TTBk6J+X9+prmxhHuRVavNVHdJpKmeJPeLMQXZXtTBKNdp1etlVNPIE9CePuw0VxeCpK0aJIa06MT0VfyfPZCszOGT2a8tWlhUDspHm0NfvKcGVG9hYLmMFFcP8aYUFDuataQpHMxQUDMlSryDNREJjvOktmrwBxCtHW9E28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMT+QHyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMT+QHyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D161F000E9;
	Thu,  3 Sep 2026 09:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788428695;
	bh=0eAJtczIcV/vL+9G0ntTZ5k4+tq9nKLhUxhMcMgb+vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CMT+QHyHNzqs7Hj8bWSH2RaRwfUW+MM4BYgygUc1BRZKko2X48R+DXaTIaF3UHwQ1
	 TwRRZRyveleN6fdqJZPAcOZ9uE2qN8+7k6Au29AeJ61mDl5Xd7UT2ilVnGz//OUIif
	 2JpF4joRZmxewdl245CijOJ4u85pZ/ZjmBlOCe41Raq8ltLv86nA3tG4gPco/mhAHH
	 XzuLNV9EIG9QUTLnr/k+TMjgf61J1fx7T3/tdz1X0KajOz345Y/DTHkbxvIn20oT+I
	 xPuaYPq9OlkYze+9nIVmRPGVFGYQMn46hVmlyUU6413L8gvs/PFzINv8fHpRmb+WYz
	 O8DkzMlWScdpQ==
Date: Thu, 3 Sep 2026 11:44:51 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_scrub: terminate systemd services if the
 sysadmin unmounts
Message-ID: <aplAW3FFxQ-AM_us@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870236.2381099.2561252941543842548.stgit@frogsfrogsfrogs>
 <178821870256.2381099.4607775862934813829.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870256.2381099.4607775862934813829.stgit@frogsfrogsfrogs>

On 2026-08-31 16:26:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We should make sure that any systemd services started on behalf of an
> XFS mount are torn down when the mount goes away.  On a modern system,
> calling umount(8) while there's an xfs_scrub service running on that
> mount point will successfully remove the mount from the caller's mount
> namespace, but the filesystem remains mounted in the service's private
> mount namespace, with the effect that the filesystem stays mounted.
> This is probably not what the user wants.
> 
> Per cks' blog, the way to fix this is through a BindTo= clause.
> 
> Note: This isn't needed for xfs_healer because it only maintains a soft
> reference to the mounted filesystem and can reconnect to a filesystem if
> its mounts move.
> 
> Link: https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdStopOnFSUnmount
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 0109639eede4dc ("xfs_scrub: tighten up the security on the background systemd service")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
