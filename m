Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBP1qBIp140426 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 19:52:12 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8070812EABED
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 17:52:54 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	MaQLwdyhR7xg6XQh for <xfs@oss.sgi.com>;
	Thu, 24 Dec 2009 17:52:54 -0800 (PST)
Date: Thu, 24 Dec 2009 17:52:34 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <20091224212756.GM21594@thunk.org>
Message-ID: <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
MIME-Version: 1.0
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
To: tytso@mit.edu
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, 24 Dec 2009 at 16:27, tytso@mit.edu wrote:
> If you don't do a "sync" after the tar, then in most cases you will be
> measuring the memory bandwidth, because data won't have been written

Well, I do "sync" after each operation, so the data should be on disk, but 
that doesn't mean it'll clear the filesystem buffers - but this doesn't 
happen that often in the real world too. Also, all filesystem were tested 
equally (I hope), yet some filesystem perform better than another - even 
if all the content copied/tar'ed/removed would perfectly well fit into the 
machines RAM.

> Another good example of well done file system benchmarks can be found
> at http://btrfs.boxacle.net

Thanks, I'll have a look at it and perhaps even integrate it in the 
wrapper script.

> benchmarks for a living.  Note that JFS and XFS come off much better
> on a number of the tests

Indeed, I was surpised to see JFS perform that good and XFS of course is 
one of the best too - I just wanted to point out that both of them 
are strangely slow at times (removing or creating many files) - not what I 
expected.

> --- and that there is a *large* number amount
> of variation when you look at different simulated workloads and with a
> varying number of threads writing to the file system at the same time.

True, the TODO list in the script ("different benchmark options") is in 
there for a reason :-)

Christian.
-- 
BOFH excuse #291:

Due to the CDA, we no longer have a root account.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
