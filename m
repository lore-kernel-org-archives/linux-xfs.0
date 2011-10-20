Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9K9e8e7251768 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 04:40:09 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44D1D7F0509
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 02:48:12 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 0gFTPgF1cgJJgspD
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 02:48:12 -0700 (PDT)
Received: by bke11 with SMTP id 11so3507775bke.26
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 02:40:06 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: new corruption pattern on ext4
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Date: Thu, 20 Oct 2011 13:40:15 +0400
Message-ID: <87sjmorog0.fsf@dmbot.sw.ru>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org, aelder@sgi.com, tytso@mit.edu

On Wed, 19 Oct 2011 14:29:41 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> xfstests: fsstress should kill children tasks before exit
> xfstests: add different logging option to fsstress
> xfstests: add fallocate support to fsstress
> xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
> xfstests: Dump inode info when possible
> xfstests: add fiemap operation
> 
> # Following testcase will fail on recent kernel in case of ext4
> # Some fixes are already available here:
> # http://www.spinics.net/lists/linux-ext4/msg27857.html
> xfstests: add new stress test
FYI: i've run 264'th test on recent tytso/ext4.git(dcf2d804ed6ffe)
and have got new type of fs-corruption, i haven't seen this before,
at this moment I dont have a fix for that:
Pass 1: Checking inodes, blocks, and sizes
Inode 176 has an invalid extent
      (logical block 236, invalid physical block 0, len 0)
Clear? no

Inode 22293 has an invalid extent
      (logical block 531, invalid physical block 0, len 0)
Clear? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
...

> 
> # Following testcase will fail on recent kernel in case of ext3/4 
> # Fixes available here:
> #  http://patchwork.ozlabs.org/patch/120581/
> #  http://patchwork.ozlabs.org/patch/120582/
> xfstests: add new quota stress test
> 
> P.S: ext4 still contains bugs caused by ordered_mode=>journal_mode
> switch for didicated inode (chattr +j ./afile), so you temproraly
> disable this test by adding "-f setattr=0" to $FSSTRESS_AVOID var.
>      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
