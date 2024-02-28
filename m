Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FAD74432
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709164528; cv=none; b=qt2utE0iIEHo3mbpaPl0VWexv4CSNSihrgycsxqaerl0ujKHSgn8g0JRSWDWddOJPFwSGZmU1T8h+YczWym54u0ykfMDgcPP3ARAFCIGe7n9l/UNoyndx2FjLllAYQ5Wkb2Lu9uHt8PRmPGMzZZ2cYFvxS6IoqziP4IMAXXsw3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709164528; c=relaxed/simple;
	bh=+ic8jIhMpnFeyLYIMI7m+bwzlHsW6uhzNWQl2gvDD5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGGQ5KiH5tWFk05qIDcUDwaySeMVumQLnEUg2p4ieyiyF5ekHWOoeUWay1w1l45vgXb1iqFZ5dX5ung4zoOJivIwdQccutpuRDt7St5Eudj3GWcVOIuVZOPR5a8lxOxcPBcRwtTYR+AVJ70rKeiXW8HOJlqnf6mcicuzbN+L4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=a/3onSKF; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="a/3onSKF"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so257497a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709164525; x=1709769325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9U6NaPE28mZH6SU63ea3EXHuOrr0bVVPLt1Ke52ONU=;
        b=a/3onSKFtCAVYDaaFAABLBGIU+fnbjISStwaLzXRiJoS+tuMAHG1zNrFV9wSi4IBqT
         zo59rUOms2dfTj+TsKbc0lBBd5n3Cjs2sHy2Fg3mFIoO6FPOwKPyyJU26a4DEGC2wVfU
         Z/CqGW0TYY1b3aenXtkkUnH1KZmwv7+AWPC8y//AqZvFDIpkveVsKVny03poH2tS0+i1
         lO5UPnI39B7V2X5iiHyMhAhQwZqjDT+Wuh4G6kXyRgk1ywetpGPX8JRfG1uGGlWsOGma
         CsJ2qtuUuthW8w3Cbrnv3gEWiRJczyLoOob50aWHnql0yAZgUKI+ND7y2mauhvDbRZ3G
         LhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709164525; x=1709769325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9U6NaPE28mZH6SU63ea3EXHuOrr0bVVPLt1Ke52ONU=;
        b=LzxzP+ZNK1ArEwc9qEIL8Ag8f+RjiqZ3P5v1sIqyO61KYQRLyLP9hj1iHLbQyFO2zo
         slCBORKpv9LEhDtrUZL7kKhbOJa+H/2zxofrC+/8CFYhEdF2rRdPZwKtU2QEFnUpoCoX
         gRNDSk2jSKbgeTRDgAKhayMiL+MjfyyThHYa+Qd9azYeRSVx7+nG1v8sxb6JUE8TaDlO
         AMANdWOkH80TLBdJw4roVYlrrX5XMDPRl6Co0qp4tKKmqnuc1JjJ76xvys+yr/XQFFNd
         s+Kfp83128Aut2MZZ2WKtIhU+00uVV4v8fD/N2bWD8x/Xhv25gwzPgOfuKaZ/1KCSrJ/
         D7DQ==
X-Gm-Message-State: AOJu0Yy/PIy1gKCccnh7Iv69sjsYAhqcQlMFFdqJRwHmB2yGW6XxpvsI
	+SC94LzSHNrI4a4XpaBzNfd1zbifS+2J1QDqqb4SFE02OOGuF41Ttv4gqFEHHyM=
X-Google-Smtp-Source: AGHT+IF43SvZvswOCVy0vOnsKZBZhkb7nurjYRAnvTxt/DureqGnjVRmTrz7JbsTpIT5oKeuwEIUzg==
X-Received: by 2002:a05:6a20:e68c:b0:19e:9966:228d with SMTP id mz12-20020a056a20e68c00b0019e9966228dmr920182pzb.20.1709164525476;
        Wed, 28 Feb 2024 15:55:25 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b001dbad2172cbsm36098plb.8.2024.02.28.15.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 15:55:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rfTli-00CsE0-0x;
	Thu, 29 Feb 2024 10:55:22 +1100
Date: Thu, 29 Feb 2024 10:55:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: stop advertising SB_I_VERSION
Message-ID: <Zd/H6pf1YM0mTk1r@dread.disaster.area>
References: <20240228042859.841623-1-david@fromorbit.com>
 <20240228160848.GF1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228160848.GF1927156@frogsfrogsfrogs>

On Wed, Feb 28, 2024 at 08:08:48AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 28, 2024 at 03:28:59PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The redefinition of how NFS wants inode->i_version to be updated is
> > incomaptible with the XFS i_version mechanism. The VFS now wants
> > inode->i_version to only change when ctime changes (i.e. it has
> > become a ctime change counter, not an inode change counter). XFS has
> > fine grained timestamps, so it can just use ctime for the NFS change
> > cookie like it still does for V4 XFS filesystems.
> > 
> > We still want XFS to update the inode change counter as it currently
> > does, so convert all the code that checks SB_I_VERSION to check for
> > v5 format support. Then we can remove the SB_I_VERSION flag from the
> > VFS superblock to indicate that inode->i_version is not a valid
> > change counter and should not be used as such.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Seeing as NFS and XFS' definition of i_version have diverged, I suppose
> divorce is the only option.  But please, let's get rid of all the
> *iversion() calls in the codebase.
> 
> With my paranoia hat on: let's add an i_changecounter to xfs_inode and
> completely stop using the inode.i_version to prevent the vfs from
> messing with us.

Ok, I'll do that in a new patch rather than try to do everything in
a single complicated patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
