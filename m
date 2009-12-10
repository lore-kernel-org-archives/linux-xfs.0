Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA7RqXY053977 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:27:54 -0600
Received: from boogie.lpds.sztaki.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B8F0DF31A1
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 23:28:25 -0800 (PST)
Received: from boogie.lpds.sztaki.hu (boogie.lpds.sztaki.hu [193.224.70.237])
	by cuda.sgi.com with ESMTP id 3sLFABURIFda6NSd for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 23:28:25 -0800 (PST)
Date: Thu, 10 Dec 2009 08:28:22 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Message-ID: <20091210072822.GA29161@boogie.lpds.sztaki.hu>
References: <4B204334.1000605@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B204334.1000605@shiftmail.org>
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
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 10, 2009 at 01:39:16AM +0100, Asdo wrote:

> I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6
> array to a 16disk MD-raid 6 array.
> Filesystems are XFS for both arrays.
[...]
> So I have repeatedly catted /proc/pid/stack for the reader and
> writer processes: the *writer* is the bottleneck, and 90% of the
> times it is stuck in one of the following stacktraces:

What does iostat say about the disk utilization during the copy?

IMHO copying a large amount of relatively small files means lots of
metadata operations which in turn means lots of small, scattered writes.
For parity RAID, that kind of load is a killer since writes smaller than
the stripe size will turn into "read all disks - modify the stripe -
write it back".

Use RAID10 if you want good performance for that kind of load.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
