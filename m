Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C335380
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECB4C68AFE; Tue, 19 Dec 2023 05:20:08 +0100 (CET)
Date: Tue, 19 Dec 2023 05:20:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: make if_data a void pointer
Message-ID: <20231219042008.GA30534@lst.de>
References: <20231217170350.605812-1-hch@lst.de> <20231217170350.605812-2-hch@lst.de> <20231218223154.GY361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231218223154.GY361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 18, 2023 at 02:31:54PM -0800, Darrick J. Wong wrote:
> (Does if_bytes really need to be int64_t?  I don't think we can
> realistically allocate that much space...)

Ѕee commit 3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08 for Dave's detailed
explanation.
