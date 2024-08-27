Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE292564;
	Tue, 27 Aug 2024 02:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724724435; cv=none; b=pYktSyCRDZ2zZ74Rg9UzEqbCYQbqS3qQ3g8K1chWPTytTY0/oLi34ulKwmabY3NFOSX25pvkDUJYt7MHo1DqkLu++msIj/m7jJmzoMLFB5ApKE9C7aErmHgDOzrBeGv8HvUz7RKVnHF4QG7gQ04zXjY66sJwD5hoNjw1RQfYAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724724435; c=relaxed/simple;
	bh=yti5Dmsx71eJ4gRGPl5AGlOBKijTJ/+gS3s99xB3Ofc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NrKzsNacaWPdpFyMblRGSMGAqyAK1ThRtsi6psuKq1IVxyDqP8f6KAh1uAD/bum6d/ZHRNdAZwgtDMWW9D8bomQLSmV2Uw9uGJh7oKrsWNmu8xi0ZEthi4MNjWQ5HFA3ubBYeOD7Pain2R6d+g4EWoSXC1QrJe1HfdBinb7M5xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIWDJQb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIWDJQb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AECC8B7A4;
	Tue, 27 Aug 2024 02:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724724435;
	bh=yti5Dmsx71eJ4gRGPl5AGlOBKijTJ/+gS3s99xB3Ofc=;
	h=Date:From:To:Cc:Subject:From;
	b=bIWDJQb0+fVUA86niC7b1g0XbNaRYLTRE/xoaiHobc8pWNqBWce10MYyzZC3SDzVo
	 QCFQX+eva9ydzmzih+GphepVYDF8eEQ+SnVdaU76DkRre41dY1eBQE3wrpAXbtkbVl
	 P7euIcIBjSUtQUSeiIASmR58B2LCe4NLjv/hyXv/riCPxf5vHQHVhiqdSqW3oxs+5v
	 3RoRHo8amOA4OzqqQYFMc8swps+i3qbxHT7ePzKn0G5aio5MA7lUY8v4Zh2l9kfLgN
	 FtTQd4Wf9CU+dXcKl7tlkf6B6pp9mpFXqMpQPU4mmCeIIzEobYdZ0E3YGOyrcdeZrM
	 gD7FwAFNMATGg==
Date: Mon, 26 Aug 2024 19:07:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: regression on generic/351 in 6.11-rc5?
Message-ID: <20240827020714.GK6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Has anyone else noticed the following regression in generic/351 between
6.11-rc4 and -rc5?

--- /tmp/fstests/tests/generic/351.out	2024-02-28 16:20:24.224889046 -0800
+++ /var/tmp/fstests/generic/351.out.bad	2024-08-26 00:03:35.701439178 -0700
@@ -25,7 +25,7 @@ b83f9394092e15bdcda585cd8e776dc6  SCSI_D
 Destroy device
 Create w/o unmap or writesame and format
 Zero punch, no fallback available
-fallocate: Operation not supported
+fallocate: Remote I/O error
 Zero range, write fallback
 Check contents
 0fc6bc93cd0cd97e3cde5ea39ea1185d  SCSI_DEBUG_DEV

Just speculating here, but seeing as that test messes with lbpme in
scsi-debug, that this might be a result of this patch:

https://lore.kernel.org/all/20240817005325.3319384-1-martin.petersen@oracle.com/

Will bisect in the morning...

--D
