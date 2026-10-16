Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E359552929;
	Fri, 16 Oct 2026 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170709; cv=none; b=RJhm93aQORygUL0mU7C4A+f4L1c+dXFhX3DbLGguBxyfIIXRiAUtmzzVcLGTEXIK99P9fDmGGEsN7OMGottqY3v5FQIw7m03Ysh6dT9WvYuy3DBxjTnMZwTYFZASXKOa8M6pFrecLrPPrGan5TlGJwpcADrIw+vqHK1AR5J8N1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170709; c=relaxed/simple;
	bh=MO6cHy40gyiVcffzrki5YVyT2NG2/5V/sOPNZT5Gy1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnhfQm1G4E6BSAvSULr8m4hYBotcAdpJB/Vy1WyxpDn/gBoGXJAqfI2D+l6vRTB+43PzRGw/pUEvedN49vKFmyMFDNZjHYva9b/xRNW+O9c/7CiO6FBPkPsExDDsux9jtstPsageCNRhlQQJvgBsMgIJgW3NCkfV/UvJWVhQb6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJ/h22TW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJ/h22TW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 660C31F000C4;
	Fri, 16 Oct 2026 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792170707;
	bh=haJF2KiPuN6dDSj74yCBDS4baMrbwUEyEPdmOlipTWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CJ/h22TWaDvBhc+q+HqM4Os488jTUc665cB+TWFAstIAbigo6SJwrxSUakXlK6lMv
	 DcwlJSK57tXy8zEeHrgNpRHc284HdsVAsGHFVdeJXIQvcpbvX9tIbjlXltGLtDkQdH
	 btpGTguplUSRWUkM9K1KVXJvisxs7r+1I6S9vX9NaK9G8xLZs+EivbkzA7aqoyFUgS
	 6Imzo5yHihOETv35YXRJQxVKL+rqjYJg/y8Iv45jrgGmSQ3MQoQ1zDSD+7tWDgYk6x
	 CeM3EhDXlGkjPc0AESK9RNImm0GnGUIPpjQ/l341vBesE8adbR46KlY9LxS3o2FVBj
	 7Dve4T6YrswSQ==
Date: Fri, 16 Oct 2026 10:11:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "sashal@kernel.org" <sashal@kernel.org>,
	Mark Tinguely <mark.tinguely@oracle.com>,
	"catherine.hoang@oracle.com" <catherine.hoang@oracle.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>
Subject: Re: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Message-ID: <20261016171146.GB107986@frogsfrogsfrogs>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
 <2026-10-14-1-daily-reply-0009-xfs-umount-hang-6-6-needs-ack@kernel.org>
 <20261015144723.GQ2705364@frogsfrogsfrogs>
 <6960f2e371138b8362922ecc0785a2945f70aa48.camel@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6960f2e371138b8362922ecc0785a2945f70aa48.camel@oracle.com>

On Fri, Oct 16, 2026 at 12:55:18PM +0000, Siddh Raman Pant wrote:
> On Thu, Oct 15 2026 at 20:17:23 +0530, Darrick J. Wong wrote:
> > > I saw Darrick's ack on the 6.12 series. Still waiting for one on this.
> > 
> > This also looks good to me,
> 
> Can you also take a look at 6.1 and 5.15?

Frankly, if you've run fstests on all those LTS kernels and no new
problems have erupted, then go for it.

--D

> Thanks,
> Siddh


