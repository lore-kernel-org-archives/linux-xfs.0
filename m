Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692092;
	b=wrjvEtuWvwZZxXzCjETkZtssaxlbK5bMUt3ChQGH8Pqx3kzuGwnLNduVcnAKjDvacuJe
	 JSU76fSivIZEnNLendZdc23q6Pb8g6eop/MEQMQePSDJqZBS9oLynp/cbGPdR8AEfsV04
	 5pixufkOGc3+raWdzqg4qaQ8XYwCnsg9WAl+fser7J2/r7j3F38BALYuq1iPhcP3YKO/L
	 +AtarrEFu9+27s/sls3XUoZf26z2lLJBgpjJO+fqBnKGTg4QzxdwgYV54weaW1q4+PlVH
	 xPWuI6FLJmzs7bDJ7verKyn5byyjlhbd/DUHHaUlK4UBmIrtRMzvzi489q6ReU1lQsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692092;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=kQK8aK74JVGjWxIv+7BaJoXtxDmfIaYAlXbrpeu/j4U=;
	b=XfLWPLZDTRsoLjQicvnpNfNAwZQ8l7OdENZgXQcUCVbyO72kat6qDYFtGMt5Hqkexhu1
	 TMXbkHsDVJvHIW9RAF/MSiDoQnboAOlpl+h31cmLvTdzW8ho/HmnEP4RJG4IOcf5UeFI0
	 Y7faCu+guSg45HXXK57ZmpthRikHPl9oTr3aTMJGgSligmv8ijnWGFB3TdVIoHg9k43UN
	 MX8wpv63RRLDjuez+Fi/8YUpOFjQElVvHNjP58fxmI1WbhBJyiZWXaE3Su3kwGg3/55BW
	 G/sJRNKDK5mYhCEgRONPo7bLKQx7Ma+fvY5t6xDWGm1cGZaE4FLtKPbF69NPIPxfhww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9608606A32C;
	Tue,  3 Nov 2026 07:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9608606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3028C68AFE; Tue,  3 Nov 2026 08:48:06 +0100 (CET)
Date: Tue, 3 Nov 2026 08:48:06 +0100
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
Subject: Re: [PATCH 0/5] iomap: remaining patches for iomap_iter_next
 conversion
Message-ID: <20261103074806.GC3678@lst.de>
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <CAJnrk1bqPCy8ryVjCsUWR2+4jkNE8rJJU2bUFsO3Q7nznsF7xA@mail.gmail.com>
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
In-Reply-To: <CAJnrk1bqPCy8ryVjCsUWR2+4jkNE8rJJU2bUFsO3Q7nznsF7xA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 30, 2026 at 12:48:15PM -0700, Joanne Koong wrote:
> I pulled in Linus's latest tree (commit abf8c33470f7) and the series
> still applies cleanly with no conflicts. It also applies cleanly on
> top of next-20261030, which includes the remaining btrfs, ntfs, exfat,
> ext2, and gfs2 changes that haven't been merged yet. There shouldn't
> be any conflicts between this series and anything else going in this
> window.

Alright.  Let's get them into the vfs tree and linux-next for a few
days and off to Linus before -rc2!

