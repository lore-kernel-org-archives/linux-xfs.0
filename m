Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53269 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFFio (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 01:38:44 -0400
Date: Tue, 6 Aug 2019 07:38:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190806053840.GH13409@lst.de>
References: <20190731141245.7230-1-cmaiolino@redhat.com> <20190731141245.7230-5-cmaiolino@redhat.com> <20190731231217.GV1561054@magnolia> <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io> <20190802151400.GG7138@magnolia> <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io> <20190805151258.GD7129@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805151258.GD7129@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Mon, Aug 05, 2019 at 08:12:58AM -0700, Darrick J. Wong wrote:
> > returned. And IIRC, iomap is the only interface now that cares about issuing a
> > warning.
> >
> > I think the *best* we could do here, is to make the new bmap() to issue the same
> > kind of WARN() iomap does, but we can't really change the end result.
> 
> I'd rather we break legacy code than corrupt filesystems.

This particular patch should keep existing behavior as is, as the intent
is to not change functionality.  Throwing in another patch to have saner
error behavior now that we have a saner in-kernel interface that cleary
documents what it is breaking and why on the other hand sounds like a
very good idea.
