Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ECW4n9092459 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 06:32:04 -0600
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.31.38]) by cuda.sgi.com with ESMTP id 3GKfmIO0KcEDZcRg
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 04:32:03 -0800 (PST)
Message-ID: <4F3A5440.409@cape-horn-eng.com>
Date: Tue, 14 Feb 2012 13:32:00 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120214000924.GF14132@dastard>
In-Reply-To: <20120214000924.GF14132@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave, hi list,

first thanks for the very detailed reply. Please find below my comments
and questions.

On 02/14/2012 01:09 AM, Dave Chinner wrote:
> On Mon, Feb 13, 2012 at 05:57:58PM +0100, Richard Ems wrote:
>> I am running openSUSE 12.1, kernel 3.1.9-1.4-default. The 20 TB XFS
>> partition is 100% full
> =

> Running filesystems to 100% full is always a bad idea - it causes
> significant increases in fragementation of both data and metadata
> compared to a filesystem that doesn't get past ~90% full.

Yes, true, I know. But I have no other free space for this backups. I am
waiting for a new already ordered system and will have 4 times this
space. So later I will open a new thread asking if my thoughts for
creating this new 80 TB XFS partition are right.



>> I am asking because I am seeing very long times while removing big
>> directory trees. I thought on kernels above 3.0 removing dirs and files
>> had improved a lot, but I don't see that improvement.
> =

> You won't if the directory traversal is seek bound and that is the
> limiting factor for performance.

*Seek bound*? *When* is the directory traversal *seek bound*?


>> This is a backup system running dirvish, so most files in the dirs I am
>> removing are hard links. Almost all of the files do have ACLs set.
> =

> The unlink will have an extra IO to read per inode - the out-of-line
> attribute block, so you've just added 11 million IOs to the 800,000
> the traversal already takes to the unlink overhead. So it's going to
> take roughly ten hours because the unlink is gong to be read IO seek
> bound....

It took 110 minutes and not 10 hours. All files and dirs there had ACLs set.


> Christophs suggestions to use larger inodes to keep the attribute
> data inline is a very good one - whenever you have a workload that
> is attribute heavy you should use larger inodes to try to keep the
> attributes in-line if possible. The down side is that increasing the
> inode size increases the amount of IO required to read/write inodes,
> though this typically isn't a huge penalty compared to the penalty
> of out-of-line attributes.

I will use larger inodes always from now on, since we largely use ACLs
on our XFS partitions.


> Also, for large directories like this (millions of entries) you
> should also consider using a larger directory block size (mkfs -n
> size=3Dxxxx option) as that can be scaled independently to the
> filesystem block size. This will significantly decrease the amount
> of IO and fragmentation large directories cause. Peak modification
> performance of small directories will be reduced because larger
> block size directories consume more CPU to process, but for large
> directories performance will be significantly better as they will
> spend much less time waiting for IO.

This was not ONE directory with that many files, but a directory
containing 834591 subdirectories (deeply nested, not all in the same
dir!) and 10539154 files.

Many thanks,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
