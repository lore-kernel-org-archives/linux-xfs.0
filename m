Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734DD2DE6E4
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752580797; cv=none; b=oBvb98H8AYZPlOPB7hDRB0GGB+0bp84+qbXy2H1O0YJ+FvXTw/IShuarrcunJyV8Blp4VQQ7cL4+w9xu7LS73oWg8vpWBy1JfJfnBbDOO3YpixSG23d3Sn9RHrS/ieA4T+EHGOQ7l4P2vktLSnN4THMPCuhUxLN0TjOtQOZinE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752580797; c=relaxed/simple;
	bh=vL/vgtRATM1D0f4Q2K1rsI7XfAnXTv5RbrFlttDJT+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrRiK9kS9kx+Bi6VxSJ26d5Uaac80VMl1E61R3ASt4ExKUMxPK5xS66hr6TCBcvY3o2ZV8wxzbdLfCgKlnibilCGsNKAWacNRpIh9l1omgQQwYdIMAwurzMR7/P6nvl+DBo3H8KR80Xn/UfH9TVSry/h/aI5a0sFTTJLg23ec7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=j3mm3jeG; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="j3mm3jeG"
Received: from trampoline.thunk.org (pool-108-26-156-131.bstnma.fios.verizon.net [108.26.156.131])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 56FBwvGV022147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Jul 2025 07:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1752580740; bh=A33SYO1f1TFl7htpYmaPxVOHkIHPGGsvvyVdiUx7m+o=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=j3mm3jeGrGK+8Z/OG4HSOTiPwSeWSrcJACXPh3387iNdNwoAYIWZ2Oj56Q1dRwA8S
	 uzhoiNRZG9T5yd3OWgqQ9qfbOn4CVJv3wyBmOIkyePTLlrb965tDVxtxuC6gfQuCDa
	 iX18lC+Ysz8hHwIE6yngVRXnukfg7fLORJQ8ol3BsDcX/M56ESyKn23vdLzSHOOpm7
	 mHZ3vD4S1nxtrdWwTve9K5eZxlHORc3CAoIpZf4SiG/BqeNTDGxRjnu57adwGsqHHa
	 RUT7zlDvkRiI+oktOgSnz5a7pmhTphnLMhKMFLPXwx9eF6NUYKBkani0Q6QW0/gjBu
	 /XoPjbgXKWk4A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 773342E00D5; Tue, 15 Jul 2025 07:58:57 -0400 (EDT)
Date: Tue, 15 Jul 2025 07:58:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, John Garry <john.g.garry@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: Do we need an opt-in for file systems use of hw atomic writes?
Message-ID: <20250715115857.GB74698@mit.edu>
References: <20250714131713.GA8742@lst.de>
 <6c3e1c90-1d3d-4567-a392-85870226144f@oracle.com>
 <aHULEGt3d0niAz2e@infradead.org>
 <6babdebb-45d1-4f33-b8b5-6b1c4e381e35@oracle.com>
 <20250715060247.GC18349@lst.de>
 <20250715-rundreise-resignieren-34550a8d92e3@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715-rundreise-resignieren-34550a8d92e3@brauner>

On Tue, Jul 15, 2025 at 12:02:06PM +0200, Christian Brauner wrote:
> 
> It feels like this is something that needs to be done on the block
> layer. IOW, maybe add generic block layer ioctls or a per-device sysfs
> entry that allows to turn atomic writes on or off. That information
> would then also potentially available to the filesystem to e.g.,
> generate an info message during mount that hardware atomics are used or
> aren't used. Because ultimately the block layer is where the decision
> needs to be made.

I'd really like it if we can edit the atomic write granularity by
writing to the sysfs file to make it easier to test the atomic write
codepaths in the file system.

So I'd suggest combining this with John Garry's suggestion to allow
atomic writes by default on NVMe devices that report NAWUPF, not to
ignore AWUPF.  If system admistrators need to make atomic writes on
legacy devices that only report AWUPF, they can manually set the
atomic write granulairty.  And if they screw up --- well, that's on
them.

And file system developers who don't care about data safety on power
failure (which we can't directly test via fstests anyway), but just
want to test the code paths, we can manually write to the sysfs file
as well.

Cheers,

						- Ted
