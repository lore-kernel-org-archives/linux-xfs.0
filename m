Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E9EA87F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 15:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D54188F8071
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 13:23:42 -0700 (PDT)
Received: from mail-qg0-f53.google.com (mail-qg0-f53.google.com
	[209.85.192.53]) by cuda.sgi.com with ESMTP id HF4YzuMotYLpJGAL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Mar 2015 13:23:41 -0700 (PDT)
Received: by qgew92 with SMTP id w92so27534750qge.2
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 13:23:40 -0700 (PDT)
Date: Fri, 20 Mar 2015 16:23:39 -0400
From: Taesoo Kim <taesoo@gatech.edu>
Subject: inconsistent timestamp update in rename() of
	xfs/fat/gfs2/ramfs/jffs2...
Message-ID: <20150320202339.GK25797@taesoo.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: lczerner@redhat.com, cmaiolino@redhat.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: blee@gatech.edu, taesoo@gatech.edu, csong84@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu

Hi all,

We've cross-checking patches from ext3/ext4, and found out
inconsistent implementations of other fs. We want to ask whether this
is intended or unexpected behavior. We will be able to send patches as
soon as confirmed/acknowledged.

Ref.

(ext4) 53b7e9f6807c1274eee19201396b4c2b5f721553
(ext3) 0b23076988b44b2c165e060248345de6f2337387

 | ext3/4: fix update of mtime and ctime on rename

---------------------------------------------------------------------
We summarized our finding:
  (* means what we believe is correct beahvoir)

<Linux 4.0-rc2>
                                        ramfs   affs    fsplus
                        vfs xfs fat gfs2    jffs2   hfsh
operation          | * |   |   |   |   |   |   |   |   |
===========================================================
new_inode->i_ctime | V | - | - | V | V | - | - | V | - | -
old_inode->i_ctime | V | V | V | - | V | V | - | - | - | -
old_dir->i_ctime   | V | V | V | V | V | V | V | - | V | V
old_dir->i_mtime   | V | V | V | V | V | V | V | - | V | V
new_dir->i_ctime   | V | V | V | V | - | V | V | - | V | V
new_dir->i_mtime   | V | V | V | V | - | V | V | - | V | V
new_dir->i_atime   | - | - | - | V | - | - | - | - | - | -

* Correct behavior in

   ext2, ext3, ext4, btrfs, f2fs, nilfs, reiserfs, cifs, exofs, jfs,
   ubifs, ocfs and minix
---------------------------------------------------------------------

Thanks,
Taesoo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
