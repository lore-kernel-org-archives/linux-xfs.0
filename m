Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3804D3F7AB9;
	Mon, 15 Jun 2026 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781533170; cv=none; b=gTwhjAMhwxfNxL+LC9wysbnRyytdVcGFSVc4XdVRVqOOSN3KMZmU1qtwyeHxzsek66q3k7KXWvKp15fy4xQT/Ht/rug0hwE1KN+Et6FEet7TsBS+Vgm6figTjNlLp66P7DrrHpRXc7Ioa/BxnOkfL8o9SxOyYAX2YQhBTMJIe4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781533170; c=relaxed/simple;
	bh=Dh3DREljiqayVU6hY6/3tRr/P63F60WctUuvDcZW1Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyMwL6DbW9WJdthGVnDax0cSrKghupg9/99YrSwFWy2o7A4kHTw/Lqz68zncFzsFb3+RKGvxMuIMAMW33AaUJGC4hI3fGQ7vDl+VKGvf7GL+AvQSgSs6zKyXwoqrZd+Rc+jjkf77Q0RSxH9/4hNkij9WKG/kX+qPJozugVgRnSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Aq+OgWGu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Aq+OgWGu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nu7HxMfWMl2/zidKVsyoZZDsi09K2766xD5KRSF5LGk=; b=Aq+OgWGu12jiv0nLg+BMlipXN6
	t5rG40hFBg98LuNL4CYAsBO/fTmaZMJ5E7Y/cAVc65Ewp2xVbH7jRHggbNnsfTN1EA8ztchn3JPYo
	zZKGTdd+CT4ahFRg5HdEeO/jlmHFU5PNtdoA6DsRINt51j8IBHkUBMO5CXQ6RoJFhFiJsCzYySlRh
	T2YfSKX4Dy0Se7ENfc5tbY0FY+f9ve4GVBffdq2lSO/wLqBMsqxh+6EmjDgySxfN2lPcEAI/qxYoe
	qziSQKGnwjNdM0sGLG8TrAnbrmm23NXnarpEZ6IozBNiLZfVjOos8AJehy7R98zCkJVeZLZC8gyfU
	xtJCNmyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZ89q-0000000EOGC-12Ff;
	Mon, 15 Jun 2026 14:19:23 +0000
Date: Mon, 15 Jun 2026 07:19:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajAJ6lXJWcko4epj@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
> Hey all -
> 
> this got long, so tl;dr:
> 
> 1) concurrency geometry breaks some xfstests for me
> 2) concurrency behavior is not consistent w/ loopback vs. imagefile
> 3) concurrency defaults to the mkfs machine not the mount machine
> 
> In detail:
> 
> So, I realize I'm late to the game here and didn't review the patches
> before they went in, but it looks like the "concurrency" mkfs.xfs
> arguments and defaults are breaking several xfstests.
> 
> 4738ff0 mkfs: allow sizing realtime allocation groups for concurrency
> c02a1873 mkfs: allow sizing internal logs for concurrency
> 9338bc8b mkfs: allow sizing allocation groups for concurrency
> 
> Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
> on various machines with between 8 and 128 CPUS, due to the
> fundamental change in geometry that results from the new
> concurrency behavior, which makes any consistent golden
> output that involves geometry details quite difficult.

Did anything ever come out of this?  We're hitting errors in exactly
those tests in the zoned XFS CI (which also tests regular XFS).
Shin'ichiro recently spent some time tracking these down, which
finally made me remember this thread.

