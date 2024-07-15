Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E633BBC2
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 22:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721084174; cv=none; b=AtZlFf8ZS2sTUZQA8SOb5PRwvWtPPjllr3Jz/jXbhab7+3aTWLZsZMNjtQaNnqIRkMU3lWatSSlPIIWK6OfulzsxUXyXJC/Nn6tJVJIEJrX3luaxdG7G1CgG0D8a+rpeHNfGLN8XzF4gjfn5uKMvqu6gFN7+0RqLDMpOgh+xH4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721084174; c=relaxed/simple;
	bh=K3wFlDptrJ0WF5O+2umfPRP4YSm7bo6oPLFAmVtIP4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4KGifjbLqy7JoVxIOPGYJgmGrW1fhC38vZqg7I7YUnWlWLL2MJNA8Q9i7cHwV3yCXxBt06wH+RUVi8w0kzWIR0KHi3NhGmyHYNXrJ1e2oXuvVJbscLQGTa2M9MZvIoMh5agTNQZE5gNTOxlbNg9unYWlL2J4q7mgWA3/b8tC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mu0Hm+wJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mu0Hm+wJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B87AC32782;
	Mon, 15 Jul 2024 22:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721084174;
	bh=K3wFlDptrJ0WF5O+2umfPRP4YSm7bo6oPLFAmVtIP4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mu0Hm+wJjfeCGYRIDG/54fzMJFKlOlw/KhE0GawV2VNSd6ZCE0Ku1Zzmxizi8ozw9
	 pkwWzlp9YwR20o8nL97/eA1d399wAfOkRRm9nNNzMe9EZdzirUZWI/a5c4Ar9pop7S
	 XdDCbep6eNf+6lwsyKEqQqeUu8VSqoN/Zh9KE2hylCi9lAyrykkCzOlOREdJr4zVsg
	 2I6OBWvj0QsOhnMO8VddTF80IEnTzXwD0fuGZROKypDfCatLbZ1oLwfm6ZPbGjr4r1
	 IWnIkNzw8z3YTu3bhz/bu+eqbR3IkVuAdEkAHvBvnJNt1ktCnXTog/Q7BLzEAYHSUU
	 7z+KnBOUNfTAQ==
Date: Mon, 15 Jul 2024 15:56:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Message-ID: <20240715225613.GZ612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-5-wen.gang.wang@oracle.com>
 <20240709210826.GX612460@frogsfrogsfrogs>
 <5A606248-86EB-406B-B9D8-68B7F06453B2@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5A606248-86EB-406B-B9D8-68B7F06453B2@oracle.com>

On Thu, Jul 11, 2024 at 10:58:02PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 9, 2024, at 2:08 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Tue, Jul 09, 2024 at 12:10:23PM -0700, Wengang Wang wrote:
> >> Add this handler to break the defrag better, so it has
> >> 1. the stats reporting
> >> 2. remove the temporary file
> >> 
> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> spaceman/defrag.c | 11 ++++++++++-
> >> 1 file changed, 10 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> >> index 9f11e36b..61e47a43 100644
> >> --- a/spaceman/defrag.c
> >> +++ b/spaceman/defrag.c
> >> @@ -297,6 +297,13 @@ get_time_delta_us(struct timeval *pre_time, struct timeval *cur_time)
> >> return us;
> >> }
> >> 
> >> +static volatile bool usedKilled = false;
> >> +void defrag_sigint_handler(int dummy)
> >> +{
> >> + usedKilled = true;
> > 
> > Not sure why some of these variables are camelCase and others not.
> > Or why this global variable doesn't have a g_ prefix like the others?
> > 
> 
> Yep, will change it to g_user_killed.
> 
> >> + printf("Please wait until current segment is defragmented\n");
> > 
> > Is it actually safe to call printf from a signal handler?  Handlers must
> > be very careful about what they call -- regreSSHion was a result of
> > openssh not getting this right.
> > 
> > (Granted spaceman isn't as critical...)
> > 
> 
> As the ioctl of UNSHARE takes time, so the process would really stop a while
> After user’s kil. The message is used as a quick response to user. It’s not actually
> Has any functionality. If it’s not safe, we can remove the message.

$ man signal-safety

> > Also would you rather SIGINT merely terminate the spaceman process?  I
> > think the file locks drop on termination, right?
> 
> Another purpose of the handler is that I want to show the stats like below even process is killed:
> 
> Pre-defrag 54699 extents detected, 0 are "unwritten",0 are "shared"
> Tried to defragment 54697 extents (939511808 bytes) in 57 segments
> Time stats(ms): max clone: 33, max unshare: 2254, max punch_hole: 286
> Post-defrag 12617 extents detected

Ah, ok.

> Thanks,
> Winging
> 
> > 
> > --D
> > 
> >> +};
> >> +
> >> /*
> >>  * defragment a file
> >>  * return 0 if successfully done, 1 otherwise
> >> @@ -345,6 +352,8 @@ defrag_xfs_defrag(char *file_path) {
> >> goto out;
> >> }
> >> 
> >> + signal(SIGINT, defrag_sigint_handler);
> >> +
> >> do {
> >> struct timeval t_clone, t_unshare, t_punch_hole;
> >> struct defrag_segment segment;
> >> @@ -434,7 +443,7 @@ defrag_xfs_defrag(char *file_path) {
> >> if (time_delta > max_punch_us)
> >> max_punch_us = time_delta;
> >> 
> >> - if (stop)
> >> + if (stop || usedKilled)
> >> break;
> >> } while (true);
> >> out:
> >> -- 
> >> 2.39.3 (Apple Git-146)
> 
> 
