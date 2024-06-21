Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1329FBF3
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 05:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718948253; cv=none; b=tHhXsKSv7+H2x4tefvbKHnx6xLks+uR8CuemEdLXyB8DAGjjPKxSJVl2uXtIAmkajj8bueBhC/5AwYxd/5Ltxf3pwp5x1trKerbrCJBe738KleP8nii+hfsW4Se+owSexvEdPspe9/9YvgOe5IKhdtUKzLjH0kNzH8Fs+sUwhGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718948253; c=relaxed/simple;
	bh=fW37THnnsOfQGAzfPo997B8IQdu43L4hyxXZV0UWizM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEi8DEGlZAl4GgfZkJJ6WLwYfe9iPMeI0fm1YS6lW2LDyczWIqDMHgGBjgS50SviHwCuoBbRTVF0mdyXtp/fkLe2ceG6WDxq6vsT+a29fNnqxxdE1GdbiOKAJH2VncWyUlGEAg0BkY57ux/7254TOoMF0QRpkvTJtfgCJKSkJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04A1968AFE; Fri, 21 Jun 2024 07:37:27 +0200 (CEST)
Date: Fri, 21 Jun 2024 07:37:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 04/11] xfs: background AIL push should target physical
 space
Message-ID: <20240621053726.GA15738@lst.de>
References: <20240620072146.530267-1-hch@lst.de> <20240620072146.530267-5-hch@lst.de> <20240620194226.GF103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620194226.GF103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 20, 2024 at 12:42:26PM -0700, Darrick J. Wong wrote:
> > transaction need to be pushed or re-logged to simply sample the
> > current target - they don't need to calculate the current target
> > themselves. This avoids the need for any locking when doing such
> > checks.
> 
> Ok, so I guess now the AIL kthread maintains the push target in
> ailp->ail_target all of the time?

Yes.

> I think this makes sense to me, but I'm wondering that I've never seen
> it on the list before.  This is a later revision to the earlier posting,
> right?

I started dusting off the last posted version and then Dave gave me
his latests working copy which hadn't been posted so far.
