Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA91A7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 08:45:56 -0600 (CST)
Message-ID: <52D007A6.2060607@sgi.com>
Date: Fri, 10 Jan 2014 08:45:58 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
References: <525C1C15.7020204@sandeen.net>
	<20131014211659.GI5663@dastard>	<20131014212347.GB1935@sgi.com>
	<525C6108.6010108@sandeen.net>	<20131015194609.GC32095@infradead.org>
	<20131015204342.GA24997@infradead.org>
In-Reply-To: <20131015204342.GA24997@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 10/15/2013 03:43 PM, Christoph Hellwig wrote:
> On Tue, Oct 15, 2013 at 12:46:09PM -0700, Christoph Hellwig wrote:
>> On Mon, Oct 14, 2013 at 04:24:24PM -0500, Eric Sandeen wrote:
>>> Ok.  Default it is!   Thanks guys, just wanted to make sure we were
>>> all in agreement there.
>>
>> Can we make sure this gets documented in doc/CHANGES?
>>
>> I'm also pretty sure the entry for 3.2.0-alpha1 is severly lacking,
>> can we make sure the one for the real release is as detailed as the ones
>> for the previous releases?
>
> Btw, I also noticed releases after 3.1.9 aren't tagged in git, any
> chance we could fix that?  The release.sh script was supposed to take
> care of this automatically.
>
> Also we have tons of fixes in the xfsprogs repo that really should go
> out into a new 3.1.12 release:
>
>      xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
>      xfs_db: add header to freesp -d output
>      xfs_repair: zero out unused parts of superblocks
>      xfs_repair: add prototype for alloc_ex_data()
>      xfsprogs: fix Out-of-bounds access in repair/dinode.c
>      xfsprogs: fix inode crash in xfs_repair
>      xfsprogs: fix unint var in repair phase6
>      xfsprogs: fix agcnts leak in xfs_repair's scan_ags
>      xfsprogs:free bp in xlog_find_tail() error path
>      xfsprogs: free bp in xlog_find_zeroed() error path
>      xfsprogs: fix buffer leak in xlog_print_find_oldest
>      xfsprogs: avoid double-free in xfs_attr_node_addname
>      xfsprogs/io: add readdir command
>      mkfs.xfs: fix protofile name create block reservation
>      logprint: fix wrapped log dump issue
>      xfs_metadump: manpage fix regarding frozen fs
>      mkfs: add missing noalign suboption information
>      xfsprogs: fix make deb
>      xfsprogs: define umode_t for build if not defined already
>      xfs_logprint: fix continuation transactions
>      xfs_fsr: file reads should be O_DIRECT
>      xfs_logprint: print all AGI unlinked buckets
>
> + a few more pending on the list.  I'd volunteer to prepare and test
> thos backports once we get the remaining patches from the list in.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
Hey Christoph,

If your still interested in a 3.1.12 release, a 'for-3.1.12' branch has 
been created.
http://oss.sgi.com/archives/xfs/2014-01/msg00056.html

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
