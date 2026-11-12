Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794527440;
	b=fCHiKdu8XjM6gYEe6oHFxyQFA/gPhTX/HIAInjqP+tNRQ31e7TsNQoue9tklRaybaQqG
	 1Y94xPuUntIYvYJTCvCbzATmFK2nJto8iGCBU4VGnKkeMD4ZeJl4chgD0Kk+vakit/w44
	 ICDMclcHDyegJsvcLReAlimTqBQ3qRqN5wfpGkf7z/uTdkBL1XPK/Zh05SC2qZkRRYz5D
	 wYishGX07aJl/G4QoQk8P6Bhjkhqg1Qm7xvcFWmFYGcOutwGBTpv31RZNJ5Bb9OvL1QwN
	 Z8uf8q62QZKhJ4hNSV4gARytMLBUcwyj913poiLTBukPG4tujun4pywm5fUs1HfNhuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794527440;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=ZH2zZZ3pvU3LG01lXc+BSILRIfpdOWzPk4P5ykE+4tGa1xE+rFqc/3ycXEqguJ2E8A9y
	 ZexX9m9GiUu3ShyPMpiimD2+kZieccTdPHA8WOOy1ymvB6r3BlmWiu30pum2h8b6mFkNK
	 XIybNsEFbful0CzIIa1Dc+SETjPgiUlJaP1W1AZphxcCuxtFFV9c+NTGCa+ea6dSxJkDd
	 voCZgb2VdM8poLEYpLGEth+qucQc3Ij7JV82ZXccit32VvdSsj4mE+inIrrV41rk1Kkp8
	 jlUFKJlPEfYwwF2dEY9jCcXUiQJ3KcSqMR2sgtNVuCA1m0RZlsBEnR+y/4rZBvwhNow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34AA606A336;
	Thu, 12 Nov 2026 23:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C34AA606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A6C668C4E; Fri, 13 Nov 2026 00:50:36 +0100 (CET)
Date: Fri, 13 Nov 2026 00:50:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v9 12/14] xfs: restart faults racing with realtime flag
 changes
Message-ID: <20261112235036.GB13410@lst.de>
References: <20261112214604.67875-1-mason@kernel.org> <20261112214604.67875-13-mason@kernel.org>
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
In-Reply-To: <20261112214604.67875-13-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

