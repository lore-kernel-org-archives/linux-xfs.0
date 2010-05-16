Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4GNUWAL210137 for <xfs@oss.sgi.com>; Sun, 16 May 2010 18:30:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 096B7149731D
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 16:33:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	p9lo72COatGt1wAh for <xfs@oss.sgi.com>;
	Sun, 16 May 2010 16:33:40 -0700 (PDT)
Date: Mon, 17 May 2010 09:32:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs didn't provide redundancy for citical data structure?
Message-ID: <20100516233243.GH8120@dastard>
References: <AANLkTimP06rpMX4BRaRIggMctQ2qR7Cul9yqcJR6Xj3O@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimP06rpMX4BRaRIggMctQ2qR7Cul9yqcJR6Xj3O@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, May 15, 2010 at 11:57:51PM +0800, hank peng wrote:
> I read this paper: http://pages.cs.wisc.edu/~vshree/xfs.pdf, which
> says xfs didn't provide redundancy for citical data structure, such as
> mirror, parity. I wonder if it is so?
> If it is, is there plan to implement that for XFS developers?

XFS assumes redundancy and protection against bit errors is done in
the block layeri (i.e. RAID of some kind). Changing that assumption
takes a lot of work and involves modifying the disk format, so can't
be done overnight. That being said, work is in progress to make XFS
more robust - see this page for ideas on how we are approaching the
problem:

http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption

I'll also point out that the above paper makes some fundamental
mistakes (e.g. XFS does not use "data=ordered" journalling as they
conclude it does from a limited observation). Hence the rest of
their results are somewhat questionable, too, as we can't examine
them closely enough to confirm or deny them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
