Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:51091 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbfDCOI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Apr 2019 10:08:27 -0400
Date: Wed, 3 Apr 2019 16:08:22 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [STABLE PATCH 0/2] Fix in-memory metadata corruption at
 xfs_attr3_leaf_write_verify()
Message-ID: <20190403140822.GH8633@kroah.com>
References: <1554042273-3307-1-git-send-email-alex@zadara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554042273-3307-1-git-send-email-alex@zadara.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadara.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de, shyam@zadara.com

On Sun, Mar 31, 2019 at 05:24:33PM +0300, Alex Lyakas wrote:
> This is a partial backport of original Darrick's series "xfs: logging fixes" to kernel 4.14.
> It fixes the in-memory metadata corruption error, which happens
> when a partially initialized attribute buffer is attemped to be written to disk. 
> This issue is reproducible with kernel 4.14, when adding a 1-sec sleep in xfs_attr_set(),
> between the call to  xfs_attr_shortform_to_leaf() and the call to xfs_attr_leaf_addname().
> 
> Darrick J. Wong (2):
>   xfs: add the ability to join a held buffer to a defer_ops
>   xfs: hold xfs_buf locked between shortform->leaf conversion and the
>     addition of an attribute

What are the git commit ids of these patches in Linus's tree?

thanks,

greg k-h
