Received: from slategray.cherry.relay.mailchannels.net (slategray.cherry.relay.mailchannels.net [23.83.223.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0AE5644E
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723750812; cv=pass; b=Ua1VH9fqxTYYoYgjS5QBqIUDZXY8+TMnhiw5oRYRoc02eFUUMTx+qK3M0IUkr+4Wp7xWi3/Dfj300YkazG1DFKisE2CadFwMskI48mfdwuF8vCY8ilDdAS4dHT3zxQ+X19AHJsz5I0yTi0Y/90uozOLUVLi6wvDQnF/M9nQoaBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723750812; c=relaxed/simple;
	bh=DYv0XX5TH/96rVPN7kpkY+c8IJDR1Wxw81yxlCaYMZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZ+YkeWrc3B4OU0Tf7qdORu7ZrNUNqvR7CSrVPqWB3G3NaOSTEihxqhTZNtl9PGm45cV2lFl1w68zT5xLcljdcD6dsEyEcT8Y64Db0H7MnTcLP0naXdjbIlfsgW6m/YZBwqAnnZ7SvmwdMSMJ+8IYfsXuB5di4bwxfjv0rBVyJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=qLH8BhP1; arc=pass smtp.client-ip=23.83.223.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="qLH8BhP1"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A11586C4D78
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:40:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 525E66C4CBA
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:40:09 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750809; a=rsa-sha256;
	cv=none;
	b=jzYUNg/UxhfMn/RyOgnXhCoI2VSP+yDf2rNNVN9hwSlgO3Ek+Fl2wE5PwAdgrwm/CoNdcu
	Ig3PzvbOSNPSx8Z7Anc3p/9E74/LCIcc/FHdy7udduux5eoAqKuT/lswiizxpj7FX+OE+K
	MpWVTnOJ/jlGh6jw4UclBQwJizT8i4l99X55aePVg3eY9Uy7WH0DtAhm+qOo46qbBTCEVS
	Sln5V1r/raqdEyVw5g9xoH4/xPlN0spkeraQmsyOBnnl+OqDSgOZ/AxE/Ua5s8PjzqDTw8
	HISfoEtZoKXS4WRW1iIstfFWrUpDH1Gj7jafxNFvRhtHFBpRcRksO5eAFIT5BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcTxIWGPeu1R01B3vemkbii6+5znxxejEkyXOzhEKmU=;
	b=Ejl/gwvr34ZjhsibdSpe6gnxSKkoEQtCiIJ320UfHEIET8Pc1rQAeonM7MyLeXn/g3NaRo
	x5CWa7f+AvYoUhJA3gIJuhtrj5uN2A3LtC7EhfZhSXDRXOkx7adgRsrsL8sCUm7BsHuX1Q
	AI/1y8TvVzZP3ZcEVgCRNfQ1+oe2B01/VDQqkkt+RP/y8d76Ygdqm0F/cr3yj7boq9Qjhh
	uHGwYSjrt8tNrLg+W3pCLx8bQooLJUuH5CcsOGS6kNbgCFswUIW/ZPI2BZNRmphzlCv7rf
	Zb7RchNbsjg+twIp/FjqhNmmry0TY9eOOmSpkep2SlyqynmQHsmA6e+/9VDm1A==
ARC-Authentication-Results: i=1;
	rspamd-c4b59d8dc-cwtkn;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Cellar-Dime: 4d72dcdf2c45c112_1723750809553_675905780
X-MC-Loop-Signature: 1723750809553:551450302
X-MC-Ingress-Time: 1723750809552
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.208.81 (trex/7.0.2);
	Thu, 15 Aug 2024 19:40:09 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFp0479NzNs
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750808;
	bh=pcTxIWGPeu1R01B3vemkbii6+5znxxejEkyXOzhEKmU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=qLH8BhP1IV9VF75GQ8se/mGUGeUpGZtXpA1kWGt3O+YPraUSVS6wbO1KRHM9Hg7Lf
	 G0qYpbkc7h6Hf3uJhdk1aOPzERZ7VOA9LwpJWGAb1uUXMmv2ooy64I8WxBdvsdGKzi
	 URN+gaHOXw/efANGUg6EDVIGad1mm4dF2KnlUg1gGshG6NqFEtOiqiFyXRYrDIOL4d
	 OqSSighHaLuJzHT7JIaAqT6q3evzyIkXnkxdghc9YGCM+36AG/irQBFKJPzYaMKHKS
	 dgYKsWWkQaBjl161dxko0Bvuvv56QTVQEktsNYTDIqVXIwxa423Db4CKUV4ns0K287
	 mmQLKwNB3BsCw==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:40:07 -0700
Date: Thu, 15 Aug 2024 12:40:07 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 2/2] xfs/306: update resblks to account for increased
 per-ag reservation size
Message-ID: <7a1a37011ed851a2dfdb8ff62e9e60236253580a.1723690703.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
 <cover.1723690703.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723690703.git.kjlx@templeofstupid.com>

The AGFL reservation patches increase the amount of reserved space that
this test needs in order to succeed.  Modify the resblks xfs_io call to
account for the increased per-AG reservation.

Without this change, the dd in the test gets an ENOSPC in the path where
a delalloc is converted to a real allocation.  This results in the test
spinning in the dd command and generating endless xfs_discard_folio
warnings.

Since resblks is supposed to prevent the filesystem from getting empty
enough to hit a case like this, increase it slightly to account for the
modified per-ag reservation size.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 tests/xfs/306 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/306 b/tests/xfs/306
index e21a5622..9acace85 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -47,7 +47,7 @@ for i in $(seq 0 3); do
 done
 
 # consume and fragment free space
-$XFS_IO_PROG -xc "resblks 16" $SCRATCH_MNT >> $seqres.full 2>&1
+$XFS_IO_PROG -xc "resblks 17" $SCRATCH_MNT >> $seqres.full 2>&1
 dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k >> $seqres.full 2>&1
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/file >> $seqres.full 2>&1
 $here/src/punch-alternating $SCRATCH_MNT/file
-- 
2.25.1

