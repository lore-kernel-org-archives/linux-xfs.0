Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeGHPpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:45:21 -0400
Date: Sun, 8 Jul 2018 08:45:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 4/8] xfs: implement inline data read write code
Message-ID: <20180708154520.GB8625@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-5-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-5-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:25AM +0800, Shan Hai wrote:
> Implement read/write functions for inline data access and use them
> for buffered/DIO/DAX operations.

Please use the iomap inline handling in this branch instead of
implementing it in XFS:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=iomap-4.19-merge

It seems like your code doesn't use the page cache for inline data
at the moment, which means you'd want to always use the direct I/O
version of the code as-is.

Althought that makes me wonder how you handle memory mapped I/O, but
I guess I'll find out later.
