Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754283AbdDLPQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 11:16:42 -0400
Date: Wed, 12 Apr 2017 08:16:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove custom do_div implementations
Message-ID: <20170412151631.GC6126@infradead.org>
References: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Apr 07, 2017 at 04:42:18PM -0500, Eric Sandeen wrote:
> Long ago, all this gunk was added with a lament about problems
> with gcc's do_div, and a fun recommendation in the changelog:
> 
>  egcs-2.91.66 is the recommended compiler version for building XFS.

heh..

Looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(if the tests run fine..)
