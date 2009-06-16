Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GHfPWF171708
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 12:41:25 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE254304092
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:41:46 -0700 (PDT)
Message-Id: <B7C1A222-58C5-4858-80B4-F871BF088DB1@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS Preallocate using ALLOCSP
Date: Tue, 16 Jun 2009 12:41:45 -0500
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
	<4A37B744.9030301@sandeen.net>
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
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
To: Smit Shah <getsmit@gmail.com>
Cc: linux-xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>


On Jun 16, 2009, at 12:28 PM, Smit Shah wrote:

> Yeah rite what i meant to say was that posix_fallocate uses ftruncate
> which in turn just updates the i_size and then posix_fallocate zeros
> out the whole thing

I didn't look at the libc implementation, but it seems
strange to use ftruncate here at all. Is it more efficient
to write zeros into a hole than appending to a file?

[snip]

> Just to see if preallocation using fallocate helps reducing the
> fragmentation and increases the throughput.  I guess it wll help
> reduce the fragmentation

... and as result read performance on such files.

> but the write performance is going to suffer.

It's not clear why it should. Not doing preallocation doesn't
mean that there is no inode updates with every write. Why
would extent conversion be more expensive that creating the
space (extent) and updating the inode size for every write?
It'd interesting to reproduce your results. Any details on
your tests and the iometer usage?

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
