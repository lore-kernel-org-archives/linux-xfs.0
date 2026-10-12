Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4F4388E61
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791773529; cv=none; b=GFj1CGiBj+sQMPLrXWPJCqzA81fB1+CyYoZpckZnJObdF4LyrdIIMeo4PTTthND5SQmTxyB59vG08QXQQ5+jtPcxYOPZeU2a/yZiUII2XvE4xrnVwMqLMN89iQpsIFZaTQe9HK+a380aPWm5pxz3vmg1LG960MwRQ9snTIFhuNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791773529; c=relaxed/simple;
	bh=+RnKcGIJ6G/VhbRqdt/Bc2gRi+Za13jvUFodR/Krc4I=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=VJ7L/AygeHQWWhaFMDLy467+44L1zk+WaTXtXkIDf2/ttf+pKfACwggDlHSI+njOCptdckf8wd+aCfwz3g5wg35k4XiNrt5qLNZsv1GO1ST3ROzEn5qqRTx4eO6pxTKjU6oQRNfAvpECJbfCl687QsGlLyzM0WydwNQLL3D1zLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=s5sw5q3O; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="s5sw5q3O"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261012025206epoutp03e688b108b9916eca49615fa658cab2d8~dqIeOJKIC1458114581epoutp03k
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:52:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261012025206epoutp03e688b108b9916eca49615fa658cab2d8~dqIeOJKIC1458114581epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791773526;
	bh=+RnKcGIJ6G/VhbRqdt/Bc2gRi+Za13jvUFodR/Krc4I=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=s5sw5q3Osg3mDz9lFSGn+NPOyx2lWPhSmhKes4yADIBg9gE+Sn8YD5B5MupfD5e6j
	 YUEhI/udWZeN2yH7b8eMlF+w+xoI7XmTEpLmGX4E7E3CR/YgK7kjZ8cMlmiyxDU59+
	 +4tdVyb2Y1ITrl7qig1/AKq9cjgCst/ccCP94yS0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261012025206epcas2p102b727ce702f793063d25dd96cf972cd~dqIdzYhFL0573505735epcas2p1P;
	Mon, 12 Oct 2026 02:52:06 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.204]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j327B0zy4z6B9mD; Mon, 12 Oct
	2026 02:52:06 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) (2) [PATCH] nfsd: do not return overlapping extents in a
 block layout
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Chuck Lever <cel@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
CC: Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga
	Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Christoph Hellwig <hch@lst.de>, Sergey Bashirov
	<sergeybashirov@gmail.com>, Carlos Maiolino <cem@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e80265ff-322b-4a52-ba51-393e3e4f503e@app.fastmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261012025205epcms2p7f506779d61fc0b40561296ef119be2e0@epcms2p7>
Date: Mon, 12 Oct 2026 11:52:05 +0900
X-CMS-MailID: 20261012025205epcms2p7f506779d61fc0b40561296ef119be2e0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007165105epcas2p264fc1fd07bab1fb877a6695062f48322
References: <e80265ff-322b-4a52-ba51-393e3e4f503e@app.fastmail.com>
	<20261007165101.GD2705364@frogsfrogsfrogs>
	<20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
	<20261008014706epcms2p7f60dc9a1db6ca16a6fff03de67688c2e@epcms2p7>
	<CGME20261007165105epcas2p264fc1fd07bab1fb877a6695062f48322@epcms2p7>

On Thu, Oct 8, 2026 at 10:14 AM, Chuck Lever wrote:
> I don't quite understand the logistics / ordering, as it appears to
> invite a conflict depending on which tree the ->map_blocks series
> goes through.

The comment as you updated it in nfsd-testing (now 170b788af22d) is
fine, nothing more is needed there.

The ->map_blocks series will not go in on top of the current trees.
Patch 1 is in xfs for-next (e3c682dd1130) and patch 8 builds on
170b788af22d, so I will post patches 4 to 8 again after the merge
window, rebased on -rc1, when both are in mainline. The series then
applies to mainline alone and does not depend on nfsd-testing or xfs
for-next. Details are in my reply to patch 8.
