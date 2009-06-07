Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57IR5pe183381
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 13:27:06 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FF14AC00A
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 11:27:22 -0700 (PDT)
Message-Id: <1641C8DC-0F15-4085-9A01-4B86E8B4BF6C@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <h0gtcd$136u$1@osprey.mgras.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 13:27:20 -0500
References: <20090520003745.GA27491@samad.com.au>
	<20090604112657.GA10738@infradead.org>
	<h0gtcd$136u$1@osprey.mgras.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Spott <Martin.Spott@mgras.net>
Cc: linux-xfs@oss.sgi.com


On Jun 7, 2009, at 12:28 PM, Martin Spott wrote:

> Hi Christoph,
>
> Christoph Hellwig wrote:
>
>> Sorry guys, still haven't been able to track it down.  Any chance one
>> of you could run with CONFIG_XFS_DEBUG enabled and see if it trips
>> over any of the asserts?
>
>  "Say N unless you are an XFS developer, or you play one on TV."

Or unless you're told by an XFS developer :)

>
>
> Very nice  ;-)
>
> I'm have to regret that I'm neither an XFS developer nor do I pretend
> to be one. Yet, as I understand, I should see at least _some_ debug
> info via 'dmesg', if there is any. Apparently the kernel is now having
> XFS with debugging enabled:
>
> Jun  7 18:53:33 isnix1 kernel: SGI XFS with ACLs, security  
> attributes, large block/inode numbers, debug enabled
> Jun  7 18:53:33 isnix1 kernel: SGI XFS Quota Management subsystem
> Jun  7 18:53:33 isnix1 kernel: XFS mounting filesystem cciss/c0d0p2
> [...]
>
>
> ....  but aside from the well-known messages as:
>
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery
> directory
> NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
> NFSD: starting 90-second grace period
> reconnect_path: npd != pd
> reconnect_path: npd != pd
> reconnect_path: npd != pd
> [...]
>
>
> ....  I'm unable to find any helpful information in this context.

Have you already reproduced the crash with the debug kernel?
The xfs debug module would not necessarily produce the verbose log.
It does, however, have many asserts, which would crash much earlier
and provide more hints as to the reasons to your original crash.

> Anything I could try - this sunday evening ?

If you haven't tried to reproduce the panic, try it now.

Good luck!
Felix

>
>
> Cheers,
> 	Martin.
> -- 
> Unix _IS_ user friendly - it's just selective about who its friends  
> are !
> --------------------------------------------------------------------------
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
