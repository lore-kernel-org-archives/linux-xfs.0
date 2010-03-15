Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFK7BH059002 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:20:08 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDEFE1D335DC
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:21:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id L7vtnSbr2BxlBlul for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:21:42 -0700 (PDT)
Date: Mon, 15 Mar 2010 11:21:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
	assfail+0x1b/0x20 SS:ESP 0068:f687bf14
In-Reply-To: <20100315151136.GA1401@infradead.org>
Message-ID: <alpine.DEB.2.00.1003151112330.22155@p34.internal.lan>
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan>
	<4B9E46F9.8090209@sandeen.net>
	<alpine.DEB.2.00.1003151042390.9496@p34.internal.lan>
	<4B9E4863.80905@sandeen.net> <20100315151136.GA1401@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Mon, 15 Mar 2010, Christoph Hellwig wrote:

> On Mon, Mar 15, 2010 at 09:46:59AM -0500, Eric Sandeen wrote:
>> Ok, then you hit an ASSERT_ALWAYS
>>
>> There are only a few:
>
> If the box is a nfs server I suspect it's a reclaimable state one and
> the patch below should help:

Hello,

The host is not running an NFS server actively, the option may be 
compiled in but it is not 'acting' as an NFS server/has shares exported. I
need stability for this specific host, I cannot run netconsole due to
restrictions etc/will switch to ext4 since, if it recurs again, all I/O to 
the disk stops and I will not be able to assist in reporting the 
bug/giving the full output.  If I could reproduce the bug in another 
environment, I would be able to troubleshoot the problem more..  This bug 
is very similar to the one I reported in the past (that host was an active 
NFS server):
http://lists.openwall.net/linux-kernel/2009/10/19/118

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
