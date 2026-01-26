Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661FD13AA2F;
	Mon, 26 Jan 2026 04:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769403441; cv=none; b=lvQIFRyyhdghuNMcadxuoCRvA9IUdWbimwQI5rrq+JyYFJfnV1Q7f7PN9yio6cKvjL+chUvsFhdsL/4tTvhxUvpTXOc3BB8JridV5MotZ+FTxpfW2JiNLmViH99KH1s4gINDWaPr7LeV3UAmO6GePqFyeCJtosQdaCYnbpKujUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769403441; c=relaxed/simple;
	bh=ajjpzkKmQYBaJ5yLJSgX4W0nod+etg3s5TaDWX1PUss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNlYCmwSNAZR2WM6rVhDgzv3HK8rPLFVWeQEHPezlfnULKZrCvjd2GyMNHI93h3fuv9JCFu5eFhYrEPKtv8/Br5si5Tx2GiRE7ILAaCLOczUNGabMUuu6J7tBJkqSNX4A1zwg6TL7VsN9Dqur1zFVMSwwvk4wMWjVdLvZ9+4fw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F3EC3227A88; Mon, 26 Jan 2026 05:57:16 +0100 (CET)
Date: Mon, 26 Jan 2026 05:57:16 +0100
From: "hch@lst.de" <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"song@kernel.org" <song@kernel.org>,
	"yukuai@fnnas.com" <yukuai@fnnas.com>, "hch@lst.de" <hch@lst.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"chao@kernel.org" <chao@kernel.org>,
	"cem@kernel.org" <cem@kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH V3 4/6] nvmet: ignore discard return value
Message-ID: <20260126045716.GA31683@lst.de>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com> <20251124234806.75216-5-ckulkarnilinux@gmail.com> <942ad29c-cff3-458f-b175-0111de821970@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <942ad29c-cff3-458f-b175-0111de821970@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Jan 24, 2026 at 09:35:16PM +0000, Chaitanya Kulkarni wrote:
> On 11/24/25 15:48, Chaitanya Kulkarni wrote:
> > __blkdev_issue_discard() always returns 0, making the error checking
> > in nvmet_bdev_discard_range() dead code.
> >
> > Kill the function nvmet_bdev_discard_range() and call
> > __blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
> > since no error handling is needed anymore for __blkdev_issue_discard()
> > call.
> >
> > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> > ---
> 
> Gentle ping on this, can we apply this patch ?

Are we down to three patches now?  Maybe resend the whole series and
get ACKs to merge everything through the block layer?

