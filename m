Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED815298258
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752830394; cv=none; b=rqEHujF2e2M5nF/PpyMEE1k6mqObc4krCc9sJ6q9/eXdvPJFiIFayW/tJVs8OOma3RmZ99l820UnKxrduiEK4IEjADUJTymfCz9sR7Cuk8Z3e4fykWRVDaLWOTTtjySFUnpW/StSP5Y/4N5T7IY+FqqVDzPPq55MzGogehPyncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752830394; c=relaxed/simple;
	bh=llu/EP7HgM6OHtYbwBb79o61tu0y9p6V0+YdUDrG1E8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IwfjQYJU5w3aT/VJOaBExkpM2qp0pxNCV+riUi51htDxB+lnuXQg2QUEqaP6GvyEp4E2t79pOYqQmmB4pcV/34LroUvwQppp74s2hV60I92fn8sCQMZ7qEVEz8fjq8fKGwCPJlkFVOjAb20Yty8taQHcUj22dF1JNIilZZqXLjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ii6B9fQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii6B9fQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA43EC4CEF0;
	Fri, 18 Jul 2025 09:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752830393;
	bh=llu/EP7HgM6OHtYbwBb79o61tu0y9p6V0+YdUDrG1E8=;
	h=Date:From:To:Cc:Subject:From;
	b=Ii6B9fQyS2dcxDa25vIiJD7GyEVo2nf6HDr78IyGkny150x8T+ujsNT46Uq2/BgzI
	 vj4+Uv/GFy+x16fzzGtvmvEZM1UpP+YQsra1HP5YuSao/7uCmNTZxGvZiXwXYh953A
	 INwgGtoW4s8jNNhIJOwsrfDPfCe/5Zs0C2GYrHb6WBQCWAxhH8jMEgqiG6UJ6qmsRa
	 XmhylZ9dW3Ez3ltYfMIK+ohMbQlx+EUVDnnlD9w8eF5ZjBdS2Ktqp55Oo5538rKNP9
	 oPR8UzXV7SA7cpEJM6anGDZw1Kdl2QxKZN+uk4JRtq2x92D9F6jzpLo20BmNV8pCbp
	 on2Kdos10soGQ==
Date: Fri, 18 Jul 2025 11:19:49 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: sfr@canb.auug.org.au
Subject: [ANNOUNCE] xfs-linux: for-next updated to eb1412d610aa
Message-ID: <grqvgpiyknuqk67x4dymyomj6dybvyc3dsny77ell4t7v6moqj@nrert77434eq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

eb1412d610aa Merge branch 'xfs-6.17-merge' into for-next

2 new commits:

Alan Huang (1):
      [414d21d65b8e] xfs: Remove unused label in xfs_dax_notify_dev_failure

Carlos Maiolino (1):
      [eb1412d610aa] Merge branch 'xfs-6.17-merge' into for-next

Code Diffstat:

 fs/xfs/xfs_notify_failure.c | 1 -
 1 file changed, 1 deletion(-)
