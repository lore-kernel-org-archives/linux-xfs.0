Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:17683 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755948AbcJPV7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 17:59:04 -0400
Date: Mon, 17 Oct 2016 08:28:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: add command line option -M to run as multi
 threaded process
Message-ID: <20161016212839.GB14023@dastard>
References: <1476608111-28948-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476608111-28948-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Oct 16, 2016 at 11:55:11AM +0300, Amir Goldstein wrote:
> xfs_io -M will start by spawning an idle thread.
> The purpose of this idle thread is to test io from a multi threaded
> process. With single threaded process, the file table is not shared
> and file structs are not reference counted.

I can see this option being confusing to those who do not understand
what is actually be done here. i.e. we'll get complaints along the
lines of "-M say xfs_io does multithreaded IO, but I only see IO
from one thread!". Can we name this "-i" to mean "run an idle-loop",
which will stop people trying to use it for something it doesn't do?

> --- a/io/Makefile
> +++ b/io/Makefile
....
> --- a/io/init.c
> +++ b/io/init.c
....

Missing a man page update to document this new option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
