Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451FC5BAF0
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 23:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755558276; cv=none; b=D6BQBtWJrKXUdl1VLhRr4aDQsTstxkhoybod8Cicge45jxPLQUAL1l4L12+mIha+hqKqpp9eqbjJ/xGQ3hhYEBj4uj3cO8Y1FuRHfAUcmG8da8M+limZF8XJWoZG5D7GQVNy5GKwYnu+KdeO5JqIKP1TW4gJ+ZZRISrXrl296qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755558276; c=relaxed/simple;
	bh=+pe4/5Y8tWbZY0+6/MnGxG/AJme51VqEr2mfeDr0Ht0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seHco0fzLQohj4JjDaVIn5+y9Wm7fKym3YDVD3q5tj5f01klzUbwcc7jWCzMvhpC/vXC90dl3py/STbMIV23s9OevtwdlQLhjd+R2gydCpz4CdTm5JH5WOeaMjoem1Q1S6aL90Mub1uHrQeaYkww46CXXOwiXKxpCz9YjgC2Wpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0Kg1oDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0Kg1oDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A853FC4CEEB;
	Mon, 18 Aug 2025 23:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755558275;
	bh=+pe4/5Y8tWbZY0+6/MnGxG/AJme51VqEr2mfeDr0Ht0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0Kg1oDi5sNQaZASYrRqMQrSx+T90ZmWZvZuQ/KjGZ4X5vNHq/O+G4+m+hARypoSz
	 AiMlSBwqjkN8Osot9QKcFtWvllAssjx0hg4NNfk7AJwBU2kRFBiKVXIHahuxCuVsV8
	 ecT7i1t/wBQYm7rhYv/d4qw7Ixxkh/ouKY/v33ay48A0twESf0GQKtjtIjqEhliMQr
	 b1PyokdpwJAF/7E4CsI/hbinpMtvQbU9kNVyMGhwweMIal6WMdiJKcfRpKi8fu7/Bb
	 fR0VKrUp+CWomzz19VxFP7F0uR58AebC2OSTxzEJKHf3nOyrPIK2hiHocvQBj7bF7p
	 3Y3bRJ05QqsdA==
Date: Mon, 18 Aug 2025 16:04:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <20250818230435.GH7981@frogsfrogsfrogs>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
 <8fd28450-d577-4921-96d9-69af0c9b1aa4@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fd28450-d577-4921-96d9-69af0c9b1aa4@sandeen.net>

On Mon, Aug 18, 2025 at 04:11:41PM -0500, Eric Sandeen wrote:
> On 8/18/25 3:45 PM, Darrick J. Wong wrote:
> > On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> >> We had a report that a failing scsi disk was oopsing XFS when an xattr
> >> read encountered a media error. This is because the media error returned
> >> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
> >>
> >> In this particular case, it looked like:
> >>
> >> xfs_attr_leaf_get()
> >> 	error = xfs_attr_leaf_hasname(args, &bp);
> >> 	// here bp is NULL, error == -ENODATA from disk failure
> >> 	// but we define ENOATTR as ENODATA, so ...
> >> 	if (error == -ENOATTR)  {
> >> 		// whoops, surprise! bp is NULL, OOPS here
> >> 		xfs_trans_brelse(args->trans, bp);
> >> 		return error;
> >> 	} ...
> >>
> >> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
> >> mean in this function?" throughout the xattr code, my first thought is
> >> that we should simply map -ENODATA in lower level read functions back to
> >> -EIO, which is unambiguous, even if we lose the nuance of the underlying
> >> error code. (The block device probably already squawked.) Thoughts?
> > 
> > Uhhhh where does this ENODATA come from?  Is it the block layer?
> > 
> > $ git grep -w ENODATA block/
> > block/blk-core.c:146:   [BLK_STS_MEDIUM]        = { -ENODATA,   "critical medium" },
> 
> That, probably, though I don't speak block layer very well. As mentioned, it was a
> SCSI disk error, and it appeared in XFS as -ENODATA:
> 
> sd 0:0:23:0: [sdad] tag#937 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=2s
> sd 0:0:23:0: [sdad] tag#937 Sense Key : Medium Error [current] 
> sd 0:0:23:0: [sdad] tag#937 Add. Sense: Read retries exhausted
> sd 0:0:23:0: [sdad] tag#937 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
> critical medium error, dev sdad, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2

Ah, yup, critical error, we ran out of retries.

> XFS (sdad1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61 
> (see error 61, ENODATA)
> 
> > --D
> > 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> >> index f9ef3b2a332a..6ba57ccaa25f 100644
> >> --- a/fs/xfs/xfs_buf.c
> >> +++ b/fs/xfs/xfs_buf.c
> >> @@ -747,6 +747,9 @@ xfs_buf_read_map(
> >>  		/* bad CRC means corrupted metadata */
> >>  		if (error == -EFSBADCRC)
> >>  			error = -EFSCORRUPTED;
> >> +		/* ENODATA == ENOATTR which confuses xattr layers */

Can this comment mention that ENODATA comes from the block layer?

		/*
		 * ENODATA means critical medium error, don't let it
		 * get mixed up with the xattr usage
		 */

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> >> +		if (error == -ENODATA)
> >> +			error = -EIO;
> >>  		return error;
> >>  	}
> >>  
> >>
> >>
> > 
> 
