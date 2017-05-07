Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42077 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdEHBL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 21:11:58 -0400
Date: Sun, 7 May 2017 02:12:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Message-ID: <20170507091209.GA6102@infradead.org>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
 <20170502073501.GB6679@infradead.org>
 <CAOcd+r3VYuLaCq6g3YH_ue_7AhPfjfVUHJVmn1S=vFOtEMuZag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r3VYuLaCq6g3YH_ue_7AhPfjfVUHJVmn1S=vFOtEMuZag@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sun, May 07, 2017 at 11:00:40AM +0300, Alex Lyakas wrote:
> We are using the sync mount option, because the XFS instances that we
> have are exposed via nfsd. Without the "sync" mount option, data from
> NFS write command would end up sitting in page cache, and the nfs
> client would not know when it has been finally persisted on disk.
> Is the any other way that you can recommend to provide data integrity
> guarantee for nfs clients? Even if it requires some development, like
> placing the data in a short-term persistent space, this is something
> we will look at.

You don't need any mount option for NFS exports.  Only NFSv2 requires
symchronous writes, while NFS3+ have the concept of unstable writes
that the client needs to explicitly committ using the COMMIT on the
write operation.  Both the NFSv2 synchronous and the NFSv3+ unstable
semantics are managed by NFSD.

(I'll speak here as a XFS and NFSD developer, and someone involved in
NFS protocol development, just in case you're doubting)

> 
> Thanks,
> Alex.
---end quoted text---
