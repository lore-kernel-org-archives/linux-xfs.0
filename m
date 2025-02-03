Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A6D1DDC1B;
	Mon,  3 Feb 2025 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738567847; cv=none; b=ELSAUYZpuh3z3jBmO0Yg77/yPK+uNSraVIK1bMqgjwTNSRQ6mZxG9gYkWNc4cXWNkTXPYGFnKCDV1OPCdDkVbCqy94ZKtS3ibaN9S5ZcXV4sC7Kkp3vO/frbHPUdDgayB3I6eWq7qO4p7dQPsWTOz/ZqHu7iQR2IFwZ6itRekio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738567847; c=relaxed/simple;
	bh=+84KAU71l+vPxfca6Ksq66ND/tzsmeMZFvRT+gDYb2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsE6uZAmBxqrDpREIoYAli0jjafUZiOB17PO2xkoyhHUtXneSEMxzctyfxZ1g4JMFdz+Itx8blFG7ogIRsWyUyqR3yWQqQFA/4tw6Q69U/UigiAdwt3kBgONaogIdtrrrAsj8++EU+iYtUmGP7MpKnDOJIil++xkomyVt7nIC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C0DD68D13; Mon,  3 Feb 2025 08:30:39 +0100 (CET)
Date: Mon, 3 Feb 2025 08:30:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
Message-ID: <20250203073038.GA17805@lst.de>
References: <6798b182.050a0220.ac840.0248.GAE@google.com> <679f8a53.050a0220.d7c5a.0070.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <679f8a53.050a0220.d7c5a.0070.GAE@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

#syz test https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/ for-next

