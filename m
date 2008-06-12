Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 09:53:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5CGrTnJ005405
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 09:53:29 -0700
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D39E21EE0C
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 09:54:25 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com [71.74.56.123]) by cuda.sgi.com with ESMTP id vAesacvkSc2e7Jgg for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 09:54:25 -0700 (PDT)
Received: from www.structurenet.com ([74.68.50.165])
          by hrndva-omta03.mail.rr.com with ESMTP
          id <20080612165424.OOUT29933.hrndva-omta03.mail.rr.com@www.structurenet.com>
          for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 16:54:24 +0000
Message-ID: <37328.38.117.134.222.1213289664.squirrel@www.structurenet.com>
In-Reply-To: 
     <9E397A467F4DB34884A1FD0D5D27CF43018903F96E@msxaoa4.twosigma.com>
References: 
    <9E397A467F4DB34884A1FD0D5D27CF43018903F96E@msxaoa4.twosigma.com>
Date: Thu, 12 Jun 2008 12:54:24 -0400 (EDT)
Subject: Re: several messages
From: "Benjamin L. Shi" <bshi@structurenet.com>
Reply-To: bshi@structurenet.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com




Index: fs/xfs/xfs_iomap.c
===================================================================
RCS file: /src/linux/2.6.18/fs/xfs/xfs_iomap.c,v
retrieving revision 1.1.1.1
retrieving revision 1.2
diff -u -r1.1.1.1 -r1.2
--- fs/xfs/xfs_iomap.c  29 Sep 2006 13:45:19 -0000      1.1.1.1
+++ fs/xfs/xfs_iomap.c  12 Jun 2008 15:59:10 -0000      1.2
@@ -706,11 +706,24 @@
         * then we must have run out of space - flush delalloc, and retry..
         */
        if (nimaps == 0) {
+               if ((mp->m_flags & XFS_MOUNT_FULL) != 0) {
+                       if (mp->m_sb.sb_fdblocks < 500) {
+                               //      printk("full again %llu\n",
+                               //              mp->m_sb.sb_fdblocks);
+                                       return XFS_ERROR(ENOSPC);
+                       } else {
+                               //      printk("not full again %llu\n",
+                               //              mp->m_sb.sb_fdblocks);
+                                       mp->m_flags &= ~XFS_MOUNT_FULL;
+                       }
+               }
                xfs_iomap_enter_trace(XFS_IOMAP_WRITE_NOSPACE,
                                        io, offset, count);
-               if (xfs_flush_space(ip, &fsynced, &ioflag))
+               if (xfs_flush_space(ip, &fsynced, &ioflag)) {
+                       mp->m_flags |= XFS_MOUNT_FULL;
+                       //printk("set full %llu\n", mp->m_sb.sb_fdblocks);
                        return XFS_ERROR(ENOSPC);
-
+               }
                error = 0;
                goto retry;
        }
Index: fs/xfs/xfs_mount.h
===================================================================
RCS file: /src/linux/2.6.18/fs/xfs/xfs_mount.h,v
retrieving revision 1.1.1.1
retrieving revision 1.2
diff -u -r1.1.1.1 -r1.2
--- fs/xfs/xfs_mount.h  29 Sep 2006 13:45:19 -0000      1.1.1.1
+++ fs/xfs/xfs_mount.h  12 Jun 2008 15:59:10 -0000      1.2
@@ -459,6 +459,7 @@
                                                 * I/O size in stat() */
 #define XFS_MOUNT_NO_PERCPU_SB (1ULL << 23)    /* don't use per-cpu
superblock
                                                   counters */
+#define XFS_MOUNT_FULL         (1ULL << 24)


 /*



>
> On Fri, 6 Oct 2006, David Chinner wrote:
>
>>> The backtrace looked like this:
>>>
>>> ... nfsd_write nfsd_vfs_write vfs_writev do_readv_writev
>>> xfs_file_writev
>>> xfs_write generic_file_buffered_write xfs_get_blocks __xfs_get_blocks
>>> xfs_bmap xfs_iomap xfs_iomap_write_delay xfs_flush_space
>>> xfs_flush_device
>>> schedule_timeout_uninterruptible.
>>
>> Ahhh, this gets hit on the ->prepare_write path
>> (xfs_iomap_write_delay()),
>
> Yes.
>
>> not the allocate path (xfs_iomap_write_allocate()). Sorry - I got myself
>> (and probably everyone else) confused there which why I suspected sync
>> writes - they trigger the allocate path in the write call. I don't think
>> 2.6.18 will change anything.
>>
>> FWIW, I don't think we can avoid this sleep when we first hit ENOSPC
>> conditions, but perhaps once we are certain of the ENOSPC status
>> we can tag the filesystem with this state (say an xfs_mount flag)
>> and only clear that tag when something is freed. We could then
>> use the tag to avoid continually trying extremely hard to allocate
>> space when we know there is none available....
>
> Yes! That's what I was trying to suggest  << OLE Object: Picture (Device
> Independent Bitmap) >> . Thank you.
>
> Is that hard to do?
>
