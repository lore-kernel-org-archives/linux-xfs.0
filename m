Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VNANrj130089 for <xfs@OSS.SGI.com>; Mon, 31 Aug 2009 18:10:44 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56626159563F
	for <xfs@OSS.SGI.com>; Mon, 31 Aug 2009 16:10:55 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id h25vINvKGAvklvtB
	for <xfs@OSS.SGI.com>; Mon, 31 Aug 2009 16:10:55 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MiG1M-0007cr-Jq
	for <xfs@OSS.SGI.com>; Mon, 31 Aug 2009 23:10:44 +0000
MIME-Version: 1.0
Message-ID: <19100.22644.149019.555685@tree.ty.sabi.co.uk>
Date: Mon, 31 Aug 2009 23:10:44 +0000
Subject: Re: zero size file after power failure with kernel 2.6.30.5
In-Reply-To: <4A99A80C.9010307@sandeen.net>
References: <200908292102.21710@zmi.at>
	<4A99A80C.9010307@sandeen.net>
From: pg_xf2@xf2.sabi.co.UK (Peter Grandi)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>> Shouldn't it be that this doesn't happen anymore? I'd love to
>> be in a position where I really can rely on a crash not
>> trashing any of my files anymore.

Then 'mount' with '-o sync', or write your own applications and
patches to the GNU/Linux kernel to enforce well known atomicity
and persistence semantics.

This issue as related to several filesystems has been discussed
in great depth over the past several months. Consider reading
and if possible try to understand these contributions:

    http://sandeen.net/wordpress/?p=34
    http://sandeen.net/wordpress/?p=42
    https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/317781/comments/45
    http://lwn.net/SubscriberLink/322823/e6979f02e5a73feb/
    http://loupgaroublond.blogspot.com/2009/03/anecdote-about-why-doing-wrong-thing-is.html
    http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/
    http://mjg59.livejournal.com/108257.html
    http://www.csamuel.org/2009/04/11/default-ext3-mode-changing-in-2630
    http://tribulaciones.org/2009/03/is-ext4-unsafe/

>> I used to have reiserfs previously, and never, not a single
>> time despite many crashes, did I have such an issue. I'd
>> really be pleased so see such stability in XFS. I'm using
>> barriers - what else must I do?

Barriers under GNU/Linux regrettably only enforce ordering. It
is a POSIX weakness. Actual delays/semantics depend on kernel
version.

> this will depend on what kde is doing internally as well.

Unfortunately KDE like most applications is known not to do the
right thing (depending on specific app and version, but most IIRC).

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
