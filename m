Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E556329DF8
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 16:33:27 -0500 (CDT)
Message-ID: <517EE729.2030706@sgi.com>
Date: Mon, 29 Apr 2013 16:33:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
References: <20130412145555.GF30622@dastard> <51799C24.8010901@sgi.com>
	<20130425214040.GQ30622@dastard>
In-Reply-To: <20130425214040.GQ30622@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/25/13 16:40, Dave Chinner wrote:
> On Thu, Apr 25, 2013 at 04:12:04PM -0500, Mark Tinguely wrote:
>> On 04/12/13 09:55, Dave Chinner wrote:
>>> Hi folks,
>>>
>>> I've attached a tarball containing the patch series that adds
>>> metadata CRC support to xfsprogs. It is still very much a work in
>>> progress, but is sufficient to start running xfstests on CRC enable
>>> filesystems.
>>>
>>> THere is much missing functionality, especially with respect to
>>> directly/attribute modifications. Only mkfs and xfs_repair have been
>>> updated to explicitly support CRC on directory/sttribute blocks,
>>> though all the other tools will stil run the result might be a
>>> little unpredictable.
>>>
>>> The patch series is as follows:
>>>
>>
>> BTW forgot about this gem, the UBER/xfsprogs-kernel-3.8-update patch
>> has been kicking up duplicate defines in sles11sp2 (gcc 4.3.4), but
>> fine in newer distros (gcc 4.6.2). Looks like a compile difference
>> issue:
>>
>> xfs_dir2_data_aoff_t  xfs_dir2_format.h and xfs_dir2.h
>> xfs_dir2_db_t         xfs_dir2_format.h and xfs_dir2.h
>>
>> The one below seems new to me:
>> prid_t                project.h and xfs_types.h
>>
>> I have been removing the entry in xfs_dir2_format.h in the past to test.
>> I don't remember the prid_t duplicate.
>
> Hmmmm. I'm not getting those warnings here (gcc-4.7.2). I'll have a
> look into it....
>
> Cheers,
>
> Dave.


I replaced the gcc-4.3 compiler with a gcc-4.6.3 compiler and the 
duplicates errors disappeared.

The following patch works with both the gcc-4.3 and gcc-4.6 compilers.

Beyond the duplicates, the header and libxfs files in 
thexfsprogs-kernel-3.8-update patch compare to Linux 3.8 kernel code and 
I consider it Reviewed-by: me.

I will do the xfsprogs-kernel-3.9-rc1-dev-update tonight.

--Mark.

---
  include/xfs/project.h         |    4 ----
  include/xfs/xfs_dir2_format.h |    6 ------
  2 files changed, 10 deletions(-)

Index: b/include/xfs/project.h
===================================================================
--- a/include/xfs/project.h
+++ b/include/xfs/project.h
@@ -20,10 +20,6 @@

  #include <xfs/xfs.h>

-#if !defined(__sgi__)
-typedef __uint32_t	prid_t;
-#endif
-
  extern int setprojid(const char *__name, int __fd, prid_t __id);
  extern int getprojid(const char *__name, int __fd, prid_t *__id);

Index: b/include/xfs/xfs_dir2_format.h
===================================================================
--- a/include/xfs/xfs_dir2_format.h
+++ b/include/xfs/xfs_dir2_format.h
@@ -40,7 +40,6 @@
   */
  typedef	__uint16_t	xfs_dir2_data_off_t;
  #define	NULLDATAOFF	0xffffU
-typedef uint		xfs_dir2_data_aoff_t;	/* argument form */

  /*
   * Normalized offset (in a data block) of the entry, really 
xfs_dir2_data_off_t.
@@ -61,11 +60,6 @@ typedef	__uint32_t	xfs_dir2_dataptr_t;
  typedef	xfs_off_t	xfs_dir2_off_t;

  /*
- * Directory block number (logical dirblk in file)
- */
-typedef	__uint32_t	xfs_dir2_db_t;
-
-/*
   * Inode number stored as 8 8-bit values.
   */
  typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
