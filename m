Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3399129EE6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQSN8VUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF36C433C8;
	Tue, 19 Dec 2023 04:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702961319;
	bh=Dlm+uZniWG46MRTjZOhzxqsVCkqAWOGGGv7TtdJ59oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQSN8VUWiNoH4OpKueuLK/8CrDN00DvfVQ/LHUjw9sBV9dVmhzSh9cd2HjO8Cjw2p
	 KwKgV7O9acVROpHwE0ZpEDm90OmTzEjhkjzAmMqUCHDCYeq7GbWadxeMYZYq3AOqKG
	 ofOgmG1hR5KeS2IuzyKJt/ihQawzcY9bJ2FYcI8rGB5Xb5cDFWpLQBHeRhz7K6hSXU
	 py3dzayvDtM0X2i2XtsZtec7hTPT6dbUQTHZdfobKyopRDfwxvgXmLikhmtQN4z4AI
	 VjP0SgfmQ2TPkDPfh/Ycp20K2i7wZ9mey230b6sdkrIarghpoD4h8UdHRbrNvagu6Q
	 FfZSBFK+zexzw==
Date: Mon, 18 Dec 2023 20:48:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: make if_data a void pointer
Message-ID: <20231219044838.GF361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-2-hch@lst.de>
 <20231218223154.GY361584@frogsfrogsfrogs>
 <20231219042008.GA30534@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231219042008.GA30534@lst.de>

On Tue, Dec 19, 2023 at 05:20:08AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 18, 2023 at 02:31:54PM -0800, Darrick J. Wong wrote:
> > (Does if_bytes really need to be int64_t?  I don't think we can
> > realistically allocate that much space...)
> 
> Ѕee commit 3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08 for Dave's detailed
> explanation.

Heh, thanks for the reminder!

--D
