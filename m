Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14499A55
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666592; cv=none; b=bG0HDqcX2muRBq0WgTgecOIgjvdegnk8wktwx5Nj3kQCWQo4QJoEJYslrm4QkjJJ/ClHr6+GILT/7n7oirwW026pz/NzvQILLRgIUtbOHL6RMpnP/YWp7ziiKmqBPLvkPQvKbKtlU80GKR0hqYqOnL2sLcx5/Q7oLpFSTHfZD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666592; c=relaxed/simple;
	bh=x7t/CYInymbOGkH9EdcvXt6yiXR+EEaLvNVwdd4xvzk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XrSFpjC5C2EQIqLjMYNpNVTwx+YYjwgujT/N6ajjmMvWX2SSMcT9Kslpx7jPrQ6fwKPMPXaoOt/TE7q7djS3tabtjIpENxUTYguolcAht9mQzfmojQUcnYqQzsNzVvCrsGh8sHK/QgCrb8Hgmr7GwPt6s7/Rk91Sf2nlVQ7dybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIjUdA/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIjUdA/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA0AC4CED0
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666591;
	bh=x7t/CYInymbOGkH9EdcvXt6yiXR+EEaLvNVwdd4xvzk=;
	h=Date:From:To:Subject:From;
	b=VIjUdA/Iq9+daY8OsH97fg6GWJBJAYJgTE3SWmtbIKodZa8C9Dz/WnHWbkK0G9KW1
	 7ndHViPMCQl8hDgVvLUmREGI+RDhZvtd0L2fhFg/Rtz4VEajv5xpbbOQtVYwRdjfVx
	 npm7AGrHUOSIHCS/PFW3KLDcuUsbcFPqLPKkUaJmEYl9tMHFpBXnFFJfRqIS2Sa5X8
	 IJUxlgGM7a9uLExj/5F55IOlejM+4rZBmJC1mLJfN03q8Stq44eyCT/PjTOEmP3uy0
	 fROYJYODqZOFvoK3d63qbJlUfxYIR2Vx1fa/HRfWrIbqRF3ybNeKWwn/HWiO/IDIoM
	 YUSgHyrPMgiPw==
Date: Tue, 26 Nov 2024 16:16:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfs-documentation: updates for 6.13
Message-ID: <20241127001630.GQ9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

Here's all the changes I have staged for the ondisk documentation for
Linux 6.13.  I'm reposting the patches along with a pull request and
will do a release immediately afterwards.

--D
