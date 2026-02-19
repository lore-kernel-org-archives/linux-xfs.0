Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6DB2E4263
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481222; cv=none; b=ga5qZ1fZwxivFURa31VClIhIC4yVWEpNotZ/upHhhNK5hwcqqqlCZ67oluqtCNCiKR/qJap6SKZGKJVAiJYomLPWPm+vN5V2/C8SDk1HIyILm8fQmnWLSE08nLPyYLGpMkjzNV/3tAyAV/mL1EGjfU8nMybgxXh77LETYLW6fTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481222; c=relaxed/simple;
	bh=VBCZYtV5NljcrEsKwgyg9DwGLj0wpvs2c1MFlXE/RZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWIr7WS50lbS74oMYuAK/SyF8S1xBnIuxfnnJeMHzDy0mty6WL7SgxBMJ4quxN03xVCDDljxUk1frvuHRzM9CAT7aki6JPvrtaAQzKyr01QbjLeQxdezlISyq4+HBg0hOaI70vrzJjynohS1lMDNWEDO+bhWW1TQAwsQghELcLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pb3mFnl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pb3mFnl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B592EC4CEF7;
	Thu, 19 Feb 2026 06:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771481221;
	bh=VBCZYtV5NljcrEsKwgyg9DwGLj0wpvs2c1MFlXE/RZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pb3mFnl7vdi0I/fKKmLwmsxZRyLryzSrX9vjE/iqbM7a85m9BEmN97HmicB3IPtrB
	 WEpZgFBi+YzLlqfcx+eJ9OjtHueDzjjjVSBKMMGVUDaSyou6opfwOTmAcW/HVQTDKd
	 Ze+MbJbphXxrtIREt368uuzHrtB/UiL24krNCTFwHwFJGRq2ilRuV2n6OvfnnvfA1F
	 lM2/L8RTSf/sbmuO6ribPP/Z+uYUCcrkNAuiMwxL4leDpV+VWT7uYn9pX08jFPE4lA
	 MGFgg8n8oNMFPTxlzPdmCvBCuPYs6rnHnvzG2rd5Zkg1ItZhSoFOi6Qs6I5SlTrzTD
	 7s6uixn9M6sLw==
Date: Wed, 18 Feb 2026 22:07:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: hch@infradead.org, jack@suse.cz, amir73il@gmail.com,
	linux-xfs@vger.kernel.org, brauner@kernel.org
Subject: Re: [PATCHSET 2/2] fs: bug fixes for 7.0
Message-ID: <20260219060701.GE6490@frogsfrogsfrogs>
References: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs>

<sigh> I forgot to cc fsdevel on this, will send again...

Ihateemailpatchsubmissions

--D

On Wed, Feb 18, 2026 at 10:00:53PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Bug fixes for 7.0.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vfs-fixes-7.0
> ---
> Commits in this patchset:
>  * fsnotify: drop unused helper
>  * fserror: fix lockdep complaint when igrabbing inode
> ---
>  include/linux/fsnotify.h |   13 -------------
>  fs/iomap/ioend.c         |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 13 deletions(-)
> 
> 
