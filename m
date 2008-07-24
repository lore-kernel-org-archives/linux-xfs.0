Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 04:45:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6OBj7g4019883
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:45:07 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7E48328358
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:46:18 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DP3lpiYVKE1FHibD for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:46:18 -0700 (PDT)
Date: Thu, 24 Jul 2008 21:46:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080724114610.GX6761@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <20080723204927.GB8421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723204927.GB8421@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 04:49:27PM -0400, Christoph Hellwig wrote:
> Btw, does anyone have recent gcov data for XFS?

Last time I checked (not recent) xfsqa covered about 70% of XFS with
default mkfs and mount options. The code has changed a lot since
then and there's been quite a few additional tests added, so I've
got no idea right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
