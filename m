Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD1573477;
	Tue,  6 Aug 2024 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968094; cv=none; b=EXtVnEx8ESvaCqk5S4pRQkwZzOqchAdC9KN4XJEL3zztu9VS6mMxq4Mf+RRiPHV1EuyYbPErnQA542h1Lvahi5vHqEJVs/g0XqRbHUwrbL5uonOkkt9r+w7uajUBju4olFFfe1KHNXFtfWzyjj9y9MvpfXjrwMr1yk6+w8p9d/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968094; c=relaxed/simple;
	bh=EafS5SuqYQY4DXp6Cq17uteGy95lkLRq6kEkyV/M2iM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=McgkfE9ucto4FoIELsu3TUq/ztwqw0Du5XNps2v0NE5wAmGAyjR4S6OwbBL8YyH6o7paHJWdhCLOvaojgyjTgDTXMn+BX1T0X8f9LyElLs1xLQMrbkaVsECAwuK17rTn6nH8nv0qxRm76rreyP5WhKjPmRXNAkoMEhZ8k+MWSaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AyhW+Gr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyhW+Gr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B8FC32786;
	Tue,  6 Aug 2024 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968093;
	bh=EafS5SuqYQY4DXp6Cq17uteGy95lkLRq6kEkyV/M2iM=;
	h=Date:From:To:Cc:Subject:From;
	b=AyhW+Gr9j/J0klk8WMCj0UtZWk8YQvz9xTY7dXv87q8Cpo7SdKPS+QxJl6aaWbARv
	 Sb0Uk6bP/WZ+G+FavfLDesbklbdjPYp8+eb84L/6SBWqx8C8uFRchbbWgc3tWJkcqA
	 8RZxtSpq+NReqjzWN3HYiz5gQi9qj3V2XyJFDzZvR98tXWQpVMmWWy/mrpDbVIVaG+
	 t8ZCgEL3h0bMYaO8bamBzXy4LXc5clJVA81+bnzzprnEUWudo+/4bVjCPw+jkzQur5
	 fGwQ7VER5OOTF4a9H0LNeJ4Z77b4OR+lq+PrjJJIl21Kq0Ig/5eH+I7CKh105MgP06
	 Q0l1Meb41U4yQ==
Date: Tue, 6 Aug 2024 11:14:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCHBOMB v30.10] xfsprogs-6.10: filesystem properties
Message-ID: <20240806181452.GE623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

After recent discussions about how to allow sysadmins to opt in or out
of automatick fsck for XFS[1][2], I now have a patchset for xfsprogs
6.10 that implements the filesystem properties that we talked about.

As a refresher, the design I settled on is to add ATTR_ROOT (aka
"trusted") xattrs to the root directory.  ATTR_ROOT xattrs can only be
accessed by processes with CAP_SYS_ADMIN, so unprivileged userspace
can't mess with the sysadmin's configured preferences.

I decided that all fs properties should have "xfs:" in the name to make
them look distinct, and defined "trusted.xfs:autofsck" as the property
that controls the behavior of automatic fsck.  There's a new wrapper
program "xfs_property" that one can use to administer the properties.
xfs_scrub{,bed} uses the property; and mkfs.xfs can set it for you at
format time.

# mkfs.xfs -m autofsck /dev/sda

# xfs_property /dev/sda get autofsck
repair

# mount /dev/sda /mnt

# xfs_property /mnt set autofsck=check

# xfs_scrub -o autofsck /mnt
Info: /mnt: Checking per autofsck directive.

--D

[1] https://lore.kernel.org/linux-xfs/20240724213852.GA612460@frogsfrogsfrogs/
[2] https://lore.kernel.org/linux-xfs/20240730031030.GA6333@frogsfrogsfrogs/
