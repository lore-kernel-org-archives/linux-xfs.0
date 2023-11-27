Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871B039FFB
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHcTtYnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE62BC433C7;
	Mon, 27 Nov 2023 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701108898;
	bh=aL4lXEqCi8RQTZNMpCeNiTjznfkTy6Czbbs7UazzrDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHcTtYnLqKnTHzbNwdN0JcPzch5gmhx1Z0vA9JsrK0Hqi6jgottKXrnwcK78iEu7a
	 E982g5d3sBLKcOu+3vBh5idjUsHMLcot48mKRQ5DMi7zDV9lbKqkQ6GqIv0+/PfTaj
	 cCeBjGhApxnbIz2u690tUypr4h609p/FECdaAf2CAbWJ8DbDlV3WHJaHupswRPEWVg
	 KzPY60O8AzyF3mq/eghatD+wm3u+Ku7JPXsAfC7QuFb2A3CAEH+jUo5xZ5jeSotyio
	 VoEE8hUA+tk09jxOEaBVB3HUtKz8hH6V0diaC9+zJMzfz+PSvC4vV3NbtBepxMfnhI
	 utDDpNSuAvrHA==
Date: Mon, 27 Nov 2023 10:14:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_copy: actually do directio writes to block
 devices
Message-ID: <20231127181457.GB2766956@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069442535.1865809.15981356020247666131.stgit@frogsfrogsfrogs>
 <ZV7z4LnIqK9BwoCG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV7z4LnIqK9BwoCG@infradead.org>

On Wed, Nov 22, 2023 at 10:40:32PM -0800, Christoph Hellwig wrote:
> > diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> > index 79f65946709..26de6b2ee1c 100644
> > --- a/copy/xfs_copy.c
> > +++ b/copy/xfs_copy.c
> > @@ -854,6 +854,8 @@ main(int argc, char **argv)
> >  					progname, target[i].name, progname);
> >  				exit(1);
> >  			}
> > +			if (!buffered_output)
> > +				open_flags |= O_DIRECT;
> >  		}
> 
> I'd just move this outside of the if/else if chain and do the
> assignment once.

Fixed.

> > @@ -887,20 +889,22 @@ main(int argc, char **argv)
> >  				}
> >  			}
> >  		} else  {
> > -			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
> > +			char	*lb = memalign(wbuf_align, XFS_MAX_SECTORSIZE);
> >  			off64_t	off;
> >  
> >  			/* ensure device files are sufficiently large */
> > +			memset(lb, 0, XFS_MAX_SECTORSIZE);
> >  
> >  			off = mp->m_sb.sb_dblocks * source_blocksize;
> > +			off -= XFS_MAX_SECTORSIZE;
> > +			if (pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off) < 0)  {
> 
> We should probably check for a short write as well?
> Also this line is a bit long.

Ok, I'll check for short writes and split the error messaging so that it
no longer says "Is target too small?" on EIO.

--D

> 
> 
> 
