Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:50701 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbdIYJdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 05:33:23 -0400
Received: by mail-wm0-f48.google.com with SMTP id b195so17519359wmb.5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 02:33:22 -0700 (PDT)
Date: Mon, 25 Sep 2017 11:33:19 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Capture state of the right inode in xfs_iflush_done
Message-ID: <20170925093319.vjtr554e4ey3lp5y@hades.localdomain>
References: <20170922113555.17711-1-cmaiolino@redhat.com>
 <20170922143216.GA17593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922143216.GA17593@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 02:32:16PM +0000, Christoph Hellwig wrote:
> Oops, yes this fix looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I wish we could clean this up a bit by making li_bio_list a
> real list_head, and then factoring the loop into a helper so that
> lip isn't even in scope..

Sounds good, Adding it to my todo list.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
