Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbfHBPQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 11:16:22 -0400
Date: Fri, 2 Aug 2019 08:14:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190802151400.GG7138@magnolia>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 11:19:39AM +0200, Carlos Maiolino wrote:
> Hi Darrick.
> 
> > > +		return error;
> > > +
> > > +	block = ur_block;
> > > +	error = bmap(inode, &block);
> > > +
> > > +	if (error)
> > > +		ur_block = 0;
> > > +	else
> > > +		ur_block = block;
> > 
> > What happens if ur_block > INT_MAX?  Shouldn't we return zero (i.e.
> > error) instead of truncating the value?  Maybe the code does this
> > somewhere else?  Here seemed like the obvious place for an overflow
> > check as we go from sector_t to int.
> > 
> 
> The behavior should still be the same. It will get truncated, unfortunately. I
> don't think we can actually change this behavior and return zero instead of
> truncating it.

But that's even worse, because the programs that rely on FIBMAP will now
receive *incorrect* results that may point at a different file and
definitely do not point at the correct file block.

Note also that the iomap (and therefore xfs) implementation WARNs on
integer overflow and returns 0 (error) to prevent an incorrect access.

--D

> > --D
> > 
> > > +
> > > +	error = put_user(ur_block, p);
> > > +
> > > +	return error;
> > >  }
> > >  
> > >  /**
> > > -- 
> > > 2.20.1
> > > 
> 
> -- 
> Carlos
