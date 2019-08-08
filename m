Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37554 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731038AbfHHHR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 03:17:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id b3so1411538wro.4
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 00:17:27 -0700 (PDT)
Date: Thu, 8 Aug 2019 09:17:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190808071723.532hytasnglsuukf@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
 <20190802151400.GG7138@magnolia>
 <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io>
 <20190805151258.GD7129@magnolia>
 <20190806053840.GH13409@lst.de>
 <20190806120723.eb72ykmukgjejiku@pegasus.maiolino.io>
 <20190806144800.GN7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806144800.GN7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 07:48:00AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 06, 2019 at 02:07:24PM +0200, Carlos Maiolino wrote:
> > On Tue, Aug 06, 2019 at 07:38:40AM +0200, Christoph Hellwig wrote:
> > > On Mon, Aug 05, 2019 at 08:12:58AM -0700, Darrick J. Wong wrote:
> > > > > returned. And IIRC, iomap is the only interface now that cares about issuing a
> > > > > warning.
> > > > >
> > > > > I think the *best* we could do here, is to make the new bmap() to issue the same
> > > > > kind of WARN() iomap does, but we can't really change the end result.
> > > > 
> > > > I'd rather we break legacy code than corrupt filesystems.
> > > 
> > 
> > Yes, I have the same feeling, but this patchset does not have the goal to fix
> > the broken api.
> > 
> > > This particular patch should keep existing behavior as is, as the intent
> > > is to not change functionality.  Throwing in another patch to have saner
> > > error behavior now that we have a saner in-kernel interface that cleary
> > > documents what it is breaking and why on the other hand sounds like a
> > > very good idea.
> > 
> > I totally agree here, and to be honest, I think such change should be in a
> > different patchset rather than a new patch in this series. I can do it for sure,
> > but this discussion IMHO should be done not only here in linux-fsdevel, but also
> > in linux-api, which well, I don't think cc'ing this whole patchset there will do
> > any good other than keep the change discussion more complicated than it should
> > be. I'd rather finish the design and implementation of this patchset, and I'll
> > follow-up it, once it's all set, with a new patch to change the truncation
> > behavior, it will make the discussion way easier than mixing up subjects. What
> > you guys think?
> 
> I probably would've fixed the truncation behavior in the old code and
> based the fiemap-fibmap conversion on that so that anyone who wants to
> backport the behavior change to an old kernel has an easier time of it.
> 

Well, another problem in fixing it in the old code, is that bmap() can't
properly return errors :P
After this patchset, bmap() will be able to return errors, so we can easily fix
it, once we won't need to 'guess' what a zero return mean from bmap()


> But afterwards probably works just as well since I don't feel like tying
> ourselves in more knots over an old interface. ;)
> 
> --D
> 
> > Cheers
> > 
> > 
> > -- 
> > Carlos

-- 
Carlos
