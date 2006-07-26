Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Jul 2006 06:30:37 -0700 (PDT)
Received: from mail01.miraclelinux.com (ns.miraclelinux.com [219.118.163.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6QDUHDW006609
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 06:30:22 -0700
Message-ID: <44C7508A.5010500@miraclelinux.com>
Date: Wed, 26 Jul 2006 20:22:50 +0900
From: Robert <robert@miraclelinux.com>
MIME-Version: 1.0
Subject: Unresolved generic_file_write_nolock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Robert <robert@miraclelinux.com>

Hi XFS guys

I like to use XFS but I have a compile question for

xfs-modules-fs-modules-1.3.3-2.4.21-27.0.2.EL.sgi9.src.rpm

which is download from ftp://oss.sgi/com/projects/xfs/testing/RHEL3/


I compiled it with kernel-2.4.21-37.EL with normal steps. Everything
is ok and then I run the command installkernel but got below error 
message like this:

depmod  ..... xfs.o
Unresolved symble : generic_file_write_nolock

Then I had tried to find this function in 2.4.21-37EL and mainstream
kernel-2.4.32, but it does not exist in them. I refer to SPEC file
and found this generic_file_write_nolock() already deleted at
linux-2.4.21-odirect.patch, no more exist. Even in the old kernel
2.4.21-20.EL, I can not find it.

This generic_file_write_nolock() is used in xfs/linux/xfs_lrw.c line 745

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2.4.22) || defined\ 
(KERNEL_HAS_NEW_O_DIRECT)
    :
    :
    :
#else
retry :
      if (ioflags & IO_ISDIRECT) {
            xfs_inval_cached_pages(vp, io, *offset, 1, 1);
      }
      ret = generic_file_write_nolock(file, buf, size, offset);
#endif

Logically, the #if KERNEL_VERSION_CODE is smaller than 2.4.22.
The generic_file_write_nolock should be included by C preprocessor.
So, could you guys tell me why the uploaded RPM:

xfs-modules-smp-1.3.3-2.4.21_27.0.2.EL.sgi9_sgi2.i686.rpm

does not included this function, generic_file_write_nolock?

and Did you compile the xfs-modules with the same kernel
2.4.21-27.0.2.EL.sgi9_sgi2?

I can not find generic_file_write_nolock in the System.map of the
its uploaded RPM :

  kernel-smp-2.4.21-27.0.2.EL.sgi9.i686.rpm

This issue take my time for about 1 week and still not solved.
Any comment is thankfully.

Best Regards
Robert
