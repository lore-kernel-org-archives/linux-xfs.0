Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45177 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdHEPqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2017 11:46:13 -0400
Date: Sat, 5 Aug 2017 08:45:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170805154528.GI24087@magnolia>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519190115.GJ4519@birch.djwong.org>
 <1501791890.2285873.1062452112.61520C55@webmail.messagingengine.com>
 <20170805141621.GA10457@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170805141621.GA10457@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Colin Walters <walters@verbum.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Sat, Aug 05, 2017 at 07:16:21AM -0700, Christoph Hellwig wrote:
> > Any objections to something like an ioctl (fd, FIFREEZETHAW, 0) ?
> 
> It's going to be completely trivial, which argues for it.  The only
> points left woul be bikeshedding over the name, and how to describe
> its semantics.

FSCHECKPOINT?  Since that's your requirement anyway...

"Ensures that all filesystem metadata (which may be in a journal
somewhere) has been checkpointed back to disk." ?

--D

> > in the end probably the real fix is probably something like storing
> > multiple copies of the bootloader config with checksums that grub
> > can verify.  Basically teach grub to try really hard to extract known-good
> > data from the FS.  For file-level consistency that'd be pretty easy,
> > we could have e.g. 
> 
> The real answer is to have a filesystem that does the above for you
> for the boot partition, e.g. one where the kernel and grub have
> a common consistency protocol for.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
