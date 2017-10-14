Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19366 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbdJNP6C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Oct 2017 11:58:02 -0400
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Sat, 14 Oct 2017 15:57:59 +0000
Message-ID: <1507996677.21357.1.camel@intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
         <20171011200603.27442-2-jack@suse.cz> <20171013071203.GA9105@infradead.org>
In-Reply-To: <20171013071203.GA9105@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <AEC2F79FFD749245BF4279CC59DD5F40@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "luto@kernel.org" <luto@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>

On Fri, 2017-10-13 at 00:12 -0700, Christoph Hellwig wrote:
+AD4- So did we settle on the new mmap+AF8-validate vs adding a new argument
+AD4- to -+AD4-mmap for real now?+AKAAoA-I have to say I'd much prefer passing an
+AD4- additional argument instead, but if higher powers rule that out
+AD4- this version is ok.

Even if we decide to add a parameter to -+AD4-mmap() I think that should be
done after we merge this version. Otherwise there's no way to stage
these changes in advance of the merge window since we need to run the
+ACI-add parameter+ACI- coccinelle script near or after -rc1 when there's no
risk of new -+AD4-mmap() users being added.

+AD4- 
+AD4- +AD4- diff --git a/include/linux/fs.h b/include/linux/fs.h
+AD4- +AD4- index 13dab191a23e..5aee97d64cae 100644
+AD4- +AD4- --- a/include/linux/fs.h
+AD4- +AD4- +-+-+- b/include/linux/fs.h
+AD4- +AD4- +AEAAQA- -1701,6 +-1701,8 +AEAAQA- struct file+AF8-operations +AHs-
+AD4- +AD4- +AKA-	long (+ACo-unlocked+AF8-ioctl) (struct file +ACo-, unsigned int,
+AD4- +AD4- unsigned long)+ADs-
+AD4- +AD4- +AKA-	long (+ACo-compat+AF8-ioctl) (struct file +ACo-, unsigned int,
+AD4- +AD4- unsigned long)+ADs-
+AD4- +AD4- +AKA-	int (+ACo-mmap) (struct file +ACo-, struct vm+AF8-area+AF8-struct +ACo-)+ADs-
+AD4- +AD4- +-	int (+ACo-mmap+AF8-validate) (struct file +ACo-, struct vm+AF8-area+AF8-struct
+AD4- +AD4- +ACo-,
+AD4- +AD4- +-			unsigned long)+ADs-
+AD4- 
+AD4- Can we make this return a bool for ok vs not ok?+AKAAoA-That way we only
+AD4- need to have the error code discussion in one place instead of every
+AD4- file system.

How about the following incremental update? It allows -+AD4-mmap+AF8-validate()
to be used as a full replacement for -+AD4-mmap() and it limits the error
code freedom to a centralized mmap+AF8-status+AF8-errno() routine:

---

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5aee97d64cae..e07fcac17ba7 100644
--- a/include/linux/fs.h
+-+-+- b/include/linux/fs.h
+AEAAQA- -1685,6 +-1685,13 +AEAAQA- struct block+AF8-device+AF8-operations+ADs-
 +ACM-define NOMMU+AF8-VMFLAGS +AFw-
 	(NOMMU+AF8-MAP+AF8-READ +AHw- NOMMU+AF8-MAP+AF8-WRITE +AHw- NOMMU+AF8-MAP+AF8-EXEC)
 
+-enum mmap+AF8-status +AHs-
+-	MMAP+AF8-SUCCESS,
+-	MMAP+AF8-UNSUPPORTED+AF8-FLAGS,
+-	MMAP+AF8-INVALID+AF8-FILE,
+-	MMAP+AF8-RESOURCE+AF8-FAILURE,
+-+AH0AOw-
+-typedef enum mmap+AF8-status mmap+AF8-status+AF8-t+ADs-
 
 struct iov+AF8-iter+ADs-
 
+AEAAQA- -1701,7 +-1708,7 +AEAAQA- struct file+AF8-operations +AHs-
 	long (+ACo-unlocked+AF8-ioctl) (struct file +ACo-, unsigned int, unsigned long)+ADs-
 	long (+ACo-compat+AF8-ioctl) (struct file +ACo-, unsigned int, unsigned long)+ADs-
 	int (+ACo-mmap) (struct file +ACo-, struct vm+AF8-area+AF8-struct +ACo-)+ADs-
-	int (+ACo-mmap+AF8-validate) (struct file +ACo-, struct vm+AF8-area+AF8-struct +ACo-,
+-	mmap+AF8-status+AF8-t (+ACo-mmap+AF8-validate) (struct file +ACo-, struct vm+AF8-area+AF8-struct +ACo-,
 			unsigned long)+ADs-
 	int (+ACo-open) (struct inode +ACo-, struct file +ACo-)+ADs-
 	int (+ACo-flush) (struct file +ACo-, fl+AF8-owner+AF8-t id)+ADs-
diff --git a/mm/mmap.c b/mm/mmap.c
index 2649c00581a0..c1b6a8c25ce7 100644
--- a/mm/mmap.c
+-+-+- b/mm/mmap.c
+AEAAQA- -1432,7 +-1432,7 +AEAAQA- unsigned long do+AF8-mmap(struct file +ACo-file, unsigned long addr,
 				vm+AF8-flags +ACYAPQ- +AH4-VM+AF8-MAYEXEC+ADs-
 			+AH0-
 
-			if (+ACE-file-+AD4-f+AF8-op-+AD4-mmap)
+-			if (+ACE-file-+AD4-f+AF8-op-+AD4-mmap +ACYAJg- +ACE-file-+AD4-f+AF8-op-+AD4-mmap+AF8-validate)
 				return -ENODEV+ADs-
 			if (vm+AF8-flags +ACY- (VM+AF8-GROWSDOWN+AHw-VM+AF8-GROWSUP))
 				return -EINVAL+ADs-
+AEAAQA- -1612,6 +-1612,27 +AEAAQA- static inline int accountable+AF8-mapping(struct file +ACo-file, vm+AF8-flags+AF8-t vm+AF8-flags)
 	return (vm+AF8-flags +ACY- (VM+AF8-NORESERVE +AHw- VM+AF8-SHARED +AHw- VM+AF8-WRITE)) +AD0APQ- VM+AF8-WRITE+ADs-
 +AH0-
 
+-static int mmap+AF8-status+AF8-errno(mmap+AF8-status+AF8-t stat)
+-+AHs-
+-	static const int rc+AFsAXQ- +AD0- +AHs-
+-		+AFs-MMAP+AF8-SUCCESS+AF0- +AD0- 0,
+-		+AFs-MMAP+AF8-UNSUPPORTED+AF8-FLAGS+AF0- +AD0- -EOPNOTSUPP,
+-		+AFs-MMAP+AF8-INVALID+AF8-FILE+AF0- +AD0- -ENOTTY,
+-		+AFs-MMAP+AF8-RESOURCE+AF8-FAILURE+AF0- +AD0- -ENOMEM,
+-	+AH0AOw-
+-
+-	switch (stat) +AHs-
+-	case MMAP+AF8-SUCCESS:
+-	case MMAP+AF8-UNSUPPORTED+AF8-FLAGS:
+-	case MMAP+AF8-INVALID+AF8-FILE:
+-	case MMAP+AF8-RESOURCE+AF8-FAILURE:
+-		return rc+AFs-stat+AF0AOw-
+-	default:
+-		/+ACo- unknown mmap+AF8-status +ACo-/
+-		return rc+AFs-MMAP+AF8-UNSUPPORTED+AF8-FLAGS+AF0AOw-
+-	+AH0-
+-+AH0-
+-
 unsigned long mmap+AF8-region(struct file +ACo-file, unsigned long addr,
 		unsigned long len, vm+AF8-flags+AF8-t vm+AF8-flags, unsigned long pgoff,
 		struct list+AF8-head +ACo-uf, unsigned long map+AF8-flags)
+AEAAQA- -1619,6 +-1640,7 +AEAAQA- unsigned long mmap+AF8-region(struct file +ACo-file, unsigned long addr,
 	struct mm+AF8-struct +ACo-mm +AD0- current-+AD4-mm+ADs-
 	struct vm+AF8-area+AF8-struct +ACo-vma, +ACo-prev+ADs-
 	int error+ADs-
+-	mmap+AF8-status+AF8-t status+ADs-
 	struct rb+AF8-node +ACoAKg-rb+AF8-link, +ACo-rb+AF8-parent+ADs-
 	unsigned long charged +AD0- 0+ADs-
 
+AEAAQA- -1697,11 +-1719,19 +AEAAQA- unsigned long mmap+AF8-region(struct file +ACo-file, unsigned long addr,
 		 +ACo- vma+AF8-link() below can deny write-access if VM+AF8-DENYWRITE is set
 		 +ACo- and map writably if VM+AF8-SHARED is set. This usually means the
 		 +ACo- new file must not have been exposed to user-space, yet.
+-		 +ACo-
+-		 +ACo- We require -+AD4-mmap+AF8-validate in the MAP+AF8-SHARED+AF8-VALIDATE
+-		 +ACo- case, prefer -+AD4-mmap+AF8-validate over -+AD4-mmap, and
+-		 +ACo- otherwise fallback to legacy -+AD4-mmap.
 		 +ACo-/
 		vma-+AD4-vm+AF8-file +AD0- get+AF8-file(file)+ADs-
-		if ((map+AF8-flags +ACY- MAP+AF8-TYPE) +AD0APQ- MAP+AF8-SHARED+AF8-VALIDATE)
-			error +AD0- file-+AD4-f+AF8-op-+AD4-mmap+AF8-validate(file, vma, map+AF8-flags)+ADs-
-		else
+-		if ((map+AF8-flags +ACY- MAP+AF8-TYPE) +AD0APQ- MAP+AF8-SHARED+AF8-VALIDATE) +AHs-
+-			status +AD0- file-+AD4-f+AF8-op-+AD4-mmap+AF8-validate(file, vma, map+AF8-flags)+ADs-
+-			error +AD0- mmap+AF8-status+AF8-errno(status)+ADs-
+-		+AH0- else if (file-+AD4-f+AF8-op-+AD4-mmap+AF8-validate) +AHs-
+-			status +AD0- file-+AD4-f+AF8-op-+AD4-mmap+AF8-validate(file, vma, map+AF8-flags)+ADs-
+-			error +AD0- mmap+AF8-status+AF8-errno(status)+ADs-
+-		+AH0- else
 			error +AD0- call+AF8-mmap(file, vma)+ADs-
 		if (error)
 			goto unmap+AF8-and+AF8-free+AF8-vma+ADs