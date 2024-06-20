Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79713E8AE
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718923834; cv=none; b=aO+q4Fwlon7xXbQB44Ii3S0PdEXPuA54gAf/IBpfZEKiwYZopsWU5IaR8lZsLcy4tPOm0fGsgW5BGQ1ING05604JW+rpmv5lHQIS/HhPe5Y0XChUVLwnfUsXEGUMV7dPtFfoqZqtYxl6Kx9HQij2FSLAbRQykEypLMNMJya3EAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718923834; c=relaxed/simple;
	bh=4RId6w2oAYtpIQZdbaiKUi3dcDpGACIgaLH69iDy+nk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uc1D6o3NCxYbEsJSGh9ajBjx7bUxs0iHZEkYcqOn+xzH2zTuVJ9COCpcw4nfl4odtSQpfBOxfcrSBRRC5+K30cN+xbeX511ohAHMujPoUa0+5pzl54U54qc5JmAw33F6w5Tw+YWL0eNQx+tsLhH+YEOtXdW7NmUbcaTQGx0zZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DF2LvAuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DF2LvAuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CB5C32781;
	Thu, 20 Jun 2024 22:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718923833;
	bh=4RId6w2oAYtpIQZdbaiKUi3dcDpGACIgaLH69iDy+nk=;
	h=Date:From:To:Cc:Subject:From;
	b=DF2LvAuyy/cuou8OeO2M/y4vNdRwLLmMcUWvc+vmzzyyJEB65wLOK4eV83pHt3bOq
	 U3Zb8Z6HJ+Je1uSN6Wq0UC77yEXbQznnSAm+QIiIS9OeGsGYZebG6cUgwwElougTa3
	 jPPnm0qvTd3S+MeyS53nrT+S9q0iN1vHCHoSigkm5DKj8OQct0OAWreHbF5yvwRMSV
	 WpPR8h+XQCaCM/eZsczbSZsuD5VrH793w5dMDkGlDm70wHo6eIPlKaK8KzrSQ0UrfQ
	 N3Z1WiGpFe6ohhYOjNkDtJ3eWnL+ACZ9nW6DrLW5eQZyiRJH2J+xJu5McwBklbgit/
	 /YnXC6VzrE+uQ==
Date: Thu, 20 Jun 2024 15:50:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB 6.11] xfs: inode cleanups for metadata directories
Message-ID: <20240620225033.GD103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

For 6.11, here's a pile of cleanups for inode creation, directory
handling, and log intent item processing.  The icreate/dir cleanups are
needed for metadata directories, and the log intent cleanups are for
adding rmap and reflink to the realtime volume.

The very last patch in the entire patchbomb implements FITRIM for the
realtime volume because a user asked.

FWIW, rt modernization are deferred to a future kernel release because
recovering from LSFMM took a while and then there have been a lot of
stability problems with 6.10.  The last of /those/ fixes will be sent as
a separate series after this patchbomb and really ought to get in before
6.10 finalizes.

--D
