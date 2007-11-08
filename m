Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 15:29:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA8NTIRM001191
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 15:29:21 -0800
Date: Fri, 09 Nov 2007 10:29:28 +1100
Subject: Re: xfs_repair 2.9.4 threading/progress info missing?
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <c7e221f6ec9555fa9789a67e7307f904@loreland.org>
Message-ID: <op.t1hx7ebt3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <c7e221f6ec9555fa9789a67e7307f904@loreland.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Braid <jamesb@loreland.org>, xfs@oss.sgi.com

On Thu, 08 Nov 2007 22:27:09 +1100, James Braid <jamesb@loreland.org>  
wrote:

>
> I just upgraded to xfsprogs 2.9.4 and it seems the multi-threading and
> progress information is no longer being reported?
>
> 2.8.18:
>         - creating 8 worker thread(s)
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>
> 2.9.4:
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
>
> Have I just mis-compiled something? The progress information in  
> particular
> was REALLY useful on our bigger filesystems.

Hi,

It is sort of still there. With the performance improvements
in 2.9.4, the multithreading implementation was changed and
hidden from the user. A side effect of this change was the
progress info is now only visible when using the ag_stride
option. Depending on your drive layout, ag_stride may speed
up repair even further, especially concats. With other layouts,
try "-o ag_stride=1". I found on one of our RAIDs, that
actually doubled doubled the repair performance on a 5 way
stripe.

Progress info for normal runs will be reintroduced in the
near future and other output will be cleaned up a tad.

Regards,
Barry.
