Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33831 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbdAHQnY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 11:43:24 -0500
Date: Sun, 8 Jan 2017 17:43:21 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108164321.GA31687@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com> <20170108145200.GA29570@lst.de> <1483887789.8189.90.camel@linux.vnet.ibm.com> <20170108151430.GA29847@lst.de> <1483889482.8189.104.camel@linux.vnet.ibm.com> <20170108153725.GA30270@lst.de> <1483893506.8189.147.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483893506.8189.147.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, James Morris <jmorris@namei.org>, Andrew Morton <akpm@linux-foundation.org>, David Safford <david.safford@ge.com>

On Sun, Jan 08, 2017 at 11:38:26AM -0500, Mimi Zohar wrote:
> We definitely need VFS help in resolving this regression.  As a last
> resort, we could always update the default IMA builtin policy to exclude
> XFS.

No, you need to explicitly white list file system that are supported,
and most importantly actually tested using an automated tesuite.
