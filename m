Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 14:42:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0UMfxqw013748
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 14:42:01 -0800
Message-ID: <45BFC99A.9050009@sandeen.net>
Date: Tue, 30 Jan 2007 16:41:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf
References: <20070130173227.GA6017@m.safari.iki.fi>
In-Reply-To: <20070130173227.GA6017@m.safari.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>

Sami Farin wrote:
> I setup namespace for /tmp and /var/tmp 
> ( pam_namespace.so into /etc/pam.d/{su,login} )
> and something did not like something I did:
> 
> [322593.844838] 0x0: 00 00 00 00 2b 00 00 11 20 21 00 00 00 68 ff ff 
> [322593.844854] Filesystem "sda8": XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc0230808
...
> sda8 is /usr , I haven't played with mount --bind or namespaces
> at /usr (AFAIK).
> 
> My sda hard disk is not broken and I have SMP kernel 2.6.19.2 + Pentium D.
> I have got no other BUGs or xfs errors and I can access /usr and other
> partitions OK.
> 

I'd try xfs_repair.  The error above means xfs read something unexpected
for metadata, which did not match the magic numbers it was expecting.  I
suppose the error message could be more informative in that regard...

The buffer it read contained this at the beginning:

0x0: 00 00 00 00 2b 00 00 11 20 21 00 00 00 68 ff ff

but I'm not sure that offers any real insight.

-Eric
