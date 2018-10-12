Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48629 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbeJLPxN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Oct 2018 11:53:13 -0400
Date: Fri, 12 Oct 2018 10:21:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on
 unsupported devices
Message-ID: <20181012082154.GB30154@lst.de>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net> <20181011103636.GC9467@quack2.suse.cz> <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com> <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Oct 11, 2018 at 01:38:34PM -0500, Eric Sandeen wrote:
> > The different behavior between filesystems was confusing customers so
> > we had to align them, then the question was which default to pick.
> > Honestly, we came to the decision to bring ext4 in line with the xfs
> > behavior because we thought that would be easier than the alternative.
> > Dave and Christoph made repeated arguments that DAX is just a hidden
> > performance optimization that no application should rely on, so we
> > went the path of least resistance and changed the ext4 default.
> 
> Ok, well, I guess we'd better reconcile "it's a hidden performance hint"
> with "if the administrator asked they must receive..." before making this
> change... cc: hch for bonus input.

I don't really care too mouch on the mount options, the important bit
was the application behavior.

I fully agree with Dan that we should have the same behavior for every
file system, though.
