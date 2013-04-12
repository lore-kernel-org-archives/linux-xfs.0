Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AA007F3F
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 01:51:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3957AC002
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 23:51:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FouS85lcONKnEKqs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 23:51:18 -0700 (PDT)
Message-ID: <5167AEDD.2050708@oracle.com>
Date: Fri, 12 Apr 2013 14:51:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: New xfstests generic/308 causes XFS hang (high CPU use), at least
	on 32-bit
References: <51656D47.9010806@gmail.com>
In-Reply-To: <51656D47.9010806@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

Hi Michael,

On 04/10/2013 09:46 PM, Michael L. Semon wrote:
> Hi!  On my 32-bit Pentium III PC, xfstests generic/308 uses xfs_io, and 
> that xfs_io hangs the XFS file system without causing a crash.  In other 
> words, the FS cannot be umounted, xfs_io can't be killed, and shutdown 
> is handled by magic SysRq keys.  In this time, there is about 90% CPU 
> usage from xfs_io (top) but zero disk I/O (iostat).
> 
> The PC uses kernel 3.8-rc4 + Dave's CRC v4 patches + J. Liu's bitness patch.
I think this is a bug for x86 only and it is irrelevant to above patches(You have also
mentioned in another email).

AFAICS, it is caused by the 2nd test case in 308, i.e.
# Write to the block after the extent just created
offset=$(((2**32 - 1) * $block_size))
$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >>$seqres.full 2>&1

Run xfs_io with the given huge offset is enough to reproduce this issue(don't need to specify
the 'fsync' option), it will hang at page write back stage soon.

As we performs buffered io writes, the code execute path should go through:
xfs_buffered_aio_write
  xfs_file_aio_write_checks
    generic_write_checks

In this case, the given offset is larger than s_maxbytes on 32-bit machine. I think we should not be
allowed to create this file at all according to the following check up at generic_write_checks():
        if (likely(!isblk)) {
                if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
                        if (*count || *pos > inode->i_sb->s_maxbytes) {
                                return -EFBIG;
                        }
                        /* zero-length writes at ->s_maxbytes are OK */
                }

However, at xfs_max_file_offset(), we figure out s_maxbytes to (__uint64_t) range, it violated the MAX_LFS_FILESIZE limits,
so the file can be created but will failed at page write back phase after a little while, just like the comments for MAX_LFS_FILESIZE:

/* Page cache limit. The filesystems should put that into their s_maxbytes 
   limits, otherwise bad things can happen in VM. */
#if BITS_PER_LONG==32
#define MAX_LFS_FILESIZE        (((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 

I'll try to fix it later.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
