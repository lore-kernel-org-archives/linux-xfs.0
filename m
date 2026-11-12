Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490507;
	b=uv7yH+dlOw6DlHRggNJrB0jhjNDxwyIJ8EFHm7bjsk7vAkRp8BByuOYwqxPcBv7pYzPm
	 FPre1tOBsoRYiit7J0w6oHaYoYNyUTAriS5v4ljqiOOXrYsedhWOXk7qtJJPUZ/F1J0rT
	 w7vIzgzOkWRPZkK6CmR6dhCOyao5qn0/Rmp2QVNxbskG4P/bvWidul53K8msLvPhwKhE4
	 8dMnyhwbROwgyl5H6Tbzcx3TtEFzrCTveBXvp+LphNgGadfAcVIuRelsPe9ll4jDM8DV5
	 VeOr9YqdX1cJpOcE8g+63qFID9fQ7BzuOcyOI19NUm8dAU4WqCV7YJxio1WYb361oBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490507;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=BX7LMJlm+WS3Ey2A41xPmFebRZMB1LaHimQYxty8XRXpAVCi6lW1cYPwZvi4Bas71+XB
	 mUNPYAIc6wLmFBO2JpjlCgb3d+6W2++Sr1HTFxa1mp/wG5s7/4iSSnzBmGYaaKQwo7abN
	 kelNDIBb4qovIoqsAlA/AB8KDNeRy7lPF8BoBJPLFAAqX2xDgtznE3DC47anotwbCqaCd
	 h1PM1N9jswu3BfooWoRUr8TgdXVEgxbCdg6cXoU9H4UNZN6XEdngbKrPkw0ll+CeYmrsE
	 fKKmXu77XHK8Z0U4UK1tCS3SlCCMUsX1/qX+Z+vOpV885lxfQlKrYUu7yNqUr4WPIfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07703606A321;
	Thu, 12 Nov 2026 13:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07703606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BDEF168D09; Thu, 12 Nov 2026 14:35:02 +0100 (CET)
Date: Thu, 12 Nov 2026 14:35:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v8 12/15] xfs: test for an extsize hint again under the
 ILOCK
Message-ID: <20261112133501.GB22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org> <20261112010229.51029-13-mason@kernel.org>
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
In-Reply-To: <20261112010229.51029-13-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

