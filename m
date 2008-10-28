Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 20:00:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S30kAV003308
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 20:00:46 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C35C854F99D
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 20:00:46 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id mk6syfa1bySI7BbO for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 20:00:46 -0700 (PDT)
Date: Tue, 28 Oct 2008 14:00:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] use inode_change_ok for setattr permission checking
Message-ID: <20081028030040.GP4985@disturbed>
References: <20081027133640.GD761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133640.GD761@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:36:40AM -0400, Christoph Hellwig wrote:
> Instead of implementing our own checks use inode_change_ok to check for
> nessecary permission in setattr.  There is a slight change in behaviour
  ^^^^^^^^^
necessary

> as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
> without superuser privilegues while the old XFS code just stripped away
> those bits from the file mode.

Better to get an error than silently lose them, I think.

> (First sent on Semptember 29th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
