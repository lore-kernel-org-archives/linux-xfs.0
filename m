Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383084CB3D
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525167; cv=none; b=isfouX0rotbkcfGdOE3lMMt+wRW575rrBRvS642UVFEsKCMNi9v7sra6+zBeEYo6/SwdzezttApUjtLRSPaYJ0bOwV27H/B2KYEASc+HZwj9YItfZiK381ib1f3amTpAmUJFJyPB0Sce1O6W9lxlK6lssCCnNFh9D8m7oWgRlkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525167; c=relaxed/simple;
	bh=AAhRUVN284uCvdT7GDLroH4Nzdm3dni6XHk6sO7y39I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0EZgryIsEEpTSWJnM8r38s4DyYgMZmnDEL8hoYA16vtTRi6liV3D0f9ijfgLXRj5ycf6xd0BahYt0mZ00FXu7ep+C5LfrB7sPqFB1jN2ltC0YZhRuFGD7HFuxAlsObdNquFzhR/rQfd0rUHvkd2s+v3iWk3s3lq2imr+VLd+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=arD1C8JM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="arD1C8JM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n465SUGDscKGxCrF8dO1SOqcCrCuglTFH24OUbZSNB8=; b=arD1C8JMq1NrQhTmHZG1R+EqaR
	ktPEFpMC4L+k35rWFoPY6IEBD9N6XMpAShT2hi7RHOLEYfkrhk0PhGDp7mpt/9qIg6IgG5yomv/IS
	L6NO0WfDUvkyGQjj68qb52wD6MqiyvxH/fNT4jtkfXWZ2YiPXJ49RgJrsKjvjf7O2ZQhY5XU4Znfv
	pJSopzPZBzIW+pX6XWLMytXV8iXYBpqUTL61JghaIjFyOio8hiNaQ/N/ke56/UOilIOLNQ5xD+I37
	3bmh0VXYMxY2ITuwWLWXaJDz6p66t0Qv6WBFu3UndAYoLalw0joJppHXc6j3GNGdVB31QPN/XAaVC
	1WixOWhQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rlBjX-000000014tL-2XKO;
	Fri, 15 Mar 2024 17:52:43 +0000
Date: Fri, 15 Mar 2024 10:52:43 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZfSK68T9jJp8_Q-w@bombadil.infradead.org>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
 <ZcQYIAmiGdEbJCxG@dread.disaster.area>
 <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>
 <ZfOg3dTO/R43FGiZ@dread.disaster.area>
 <ZfO2-wefNDEJGL5w@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfO2-wefNDEJGL5w@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Mar 15, 2024 at 02:48:27AM +0000, Matthew Wilcox wrote:
> On Fri, Mar 15, 2024 at 12:14:05PM +1100, Dave Chinner wrote:
> > On Thu, Mar 14, 2024 at 05:12:22PM -0700, Luis Chamberlain wrote:
> > > Joining two 8 EB files with device-mapper seems allowed:
> > > 
> > > truncate -s 8EB /mnt-pmem/sparse-8eb.1; losetup /dev/loop1 /mnt-pmem/sparse-8eb.1
> > > truncate -s 8EB /mnt-pmem/sparse-8eb.2; losetup /dev/loop2 /mnt-pmem/sparse-8eb.2
> > > 
> > > cat /home/mcgrof/dm-join-multiple.sh 
> > > #!/bin/sh
> > > # Join multiple devices with the same size in a linear form
> > > # We assume the same size for simplicity
> > > set -e
> > > size=`blockdev --getsz $1`
> > > FILE=$(mktemp)
> > > for i in $(seq 1 $#) ; do
> > >         offset=$(( ($i -1)  * $size))
> > > 	echo "$offset $size linear $1 0" >> $FILE
> > > 	shift
> > > done
> > > cat $FILE | dmsetup create joined
> > > rm -f $FILE
> > > 
> > > /home/mcgrof/dm-join-multiple.sh /dev/loop1 /dev/loop2
> > > 
> > > And mkfs.xfs seems to go through on them, ie, its not rejected
> > 
> > Ah, I think mkfs.xfs has a limit of 8EiB on image files, maybe not
> > on block devices. What's the actual limit of block device size on
> > Linux?
> 
> We can't seek past 2^63-1.  That's the limit on lseek, llseek, lseek64
> or whatever we're calling it these days.  If we're missing a check
> somewhere, that's a bug.

Thanks, I can send fixes, just wanted to review some of these things
with the community to explore what a big fat linux block device or
filesystem might be constrained to, if any. The fact that through this
discussion we're uncovering perhaps some missing checks is already
useful. I'll try to document some of it.

  Luis
