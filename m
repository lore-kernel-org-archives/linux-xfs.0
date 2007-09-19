Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:34:07 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JFXbv0030965
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:33:42 -0700
Date: Wed, 19 Sep 2007 13:03:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] kill unnessecary ioops indirection
Message-ID: <20070919110318.GA3703@lst.de>
References: <20070914162802.GE7110@lst.de> <46EF661C.4030500@sgi.com> <20070918192327.GA24369@lst.de> <46F07E79.8090605@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F07E79.8090605@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Sep 19, 2007 at 11:42:17AM +1000, Lachlan McIlroy wrote:
> >vn_to_inode()/vn_from_inode() are no-ops nowdays, btw.
> Yeah I know - that's why I'd like to get rid of them.  They make the
> code ugly and give the impression we need to work with two different
> objects.  There's lots of places where we declare an extra pointer on
> the stack when we don't need to.  Anyway that's fodder for another
> patch, this patch looks good now.

Yes, eventually we should get rid of them.  I have a patch for the
functions prototypes in xfs_vnodeops.h somewhere, and fixing the dmapi
interface to avoid vnodes is also high on my todo list.
