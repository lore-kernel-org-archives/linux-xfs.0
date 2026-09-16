Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DF8472F94
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547638; cv=none; b=fbhddr+sHpw8LNRfTRJRn7kzWCamlzxQZLfjSIlcS3Ai6YY65jMSpcaRW4wVOO+aK64HksIuM5IU5JlGA1JqjrhItXuF9a7ORrJooeRFnthZfi2vIlKVM9iRxmcXSJs/NI7VuOrxSzJWq0IjALnfBnYnkFdzeQdpMO2l950MDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547638; c=relaxed/simple;
	bh=ru7fGjTwF06OtIEJOfwXOla8fn/zqXQv7uJINzebzPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SA1M9CUMtSyFtkEvdikwa5n51dcaetgviua2sA6fz1ocqWWmOiePPcfSCMp0OTxrvytcF3+1sOXFQusenUg6hEYLzP47W7Gpc+LK5K8DETao3TYAA+WTBTYWhJB0Tb3YtKNHoCY0Ytf7vAHNq9PNpfXmLW4nJPL4ovkDzKpX348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xf8mQzJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xf8mQzJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727671F00893;
	Wed, 16 Sep 2026 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789547636;
	bh=T8/sIRDD4wWR/vHu4Gf5WVcsEkFGZDvSZScx1Bwtfck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xf8mQzJDb08vQvgypBvx/Pbtp17aSFH8zPVr8Zrd/jauRmXD0vDtZP9rUO2UeS6u3
	 JQBD3uJc9KLvzW6sYVPUTadc+O4sP3kdOv0iJPqYkYBSAVnd6xFMA0bTIW+MkG0yJU
	 lEbww4oieFKThtApGUEnKGdvgUH4KMPDm40SOgKItNiaWF1oRv0TvGxNkGrOekVzXh
	 CmwNUQhbeEqisYnw5b8AJrlN+OvRW+wvcFmrR3pwPrV8MXtOVmM+vylo/YH4OmJHs0
	 DIjrU4c6/siYoKwzgLBm/+ujF9QHfrOemM302GViAMULjv9688FQunMRrf3jo/66WX
	 2PTj6jBjrSWuQ==
Date: Wed, 16 Sep 2026 10:33:52 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libfrog: try to pass struct fs_path objects to
 quotactl wrapper
Message-ID: <aqpUR1iinW_UYiXW@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>
 <aqkeeAgNLMFFqgcl@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aqk5gM82hhqq-Upd@infradead.org>
 <20260915161533.GD2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915161533.GD2705364@frogsfrogsfrogs>

On 2026-09-15 09:15:33, Darrick J. Wong wrote:
> On Tue, Sep 15, 2026 at 05:26:40AM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 15, 2026 at 12:34:33PM +0200, Andrey Albershteyn wrote:
> > > > +	const struct fs_path	*mount,
> > > > +	enum xfs_quota_cmd	xcommand,
> > > > +	uint			xtype,
> > > > +	uint			id,
> > > > +	void			*addr)
> > > > +{
> > > > +	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);
> > > 
> > > The xfsquotactl() can be unfolded here and calls may be replaced
> > > with xfrog_quotactl(), no?
> > 
> > Yeah, looks like we should be able to kill it.  But maybe do that
> > as a follow on cleanup?
> 
> Hrm.  There are two xfsquotactl() callers remaining after this patch.
> One of them is set_limits() in quota/edit.c.  One of the callers of
> set_limits is limit_f, which could very well pass through the fs_path
> like everywhere else:
> 
> 	set_limits(id, type, mask, fs_path->mnt_fd, fs_path->fs_name,
> 		   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
> 
> Obviously a good candidate for passing the fs_path instead of the raw
> pieces.
> 
> The other set_limits caller is restore_file:
> 
> static void
> restore_file(
> 	FILE		*fp,
> 	uint		type)
> {
> 	char		buffer[512];
> 	char		dev[512];
> 	uint		mask;
> 	int		cnt;
> 	uint32_t	id;
> 	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
> 
> 	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
> 		if (strncmp("fs = ", buffer, 5) == 0) {
> 			/*
> 			 * Copy the device name to dev, strip off the trailing
> 			 * newline, and move on to the next line.
> 			 */
> 			strncpy(dev, buffer + 5, sizeof(dev) - 1);
> 			dev[strlen(dev) - 1] = '\0';
> 			continue;
> 		}
> 		rtbsoft = rtbhard = 0;
> 		cnt = sscanf(buffer, "%u %llu %llu %llu %llu %llu %llu\n",
> 				&id,
> 				(unsigned long long *)&bsoft,
> 				(unsigned long long *)&bhard,
> 				(unsigned long long *)&isoft,
> 				(unsigned long long *)&ihard,
> 				(unsigned long long *)&rtbsoft,
> 				(unsigned long long *)&rtbhard);
> 		if (cnt == 5 || cnt == 7) {
> 			mask = FS_DQ_ISOFT|FS_DQ_IHARD|FS_DQ_BSOFT|FS_DQ_BHARD;
> 			if (cnt == 7)
> 				mask |= FS_DQ_RTBSOFT|FS_DQ_RTBHARD;
> 			set_limits(id, type, mask, -1, dev, &bsoft, &bhard,
> 					&isoft, &ihard, &rtbsoft, &rtbhard);
> 		}
> 	}
> }
> 
> Here, we have a device string, but no open fd to it.  I could construct
> a fake fs_path object to use the xfrog_quotactl() interface, but that's
> kinda nasty so I'd rather just leave it as an xfsquotactl() site.
> 
> The second caller is makecfg_f -> get_qflags, which is added in a couple
> of patches.  That one I could just pass it through
> 
> 	mount = fs_table_lookup_mount(file->name);
> 	if (!mount) {
> 		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
> 		return 1;
> 	}
> 
> 	mount->mnt_fd = file->xfd.fd;
> 	ret = get_qflags(mount, &qflags);
> 	mount->mnt_fd = -1;
> 
> Regrettably, struct fileio in spaceman/ is private to xfs_spaceman so
> there's no general way to pass that to a libfrog function, which is why
> we have to play switcheroo games with mount->mnt_fd here.

aha

Looks good to me then
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
