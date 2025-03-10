Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F89C233721
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627593; cv=none; b=AQTTWXju7nj0hL7AsCSGcS9ymjYuu1j4o+lVT5TrPQR1UvGfVWL3rrA+jrEU9fyxXneFtSeYZ316YFk9c6x5EJ3/G+Ra3izM1acGcfNRrYQdvewhhd4aGYNpCU/Ccp0C59LTT0zFqEGl4RvixIrcOB4pjwy5OxEgOBHDbh7tJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627593; c=relaxed/simple;
	bh=SyD5g8DkYs++xjQfstZCVvjkNQZxa6nkj1d83B7MIp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6L5yw5SbkUyRBS4Tn5MpsuUo94WkuiDBtI2utKXVC4/FhzAyIAv8n+OrvJmvEEk/RblxXu2uo1QMiQ87VSOqeRuB/gcWK3eHbDWxm4/QdyUYP1NLUmFedr5Gzuz09PtCFcakZEVZhXmDiDZWJfYwZm29yty0asT74KVZJ8Sbp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyKov+R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyKov+R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16A9C4CEEC;
	Mon, 10 Mar 2025 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741627593;
	bh=SyD5g8DkYs++xjQfstZCVvjkNQZxa6nkj1d83B7MIp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IyKov+R6uAGFZ7T8nFLb23aiiOaDQN72TKAxPyQxgpqLLnQQg0rDFj19Yuk0bXpuP
	 eI8IbyAQq1X+D5q29FmWaEVQVCjaurG9e2PDChn6e4KcTdscUNnT1QexErOVNxnQ9H
	 1gCXdvM9r0n2K/cAe8fA+xNuBoXsWeC2s3+bb3wul4jh8RLQ7pYXDIrASsE8XjZVWZ
	 MQj81aZcY9dNRlO7QhfvfULdK5BfeD063PzXi0sRtXhAP2425VD0VssL+bo3rMdIsM
	 FgQDreZEFKRB7oykBbmyS73VjULKkoNeZHJlPH3LEV5QETUj2jTr6W9ztt2pQTDMwk
	 DLKnBIqYU0k4Q==
Date: Mon, 10 Mar 2025 10:26:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Kjetil Torgrim Homme <kjetilho@ifi.uio.no>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_{admin,repair},man5: tell the user to mount with
 nouuid for snapshots
Message-ID: <20250310172632.GV2803749@frogsfrogsfrogs>
References: <20250307175501.GS2803749@frogsfrogsfrogs>
 <f296547d-7a7c-4df5-89e2-9e3cdab546f5@oracle.com>
 <w7ift5gmxeihp2u3chbi25to7mfnurvhizgo36aitpzwx2mf5w@jg55nn5sti2w>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w7ift5gmxeihp2u3chbi25to7mfnurvhizgo36aitpzwx2mf5w@jg55nn5sti2w>

On Mon, Mar 10, 2025 at 01:24:26PM +0100, Andrey Albershteyn wrote:
> On 2025-03-07 20:37:48, John Garry wrote:
> > On 07/03/2025 17:55, Darrick J. Wong wrote:
> > > +"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
> > > +"filesystem, you may need to give mount the nouuid option.If you are unable\n"
> > 
> > mega nitpick: it looks like a space was missing before 'If'
> 
> will fix it when applying

Cool, thank you!

--D

> > 
> > > +"to mount the filesystem, then use the -L option to destroy the log and\n"
> > 
> 
> -- 
> - Andrey
> 
> 
