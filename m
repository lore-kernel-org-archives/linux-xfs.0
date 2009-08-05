Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n754Q1TZ215417 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 23:26:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 457C23A732E
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 21:26:50 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ZVH0PA4ppqU0flHe for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 21:26:50 -0700 (PDT)
Message-ID: <4A790A09.8050502@sandeen.net>
Date: Tue, 04 Aug 2009 23:26:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
References: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
In-Reply-To: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
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
To: Chris Samuel <csamuel@vpac.org>
Cc: xfs@oss.sgi.com

Chris Samuel wrote:
> Hi folks,
> 
> I believe we've been hitting the same issue that
> Gabriel Barazer reported in 2.6.28.9 on the 22nd
> of July on our NFS server for our HPC Linux clusters.

...

> This kernel is built with XFS as a kernel module so I've
> been able to attach the objdump output that Eric Sandeen
> had originally requested from Gabriel.

I'll take a look.  The reason for the objdump was to try to work out
where in xfs_rename we were erroring out, but in your case:

xfs_rename+0x5ac/0x5af

I guess it's the trans_cancel at the very end of the function on the
goto <blah>: error cases.

Is there any chance you could instrument xfs_rename so that for every
goto abort_return and goto error_return you add a printk so we know
which one you hit?

Maybe something like:

printk("line %s error %d\n", __LINE__, error);

just before each goto, with appropriate braces {} sprinkled in as necessary?

I can send a patch if that helps.

Sorry for the brute-force debugging but not at all sure yet what this
may be.

Thanks,
-Eric

> Like Gabriel we're stuck on 2.6.28.x as the last working
> NFS exporting XFS kernel due to kernel bug #13375 (the
> radix bug), so I hope this helps!
> 
> cheers,
> Chris
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
