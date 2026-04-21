Received: from out198-158.us.a.mail.aliyun.com (out198-158.us.a.mail.aliyun.com [47.90.198.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A61E5201
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 03:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776743035; cv=none; b=eVPnIK06JgQ3iRtM24MwSUW5OhCVfOFOtQNh3eEuShMSn2X2nGm5S6qUXX7eEO7wDWUsrF0aRiPeWh4qjEo9Z62cNgPHxgyQahBQ3mfSR0I7NYCEm6aMF1yfks38GkLZ3Js0tdqG0nra2acUEdEpUSyFFghlM14nxepgdXwc5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776743035; c=relaxed/simple;
	bh=EIpZ5t+682oxVS1Ab/6K4dYedOo8C4jjZM0+HjYhxHY=;
	h=Date:From:To:Subject:Message-Id:MIME-Version:Content-Type; b=sRpbsyp5b7w6U8v7OmcfES79QVRiC+t9LOD4JlRpT1cU4Tvaiae5HxEOQ73FlCi8/RoU2SmTSH1agmvgRX37aJhA8BezYI3Ds50abquf60kXE/GOkeETNPuEeUmGtO1meuQ7e31e459H86CTv55CbNCxWzfc0QptYED1HgnsvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1554804|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.416355-0.000493095-0.583152;FP=15303241426177611678|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037017159;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.hGWixJ-_1776735723;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.hGWixJ-_1776735723 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 09:42:04 +0800
Date: Tue, 21 Apr 2026 09:42:05 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-xfs@vger.kernel.org
Subject: 4K inode support on 4Kn device
Message-Id: <20260421094204.A743.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.02 [en]

Hi,

I want to support 4K inode on 4Kn device.

1,  change the size of XFS_DINODE_MAX_SIZE/XFS_DINODE_MAX_LOG
     to 4096/12 from 2048/11.

2, do we need to keep the following restriction in man mkfs.xfs?
    the inode size cannot exceed one half of the filesystem block size.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/04/21


