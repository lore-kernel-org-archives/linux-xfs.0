Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45593C30
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629828; cv=none; b=ox4FHvqn+W5mGk8VrpoTQvHAjsmOZ3m3pJbn0whNie3tvc476vgAbrESiqsBfl5LMLHqIPrWPKIR309OKZAZfA6xdJ75Zuf7rHELrvEwsCvmV1ip/kcZWAgEt6X8v3HADYQK/I1j4A8gRLFyy1JyYTNPs8TGzNMdfXC2lbn4Srg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629828; c=relaxed/simple;
	bh=EkbRP28bFipvvNW429H076P4hxgGfiG2LM6tLSrA00o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZfztPoVum9Nu56ZTXwXto286LBWtB+fOM+KgWzRVHEHd+TGLPFegJy0iQB7+Kc5gaSbCzTFVojWq1/f8B4K6g3jRkahAlKcmGWeamreKZjkmeoCPaNpxIgL1m31BwaaDIYOZgkvIw6MGUyabW3eEVmCEgur46CnoVSOCIfl62M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9rzGKEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9rzGKEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ABEC4CECE;
	Thu, 19 Dec 2024 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629828;
	bh=EkbRP28bFipvvNW429H076P4hxgGfiG2LM6tLSrA00o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R9rzGKEg2o/2qL8FSZmXqcnYVSkr7aHQIR70LUpHvojJkIlUp1QtLa5ukNQ0Dt+q9
	 pRPQTcxG/LEl4AD9/wDI+41mslzlAew6RGYbKFLU5DVlTb/OtKe6xfZbL89UrjTAhc
	 b6jMUxfpT8kSDh3GOfyTRtCG5Cq3+N3BrzW1XyaD9Gz8NcTYCHaSYaZ1O9TFJsHh3M
	 jx5v5kC4jqwoAJSOQbeqyJ5+X4M5uO/RE7GOPFycWs2dz5qwdCSf/hJd5k1pFiMbsN
	 +YcRjK1hbsKAPX7kf2KFHNMfg+ZdBlEXJsCq9GwcXc9+oiffVDaxWf/CVna6k13txf
	 ZBDfhR5u+J+JQ==
Date: Thu, 19 Dec 2024 09:37:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241219173708.GN6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-26-hch@lst.de>
 <20241213210140.GO6678@frogsfrogsfrogs>
 <20241215053135.GE10051@lst.de>
 <20241217165955.GG6174@frogsfrogsfrogs>
 <20241219055059.GA19058@lst.de>
 <20241219160004.GI6174@frogsfrogsfrogs>
 <20241219173616.GB30295@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219173616.GB30295@lst.de>

On Thu, Dec 19, 2024 at 06:36:16PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 19, 2024 at 08:00:04AM -0800, Darrick J. Wong wrote:
> > > I really hate that, as it encodes the policy how to get (or not) the
> > > blocks vs what they are.
> > 
> > Yeah, me too.  Want to leave it as XC_FREE_RTAVAILABLE?
> 
> That would be my preference (at least based on the so far presented
> options)

Fine by me.

--D
