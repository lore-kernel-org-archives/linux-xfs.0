Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQJBNM7011189 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 13:11:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B67844AD90
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 11:11:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Kx1YEMHniGBlFkvG for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 11:11:22 -0800 (PST)
Date: Fri, 26 Dec 2008 04:07:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
	raid[156]
In-Reply-To: <A20315AE59B5C34585629E258D76A97C031B2765@34093-C3-EVS3.exchange.rackspace.com>
Message-ID: <alpine.DEB.1.10.0812260401550.24520@p34.internal.lan>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
	<A20315AE59B5C34585629E258D76A97C031B2765@34093-C3-EVS3.exchange.rackspace.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, smartmontools-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Thu, 25 Dec 2008, David Lethe wrote:

>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>
>> Other options?
>>
>> How do others maintain data integrity?  Just not worry about it until
>> you have
>> to, rely on backups.. or?
>>
>> Justin.
>
> 4GB files using gpg and tar in the '90s?
Sorry, to clarify they were ~650-700MiB tars but combined to around a ~4GiB
file later on (from the late 90s), CD's were cheap and yeah 2GiB limit.  But
later on to consolidate I moved them to 4GiB DVDs and thus tarred them together
and then gpg on top of that.

> I know gpg had 2GB file-related bugs as late as 2005 that caused corruption, and
> there was a heck of a lot of 2GB-related bugs in 2.2 and 2.4 kernels which you
> must have been running back then.  You are also using later versions of these
> programs on the new systems, and I'd be willing to bet they compound the problem by
> assuming there was no corruption to begin with.
Once I restored the data from DVDs, I was able to restore *all* data 
successfully.

>
> I use:
> - gzipped tar archives, but I gzip the individual files, rather than the tarball. That way
> any compression-related bugs are limited to a single file. I copy them to DVDs.
That works as well, but are they your regular files gzipped, no encryption?

>
> - For online/nearline, I now use a ZFS, but on a native Solaris system that functions as my primary
> NFS/CIFS/iSCSI server with and a ZFS software-RAID based file system.   I am profoundly impressed with
> it, and when they release the deduplication enhancement for ZFS, I'll adopt it and won't have to buy
> any more DVDs, except for offsite archiving purposes.
Wow, I did not know ZFS had plans for de-dupe!! I will have to look into this,
thanks for the info.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
