Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731532AbeGQOa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 10:30:28 -0400
Date: Tue, 17 Jul 2018 06:57:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
Message-ID: <20180717135741.GA9086@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
 <20180711130825.dkreolul3mlvtf3b@odin.usersys.redhat.com>
 <2e421e56-7463-3ac1-2eac-fa72ee8cd3eb@oracle.com>
 <fd877bb3-641f-b70c-a40e-e4287339ed53@oracle.com>
 <20180712013147.GK32415@magnolia>
 <e70ed6e4-a889-87ac-d25c-db2abc0e61a1@oracle.com>
 <20180712090858.u4aodoaf7nmhe3dt@odin.usersys.redhat.com>
 <3ed378e1-8ef3-ddff-7d5f-adf3be6abda8@oracle.com>
 <20180713123955.xbdleb3crazkjnt3@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713123955.xbdleb3crazkjnt3@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jul 13, 2018 at 02:39:55PM +0200, Carlos Maiolino wrote:
> Did we? I couldn't find any interface, design, or whatever saying that userspace
> can safely assume a zero block file don't have data there and can be ignored,
> in fact, the link I posted previously already shows how tar people were not sure
> if they should assume a zero block file could be ignored. So, in fact, we didn't
> break anything, because as far as I know, nobody and no standard said an
> existing zero block file could be safely ignored, assuming it contains no data
> at all. Such thing might exist, but I'm not aware of.

You are right that there is no interface.  But breaking existing
userspace simply isn't an option either, especially when it could
lead to data loss and corruption.
