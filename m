Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1DF1110
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJsMSPUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D3EC433C7;
	Tue,  5 Dec 2023 05:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701753588;
	bh=S7evO0yRdlb4Hs0TlKk1gwrHjkeQzpHr4u5Uk4ceIlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DJsMSPUAjiTcHoJCXBs4CD2sIxPJwVEi/2kdxEZcDo9XOThQ7RN9Zge+uC3Gaut77
	 zNwCCOEx+xVXe3R5PdhIDX+fAwJ44m43IA0CByI+x39HHe/MREkMQlENq2t4dQrHto
	 iOWlcXHoMaLbILZrzd+iHROnVUvxx5Tec4NF/SSJ3Mn70qzVJK2KkcYNajSpi2TJyj
	 eHyalbMyxq82qKKY4ms9sJUohjJstOh39Fu8KMXwE/Ox988MeFm6r0EMzwmnoJOVc3
	 N6Cksm2CHj6V7UBpva/PDHF1ibjpEdtBMNpZuNFWl5gRLFS8dKLmCUWAk2B3GKw3Op
	 Ic+Dd3Dk7ODcw==
Date: Mon, 4 Dec 2023 21:19:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't leak recovered attri intent items
Message-ID: <20231205051947.GJ361584@frogsfrogsfrogs>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
 <170162989722.3037528.16617404995975433218.stgit@frogsfrogsfrogs>
 <20231205043143.GA28309@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205043143.GA28309@lst.de>

On Tue, Dec 05, 2023 at 05:31:43AM +0100, Christoph Hellwig wrote:
> Based on my now existent but still vague understanding of the logged
> attr code:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yay! :)

--D

