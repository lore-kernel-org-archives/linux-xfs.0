Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38249 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387876AbfHBJTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 05:19:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so76409297wrr.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 02:19:42 -0700 (PDT)
Date: Fri, 2 Aug 2019 11:19:39 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731231217.GV1561054@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

Hi Darrick.

> > +		return error;
> > +
> > +	block = ur_block;
> > +	error = bmap(inode, &block);
> > +
> > +	if (error)
> > +		ur_block = 0;
> > +	else
> > +		ur_block = block;
> 
> What happens if ur_block > INT_MAX?  Shouldn't we return zero (i.e.
> error) instead of truncating the value?  Maybe the code does this
> somewhere else?  Here seemed like the obvious place for an overflow
> check as we go from sector_t to int.
> 

The behavior should still be the same. It will get truncated, unfortunately. I
don't think we can actually change this behavior and return zero instead of
truncating it.

> --D
> 
> > +
> > +	error = put_user(ur_block, p);
> > +
> > +	return error;
> >  }
> >  
> >  /**
> > -- 
> > 2.20.1
> > 

-- 
Carlos
