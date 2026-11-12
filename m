Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794527460;
	b=kVwPKx0Twj9hKOayb4NJWZqDSDEVDcJsUFIUEV+OVKZO2C/+8a0HrzEPLkcg5C3yVKJ6
	 rJsEFqKagaCelgsC2y+UIudS/ACkMMyjKNaeNEB3SnNSmihJAUkgi1RXxc1Af54yTJbWI
	 pAx5hW7LLAE5vMRPgXXBT4HaOrAnxoTTU2zxCtZF+a99vPvXHq7E5TYSuoyx3iZjwVbIl
	 DvzKidsFy27CPa/nDSuQ/NgO8qO8VDHEHGqIFrTv2DbtSNTteRVavEsdSWtR9y04an35O
	 SY7s1Az9gKgGBJAm4dmluc6NE+2qIH04AcSJk0VfIVnuTrhV1RR/2RFPI1NCjD1Lvzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794527460;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Z1lD/cCzQ2nlPhd3OfZrtR5Zf6u2cibqayw3cY6rQAOPAHyagKvs0pfGuyWEG2NptSKZ
	 EYm9/M/iml4lNj2/3zgb+ukAYECVV/TqtxBZ7m9oyP5l7J5MWSje4NiuQ8QJehI5QoJ0F
	 RrwNxT6mMeXv4j7szkrBCxmv7E+bhmHNUJMJsNVkbcq/iMWLmbt/ddGexY+GJjxTChQBt
	 MhZOANB5aI3FVM71+iTPV8m3x/VLvycreGbrctR/DAr5/z3lUVJnusM/uQjZ5LeWk1KOQ
	 +FH0xIVxJUrbmngtKBu8abN/IdGZvgUrhuld0GnoyWB6i3mJRqyq4khBd/1Ejj/Ey6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EBD606A89D;
	Thu, 12 Nov 2026 23:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28EBD606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F23A68D0D; Fri, 13 Nov 2026 00:50:56 +0100 (CET)
Date: Fri, 13 Nov 2026 00:50:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v9 13/14] xfs: don't enable DAX on zoned inodes
Message-ID: <20261112235055.GC13410@lst.de>
References: <20261112214604.67875-1-mason@kernel.org> <20261112214604.67875-14-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112214604.67875-14-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
