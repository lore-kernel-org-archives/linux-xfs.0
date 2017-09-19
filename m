Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38595 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdISON6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 10:13:58 -0400
Date: Tue, 19 Sep 2017 07:13:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170919141358.GA4202@infradead.org>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918175651.GA7937@infradead.org>
 <20170919081538.mk23eue6dysv67b2@rh_laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919081538.mk23eue6dysv67b2@rh_laptop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

On Tue, Sep 19, 2017 at 10:15:38AM +0200, Lukas Czerner wrote:
> On Mon, Sep 18, 2017 at 10:56:51AM -0700, Christoph Hellwig wrote:
> > This seems to miss any explanation and 6 out of 7 patches.
> 
> See linux-fsdevel for entire patch set.
> https://www.spinics.net/lists/linux-fsdevel/msg115740.html

But only one made it to linux-xfs, so please fix your patch sending.

> (f)pathconf on it's own is useless because I need to get this
> information directly from the file system. Supported fallocate modes can
> differ with inode flags (encrypted files, extent/indirect based files on
> ext4). I also need in-kernel interface.

And that is exactly what I want you to do:  finally bite the bullet
and add pathconf inode operation.
