Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CCC368D50
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791424033; cv=none; b=cwkzVVezDt9I38t9kP/roO9BgrAcj5JFnm782r2qoUfv7orCfCb6ZVkWSQqKPBXSmiTTw//YuZ6y4gVi9uiGNyfqbIdk57BWYwbw32Xb1gGb06isrKEzcaSG9n4CJzeUT9dOUANylonMlGpGuM6ynXllSzgl4Hn0zCqhPSwAj9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791424033; c=relaxed/simple;
	bh=I3nosz+vmDV5FfbRzKE8hbg8kzT9hOZFPeJmQrm7NR0=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=VuliVlGAPAB/v5thDg7NLKeTh8bAkC86Vsbs/Ft6AqEBGqPCMLWAv97N4APY/HSO40Jv90snyS0Q4jQc4NEGT4Vsw3M5+ck89jQNDSRxNPeXlOBFkOWfl1gvSc5KLS8UpLGcLyWL9ubE/c/iQfU0hgbeZYEsn9k4E0ennM2BPGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G0PH321m; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G0PH321m"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261008014707epoutp0145901ac0c9f22844eef11d68cf2db023~caql3b0fr1692616926epoutp01r
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 01:47:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261008014707epoutp0145901ac0c9f22844eef11d68cf2db023~caql3b0fr1692616926epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791424027;
	bh=Cuh+q5LKXzLv2R0KI9enLSIgormXsfisByY542JUI0E=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=G0PH321mbWT1ZgCxqgPgD2z3aQiRa0r+Y+GZEYkVIXIVcWpdFD3q0Vk3tEpe7gYWQ
	 8AD9B3OnLg7zNrJJaLPcJrK36uE3GF9/BUkf3YR7XrT38InHeLTkdYZ8aPDJnMLngv
	 bs6sNxdlWlU2SdWxkoZJUCk9xUcymqmhBoQe3k6E=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261008014707epcas2p3463766a3d57abbe67dbf1161c4ce43c2~caqlbVyyq3083430834epcas2p3e;
	Thu,  8 Oct 2026 01:47:07 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.212]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j0Xt31Jcnz3hhTC; Thu,  8 Oct
	2026 01:47:07 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] nfsd: do not return overlapping extents in a block
 layout
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
	Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Christoph Hellwig
	<hch@lst.de>, Sergey Bashirov <sergeybashirov@gmail.com>, Carlos Maiolino
	<cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261007165101.GD2705364@frogsfrogsfrogs>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008014706epcms2p7f60dc9a1db6ca16a6fff03de67688c2e@epcms2p7>
Date: Thu, 08 Oct 2026 10:47:06 +0900
X-CMS-MailID: 20261008014706epcms2p7f60dc9a1db6ca16a6fff03de67688c2e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007165105epcas2p264fc1fd07bab1fb877a6695062f48322
References: <20261007165101.GD2705364@frogsfrogsfrogs>
	<20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
	<CGME20261007165105epcas2p264fc1fd07bab1fb877a6695062f48322@epcms2p7>

On Wed, Oct 07, 2026 at 09:51:01AM -0700, Darrick J. Wong wrote:
> Nitpicking here, but the extent could extend beyond than the requested
> @offset/@length range too, right?  Shouldn't the comment say that, since
> the header comment allows for both cases, right?

Yes, it can end past offset + length. Chuck had already applied the
patch to nfsd-testing (214e388464bf) when your reply came, so the
comment there still says "may be shorter than the requested length".

The ->map_blocks series that Christoph asked for removes that comment:

https://lore.kernel.org/r/20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com

nfsd4_block_map_extent() becomes nfsd4_block_iomap_to_extent(), which
only converts a mapping, and the ->map_blocks comment says that the
last mapping may end before or after @offset + @len.

If Chuck would rather fix it in nfsd-testing in the meantime, the
comment would read:

/*
 * Get an extent from the file system that contains offset. It may start
 * below offset and may end before or after offset + length.
 */
