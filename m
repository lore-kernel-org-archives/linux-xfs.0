Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33957 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757131AbdEGWb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 18:31:27 -0400
Received: by mail-ua0-f182.google.com with SMTP id g49so31647209uaa.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 May 2017 15:31:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170502073501.GB6679@infradead.org>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap> <20170502073501.GB6679@infradead.org>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Sun, 7 May 2017 11:00:40 +0300
Message-ID: <CAOcd+r3VYuLaCq6g3YH_ue_7AhPfjfVUHJVmn1S=vFOtEMuZag@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

Hi Christoph,

>> We have an XFS instance mounted as "sync"
>> (rw,sync,noatime,wsync,attr2,discard,inode64,prjquota 0 0). This instance is
>> exposed via nfsd. Size is about 50TB.
>
> Don't use the sync option ever.  In fact we probably should remove it.
We are using the sync mount option, because the XFS instances that we
have are exposed via nfsd. Without the "sync" mount option, data from
NFS write command would end up sitting in page cache, and the nfs
client would not know when it has been finally persisted on disk.
Is the any other way that you can recommend to provide data integrity
guarantee for nfs clients? Even if it requires some development, like
placing the data in a short-term persistent space, this is something
we will look at.

Thanks,
Alex.
