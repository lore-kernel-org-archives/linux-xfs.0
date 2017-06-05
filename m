Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49471 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751239AbdFEPKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2017 11:10:22 -0400
Date: Mon, 5 Jun 2017 17:09:37 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: request for inclusion of 2 xfs patches
Message-ID: <20170605150937.GB26743@kroah.com>
References: <89781cfb-b826-8d01-d054-f70b0e2d8439@suse.com>
 <d4f07925-a558-cf4a-fd1f-b570d17ffd12@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f07925-a558-cf4a-fd1f-b570d17ffd12@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org, sandeen@sandeen.net, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, May 29, 2017 at 12:28:19PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.05.2017 12:27, Nikolay Borisov wrote:
> > Hello, 
> > 
> > I'd like to request the following two patches to be 
> > included in 4.4 stable: 
> > 
> > 0facef7fb053 ("xfs: in _attrlist_by_handle, copy the cursor back to userspace")
> > 
> > 2a6fba6d2311 ("xfs: only return -errno or success from attr ->put_listent")
> > 
> > The fix a failure in xfstest/269 and also enable the xfs' XFS_IOC_ATTRLIST_BY_HANDLE
> > ioctl to function properly. The first commit applies cleanly, whereas the second has 
> > a minor conflict due t spacing. Backport is attached. 
> > 
> 
> Please omit my Acked-by tagged when applying the backport

Heh, now done, both queue up, thanks.

greg k-h
