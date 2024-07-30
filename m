Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003976AA7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303387; cv=none; b=ptCTQjL39jsX5UGEDj/NcazqAh7gxUJ+7W7UGBcZEl2+vZ3upm85CKUfYhsgPBLi/uV56d6hA7V0WV5kT8l/wdmGFmVtiWkbYYw1cJt3db1hm8PZvQhT1Vd3M/XktuwjdZjz7kEOP9OW2yAO5KERD3yProlNiK+JnpG5jseizxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303387; c=relaxed/simple;
	bh=ZJZi/pOOb3IAMbS+3fmhZUYtpxm+dtZuy/UyoawlScM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N2PKacvndzYYSG7uKEwCQSvrdR0UebPp1Ek7/SLPGsgqtg1+KChB/8Qt2013VR6NDFfWlEp09C9FKNJ4RMETuig12CJ9iYWGIT3rvHQNeE4Etcb3/35PPUzPWZC/OJ8NZAprrTUa2gIe/bw+VfVAwG8USZK5QIU9Y648tNhnkt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwCKRwCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwCKRwCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB82DC32786;
	Tue, 30 Jul 2024 01:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303386;
	bh=ZJZi/pOOb3IAMbS+3fmhZUYtpxm+dtZuy/UyoawlScM=;
	h=Date:From:To:Cc:Subject:From;
	b=CwCKRwCcC7hsIoPrZ9LHZnMrC9QAHKxejNDSn/jXTqCObxTZDyEAPiJ70eqppuFRP
	 /xfkHvXJfnXnHlU49MPbO65+9ZDiNSkw2RQuQvSeBJwKZ8cGxbWmGE3enfMkEBPcbZ
	 TPb78UdFc9fnfwaIdfPWsjk0GCXsKnd44cUOpHiCXsNvv7TnvHikfodE3PLdL1iTHF
	 LTO0LJuqFD6E/uF1IUYuOGnbYPOcFDMMRzrb5EzoUf/OcxH1i6ftVyUAP7Se3Nygbu
	 EhGNRc0Zeu7d4qMzmgRWXzFmShsSLOsRGoxRrcHyp5rKIZU10BZJuc+cwgiNMqvg55
	 qxxTF+kgK/vxQ==
Date: Mon, 29 Jul 2024 18:36:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULLBOMB] xfsprogs: catch us up to 6.10
Message-ID: <20240730013626.GF6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please pull these fully reviewed patchsets for xfsprogs 6.10.

--D
