Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7FC49427F
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792397566; cv=none; b=MCX/+MtOirESCiLHg4xDhdnTVpkwnu+SRqnOVqFjaLREit9kszS4eyrggY9vZjPbr9iFXjVMROJR+VeI9AJ3pGzNzhP7NP3eNK9Py7WJqG1M3kqHup1uGjaMHvjmqDQniGc02zx88JUssG4ug/f18WhL4veacynJSInvlHQ4TSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792397566; c=relaxed/simple;
	bh=BvMxN6crgdZ6070Dug3YFkqYmO2m7bYLptbeam0q8Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDQNaiRYq+QrH7A7A8K4cR3zlst6rGt8gtkilXeN7EJqfKVok4o1R9Ff+hbcbf/aBGliKJ88ivDfWrQPHDoZU0SLzKaQX9axlu+9hOphhPO83hAl/1shXic+kfxdHnFfOsuKOsLfekIhO54H3y5XA2nbwentOihERxe9Vq3ogS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBuYJZ4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBuYJZ4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77801F000C4;
	Mon, 19 Oct 2026 08:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792397565;
	bh=UExqLP+NvL078HMHf68tgvZFqaEaFo6G9LCQaugsO8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bBuYJZ4a+1vpa9TNwCUy3Cynjowh5ZBffJAXAiTMGE9kiDyB6YPEqpVD62PMxMLXv
	 YXkLa+JBCDmxVg3w5HZru6hfBPKUsOYJqpvKssL7kNEQ5Nyi1XzXJKTC4AuEKByZKG
	 5GHitYlIrwHeEYbrNm+RMCfyFLlZonXXMrDlv0WUbmu8ssJAzO0BNC/Ox6h5RFKIfn
	 FdsHsoTx70l9dZMo2MMcgnC995NMUI+U2dXWSh+7rbPOs2yIXNkw6gZfSj2ELfd0gK
	 oT69gHtULJKG4ubzmsNCJRJLkInYj62CSUW2YwD6n1tgUII5y+wzVuJrBssXQfFppL
	 ZYI9hnLVDrBKQ==
Date: Mon, 19 Oct 2026 10:12:42 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] tools: add a new script to generate fixes tags
Message-ID: <atXMAL0VDq8La3wh@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
 <179158948300.3720929.2141793283079787803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158948300.3720929.2141793283079787803.stgit@frogsfrogsfrogs>

On 2026-10-09 16:53:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a program that can generate Fixes: tags for a new bugfix commit to
> cite an older buggy commit.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tools/git-fixes |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100755 tools/git-fixes
> 
> 
> diff --git a/tools/git-fixes b/tools/git-fixes
> new file mode 100755
> index 00000000000000..5729de462e7183
> --- /dev/null
> +++ b/tools/git-fixes
> @@ -0,0 +1,61 @@
> +#!/bin/bash
> +
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +# Copyright (c) 2026 Oracle.  All Rights Reserved.
> +# Author: Darrick J. Wong <djwong@kernel.org>
> +
> +# Cite a list of git hashes in Fixes: tag format.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +	echo "Usage: $0 commit [commits...]"
> +	exit 1
> +fi

I miss a bit more description on the use of this, so, the output of
this script is Fixes: for the first <commit> description and the
rest [commits...] are targets to be in Fixes:?

Also, would be nice to see user.stableSubmissionTarget and
versionsort.suffix mentioned in the description above

-- 
- Andrey
