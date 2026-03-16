Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2206E355020
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701530; cv=none; b=G/OaMpgbgybJLIMHVhhfv9QRg/vkGN4GDFlwsP4WnH6ItY7DIz41RWsPyrWm4lYncm2jCGbIPU0TbloHL0D+Doa4bygmEr25ppjfMTjkSDhw3Pd/o9jjMBSnliKFWpFXWoUM5fYWd67bT8kWBBSo4s08ElZDsjmXQuDzuNE8wxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701530; c=relaxed/simple;
	bh=0+PLEg9nCmK8zDEkw1nz61XlZHwuIbLzK/M819r3Y70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nw//RVh+QZdFv5TBknTLT98v9vXGD4JxkRBSqJxbiVa1c68CoeBmLKo7P5q8PhEajn+9Wa/nUwCPRi0DSVNPxud7+0u98BBUN4g+k6s2lWLz0eejcJ5G+1jE4LDMt84Xb1sPuke6gnUF1RRAq0ex3GpI331Z2io1vPu1qX3Kmig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVySnuiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVySnuiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C890C19421;
	Mon, 16 Mar 2026 22:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773701529;
	bh=0+PLEg9nCmK8zDEkw1nz61XlZHwuIbLzK/M819r3Y70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVySnuiS0Nxw9qRN9OHHry2m5yto3i39VeSC/kQSRPYc4cWyQneRtpdBc2WkcXSp/
	 T/um+sxCzU2tcSLYeaIwgn2YhCCa3GoZ92+qNOxWl+EP0kV4fOLYQoz2jwM4eoYE4V
	 o30ZflkTgqHrcjHOwHSeXWq/IREiucVXnFzRFhNAOdgvfNyezVeoSqST+TqZMRP46D
	 5qmPXkl4fJs6x+0UJ2dutrWsP++r/rG+Wg4bnHATA91m8Pq0Lg5B/5nRA5h/j7jBpo
	 HpurOQv8Hco5Rjoufei8kLUzYP1wIRjZjeWNDlpMT09r3433gvx97NvObFHh8L+t7z
	 BZmH1v1/9h7iA==
Date: Mon, 16 Mar 2026 15:52:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: generic/753 crash with LARP
Message-ID: <20260316225209.GF1770774@frogsfrogsfrogs>
References: <aYC0pe-S-RWSMXHn@infradead.org>
 <20260202185959.GJ7712@frogsfrogsfrogs>
 <CAF-d4OshnJ997DDsgWzr0f+4-JpRaQ+B5-y6M0PUm=es9LpQXA@mail.gmail.com>
 <20260226053052.GE13853@frogsfrogsfrogs>
 <CAF-d4Oscq=qaCd9dbbEZjG8dA5Q7erdWSszoxY1migM8j85eRw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF-d4Oscq=qaCd9dbbEZjG8dA5Q7erdWSszoxY1migM8j85eRw@mail.gmail.com>

On Sat, Feb 28, 2026 at 04:54:25PM +0530, Ravi Singh wrote:
> On Thu, Feb 26, 2026 at 11:01 AM Darrick J. Wong <djwong@kernel.org> wrote:
> 
> > Hrm.  Where should we insert a xfs_force_shutdown call to reproduce the
> > problem?  I can get this to trip, but only after 18-25 minutes of
> > letting g/753 run.
> 
> I'm able to reproduce the crash reliably with the patch below.
> With this change, g/753 crash quickly.
> Please see if this works for you as well.
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf4..15eefa3e1 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -500,6 +500,17 @@ xfs_attr_finish_item(
>                 goto out;
>         }
> 
> +       /* Simulate crash after setflag committed during LARP replace. */
> +       if ((attr->xattri_dela_state == XFS_DAS_NODE_REMOVE_RMT ||
> +            attr->xattri_dela_state == XFS_DAS_NODE_REMOVE_ATTR) &&
> +            (args->op_flags & XFS_DA_OP_LOGGED) &&
> +            !(args->op_flags & XFS_DA_OP_RECOVERY)) {
> +               xfs_force_shutdown(args->dp->i_mount,
> +                                  SHUTDOWN_CORRUPT_INCORE);
> +               error = -EIO;
> +               goto out;
> +       }
> +
>         error = xfs_attr_set_iter(attr);
>         if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
>                 return -EAGAIN;
> 
> >
> > Also, if you apply that patch so that it creates the incomplete attr
> > name, do you end up with a consistent filesystem afterwards?
> 
> No. After applying the patch, the filesystem remains consistent
> after the run. xfs_repair -n does not report any structural
> corruption or incomplete attribute.
> I haven’t done exhaustive testing yet, though.
> 
> >
> > I think xfs_repair could report incomplete attr names instead of
> > clobbering the whole attr fork.  xfs_scrub can fix it, so it's not a big
> > deal to leave incomplete names around ... unless it'll confuse
> > xfs_attr_set?
> 
> I agree. I took a look at your xfs_progs commit
> 11a22e694671c112b3ebfffe879cc148cb8b5494.
> 
> >
> > (Also, do you ever see the xfs_repair in g/753 fail with complaints
> > about a corrupt attr leaf block at block offset 0?  I've seen that once
> > or twice but haven't reproduced it consistently yet...)
> 
> If you're referring to xfs_repair -n corruption errors like:
> 
> Metadata corruption detected at 0x55dc57df7f68,
> xfs_da3_node block 0x10801d0/0x1000
> corrupt block 0 of inode 25165954 attribute fork
> problem with attribute contents in inode 25165954
> would clear attr fork
> 
> Yes, I’ve seen this once as well. However, I haven’t been able
> to reproduce it reliably.

I think this patchset
https://lore.kernel.org/linux-xfs/20260312085800.1213919-1-leo.lilong@huawei.com/

nearly fixes that problem.  I added a small follow-on in
https://lore.kernel.org/linux-xfs/20260316045613.GU1770774@frogsfrogsfrogs/

which seems to have fixed the problem completely, at least if you have
this xfs_repair patch also applied:
https://lore.kernel.org/linux-xfs/20260316225033.GP6069@frogsfrogsfrogs/

--D

> Thanks,
> Ravi
> 
> >
> > --D
> >
> 
> 
