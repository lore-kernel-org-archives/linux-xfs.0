Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35LbiMp076077 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 16:37:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	g8dEqhjK6FXy29zE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 14:37:41 -0700 (PDT)
Date: Thu, 5 Apr 2012 17:37:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120405213740.GA22824@infradead.org>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: xfs@oss.sgi.com

Hi Stefan,

thanks for the detailed report.

The seekwatcher makes it very clear that XFS is spreading I/O over the
4 allocation groups, while ext4 isn't.   There's a couple of reasons why
XFS is doing that, including to max out multiple devices in a
multi-device setup, and not totally killing read speed.

Can you try a few mount options for me both all together and if you have
some time also individually.

 -o inode64

	This allows inodes to be close to data even for >1TB
	filesystems.  It's something we hope to make the default soon.

 -o filestreams

	This keeps data written in a single directory group together.
	Not sure your directories are large enough to really benefit
	from it, but it's worth a try.

 -o allocsize=4k

	This disables the agressive file preallocation we do in XFS,
	which sounds like it's not useful for your workload.

> I ran the tests with a current RHEL 6.2 kernel and also with a 3.3rc2
> kernel. Both of them exhibited the same behavior. The disk hardware
> used was a SmartArray p400 controller with 6x 10k rpm 300GB SAS disks
> in RAID 6. The server has plenty of RAM (64 GB).

For metadata intensive workloads like yours you would be much better
using a non-striping raid, e.g. concatentation and mirroring instead of
raid 5 or raid 6.  I know this has a cost in terms of "wasted" space,
but for IOPs bound workload the difference is dramatic.


P.s. please ignore Peter - he's made himself a name as not only beeing
technically incompetent but also extremly abrasive.  He is in no way
associated with the XFS development team.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
