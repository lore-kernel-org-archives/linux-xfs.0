Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GF4X7E165919 for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:04:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F088E918291
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 08:12:39 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ujvMQGhnmdFVqe3a for
	<xfs@oss.sgi.com>; Tue, 16 Jun 2009 08:12:39 -0700 (PDT)
Message-ID: <4A37B496.2060403@sandeen.net>
Date: Tue, 16 Jun 2009 10:04:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_io: fix test for fallocate on 32bit boxes
References: <4A36A448.4060406@sandeen.net>
	<20090616140459.GA24783@infradead.org>
In-Reply-To: <20090616140459.GA24783@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Jun 15, 2009 at 02:43:04PM -0500, Eric Sandeen wrote:
>> xfs_io: fix test for fallocate on 32bit boxes
>>
>> As per Red Hat bug 500487, fallocate64 is missing in glibc,
>> so attempts to build with fallocate and _FILE_OFFSET_BITS=64
>> will fail.
>>
>> So, change the config to test the way we will build, and
>> it'll fail properly on x86 until glibc gets fixed.
> 
> Yikes.  What's the status of actually getting it fixed in glibc?
> Otherwise we might have to switch to the raw syscall as ugly
> as it might be.
> 

>From the bug:

Comment #6 From  Jakub Jelinek (jakub@redhat.com)  2009-06-11 16:40:37 EDT

Unfortunately no, this can't be backported.  The symbol is exported as
@@GLIBC_2.11 symbol, F11 has only glibc 2.10.  If we add a single
GLIBC_2.11 symbol, we'd have to add them all, which means at least wait
until glibc 2.11 is released (in 4-5 months approximately).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
