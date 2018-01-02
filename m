Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36970 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbeABKZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 05:25:43 -0500
Received: by mail-wm0-f51.google.com with SMTP id f140so59976160wmd.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2018 02:25:43 -0800 (PST)
Date: Tue, 2 Jan 2018 11:25:39 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Block size and read-modify-write
Message-ID: <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 29, 2017 at 12:14:14AM +0100, Gionatan Danti wrote:
> Hi list,
> I would ask a question: how XFS block size affect read-modify-write in case
> of very small writes?
> 

Hi,

> For example, suppose an XFS filesystem with the default 4K data block size.
> Am I correct saying that:
> - a 512B normal, cached writes will cause a read-modify-write of the entire
> 4K sector?
> - a 512B O_DIRECT write will *not* cause a read-modify-write of the 4K
> sector, rather it will be flushed to disk as-is (512 bytes in length)?
> 

IIRC, although the DIO requirement is to have writes aligned to the logical sector
size, issuing such IOs not properly aligned with the filesystem block size, have
a few consequences.

- It will require exclusive inode io locks, so serializing IOs to the inode
- And yes, it will require a RMW to the block in question, all IO are always
  made in filesystem block size units.

I'm probably missing something else here though, but these two are the things I
had in my mind.

Cheers

> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
