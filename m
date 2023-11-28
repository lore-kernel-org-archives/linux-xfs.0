Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1xe8RgWP"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B95DE
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9/xoNN/u7WzPNODuw/bokKsZImcV3WzqoVZF7GlasXM=; b=1xe8RgWP0hMT8iER63JffA5ofK
	sM07a2kj+U8iXDbbtFOdbT4F6gTXV1qWXL1D76/j4A1PoBpyOvneKFnEBQE+Vf8ewVZ/FOyOcddfV
	tk8CWK0PjCQce0XU92T1lMilEONzvX5gIUa599tfelZ/3KGMduLaHNf7sB5TN/Bn141ukLJMiOEVl
	J11jiDwfGRtj62Re/I4Q3CGGI/l00n4/ZNajADdMfO2vxyXEE2+l2tNzAgLAOcYm9Myn54DOkO0Zn
	Dj8L/iCjEGS3TUa8bzHWzCY2U7G+CdXU43rrz3y9msM/Aki1hCcwoJd7bN3j2rHGfce6T1O7AaBUZ
	yniwGOjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qt5-004Aes-0T;
	Tue, 28 Nov 2023 05:43:59 +0000
Date: Mon, 27 Nov 2023 21:43:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: create separate structures and code for u32
 bitmaps
Message-ID: <ZWV+H1TtwiFtC/xO@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927011.2770967.5667556103424812308.stgit@frogsfrogsfrogs>
 <ZWGMz5WYlUGpv7OQ@infradead.org>
 <20231128013444.GM2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128013444.GM2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 05:34:44PM -0800, Darrick J. Wong wrote:
> > Also why are the agb_bitmap* wrappers in bitmap.h?  Following our
> > usual code organization I'd expect bitmap.[ch] to just be the
> > library code and have users outside of that.  Maybe for later..
> 
> Those wrappers are trivial except for the enhanced typechecking, so I
> didn't think it was a big deal to cram them into bitmap.h.

I find that kind of code structure a bit confusion to be honest.
If you prefer it I can live with it (at least fow now :)) of course.

