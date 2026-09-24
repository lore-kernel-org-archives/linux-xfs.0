Received: from mta-101a.earthlink-vadesecure.net (mta-101b.earthlink-vadesecure.net [51.81.61.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507343A7F62;
	Thu, 24 Sep 2026 21:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.61.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790285123; cv=none; b=F7abqY/WRcEWs8BvEO7iUgC3lN77jlwa91i6l7SoUzdAGKzx4lPhMB6fPMjSnaJ47Hg58lPAHtuJ/bbG1mh5csLPxtbN8tnTUb6WjpYZF8oRWIqsQJ0eybXPYs+Qgzlc536vXs7OqQNztbeByem88VLbaXbcagXuMUc/sFH7Uqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790285123; c=relaxed/simple;
	bh=DxCx3we6ZjEK4UXm1yjCug7ohEPFNqgc11uCqEFmFq4=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=b5u/nDUwObmwZTMz5A+Y2n62MzB/UTrePMxTWJWVMUrjr9Mx1LMSJpddhREZ7c0ipdzoMkBpV6XRhMa0JqLF38WLOS1o3CdEMfAQeWPHaSuzjXs+77OWsl2Aru4frdW0/FA5PJg83L7Rt717ImKXqqNl9rrkwwxwLO8oxqzKmUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b=rf4vu/+l; arc=none smtp.client-ip=51.81.61.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b="rf4vu/+l"
DKIM-Signature: v=1; a=rsa-sha256; bh=6XTHg8xlOhcXzepC7o7MZKfFwE5+WFjVghW5FZ
 jd9GE=; c=relaxed/relaxed; d=earthlink.net; h=from:reply-to:subject:
 date:to:cc:resent-date:resent-from:resent-to:resent-cc:in-reply-to:
 references:list-id:list-help:list-unsubscribe:list-unsubscribe-post:
 list-subscribe:list-post:list-owner:list-archive; q=dns/txt;
 s=dk12062016; t=1790285118; x=1790889918; b=rf4vu/+lTT6w+4qxhmjP5MDBi2N
 wVZp51F4RdR0cESK8qsnS9qEhmNNLdEYm3l5Xsfuc8/AEyg4ylKkvElppr2FnPfu1IyTLO9
 1r3oxisZ8ovsZLmUdxxjDefreDwbtbc3BZm/2ihZ8ftsbdM1+UDHPZ5NeHrdboTEY22Edlf
 AUbpziYH1BRb8493mdazgO0uGFE2x72455z7PhSEq+QxNI99yTfzwCwt31lkzBESF0KFf4C
 7a9WxAI/y0LI6dmiA2GiV4WM4mPFR9JgJwzQ0O0TXeutthd+lCnQH9Gh25HDzxE3VXopJBJ
 DUC1cvlAf8Jh7G2GfYhSGSU3Tyrl7JQ==
Received: from smtpclient.apple ([47.219.251.75])
 by vsel1nmtao01p.internal.vadesecure.com with ngmta
 id 5a1004f9-18d85ed44749f0a2; Thu, 24 Sep 2026 21:25:18 +0000
From: Steve Shoecraft <spshoecraft@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-Id: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
Date: Thu, 24 Sep 2026 16:25:06 -0500
Cc: linux-xfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)


I asked claude code for an email body and this is what It said:

  MXFS is a Linux shared-disk clustered filesystem derived from XFS: several
  nodes mount the same block device read/write, with distributed locking,
  cache coherency, fencing (SCSI persistent reservations) and journal
  recovery of failed nodes.

  It is built as an out-of-tree module. The xfs/ tree is XFS forked from the
  6.19 development cycle and heavily modified, plus a coordination overlay,
  a DLM and a platform layer; it is not a patch series against upstream.

  The code was written by an AI coding agent (Anthropic's Claude Code),
  directed by me; I have not reviewed it line by line. The README states
  this at the top.

  The released configuration is two nodes over the TCP DLM transport,
  verified on specific kernels (Ubuntu 24.04 6.8, Proxmox VE 9 6.17/7.0,
  RHEL 9.8), and it passes the project's two-node test suite. Other
  configurations (more nodes, a disk-based lock transport) are in
  development. Open defects, with their evidence, are tracked publicly in
  the repository (data/defects.json).

  I am not proposing upstream inclusion. I am looking for review from
  filesystem and XFS developers, especially of the locking, coherency and
  recovery design, and of where it diverges from XFS's assumptions.

  https://github.com/sshoecraft/mxfs

