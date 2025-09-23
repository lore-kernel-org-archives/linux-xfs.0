Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA24275B19
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647357; cv=none; b=ilHZZkBwH6dHC1pur06YXsUkhI+4jlPymH/UsO6vbf0WND8THs/zAVC+vtlyvVwbzObb0UJE6iCJhv9ehVzXkIK3NDN1ReiEOHpynIqeHGOw+RPW6c2Zc587AcS1pgzmH62FeS9N23XiYPDw/0N0iYAtNrP2JNhom91v0mehxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647357; c=relaxed/simple;
	bh=EM9UY1Ajpfw24kVvNqa9pMWGsn5Dn+VdciL+9KSZ2fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxPHsWromJ5gmaFRyFnuxp0KC32WcpUhlP2TlRv69/ap9jGBGx1yllyIlQebJ7QK30bPgRSd+M++FvH2Ayo6RCbJHy+96iCMC7R9jcUqEJhdJdjgA0wShdGdwjj5d0wh4AjcRKzfdgYsx8odniEt41Hi+h0B6c2C2Dldf8/dbG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOE5NuQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOE5NuQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E9EC4CEF5;
	Tue, 23 Sep 2025 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758647356;
	bh=EM9UY1Ajpfw24kVvNqa9pMWGsn5Dn+VdciL+9KSZ2fQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iOE5NuQqYF6kOg2lm6YylacWEwrmN4cKEN/E8S+GMTV4TlZZQUy09NG6+Na+rJepD
	 jaRJw8pXCDVWqm6C/o76aDieDv6gGvKCeLkiTUp/STTqJRBzJ92ck8GapVKdYymskN
	 WdnhFkk9v52NiV+eCkn6KD1NRwt1PD5A9iba01Uy0VlSYhIFOWod227ugZF3GfQ6ZS
	 VYGbyYjGDT+9W9WQ4awgRsCdroABurlYjFK36u7oG1CJIVkCJSzcw0fRJ9q8zqH759
	 /BZcuD/UXWmbVMrfc2Z5Yi77bB63xdZn+SJbXdL7+vt1HLsuGMC6M3YygNpFeHkcnn
	 KSRS/iIBzhO6w==
Date: Tue, 23 Sep 2025 10:09:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: regressions in xfs/633 and xfs/437?
Message-ID: <20250923170915.GT8096@frogsfrogsfrogs>
References: <20250922152954.GR8096@frogsfrogsfrogs>
 <conkiyr3ppcjq6j3pwgkrbvakvvez5h4wixrmmjh2c2pmhazhd@f7jqzxdhpmvi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <conkiyr3ppcjq6j3pwgkrbvakvvez5h4wixrmmjh2c2pmhazhd@f7jqzxdhpmvi>

On Mon, Sep 22, 2025 at 06:11:27PM +0200, Andrey Albershteyn wrote:
> On 2025-09-22 08:29:54, Darrick J. Wong wrote:
> > Hey folks,
> > 
> > Have any of you noticed a recent regression in xfs/437 and xfs/633?
> > 
> > --- /run/fstests/bin/tests/xfs/437.out	2025-07-15 14:41:40.303420629 -0700
> > +++ /var/tmp/fstests/xfs/437.out.bad	2025-09-21 18:53:36.368250642 -0700
> > @@ -1,2 +1,3 @@
> >  QA output created by 437
> >  Silence is golden.
> > +mkfs/proto.c:1428:	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> > 
> > --- /var/tmp/fstests/xfs/633.out.bad
> > +++ /dev/fd/63	2025-09-21 17:45:58.431935255 -0700
> > @@ -1,6 +1,107468 @@
> >  QA output created by 633
> >  Format and populate
> >  Recover filesystem
> > +./common/xfs: line 335: 326611 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
> > +./common/xfs: line 335: 326617 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
> >  Check file contents
> > +--- /tmp/326192.stat.before	2025-09-21 17:36:10.071959154 -0700
> > ++++ /tmp/326192.stat.after	2025-09-21 17:36:12.863959041 -0700
> > +@@ -1,23 +1,3 @@
> > +-11a4 0:0 0 0 fifo 0 1731556303 ./S_IFIFO
> > +-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c19
> > +-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c1a
> > <snip>
> > 
> > The xfs/437 failure is trivially fixable, not sure what's causing the
> > segfault here?  Probably something in the new file_{get,set}attr code in
> > xfs_db is my guess...?
> > 
> > MKFS_OPTIONS  -- -f -m metadir=1,autofsck=1,uquota,gquota,pquota, -n size=8k, /dev/sdf
> > MOUNT_OPTIONS -- /dev/sdf /opt
> > 
> > (note that both problems happen on a variety of different
> > configurations)
> > 
> > --D
> > 
> 
> I haven't seen this, thanks, will look into it

I'll send some fixes shortly.

--D

> -- 
> - Andrey
> 
> 
