Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 23:27:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K6RbiC030193
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:27:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 825A911900DA
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:28:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id CGKT2T0g3By21ufA for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:28:26 -0700 (PDT)
Date: Tue, 20 May 2008 08:28:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
Message-ID: <20080520062815.GA8324@lst.de>
References: <20080520060838.GA6436@lst.de> <48326D66.8000106@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48326D66.8000106@nokia.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 20, 2008 at 09:19:18AM +0300, Artem Bityutskiy wrote:
> Could we go a further and allow the file-system returning error if it
> for some reasons cannot change the time? For example, the FS could
> return -EIO or -ENOSPC up and VFS would have to free resources and
> propagate this error to user-space. Is this possible?

->setattr and notify_change already return errors, so we just need to
propagate them one level further.  Feel free to send a patch.
