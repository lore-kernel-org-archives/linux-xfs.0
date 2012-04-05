Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35Fe7pW049720 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 10:40:08 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id uWYUw6fIvFZLW33G for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 08:40:06 -0700 (PDT)
Message-ID: <4F7DBCD4.2040007@sandeen.net>
Date: Thu, 05 Apr 2012 08:40:04 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to pre-allocate files for sequential access?
References: <33564834.post@talk.nabble.com>
In-Reply-To: <33564834.post@talk.nabble.com>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

On 4/4/12 4:57 PM, troby wrote:
> 
> I am trying to set up a 20 TB filesystem which will contain a single
> directory with 10000 pre-allocated 2GB files. There will be only a small
> number of other directories with very little activity. Once the files are
> preallocated there will be almost no new file creation. The files will be
> written sequentially, typically with writes of about 120KB, and will not be
> updated until the filesystem fills, at which point the earliest files will
> start to be overwritten (not deleted). There will be relatively little read
> activity. There will be a single writer process using a single thread. The
> filesystem application is MongoDB. I am trying to minimize seek activity
> during the write process, and would also like to have contiguous file
> allocation since the database queries will be retrieving records from a
> sequentially-related set of files.
> The filesystem as currently created looks like this:
> 
> meta-data=/dev/sdb1              isize=256    agcount=20, agsize=268435448
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=5127012091, imaxpct=1
>          =                       sunit=8      swidth=56 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> However what I see is that the earliest created files start about 5TB into
> the filesystem. The files are not being created in contiguous block ranges.
> Here is an xfs_bmap example of three files created in sequence:
> 0: [0..4192255]: 24075083136..24079275391
> 0: [0..4192255]: 26222566720..26226758975
> 0: [0..4192255]: 28370050304..28374242559

Please try again from scratch after mounting with the -o inode64 mount option,
which we will make default Real Soon Now(tm).

That option will more evenly spread inodes & file data throughout your whole
20T.

> Currently a process is doing continuous data inserts into the database, and
> is writing sequential segments within the files, filling a file in about 6
> minutes, and moving on to the next. There is also a small amount of write
> activity to a single file containing database metadata which is located
> about 5TB into the filesystem. The database index files are located on a
> separate disk. 
> 
> Using seekwatcher I've determined that the actual I/O pattern, even when a
> small number of files is being written to, is spread over a fairly wide
> range of filesystem offsets, resulting in about 250 seeks per second. I

Some of that seeking will be log writes, in the middle of the fs.

> don't know how to determine how long the seeks are. (I tried to upload the
> seekwatcher image but apparently that's not allowed). Seekwatcher shows the
> I/O activity is in a range between 15 and 17 TB into the filesystem. During
> this time there was a set of about 4 files being actively written as far as
> I know.
> 
> I'm guessing that the use of multiple allocation groups may explain the
> non-contiguous block allocation, although I read at one point that even with
> multiple allocation groups, files within a single directory would use the
> same group. I don't believe I need multiple allocation groups for this

That's generally true, but only until that group fills.  If you fill the
whole fs with files in the same dir, of course it will have to spill to other
AGs...

> application due to the single writer and the fact that all files will be
> preallocated before use. Would it be reasonable to force mkfs to use a
> single 20TB allocation group, and would this be likely to produce contiguous
> block allocation?

The AG size maxes out at 1T, so you can't make a single AG.

I'd give it another shot with inode64 and see if things look a little better,
or at least a bit more predictable.

-Eric

> This is kernel 3.0.25 using xfsprogs 3.1.1.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
