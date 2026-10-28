Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199695;
	b=VRvldj5o2cG95/bSmlrX9szfoof2p/DPlE5yAqSrlLImEP9wUthc+eQQwvZFz57wliwp
	 hMipJIcMcTwGZthfDuiwEQjkVmWykqB63QiKFsEAdCmiRjgcZ68fa4HdWlzN1816MYn3w
	 Yr6FqowEYWLUFaEoC1rAxdEcildf4MmmrdLQHnP/LXaLKiiPyDFMGXOGPVnT7VmOLTc3a
	 1ChWLBTmuhFu9M9Grpa0Kx65mZKFWFnPLynkNj16Qt41HR6gv+AWM5ibXxH0gKpKor8Dm
	 zhxMdJQk3U7lV24X7y8QKIxWWBN/rgvYT29mEx56SnxZAMTIdugLK3vlylJOhq7a54w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199695;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=FodwuhGNyXxVqEJN1WVKCjLa+lGk8J9ntTHyhxLg7OQ=;
	b=0P8pqfA23GyltaTvAOO3Wi+l5fAYenflPovxzWi7TWATDkiJuj1HDlBi9fgifnk6pKFU
	 JU31KWlxorsqjTZMR+dx3ADl5MpNinvNxRgCPpgznKrqqdOclruzEv/bddY2/jAO1vZZB
	 MDkwWi6tV4sacoCx8UCJ7xU7G6pger38NV+wjJMYQycbjmen1/LFyLOXDzkMra4Zp0aff
	 ENLS53CN8665VxHWTm09BmdrSnw+xHAq3QJSh/sMe3pG9LUW+qGckklF6RabKdYDANdus
	 QfILr5jFmXyCLYS5TKufyxWF+WHgJ1cyyhGb7uwxCt0EvJ5R/Ft80R4bbaeGqcdI5fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55559606A324;
	Wed, 28 Oct 2026 15:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55559606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04FA668BFE; Wed, 28 Oct 2026 16:01:30 +0100 (CET)
Date: Wed, 28 Oct 2026 16:01:29 +0100
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
Subject: Re: [PATCH 2/5] fuse: convert ext_map iomap ops to ->iomap_next()
Message-ID: <20261028150129.GB15828@lst.de>
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <20261027215326.2693300-3-joannelkoong@gmail.com>
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
In-Reply-To: <20261027215326.2693300-3-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hmm, it would have been nice to CC adding a new creative iomap use
to the relevants lists..

Anyway, the conversion looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

