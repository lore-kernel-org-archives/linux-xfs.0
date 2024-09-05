Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED80BE4A
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 09:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725526883; cv=none; b=VQwUt6Oi7GeUBJJJFmqeKPIpYtta3q6Rp0wRD4OtKXsXY/QhD+g66tPgQlymMRF7xLjw7xM7lkFIFOQg84awl09Pc45Yu07nfqz1psSvsWc7H7ry/n+sJLZ47+shMT75PUhKylb4CUrB+eVO5cL0YMpscONk2WEDQrfPmx/y7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725526883; c=relaxed/simple;
	bh=vpYMqOD/PAAtJNZ1ycwRCiXAOL9rC/rTYldrwkD83kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHR0EkzJeIHKID3T3U1OBoIsUGxuKqPcwPNYMpHQw/WFOhVU13Cg8ER5OA0VlxN45zpYIBMDx9CTzDUgDjRQsJLySgvXEnWKr7C0a4/d32XCHkDVtabklbxObNcTqwcu/6/k2k4fafoBIKVLmF7fPcBqHadi63CslTr9QQufOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llpmPW+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llpmPW+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E49C4CEC3;
	Thu,  5 Sep 2024 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725526883;
	bh=vpYMqOD/PAAtJNZ1ycwRCiXAOL9rC/rTYldrwkD83kQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=llpmPW+ut/QmZxPmRLHyhrSHHMYoH5XncsJCg0Vcl3NwfFq93MNG2/nL8+BpAS8MU
	 +N/ZtSZsuz8Ne+nCXnWmtsnI5osx+n79BLAHO30braEBETbr2BNihJpJNgmdxmLnTi
	 7P3adbd04QN5nCxtidtQ+n4x1rQ9L8GMniXujIZQ6tyGMFgmq+bENJP61+n9qawheX
	 DXGTLozGj9d0ZkEumuhboj8gTWE8iFmlOdrNQiTwXGMU37ZJA/kqr5YZwaPr5abgUD
	 d6EngrMRF9ac48dIngUWTsIXmWklY9h/ga0grOzrvv5nGqoGF9TO2RVPYl48xO+Gc7
	 DiIUdPfDhcLeA==
Date: Thu, 5 Sep 2024 11:01:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] man: Update unit for fsx_extsize and fsx_cowextsize
Message-ID: <lcsus6hy4vqtngbgp7q2gvll42ujgkq2mioo64j2shlhrz2mlr@ykrwvep3bpla>
References: <20240808074833.1984856-1-john.g.garry@oracle.com>
 <20472c92-188a-466c-ba10-2a634782782f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20472c92-188a-466c-ba10-2a634782782f@oracle.com>

On Thu, Sep 05, 2024 at 09:15:50AM GMT, John Garry wrote:
> On 08/08/2024 08:48, John Garry wrote:
> > The values in fsx_extsize and fsx_cowextsize are in units of bytes, and not
> > filesystem blocks, so update.
> > 
> > In addition, the default cowextsize is 32 filesystem blocks, not 128, so
> > fix that as well.
> > 
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> Has this change been missed?

Yup, I'll add it to the next release.

Carlos.


> 
> Cheers,
> John
> 
> > 
> > diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> > index 2c626a7e..25a9ba79 100644
> > --- a/man/man2/ioctl_xfs_fsgetxattr.2
> > +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> > @@ -40,7 +40,7 @@ below for more information.
> >   .PP
> >   .I fsx_extsize
> >   is the preferred extent allocation size for data blocks mapped to this file,
> > -in units of filesystem blocks.
> > +in units of bytes.
> >   If this value is zero, the filesystem will choose a default option, which
> >   is currently zero.
> >   If
> > @@ -62,9 +62,9 @@ is the project ID of this file.
> >   .PP
> >   .I fsx_cowextsize
> >   is the preferred extent allocation size for copy on write operations
> > -targeting this file, in units of filesystem blocks.
> > +targeting this file, in units of bytes.
> >   If this field is zero, the filesystem will choose a default option,
> > -which is currently 128 filesystem blocks.
> > +which is currently 32 filesystem blocks.
> >   If
> >   .B XFS_IOC_FSSETXATTR
> >   is called with
> 
> 
