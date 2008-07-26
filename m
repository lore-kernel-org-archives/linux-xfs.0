Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:13:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9DSVb020498
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:13:28 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 164FF331B84
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:14:38 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id kKgXCOSCjGXgd7qf for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:14:38 -0700 (PDT)
Date: Sat, 26 Jul 2008 11:14:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] stop using file_update_time
Message-ID: <20080726091428.GA29710@lst.de>
References: <20080726063339.GC22603@lst.de> <20080726091348.GT5947@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726091348.GT5947@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 07:13:48PM +1000, Dave Chinner wrote:
> I don't think you meant to remove the xfs_ichgtime() prototype
> as well...

Actually I did, but I forgot to mention why.  There's a second prototype
in xfs_inode.h which is enough.
