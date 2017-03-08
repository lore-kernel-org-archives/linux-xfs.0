Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52493 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdCHQJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 11:09:25 -0500
Date: Wed, 8 Mar 2017 07:56:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Significantly longer fallocate times with Flag Unwritten Extents
 disabled
Message-ID: <20170308155602.GE4353@infradead.org>
References: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill McDuck <billmcdave@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 06, 2017 at 12:02:01PM +0000, Bill McDuck wrote:
> Hello.
> 
> I have been testing the performance of XFS with "Flag Unwritten
> Extents" enabled and disabled.

Why do you disable it?  It's been part of the defauly on feature
set for a decade, and manually disabling it will make you run into
completely untested code.  There is a reason it's mandatory for v5
file systems.

> 
> For security reasons I know XFS flags all unwritten extents by
> default, so that uninitialized disk space cannot be read by the user.
> In my application I actually want to have access to this uninitialized
> disk space. I have been modifying the superblocks using xfs_repair to
> enable this functionality.

Don't do that, it's not supported for a reason.
