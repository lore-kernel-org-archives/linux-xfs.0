Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C737719
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286662; cv=none; b=GK+BO4+COhLLVQ5gREoWrhemizxqlQqECxecP1lf0jvHm6EKnWorlr+H6mau9lXIWCKyM6fGq3MaHzZBWUmI5ZrIji86bDjutXY4k9/Z/EO9kFCctW472108u0TLu+EnyNV41sydhk77FWcPPRKw/Q+SZwCHLWIVFoFRwCt1N2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286662; c=relaxed/simple;
	bh=Xtk9lk3GbIyTMT8mzLA3xDAbyUrNv5wbDhpysTad6p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mbHR+I4ROwAA4zVZpLLQj2p+N/5SCD2SQ2ggA0T2mtAn8qSxEoIxvCBUFIdRpdo+AAy+XiRvZveIHsdWXp0NUTlgjaaqvq+0byYg58ntB+WpU2azaTsYW6z0gzRlSDgsvT/WrghDmE3kxb6XYa8Ml8WS3wn+Bplyy7/qVPsv7Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSWEAG8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSWEAG8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BD9C113CE;
	Tue, 16 Apr 2024 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713286661;
	bh=Xtk9lk3GbIyTMT8mzLA3xDAbyUrNv5wbDhpysTad6p4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OSWEAG8uRHgDNcNl8RSwLval8trou8xBo8TUhDcDQp99j3TM7cO8tiweUCW0qCAKU
	 Mi7YL80xoRL2ay8OKZkuJHarmLu9ExVSguDIFWXdF4/QNe6lWw7kHFTJ4rqhZ0wKj0
	 oxQWnaFRucG0UONSzxi8jTLnDw/hccJA62JKOuPfiGjGXb8aJXEcI3dxT9m/1F/pVW
	 Y92eSFyYDjWgruE3mfoymgN0Soq/MJgXOaOKEGBp4EKqhfFm/lo8+dzU4L+mT2xyZn
	 QmzZPb5pR/wdRcXi5n7RPWYZkDw2Kc0yCYVh1GlupHvFbqEeJqBi0YbmeiB9u1v1EZ
	 tsAds8tWFWFDw==
Date: Tue, 16 Apr 2024 09:57:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <20240416165741.GP11948@frogsfrogsfrogs>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
 <Zh4EpDiu1Egt-4ii@infradead.org>
 <20240416154932.GH11948@frogsfrogsfrogs>
 <Zh6nVRlJXXN87tho@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6nVRlJXXN87tho@infradead.org>

On Tue, Apr 16, 2024 at 09:29:09AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 08:49:32AM -0700, Darrick J. Wong wrote:
> > > Not a fan of this, but I guess there is a real need somewhere because
> > > we run out of the number of open fds otherwise?
> > 
> > Yes, we can hit the open fd limit...
> > 
> > >                                                  Given that repair
> > > generally runs as root wouldn't it make more sense to just raise the
> > > limit?
> > 
> > ...and we /did/ raise the limit to whatever RLIMIT_NOFILE says is the
> > maximum, but sysadmins could have lowered sysctl_nr_open on us, so we
> > still ought to partition to try to avoid ENFILE on those environments.
> > 
> > (Granted the /proc/sys/fs/nr_open default is a million, and if you
> > actually have more than 500,000 AGs then either wowee you are rich!! or
> > clod-init exploded the fs and you get what you deserve :P)
> 
> Whar is clod-init?  And where did you see this happen?  

cloud-init is a piece of software that cloud/container vendors install
in the rootfs that will, upon the first startup, growfs the minified
root image to cover the entire root disk.  This is why we keep getting
complaints about 1TB filesystems with 1,000 AGs in them.  It's "fine"
for ext4 because of the 128M groups, and completely terrible for XFS.

(More generally it will also configure networking, accounts, and the
mandatory vendor agents and whatnot.)

--D
