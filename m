Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880DB192D6B;
	Thu, 15 May 2025 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747320883; cv=none; b=U7oBwnnOxKyfP5EyecxTkEce95iGokNENiw3N/zBaVvsVmJu8J029bmjcJ8SFNjpCku2OD0ZanXqgHf+zKMTvkBZBSuPoOArwwSYX72N5ACwKQ/5Qsai10wsNwgcIS0spYH/Nd1cYUhCob3aaqip7MuTUJPJ1EVnlsGa0MQPvM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747320883; c=relaxed/simple;
	bh=cYtAejpzISYl29Fbg64b/fMp392EFfCBtSuZccz4IRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5cbDTeKwtgmYYBG2SFX7QDARwyE6gZwCMX39kYH13yKMBZ/sClI+JAZeRPwsRZP4frawm2kBHMoHOyaTyKUgRWVP94OIdaq/2iTnltklgWcJqS158lnj7DBQJB05gv2fJhXoQEHqHLzn6eXkefGW3BESvroqAk3K+EZ//J7QlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiXFO8hC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiXFO8hC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC130C4CEE7;
	Thu, 15 May 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747320881;
	bh=cYtAejpzISYl29Fbg64b/fMp392EFfCBtSuZccz4IRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiXFO8hCUaq0F8iwza1tgc4wm/dJ2CyFUp/2j/J75BqgYBbj7nSYAkNRM+ILWohi5
	 LiknEqQFWIBHJTkBG8RQ9UpFveUp6oivkafILbdpG+nBS4DGKjpgdTyE94dAzg3QU8
	 5g/KWp/I15AI11/K4W4ly+9R9btQVczsXuPbTJnVBk598c9c7eABJeCU4ep+rXw73m
	 lMFJnxzzqh+LBkA6tWdI5WAj3DDT+P8nviwmnYikHLo5eBLAnSuesxw9YJDYKRdrgR
	 EetTgIV69vqXtHAiIfzhjtZZfrzWVZzrD8rfHyJvHpNP/EQ881hMh+VZp1Pxus3r4C
	 Hwmm06cdDEI3Q==
Date: Thu, 15 May 2025 07:54:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
Message-ID: <20250515145441.GY25667@frogsfrogsfrogs>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
 <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>

On Thu, May 15, 2025 at 09:16:12AM +0100, John Garry wrote:
> On 14/05/2025 16:38, Darrick J. Wong wrote:
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
> > > >    		fi
> > > >    		if [ "$param" == "-A" ]; then
> > > >    			opts+=" -d"
> > > > -			pwrite_opts+="-D -V 1 -b 4k"
> > > > +			pwrite_opts+="-d -V 1 -b 4k"
> > > according to the documentation for -b, 4096 is the default (so I don't think
> > > that we need to set it explicitly). But is that flag even relevant to
> > > pwritev2?
> > The documentation is wrong -- on XFS the default is the fs blocksize.
> > Everywhere else is 4k.
> 
> Right, I see that in init_cvtnum()
> 
> However, from checking write_buffer(), we seem to split writes on this
> blocksize - that does not seem proper in this instance.
> 
> Should we really be doing something like:
> 
> xfs_io -d -C "pwrite -b $SIZE -V 1 -A -D 0 $SIZE" file

In _require_xfs_io_command?  That only writes the first 4k of a file, so
matching buffer size is ok.

Are you asking if _require_xfs_io_command should seek out the filesystem
block size, and use that for the buffer and write size arguments instead
of hardcoding 4k?  For atomic writes, maybe it should be doing this,
since the fs blocksize could be 64k.

--D

> Thanks,
> John
> 
