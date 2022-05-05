Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCBCC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 18:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383114AbiEESU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 14:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383121AbiEEST3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 14:19:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC218E10;
        Thu,  5 May 2022 11:15:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4E4CC68AA6; Thu,  5 May 2022 20:15:44 +0200 (CEST)
Date:   Thu, 5 May 2022 20:15:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] iomap: add per-iomap_iter private data
Message-ID: <20220505181543.GA814@lst.de>
References: <20220504162342.573651-1-hch@lst.de> <20220504162342.573651-3-hch@lst.de> <20220505154126.GB27155@magnolia> <20220505154557.GA22763@lst.de> <20220505163219.GJ27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505163219.GJ27195@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:32:19AM -0700, Darrick J. Wong wrote:
> > No need to transfer it back.  It ist just a creative way to pass private
> > data in.  Initially I just added yet another argument to iomap_dio_rw,
> > and maybe I should just go back to that to make the things easier to
> > follow.
> 
> Hmm.  Who owns iocb->private?  AFAICT there are two users of it -- the
> directio code uses it to store bios for polling; and then there's ocfs2,
> which apparently uses it for iocb lock state(!) flags.

Yeah.

> Getting back to iomap, I think the comment before __iomap_dio_rw should
> state that iocb->private will be transferred to iter->private to make
> that relationship more obvious, in case ocfs2 ever stumbles into iomap
> and explodes on impact.

I think I'll just look into passing an extra argument instead.  It
is pretty clear that using iocb->private was a little too clever and
takes experienced file system developers way too much time to understand.
