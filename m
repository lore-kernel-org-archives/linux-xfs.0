Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199656;
	b=YAg9qikKxGKQsxmMdy4fbcYpHRCeSa4gdrMMFb2V9VwWgyRv3INdxVWx27UQ/dpzXWA2
	 WBhopiOg8vNXEWFf1Q+q+M2onI6HsBF3cKGSkHyKJ4YjoGQzhXX6WOsfSDAcocTAB5oHh
	 a8yZAE4vDduMJAFLVBj3+1FV9/28yr5uDnzjUbYd1RNkYQvRpgkHHMf2LV6JrCfJj7kb+
	 J1UEmCY9Dd9j2/NEMrM+6ByuFkVXfJh4X/oBHSIsoexVl3uq210uTHbHe1+5qbck0msE2
	 ys0+/T2wSzWuaaVXAQrThU+/QiIqNzqu8OGDFO1bef6/NuVYX8Wcruy1bi3WRh2ck9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199656;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=SqsVhitOdePujGrPLjfjoRG/ResbjWYsPperqBhRTF4=;
	b=bgjmRnddShTsQogZiHyc7lz7IHJIeZdUJ91hnavMCLTsUKCYC4qtBeQHT46ahinHFEaF
	 30yo1g7Ac3ljTddAl1FcsZJJM4p9yI2kZlxO5AQ+7WVV23Eqg2ao6fxpujqy6X3pXAgXs
	 CILyS1OGWl+kich2E6nAHM0JEMySA+tCoLXdC0GWKq2zzJqPXErzAsKczUYWr7zLPKdhY
	 hiol+a+cBkSPZEtxvNvGpTKGck1WDiiVjJfh3r4HWCeQ0N/YM7BzZpOw/3Z1S6iNGiRad
	 /wPD17EERVgicRUZgKpGxqDVjEnYtZEgNvOBOD5JSWj9gSAC67qnrwPcFIHD+Mp9tXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CD3606A31A;
	Wed, 28 Oct 2026 15:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0CD3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9DB8768AFE; Wed, 28 Oct 2026 16:00:49 +0100 (CET)
Date: Wed, 28 Oct 2026 16:00:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	bfoster@redhat.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
Message-ID: <20261028150048.GA15828@lst.de>
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <20261027215326.2693300-2-joannelkoong@gmail.com>
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
In-Reply-To: <20261027215326.2693300-2-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 27, 2026 at 02:53:22PM -0700, Joanne Koong wrote:
> Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
> is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
> iomap_iter_next() helper to finish the previous mapping if needed and
> produce the next one. No functional changes are intended.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

