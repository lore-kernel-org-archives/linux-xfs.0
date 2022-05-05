Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE246C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 18:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383414AbiEESc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 14:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384242AbiEES2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 14:28:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84DC5DD18;
        Thu,  5 May 2022 11:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDED461F3B;
        Thu,  5 May 2022 18:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C9DC385AC;
        Thu,  5 May 2022 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651774701;
        bh=U9V8UWfsURigJJ5eOaBqFZ69rsQHY7ySGqQ9aSp7IU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VNXgDgXZbtKqg0Ju4BqbvlQhyr+e5HiUVfYfG8h0LxBBkrkipocJIedOVZykPsD4L
         EuerpLl7kcwHOSCZxWlnow4J3xCplPiJVrvpFcyUtVcH8RMZfgStffK6HcONrWOzg2
         FdvlSxuiMt2zWVHAiGYAE4XZICtm2l8seZSKhPElegNjmtuYDMeWaGnXNY7xNjmQGP
         Rm7SO11lssPWqEFmXWgGUyhurqMgA1flkjazkMFYgYr6hjfvCRdRuYRMzoIAtzrPtF
         pgkJIoNZGfUJPcFxpwGloxToVjK5sGumsNJydN2m/1VHyzdXgUYqyk0cFuP6uaQ5p0
         VDLeVfzLZl96A==
Date:   Thu, 5 May 2022 11:18:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] iomap: add per-iomap_iter private data
Message-ID: <20220505181820.GK27195@magnolia>
References: <20220504162342.573651-1-hch@lst.de>
 <20220504162342.573651-3-hch@lst.de>
 <20220505154126.GB27155@magnolia>
 <20220505154557.GA22763@lst.de>
 <20220505163219.GJ27195@magnolia>
 <20220505181543.GA814@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505181543.GA814@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 08:15:43PM +0200, Christoph Hellwig wrote:
> On Thu, May 05, 2022 at 09:32:19AM -0700, Darrick J. Wong wrote:
> > > No need to transfer it back.  It ist just a creative way to pass private
> > > data in.  Initially I just added yet another argument to iomap_dio_rw,
> > > and maybe I should just go back to that to make the things easier to
> > > follow.
> > 
> > Hmm.  Who owns iocb->private?  AFAICT there are two users of it -- the
> > directio code uses it to store bios for polling; and then there's ocfs2,
> > which apparently uses it for iocb lock state(!) flags.
> 
> Yeah.
> 
> > Getting back to iomap, I think the comment before __iomap_dio_rw should
> > state that iocb->private will be transferred to iter->private to make
> > that relationship more obvious, in case ocfs2 ever stumbles into iomap
> > and explodes on impact.
> 
> I think I'll just look into passing an extra argument instead.  It
> is pretty clear that using iocb->private was a little too clever and
> takes experienced file system developers way too much time to understand.

Ok.

--D
