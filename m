Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E17CF7F60
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 09:29:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFA0B304053
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:29:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1ZSpH8rGARvMrrJF for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 07:29:49 -0800 (PST)
Message-ID: <54C268ED.2000801@sandeen.net>
Date: Fri, 23 Jan 2015 09:29:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Change sector size on existing partition
References: <54C246EC.90207@xtremenitro.org>
In-Reply-To: <54C246EC.90207@xtremenitro.org>
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
To: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>, xfs@oss.sgi.com

On 1/23/15 7:04 AM, Dewangga Bachrul Alam wrote:
> Hi,
> 
> I'm new to XFS, I have RAID-10 array with 4 disk, when I check with
> xfs_info, the information print like this.
> 
> $ xfs_info /var/lib/mysql
> meta-data=/dev/mapper/vg_catalystdb01-lv_database isize=256
> agcount=16, agsize=1600000 blks
>          =                       sectsz=4096  attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=25600000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=12500, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Is it possible to change `sectsz` value to 512 without re-format it? Or
> any suggestion? I have issue with current sector size, my TokuDB
> engines[1] can't start because of this.
> 
> [1] https://groups.google.com/forum/#!topic/tokudb-user/kvQFJLCmKwo

You almost certainly need this commit to resolve the issue.

You didn't say here what kernel you were using, but from your other
post it looks like CentOS 6.4.  Are you using stock xfsprogs from centos6.4
as well?  I don't remember if it chooses 4k sectors for 4k physical block
devices or not; unless you have a custom xfsprogs version or overrode
sector size at mkfs time, I guess it must.

commit 7c71ee78031c248dca13fc94dea9a4cc217db6cf
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jan 21 16:46:23 2014 -0600

    xfs: allow logical-sector sized O_DIRECT
    
    Some time ago, mkfs.xfs started picking the storage physical
    sector size as the default filesystem "sector size" in order
    to avoid RMW costs incurred by doing IOs at logical sector
    size alignments.
    
    However, this means that for a filesystem made with i.e.
    a 4k sector size on an "advanced format" 4k/512 disk,
    512-byte direct IOs are no longer allowed.  This means
    that XFS has essentially turned this AF drive into a hard
    4K device, from the filesystem on up.
    
    XFS's mkfs-specified "sector size" is really just controlling
    the minimum size & alignment of filesystem metadata.
    
    There is no real need to tightly couple XFS's minimal
    metadata size to the minimum allowed direct IO size;
    XFS can continue doing metadata in optimal sizes, but
    still allow smaller DIOs for apps which issue them,
    for whatever reason.
    
    This patch adds a new field to the xfs_buftarg, so that
    we now track 2 sizes:
    
     1) The metadata sector size, which is the minimum unit and
        alignment of IO which will be performed by metadata operations.
     2) The device logical sector size
    
    The first is used internally by the file system for metadata
    alignment and IOs.
    The second is used for the minimum allowed direct IO alignment.
    
    This has passed xfstests on filesystems made with 4k sectors,
    including when run under the patch I sent to ignore
    XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
    tested end of block behavior on preallocated, sparse, and
    existing files when we do a 512 IO into a 4k file on a
    4k-sector filesystem, to be sure there were no unexpected
    behaviors.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
