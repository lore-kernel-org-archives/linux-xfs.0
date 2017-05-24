Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:49260 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932442AbdEXRut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 13:50:49 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <8eb6b192-50fa-d283-3aa6-59bf75dde8b8@sandeen.net>
 <d8ac124743a86de83e57a89f3f95b400@assyoma.it>
 <20170524073812.h7fzmdyhdtzf7sew@eorzea.usersys.redhat.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <572fee65-3530-e111-f991-4bdd42749da5@assyoma.it>
Date: Wed, 24 May 2017 19:50:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170524073812.h7fzmdyhdtzf7sew@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it



On 24/05/2017 09:38, Carlos Maiolino wrote:
> 
> If the application don't deal with the I/O errors, and ensure its data is
> already written, what difference a RO fs will do? :) the application will send a
> write request, the filesystem will deny it (because it is in RO), and the
> application will not care :)

Maybe I am wrong, but a read only filesystem guarantee that *no other 
data modifications* can be done, effectively freezing the volume.

With a full thin pool, XFS will continue to serve writes for already 
allocated chunks, but will reject writes for unallocated ones. I think 
this can lead to some inconsistencies, for example:
- this part of a file was updated, that one failed - but nobody noticed;
- a file was copied, but its content was lost due to data writeout 
failing and no fsyncs (and filemanagers often do *exactly* this);
- having two files, this file was updated, that other failed;
- writing to a file, its size is updated (not only apparent size, but 
real/allocated one also) but data writeout fails. In this case, reading 
the file over the unallocated space returns EIO, but you need to *read 
all data* until EIO to realize that the file has some serious problem.

In all these cases, I feel that a "shutdown the filesystem at the first 
data writeout problem" command can save the day. Even better would be a 
"put the filesystem in read only mode".

True, a well bahaved application should issue fsync() and check the I/O 
errors, but many applications don't do that. Hence I was asking if XFS 
can be suspended/turned-off.

Maybe I'm rising naive problems - after all, a full filesystem will 
behave somewhat similarly in at least some cases. However, from 
linux-lvm mailing list I understand that a full thin pool is *not* 
comparable to a full filesystem, right?

Thanks.


-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
