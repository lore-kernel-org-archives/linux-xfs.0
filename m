Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbfA1Mup (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 07:50:45 -0500
Date: Mon, 28 Jan 2019 13:50:44 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Message-ID: <20190128125044.GC27972@quack2.suse.cz>
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>

Hi,

On Fri 25-01-19 16:27:52, Amir Goldstein wrote:
> I would like to discuss the concept of lazy file reflink.
> The use case is backup of a very large read-mostly file.
> Backup application would like to read consistent content from the
> file, "atomic read" sort of speak.
> 
> With filesystem that supports reflink, that can be done by:
> - Create O_TMPFILE
> - Reflink origin to temp file
> - Backup from temp file
> 
> However, since the origin file is very likely not to be modified,
> the reflink step, that may incur lots of metadata updates, is a waste.
> Instead, if filesystem could be notified that atomic content was
> requested (O_ATOMIC|O_RDONLY or O_CLONE|O_RDONLY),
> filesystem could defer reflink to an O_TMPFILE until origin file is
> open for write or actually modified.
> 
> What I just described above is actually already implemented with
> Overlayfs snapshots [1], but for many applications overlayfs snapshots
> it is not a practical solution.
> 
> I have based my assumption that reflink of a large file may incur
> lots of metadata updates on my limited knowledge of xfs reflink
> implementation, but perhaps it is not the case for other filesystems?
> (btrfs?) and perhaps the current metadata overhead on reflink of a large
> file is an implementation detail that could be optimized in the future?
> 
> The point of the matter is that there is no API to make an explicit
> request for a "volatile reflink" that does not need to survive power
> failure and that limits the ability of filesytems to optimize this case.

Well, to me this seems like a relatively rare usecase (and performance
gain) for the complexity. Also the speed of reflink is fs dependent - e.g.
for btrfs it is rather cheap AFAIK.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
