Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8DB3E51CF;
	Mon, 23 Mar 2026 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299393; cv=none; b=Xs3dkFT4sY5LyC8ScKQ4GcO8WhGwuKVvbUOozqPcYaEsaBQ805CwVJSCTPATpWPJTUmo6ULXyuXCCA/MUeMkH7fqY1DogJcmtEbT/DJs6jJzEIkTzw2IqRMseVJN0iSqD7926QEfRXD0yG1by6HmFUPWRESfwuw6zxd7iwrX2Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299393; c=relaxed/simple;
	bh=DafmbkMzyPr+uuz7EKoPBBIaj+Zc/1ct/k3hW7o1G2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZP2fDLcE/080GQkde8Hl8BhuAQ0HUQHqSavHQP+vtBR+duO6cqj4wUmap38T8GU6z1/WWqbS0mdjKMI72oNQRAS1fys5N8tS0euh8AbtfRRmRijceQ1avPZ6jGhKIvrdKkAer5srH0HZcclf2hmGhIYL26eJVgR0+CFfaSttQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2TtqCvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2TtqCvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFE6C2BC87;
	Mon, 23 Mar 2026 20:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774299392;
	bh=DafmbkMzyPr+uuz7EKoPBBIaj+Zc/1ct/k3hW7o1G2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y2TtqCvhJal2Skb1pbOwhlMw5i0zi+TVmJE2Eq3Zxj75W15S1BxEQD58l4YlVnFUb
	 kY/YJ/UvABWWUo8rxVaSM/vBdmwnhywjnxa8/wG/jJlc5Wjkn0lJj5Axjt2B9GXofU
	 vypcliAmtrK7orhjNr2+L0qDVjnTUGAbZdw9aXRjEtBtrOgqk4lcso2o9KwhMQUOHU
	 MpZdCb2IPph2LOtuKIud5YxXFvsqC9aDxZxfGkfvHG4jTuOpwnL/nyHCI5++0Uxv8i
	 0zVH3NP0A0z3R2FaeL8PrT3Y5aOm8dCPA44E5Xd73hWTzfdevrkhAJU1SfWc+70Rz5
	 y+Yovu6tv/WZA==
Date: Mon, 23 Mar 2026 13:56:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <kees@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] xfs: Replace strncpy() with strscpy_pad() in tracepoint
 error paths
Message-ID: <20260323205631.GK6223@frogsfrogsfrogs>
References: <20260323172204.work.979-kees@kernel.org>
 <20260323152514.006d96b5@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323152514.006d96b5@gandalf.local.home>

On Mon, Mar 23, 2026 at 03:25:14PM -0400, Steven Rostedt wrote:
> On Mon, 23 Mar 2026 10:22:09 -0700
> Kees Cook <kees@kernel.org> wrote:
> 
> > Replace the deprecated[1] strncpy() with strscpy_pad() in the
> > xfile_create and xmbuf_create tracepoints.
> > 
> > Both tracepoints use file_path() to resolve a pathname into
> > __entry->pathname (a char[MAXNAMELEN] trace ring buffer field). On
> > failure, the error path overwrites the buffer with the string literal
> > "(unknown)" via strncpy(). The original strncpy() zero-pads the
> > remaining 246 bytes (MAXNAMELEN is 256, "(unknown)" is 10 bytes
> > including NUL).
> > 
> > strscpy_pad() preserves this zero-padding, which matters because the
> > destination is a trace ring buffer entry: ring buffer slots are not
> > zeroed on allocation, and the raw buffer is readable by userspace via
> > tracefs. The zero-padding ensures no stale data remains in the
> > buffer after the error path overwrites it.
> > 
> > The source is a 10-byte string literal into a 256-byte destination,
> > so there is no behavioral change.
> 
> Hmm, seems to be a lot of waste. Note, the ring buffer now zeros out its
> data on allocation so there's no need to zero pad anything, at least not
> for exposing data. You may expose a previous trace.
> 
> Also, why are these using full path size and not just use dynamic array.
> That would be much more efficient in both performance and space.

"Darrick was too stupid to figure that out when he wrote it."

Initially the shmem files used by xfile/xmbuf provided a longer
description of exactly what the file was being used for (e.g. "AG 43
rmapbt") but the dynamic string memory allocations were annoying to have
to catch since some of them exceeded 16 bytes (or whatever the
"guaranteed not to fail" limits arenow) and then I was snowed under by a
bunch of static checker people and so I gave up and ripped all that out.

So at this point the description is hardly useful and maybe I'll just
submit a patch to rip out all the file_path tracepoint stuff.

--D

> -- Steve
> 
> 
> > 
> > Link: https://github.com/KSPP/linux/issues/90 [1]
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> >  fs/xfs/scrub/trace.h | 3 +--
> >  fs/xfs/xfs_trace.h   | 3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > index 39ea651cbb75..46c420f51129 100644
> > --- a/fs/xfs/scrub/trace.h
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -980,8 +980,7 @@ TRACE_EVENT(xfile_create,
> >  		__entry->ino = file_inode(xf->file)->i_ino;
> >  		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
> >  		if (IS_ERR(path))
> > -			strncpy(__entry->pathname, "(unknown)",
> > -					sizeof(__entry->pathname));
> > +			strscpy_pad(__entry->pathname, "(unknown)");
> >  	),
> >  	TP_printk("xfino 0x%lx path '%s'",
> >  		  __entry->ino,
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 813e5a9f57eb..9f9fb86097ed 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -5101,8 +5101,7 @@ TRACE_EVENT(xmbuf_create,
> >  		__entry->ino = file_inode(file)->i_ino;
> >  		path = file_path(file, __entry->pathname, MAXNAMELEN);
> >  		if (IS_ERR(path))
> > -			strncpy(__entry->pathname, "(unknown)",
> > -					sizeof(__entry->pathname));
> > +			strscpy_pad(__entry->pathname, "(unknown)");
> >  	),
> >  	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> 
> 
