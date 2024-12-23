Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEAE1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990798; cv=none; b=dHjblHyyplSAFYHqCOFYA/JxIodDvlf2dstzUPJDkJcBCryhHCoscK1FoiU7Naatc9JbQ/tIKdL5m8NcVfdURHj973eZcRIUSbFx/shni+TxExJuILFkSPt75NcB9B8ZGgnbRkh/ePFRJwy9nq3PRo7XupruIyWFP6faAeDD55w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990798; c=relaxed/simple;
	bh=y48VYamgt6QOQXx49bOzfyrg/uyjeUWk22WrlvMk7Ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nfv9B0FcJWewfEuxz5WF9t02vNgPBP5j7zRSoWfeU1weT32SqKXAUPO9EGDPyWiDyEm6chy4KY7EbkTH8BCiv5YKPmWLGBwsTUvEGna+RtM76QzqbS/ZCNtQNVymoxjTSxR/pfETcQUzimZSft6p3i5NBfVGIl2HnWdY2tZRAUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iR5FVDeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iR5FVDeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598CEC4CED3;
	Mon, 23 Dec 2024 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990798;
	bh=y48VYamgt6QOQXx49bOzfyrg/uyjeUWk22WrlvMk7Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iR5FVDeKb/t2PQFc10SWDzHxCjIrb7I0/hXDAaC2mRLf8/EdZFvny7bTY0wCbFpwV
	 ZW2TNyFxZQGDbKQNleMjpfEpiF4Vuic9CdorYSkUGrWbYymp+Wv6FL5RcnVl068lkt
	 3W9vNfxCDegz9ivkWiX17rjEwP87Z0cLPy9sYy/I4VOrIrqkAfjfVOoECG3T9qGDS/
	 ux9QDVokmse58occUp4Sk6dQaJkM8g2dZRSxM+/VDgyI9wTuN41WFacucAARygseoH
	 Ceno3WAj8DzxthB8DAkAZPW4EeccpX4kcFWTWIJOWR3cjwI1xFlG2E6J27Ru/6UJaN
	 pWFRWYnUElwqQ==
Date: Mon, 23 Dec 2024 13:53:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sai Chaitanya Mitta <mittachaitu@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <20241223215317.GR6174@frogsfrogsfrogs>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>

On Mon, Dec 23, 2024 at 10:12:32PM +0530, Sai Chaitanya Mitta wrote:
> Hi Team,
>            Is there any method/tool available to explicitly mark XFS
> file extents as written? One approach I
> am aware is explicitly zeroing the entire file (this file may be even
> in hundreds of GB in size) through
> synchronous/asynchronous(aio/io_uring) mechanism but it is time taking
> process for large files,
> is there any optimization/approach we can do to explicitly zeroing
> file/mark extents as written?

Why do you need to mark them written?

--D

> 
> Synchronous Approach:
>                     while offset < size {
>                         let bytes_written = img_file
>                             .write_at(&buf, offset)
>                             .map_err(|e| {
>                                 error!("Failed to zero out file: {}
> error: {:?}", vol_name, e);
>                             })?;
>                         if offset == size {
>                             break;
>                         }
>                         offset = offset + bytes_written as u64;
>                     }
>                     img_file.sync_all();
> 
> Asynchronous approach:
>                    Currently used fio with libaio as ioengine but
> results are almost same.
> 
> -- 
> Thanks& Regards,
> M.Sai Chaithanya.
> 
