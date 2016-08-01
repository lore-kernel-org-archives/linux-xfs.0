Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D117D7CE3
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:32:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 941608F8033
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:32:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yqNMN5dYEnZrvKdw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:32:09 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:32:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_icache.c:1298]: (style) Redundant condition
Message-ID: <20160801063208.GB15590@infradead.org>
References: <CAMzoamagYyR5x4UWfLb1HZ5zf4ZYQzEpTC8Q-89gd0pA4dTK5g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMzoamagYyR5x4UWfLb1HZ5zf4ZYQzEpTC8Q-89gd0pA4dTK5g@mail.gmail.com>
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
To: David Binderman <linuxdev.baldrick@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dcb314@hotmail.com, xfs@oss.sgi.com

On Mon, Jul 25, 2016 at 04:13:28PM +0100, David Binderman wrote:
> Hello there,
> 
> linux-4.7/fs/xfs/xfs_icache.c:1298]: (style) Redundant condition:
> eofb. '!eofb || (eofb && eofb.eof_scan_owner!=0)' is equivalent to
> '!eofb || eofb.eof_scan_owner!=0'
> 
> Source code is
> 
>    ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
> 
> Maybe better code
> 
>    ASSERT(!eofb || (eofb->eof_scan_owner != 0));

Yes, that would be better.  But it's probably not worth changing
existing code just for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
