Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 23:18:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K6Imnn028636
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:18:51 -0700
Received: from mgw-mx06.nokia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4E4118D1F8
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:19:36 -0700 (PDT)
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233]) by cuda.sgi.com with ESMTP id Y6p17GP7EdbY6Fxt for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:19:36 -0700 (PDT)
Message-ID: <48326D66.8000106@nokia.com>
Date: Tue, 20 May 2008 09:19:18 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
MIME-Version: 1.0
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
References: <20080520060838.GA6436@lst.de>
In-Reply-To: <20080520060838.GA6436@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Christoph,

Christoph Hellwig wrote:
> Currently touch_atime and file_update_time directly update a/c/mtime
> in the inode and just mark the inode dirty afterwards.  This is pretty
> bad for some more complex filesystems that have various different types
> of dirtying an inode and/or need to store the data in another place
> for example for a buffer to be logged.
> 
> This patch changes touch_atime and file_update_time to not update the
> inode directly but rather call through ->setattr into the filessystem.

This patch would make our (UBIFS develpers') life easier, thank you!

Could we go a further and allow the file-system returning error if it
for some reasons cannot change the time? For example, the FS could
return -EIO or -ENOSPC up and VFS would have to free resources and
propagate this error to user-space. Is this possible?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
