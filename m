Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:07:54 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AF7h4p003296
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:07:48 -0700
Date: Mon, 10 Sep 2007 16:07:45 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ensure file size is logged on synchronous writes
Message-ID: <20070910150745.GA16595@infradead.org>
References: <46DB7A60.4050203@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DB7A60.4050203@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 03, 2007 at 01:07:12PM +1000, Lachlan McIlroy wrote:
> Synchronous writes currently log inode changes before syncing
> pages to disk.  Since the file size is updated on I/O completion
> we wont be writing out the updated file size and if we crash the
> file will have the wrong size.  This change moves the logging
> after the syncing of the pages to ensure we log the correct file
> size.

Looks good to me.
