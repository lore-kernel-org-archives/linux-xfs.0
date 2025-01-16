Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD6158520;
	Thu, 16 Jan 2025 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069865; cv=none; b=aR/oTCg9pFHioZg/TS4O3y2flueIbiMHEf69eRBGV8e7JPaK29suIwEiHByTrxG1tf7Vs0X1o6IL+56JX0krHvHMW9de0g0l8u6AeWsiBxc5N2Qeo2oJ3TdxvVdmMaIjStqsHCBJ7XGwU1OXDQZiHXw6Tdaq3Bn1OkU91Rs8oAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069865; c=relaxed/simple;
	bh=r/JxdK1GF5kia12URGyHrj0RmdP6clsVGUNGR5EcZ1U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaiJupROMROSaza5cfkk5AVJm6dJwh45cmikYBm+UcI/whr8GenWn6dP1IgZC+cfSNCZMSW2ErM5ABfAW6x0r+MqEL+AJqI+voSCiIF3HXz1k+D2bB6RfLVoECp7ge7snIHxZLJuQn9wE9ms4lwn1afhQTFnQdYYmQCN/ymxtsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhTljOhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhTljOhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D84C4CED6;
	Thu, 16 Jan 2025 23:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069864;
	bh=r/JxdK1GF5kia12URGyHrj0RmdP6clsVGUNGR5EcZ1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MhTljOhDca9Dr+Mqj70XPk71GuhieKTj9S/YDdJ+oTtefUFU+BjoPmRpQ66q1WEVw
	 ShoQVRojHATjeBpJNHnZXACl42+2r5+HVYHosOJEJrv26EICfhSLBfih6WJ/ouIWYH
	 Gf09OrER7CELq+ezcKBvxJCt5H+HlvDJPsqFk3sH0Jg6yuDLD8mlvgDbT8hgpiV7Gk
	 68OzOEsCT2Up60MYwJWGEsYoHOkMOvNJXWcjtzIe8V0sTuqD8O8VeQI0N8djEZpeyj
	 2vxq9Sq1cs/hHUcpz32jZXBPU/0OjCliiDbguqnVcHGmlY/aSCpdoFX6M6si4rfnoC
	 m9X3yXmJS2q0A==
Date: Thu, 16 Jan 2025 15:24:23 -0800
Subject: [PATCHSET v6.2 4/7] fstests: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975660.1928701.8344148155038133836.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Add a new regression test for xattr support of xfs protofiles.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=protofiles

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=protofiles
---
Commits in this patchset:
 * fstests: test mkfs.xfs protofiles with xattr support
---
 tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+)
 create mode 100755 tests/xfs/1937
 create mode 100644 tests/xfs/1937.out

