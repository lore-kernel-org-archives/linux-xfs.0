Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E88361954
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366028; cv=none; b=ahjw5S1YGOodxTOxtXtHmVDbozZucvjMiTo9pI3abmfs2puUoPLEw/LgMrCcD+JYq6SlCMYMyCPUtq6ojgv33spTYM6y+Z9uwatXvLMXmWRslo7nWkQ4CbfrsDE6qu69boTfz/hRYaB/Rv4UpUYnfBO+DQfK99cU0WroayAI++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366028; c=relaxed/simple;
	bh=ygahhRj+mydCaY+G9vT3Edb2A4JUT9WwQlVeK55P3h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpuy55rCUUjdwDhmW2iUHV0yiGDygoPhF5ErVH3RQAqje3k3VcS3wULwk8CiM5ezH7Di+SNFohSLmbMN88Cu3b+UVF069DoZSzruJQ8fDtT2t+Le5VoM7AsrJHfXcGTsGyOqxCaHaRn6j7H6aU+trVy25YYL0Oj0nc2c1PP+ptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMO3W4cI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMO3W4cI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C066E1F00A3F;
	Wed,  2 Sep 2026 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366025;
	bh=xXXxl9QVh+dURKKpBM4oKXSWJMs/sRPhu2AgzfMyCO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mMO3W4cIxDghJv8K63NcBUw/TtkOe/N0zZqP+QWKFLhFVs1IM7CuBq5hYmEIkS8Am
	 PvbRFp0x8taZohx5rg87f6bXH0dmt/WGvxaKS/YKG7S1vYkVVzwNymGwxKTr5Pzbzg
	 5MI5oaapOnBlyVWIAcJ99u7a57sTIDJ1t5iEy9zv4PGnBs0Ex3Alrk9wQFHQN/tVhL
	 SDNpmvOurKKe/WL4Ol72GKdovXd+Q+5N1MC7MGZbKN/q/Qiky1i6CNG9rNRoy3CgeZ
	 3D24iU0SsXmSSr9AkNcTQcW6CDuGVPFM769B31NfQC3VopeUGWtLzblTctpICc0ZbG
	 jDqWFz+EYrYug==
Date: Wed, 2 Sep 2026 09:20:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	aalbersh@kernel.org, cem@kernel.org
Subject: Re: [PATCH] libxfs: report device open errors during topology probing
Message-ID: <20260902162025.GU1933798@frogsfrogsfrogs>
References: <20260827112855.70037-1-hans.holmberg@wdc.com>
 <20260831071039.GA25070@lst.de>
 <32e910c2-28b1-4df5-99aa-8bf13801ca1e@wdc.com>
 <20260902055954.GA24431@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902055954.GA24431@lst.de>

On Wed, Sep 02, 2026 at 07:59:54AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 01, 2026 at 10:46:27AM +0200, Hans Holmberg wrote:
> > > I wonder if there are any valid failures from blkid_new_probe_from_filename
> > > where we'd want to continue?  Probably not as it doesn't really have an
> > > obvious failure path, but so far we continue here.  So the print is useful
> > > for sure, but I wonder if failing here might cause regressions in some
> > > really odd use case (containers without sysfs?  Although we'd run into
> > > trouble with that quickly in other places).
> > 
> > 
> > Yeah, it might be safer to just print the warning, and that would solve
> > my problem (no instructive error message),
> > 
> > On the other hand it's nice to fail early - but not if it causes regressions
> > of course.
> 
> Yeah, failing early is nice, but I'm a bit fearful we might break
> existing (but really weird setups).

AFAICT hidden sysfs doesn't seem to break libbkid's probing of devices:

# mount moo /sys/ -t tmpfs ; mkfs.xfs -f /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=644992 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=2579968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=268435456 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.

--D
