Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07EF22C6E8
	for <linux-xfs@vger.kernel.org>; Mon,  9 Dec 2024 08:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733066; cv=none; b=bmlUfoBc3Wu3IxHqqVqb8JULTGspbiUHQulSZqPYQPJgkw1P5ZrmBYAIiWdjLDPnE7Nz5z2HMgxChcZ+fTXnmx2MOltqKsZ/DCP60J8ZIEz2GvGeipETdp0G9FQWIBe+TtNv2HOfgtYrVJrzQggwpr/hCSIHYp3CXWm/zhPp0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733066; c=relaxed/simple;
	bh=geDEKNfI34RxBXuR+ORaJ0c4Lil6FRS/CtO4SsouXFg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rFpEjhzNAmYUJGrhHbCfiKXjwe6F9RJh4XhbednuFUzV+oJqwl7rmI1KrfWDjrxFGrZ+RBeBEwoRFKxembik2ulKWKeKsoO/jUrt+lUWRE1IN7893OhEWb0p+wPXd4IvSwKgm7P2KRd90EKnS5JjCq14KrFxPvLg5Wz+SHS2FYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqNFsrx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqNFsrx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945DCC4CED1
	for <linux-xfs@vger.kernel.org>; Mon,  9 Dec 2024 08:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733733065;
	bh=geDEKNfI34RxBXuR+ORaJ0c4Lil6FRS/CtO4SsouXFg=;
	h=Date:From:To:Subject:From;
	b=DqNFsrx6ZgsPybul4etQYaHH1SvA4YU4B+a81wr4vellUM/g/p5c3sAG2Gd72Wx3V
	 yaqa7JtUUEfBP85OQPPk+btT1ILF890lQRGIGEzK+oVheNItisphnVDfeaJjsXEaVW
	 zohgFKCpjRCCouW9hkA2c/DbLPx5inJowaTKrxR5zB/JXFvHrMPEPmq12jZ2U8YESL
	 4DekKCuVSvUGxympTxtjdKp2G6PYXNg49XmMsl5yl5TArTxmRbfMaclAqTUX4lmjIU
	 3GKCVbHViCoZdzFPwmdAsNng3s6oy1bndiWDO7hFgib+zaTMlFGWEuNYLeSF3ygiws
	 e5SF6tu2Zflow==
Date: Mon, 9 Dec 2024 09:31:01 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: xfs-linux: for-next updated to fac04efc5c79 (v6.13-rc2)
Message-ID: <fnsup2me2h27gu3eijx3kqesc44zrbcakynsnr62wdwiqpkuqa@a3thmywdgal2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

this is a quick heads up that the for-next branch located at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

Has been updated to:

fac04efc5c79 Linux 6.13-rc2


This update just synchronizes for-next to Linux 6.13-rc2.

Any questions, let me know.

Carlos
