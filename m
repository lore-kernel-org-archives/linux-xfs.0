Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7353D3D1D
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488935; cv=none; b=ipf5K1lihpRB+5+kIuFBKs4kgJhYv5hQwcCIOCq2s7u6HYaWrPNmv9EPHqc68oV9nLBKgqCPmflz0eOn7HOVsKJP0pUMYFN50uDZBffx8eQlEFeOST2gGswHGYbbb/bRuS55x7ox+P0WdN+SW6ZdQVlkQlxbUxpV/6w+8f18cIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488935; c=relaxed/simple;
	bh=i6yGLwOhkSeHNsLf99sE0i3z1xwRvkNB9dpojaTQYfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksZNqj1SZtzQD7ZNgI4X82S9AHAFcayO8mlg0U2HBctPIxyLiaQ0KiG028ZzfWnCUQaL8QiPfP5xYWS+1WwPzJekP4LRPfclL3fFHK1ru1YfwqAQVBoe3eRkQ1Q1dYB+BISZMyRNEP5k1saiPJ22Bm1iybj/+dglnVQ84cw5+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekzoJFOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekzoJFOE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C0E0C1F000FF;
	Tue, 15 Sep 2026 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789488933;
	bh=Gvxj2abD/nEnzWy13lXpsvt0Vadx5WBjS3wTIiNyY/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ekzoJFOELnobKxt/XcJiln1pfm8KjqulSHBOMGqKjck+C3AGB8BDVP4MCi4dthADQ
	 OXwyJeV/14NGdk5TbM0ytsJV6L1mmuZ0Qm0DVqlDvsy3oePqBwrPqdbz3cI4mpeNV0
	 YuYCMiZ6ky5hAWWUSAsgT4XM5wnq+rozvmwc3GFyX7ohN57+CiYFkyBxdm70svLIQC
	 3Bm77y6drzTVMhk4T6wKexDhMa3zCd5YJMgochuMXQsnPpD+Rj/5PgsIpzQLkXiF0H
	 GLKWdW4jL/T0PaeJoB25xMK7KxJOI6bJspE1xDoIXgzfr4NIO4hU3dPwOindIIKTdo
	 Ec/b9UDQiLQxw==
Date: Tue, 15 Sep 2026 09:15:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libfrog: try to pass struct fs_path objects to
 quotactl wrapper
Message-ID: <20260915161533.GD2705364@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>
 <aqkeeAgNLMFFqgcl@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aqk5gM82hhqq-Upd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqk5gM82hhqq-Upd@infradead.org>

On Tue, Sep 15, 2026 at 05:26:40AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 15, 2026 at 12:34:33PM +0200, Andrey Albershteyn wrote:
> > > +	const struct fs_path	*mount,
> > > +	enum xfs_quota_cmd	xcommand,
> > > +	uint			xtype,
> > > +	uint			id,
> > > +	void			*addr)
> > > +{
> > > +	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);
> > 
> > The xfsquotactl() can be unfolded here and calls may be replaced
> > with xfrog_quotactl(), no?
> 
> Yeah, looks like we should be able to kill it.  But maybe do that
> as a follow on cleanup?

Hrm.  There are two xfsquotactl() callers remaining after this patch.
One of them is set_limits() in quota/edit.c.  One of the callers of
set_limits is limit_f, which could very well pass through the fs_path
like everywhere else:

	set_limits(id, type, mask, fs_path->mnt_fd, fs_path->fs_name,
		   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);

Obviously a good candidate for passing the fs_path instead of the raw
pieces.

The other set_limits caller is restore_file:

static void
restore_file(
	FILE		*fp,
	uint		type)
{
	char		buffer[512];
	char		dev[512];
	uint		mask;
	int		cnt;
	uint32_t	id;
	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;

	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
		if (strncmp("fs = ", buffer, 5) == 0) {
			/*
			 * Copy the device name to dev, strip off the trailing
			 * newline, and move on to the next line.
			 */
			strncpy(dev, buffer + 5, sizeof(dev) - 1);
			dev[strlen(dev) - 1] = '\0';
			continue;
		}
		rtbsoft = rtbhard = 0;
		cnt = sscanf(buffer, "%u %llu %llu %llu %llu %llu %llu\n",
				&id,
				(unsigned long long *)&bsoft,
				(unsigned long long *)&bhard,
				(unsigned long long *)&isoft,
				(unsigned long long *)&ihard,
				(unsigned long long *)&rtbsoft,
				(unsigned long long *)&rtbhard);
		if (cnt == 5 || cnt == 7) {
			mask = FS_DQ_ISOFT|FS_DQ_IHARD|FS_DQ_BSOFT|FS_DQ_BHARD;
			if (cnt == 7)
				mask |= FS_DQ_RTBSOFT|FS_DQ_RTBHARD;
			set_limits(id, type, mask, -1, dev, &bsoft, &bhard,
					&isoft, &ihard, &rtbsoft, &rtbhard);
		}
	}
}

Here, we have a device string, but no open fd to it.  I could construct
a fake fs_path object to use the xfrog_quotactl() interface, but that's
kinda nasty so I'd rather just leave it as an xfsquotactl() site.

The second caller is makecfg_f -> get_qflags, which is added in a couple
of patches.  That one I could just pass it through

	mount = fs_table_lookup_mount(file->name);
	if (!mount) {
		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
		return 1;
	}

	mount->mnt_fd = file->xfd.fd;
	ret = get_qflags(mount, &qflags);
	mount->mnt_fd = -1;

Regrettably, struct fileio in spaceman/ is private to xfs_spaceman so
there's no general way to pass that to a libfrog function, which is why
we have to play switcheroo games with mount->mnt_fd here.

--D
