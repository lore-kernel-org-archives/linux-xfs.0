Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53121 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751816AbdHACPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2017 22:15:13 -0400
Message-Id: <1501553712.1055225.1059044352.109C04CB@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501516968.579311.1058393288.0714478A@webmail.messagingengine.com>
 <CAPcyv4h_YWaAXG5pfkOJ0M74i5yEke1SoC3ESErTh41hngtG-w@mail.gmail.com>
 <1501518747.586018.1058450568.4B6F28FB@webmail.messagingengine.com>
 <1501522933.602272.1058529880.6C4A2D98@webmail.messagingengine.com>
 <20170731182352.GE4477@magnolia>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
In-Reply-To: <20170731182352.GE4477@magnolia>
Date: Mon, 31 Jul 2017 22:15:12 -0400
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Mon, Jul 31, 2017, at 02:23 PM, Darrick J. Wong wrote:

> I don't think F_SEAL_{SHRINK,GROW} prevents reflinking or CoW of file data,
> which are two things that cannot happen under S_IOMAP_IMMUTABLE that
> aren't size changes.  From the implementation it looks like shrink and
> grow are only supposed to disallow changes to i_size, not i_blocks (or
> the file block map).

True. 

> Then again, I suppose F_SEAL_* only work on shmem, so maybe it simply
> isn't defined for any other filesystem...?  e.g. it doesn't prohibit
> reflink, but the only fs implementing seals doesn't support reflink.
> 
> <shrug>
> 
> Seals cannot be removed, which is too strict for the S_IOMAP_IMMUTABLE
> user cases being presented.

To be clear, the set of use cases is swap files and DAX, right?  Or is there anything else?
I can't imagine why anyone would want to turn a swap file back into a regular file.
I haven't fully followed DAX, but I'd take your word for it if people want to
be able to remove the flag after.

Anyways, I think your broader point is right; the use cases are different enough
that it doesn't make sense to try to add S_CONTENT_IMMUTABLE (or however 
one decides to call it) at the same time.
