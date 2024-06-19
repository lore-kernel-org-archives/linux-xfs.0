Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7D92F2E;
	Wed, 19 Jun 2024 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816452; cv=none; b=HpdkatPx4RnBHngthOHtXbsgzUuSAo9hKUhtrwzir/p1kszY0hNqnYWiJucq9e+nbRm2cl8sbs4yFm8ZwbrZU/IP3FHHnguVbPJNteo5m1e8gmsqmzslnqWFg4YNHXgOgqCz3Z+TquRKBHgTwnOvVxMUPt6qrCL8grEqCCy0DNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816452; c=relaxed/simple;
	bh=j4cyNkuOjm1tqiKtkZvOjIHqBYQTYbVGxpNXQcUiPjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWWaFhDazDdF6MCEyUVLWy/aMDRFjQwOKlCU6IBGS1SAbgojmVuRoyltyK/sMK92Ctjqx4x/v4P9nCMHNOZYl0/DNEo8IkvxkC1r6Ukhq5JR+RhLrPv0breqWuPI7cO3Kd1eDy+DL36ny2WI5ljltEmxWscUtUWb/jg8RUit5R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+7RxEPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+7RxEPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816EC2BBFC;
	Wed, 19 Jun 2024 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718816451;
	bh=j4cyNkuOjm1tqiKtkZvOjIHqBYQTYbVGxpNXQcUiPjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+7RxEPAx51jiLsHWhXGJUeqCLRfh5RArYuKa26R7V9EudZi1cMebOGhLZcr9IV+J
	 m7mJxWKtCvi8vbXatENW/8ZaGWpPN9Tk1QKCrehZxm2DKpzqvzBPRTISu4LfS9D5x6
	 YUBaHVOLzFGogkZy6PYqjcavQgo4BcDn8wkSBJ7gwq/ISqe07OehghicMFuLI0TZyq
	 AAwrDjVzTWylEiXvyjjrymlKoknpGd4XjkkBj1P/YJonNMsmTycHyF/2TX40ANdbmD
	 doyI3vXJuWynVvwDXLTiCyOmOXVFRKkxkNvyevoCo4P4HIcI6Mhk1hrF4zsT6D6W0r
	 RDHUkFmJKGL/g==
Date: Wed, 19 Jun 2024 10:00:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 04/11] populate: create hardlinks for parent pointers
Message-ID: <20240619170050.GP103034@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145868.793846.6556224145030803204.stgit@frogsfrogsfrogs>
 <ZnJ3L5eEz1iLmACd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ3L5eEz1iLmACd@infradead.org>

On Tue, Jun 18, 2024 at 11:14:07PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 05:50:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create some hardlinked files so that we can exercise parent pointers.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate |   38 ++++++++++++++++++++++++++++++++++++++
> >  src/popdir.pl   |   11 +++++++++++
> >  2 files changed, 49 insertions(+)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index 15f8055c2c..d80e78f386 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -464,6 +464,44 @@ _scratch_xfs_populate() {
> > +
> > +		# Create a couple of parent pointers
> > +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' --hardlink --format "two_%d"
> 
> > +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "many%04d"
> 
> > +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "y%0254d"
> 
> > +			ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/${fname}"
> 
> Can you break these lines to make the code a little easier to read?

Will do.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
