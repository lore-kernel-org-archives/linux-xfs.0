Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B39AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 15:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351332AbiEEPtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 11:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348488AbiEEPtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 11:49:41 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFDE44A0A;
        Thu,  5 May 2022 08:46:01 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DD1ED68AA6; Thu,  5 May 2022 17:45:57 +0200 (CEST)
Date:   Thu, 5 May 2022 17:45:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] iomap: add per-iomap_iter private data
Message-ID: <20220505154557.GA22763@lst.de>
References: <20220504162342.573651-1-hch@lst.de> <20220504162342.573651-3-hch@lst.de> <20220505154126.GB27155@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505154126.GB27155@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 08:41:26AM -0700, Darrick J. Wong wrote:
> > +	 */
> > +	iomi.private = iocb->private;
> > +	WRITE_ONCE(iocb->private, NULL);
> 
> Do we need to transfer it back after the bio completes?  Or is it a
> feature that iocb->private changes to the bio?

No need to transfer it back.  It ist just a creative way to pass private
data in.  Initially I just added yet another argument to iomap_dio_rw,
and maybe I should just go back to that to make the things easier to
follow.
