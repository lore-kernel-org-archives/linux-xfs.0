Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7390A7F6C
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 01:37:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4458D304048
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 23:37:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MauYT5eGtNp99byq for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 23:37:40 -0700 (PDT)
Date: Tue, 21 Jul 2015 16:37:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: useless code blocks
Message-ID: <20150721063738.GA7943@dastard>
References: <2035333009.511763.1437398166766.JavaMail.zimbra@redhat.com>
	<1213913978.543970.1437400666553.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1213913978.543970.1437400666553.JavaMail.zimbra@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 20, 2015 at 09:57:46AM -0400, Jan Tulak wrote:
> Hi all,
> 
> I found these useless bits of code in xfsprogs:
> 
> repair/incore_ino.c:575-576: 
> if (ino_rec->ino_startnum == 0)
>   ino_rec = ino_rec;
> 
> This one is pretty clear. It is there since 2001 (commit 2bd0ea187 
> by nathans@sgi.com, who didn't wrote here since 2006, so I find 

nathans@redhat.com will get you that same person ;)

> CC-ing him useless). It looks like a forgotten code which doesn't 
> do anything, but I ask in case it is a hidden bug.

Who knows? It came from the Irix code base by the look of it, so
maybe it was just working around a compiler bug?

> And:
> 
> db/check.c:3035, 3037: Always true expression, as be32_to_cpu() 
> translates to __u32 type and unsigned can't be less than zero.
> 
> be32_to_cpu(free->hdr.nvalid) < 0 ||

The old endian conversion stuff in userspace needed that. When we
converted it to the same as the kernel macros, we didn't change any
of the logic. gcc isn't warning about this on x86-64, so in general
signed/unsigned stuff goes unnoticed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
