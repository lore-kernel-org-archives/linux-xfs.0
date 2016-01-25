Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 609BB7CA1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 12:24:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED7D0AC002
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:24:45 -0800 (PST)
Received: from legacy.ddn.com (legacy.ddn.com [64.47.133.206]) by cuda.sgi.com
	with ESMTP id rSCYAu6iWwgh8oE5 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:24:44 -0800 (PST)
From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: xfs and swift
Date: Mon, 25 Jan 2016 18:24:42 +0000
Message-ID: <56A66869.3080506@ddn.com>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
In-Reply-To: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
Content-Language: en-US
Content-ID: <66D27453C634284794EC93306E65EF43@ddn.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Seger <mjseger@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>
Cc: Laurence Oberman <loberman@redhat.com>

Hi Mark!

On 01/06/2016 04:15 PM, Mark Seger wrote:
> I've recently found the performance our development swift system is
> degrading over time as the number of objects/files increases.  This is a
> relatively small system, each server has 3 400GB disks.  The system I'm
> currently looking at has about 70GB tied up in slabs alone, close to 55GB
> in xfs inodes and ili, and about 2GB free.  The kernel
> is 3.14.57-1-amd64-hlinux.
> 
> Here's the way the filesystems are mounted:
> 
> /dev/sdb1 on /srv/node/disk0 type xfs
> (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)
> 
> I can do about 2000 1K file creates/sec when running 2 minute PUT tests at
> 100 threads.  If I repeat that tests for multiple hours, I see the number
> of IOPS steadily decreasing to about 770 and the very next run it drops to
> 260 and continues to fall from there.  This happens at about 12M files.
> 
> The directory structure is 2 tiered, with 1000 directories per tier so we
> can have about 1M of them, though they don't currently all exist.

This sounds pretty much like hash directories as used by some parallel
file systems (Lustre and in the past BeeGFS). For us the file create
slow down was due to lookup in directories if a file with the same name
already exists. At least for ext4 it was rather easy to demonstrate that
simply caching directory blocks would eliminate that issue.
We then considered working on a better kernel cache, but in the end
simply found a way to get rid of such a simple directory structure in
BeeGFS and changed it to a more complex layout, but with less random
access and so we could eliminate the main reason for the slow down.

Now I have no idea what a "swift system" is and in which order it
creates and accesses those files and if it would be possible to change
the access pattern. One thing you might try and which should work much
better since 3.11 is the vfs_cache_pressure setting. The lower it is the
less dentries/inodes are dropped from cache when pages are needed for
file data.



Cheers,
Bernd
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
