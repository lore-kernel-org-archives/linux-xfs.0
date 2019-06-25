Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYLCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:02:06 -0400
Date: Tue, 25 Jun 2019 04:02:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove unused header files
Message-ID: <20190625110206.GC9601@infradead.org>
References: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 20, 2019 at 08:46:26PM -0500, Eric Sandeen wrote:
> There are many, many xfs header files which are included but
> unneeded (or included twice) in the xfs code, so remove them.
> 
> nb: xfs_linux.h includes about 9 headers for everyone, so those
> explicit includes get removed by this.  I'm not sure what the
> preference is, but if we wanted explicit includes everywhere,
> a followup patch could remove those xfs_*.h includes from
> xfs_linux.h and move them into the files that need them.
> Or it could be left as-is.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Do you have a script testing what includes are needed?

Either way, this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
