Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 771907F78
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 02:26:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62655304051
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 00:26:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RDQnsJfFZKfpE8a2 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 00:26:54 -0700 (PDT)
Date: Thu, 25 Sep 2014 17:26:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140925072640.GF4758@dastard>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140924162507.GC27000@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-api@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> On Wed 24-09-14 22:04:30, Li Xi wrote:
> > This patch adds ioctl interface for setting/getting project of ext4.
>   The patch looks good to me. I was just wondering whether it won't be
> useful to add an ioctl() which isn't ext4 specific. We could just extend
> ->setattr() to allow setting of project ID (most filesystems would just
> return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> ->setattr from the generic ioctl. That way userspace won't have to care
> about filesystem type when setting project ID... What do others think?

I've repeatedly said that these ext4 project ID patches should
implement the same interfaces as XFS rather than creating a new set
of incompatible, ext4 specific interfaces to do implement the same
functionality.

There is no good reason for forcing userspace to re-invent tools
that already exist just to manage identical functionality in
different filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
