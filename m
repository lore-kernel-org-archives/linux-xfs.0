Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853D91DE8B0
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 01:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744767013; cv=none; b=J3k8qQNoTobYBryMtZx24FsSsZUDKmRPmdk6a4FwIKH08hc+fe8R1/OXYfEyFV5aF8kyhAIN4hyt4PFUN1ivzvshz+6admn/6+aeUzRaP54Ar/4KPmV8gI32ZVFNy9MdlMap+dKCMILrMJx35g7gVu765wNDRb7SkRBylUJHQCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744767013; c=relaxed/simple;
	bh=Blb9N5BONXBMBUostvygDbqHU+G6bXMxG0/RaN1WDM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HL7UWiw4enwI2ElkWuDlBdlKVZE/n89v/xWxqxmTe1Px7k+W/g124RqJh/j8a3QISl9lxMOE1HdW45JqwCsDoxZ1mhZeBWhwrk2SrYKrXdym8WCo5JZTUq/9PrOzWjpyDDdjQsPhByg/7divlni6V/ATFJ/u6YIgVHfdt0+hs7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNU2UCNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNU2UCNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02599C4CEE7;
	Wed, 16 Apr 2025 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744767013;
	bh=Blb9N5BONXBMBUostvygDbqHU+G6bXMxG0/RaN1WDM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNU2UCNkgo4fpH8hpE1nfxAkIf+Gvc0ERzgui+Nn8Vt+rsGKqN/1qyD8EzL23JSgf
	 1Lapy8fJx5Bc6ZN+T/FrEUCg1A56hCQTBe3OtkqSJEM7f6V1v2VzVdIKKXEpRE6Jvq
	 NUiyf0FWXj0nn0LJ8fEHb1wp+rO1hQmlS0jCj4ed8jt6d8Qj3vDCOOTcf/Buhqgamc
	 Tl8Y9D32w3Z4coC5Ju7LYUcYOhql8wpRMx7avaCiveUuMflVCL2jSEM1JIZ23UfngF
	 rICFSWytMHeLD2fF11u876GYYyxmDYhSnn74GEjaCaPMyPT7DiUFvk+9Hg8TjHZC9Q
	 uCdr/cxFbtbFw==
Date: Tue, 15 Apr 2025 18:30:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: bodonnel@redhat.com, linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH v3] xfs_repair: fix link counts update following repair
 of a bad block
Message-ID: <20250416013012.GX25675@frogsfrogsfrogs>
References: <20250415184847.92172-3-bodonnel@redhat.com>
 <d20ee07d-bdcc-48b4-9e35-7228187d69e7@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d20ee07d-bdcc-48b4-9e35-7228187d69e7@sandeen.net>

On Tue, Apr 15, 2025 at 02:12:31PM -0500, Eric Sandeen wrote:
> On 4/15/25 1:48 PM, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > Updating nlinks, following repair of a bad block needs a bit of work.
> > In unique cases, 2 runs of xfs_repair is needed to adjust the count to
> > the proper value. This patch modifies location of longform_dir2_entry_check,
> > to handle both longform and shortform directory cases. 
> 
> This is not accurate; short form directories are not generally in play here.
> They only arise due to the directory rebuild orphaning all entries without
> the prior scan, yielding an empty directory.
> 
> > This results in the
> > hashtab to be correctly filled and those entries don't end up in lost+found,
> > and nlinks is properly adjusted on the first xfs_repair pass.
> 
> Changelog suggestion:
> 
> xfs_repair: phase6: scan longform entries before header check
> 
> In longform_dir2_entry_check, if check_dir3_header() fails for v5
> metadata, we immediately go to out_fix: and try to rebuild the directory
> via longform_dir2_rebuild. But because we haven't yet called
> longform_dir2_entry_check_data, the *hashtab used to rebuild the
> directory is empty, which results in all existing entries getting
> moved to lost+found, and an empty rebuilt directory. On top of that,
> the empty directory is now short form, so its nlinks come out wrong
> and this requires another repair run to fix.
> 
> Scan the entries before checking the header, so that we have a decent
> chance of properly rebuilding the dir if the header is corrupt, rather
> than orphaning all the entries and moving them to lost+found.
> 
> > Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> 
> Other than the commit log, 
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

With the changelog amended,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> > ---
> > 
> > v3: fix logic to cover the shortform directory case, and fix the description
> > v2: attempt to cover the case where header indicates shortform directory
> > v1:
> > 
> > 
> > 
> >  repair/phase6.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/repair/phase6.c b/repair/phase6.c
> > index dbc090a54139..4a3fafab3522 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -2424,6 +2424,11 @@ longform_dir2_entry_check(
> >  			continue;
> >  		}
> >  
> > +		/* salvage any dirents that look ok */
> > +		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> > +				irec, ino_offset, bp, hashtab,
> > +				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> > +
> >  		/* check v5 metadata */
> >  		if (xfs_has_crc(mp)) {
> >  			error = check_dir3_header(mp, bp, ino);
> > @@ -2438,9 +2443,6 @@ longform_dir2_entry_check(
> >  			}
> >  		}
> >  
> > -		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> > -				irec, ino_offset, bp, hashtab,
> > -				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> >  		if (fmt == XFS_DIR2_FMT_BLOCK)
> >  			break;
> >  
> 
> 
