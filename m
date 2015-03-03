Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 185657F5F
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 04:38:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B401AC001
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 02:38:49 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5Bf113Ahh7aDdbKx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 02:38:47 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5 v2 RESEND] fs: Fixes for removing xid bits and security
	labels
Date: Tue,  3 Mar 2015 11:38:34 +0100
Message-Id: <1425379119-3773-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

  Hello,

  warning in XFS made me look into detail into how clearing of suid / sgid
bits and security labels is done. And I've spotted a few issues:
1) MS_NOSEC handling is broken - we set it after each file_remove_suid() call.
   However we needn't have removed suid bit simply because we have
   CAP_SYS_FSID and further writes to the file from processes without this
   capability still need to clear the suid bit.
2) file_remove_suid() is a misnomer since it also handles removing of
   security labels. It is even more confusing because should_remove_suid()
   doesn't return whether file_remove_suid() is needed or not.
3) On truncate we do clear suid bits but not security labels. According to
   documentation in include/linux/security.h that's a bug but please correct
   me if I'm wrong.
4) ocfs2 doesn't clear security labels - hard to fix, I left it alone for now.
5) XFS didn't provide proper exclusion for clearing mode bits.

  This series aims at fixing above issues.

  Since v1 I have removed bogus patch changing inode_set_flags(), I have
updated changelog of patch 4/5 to better explain why ->inode_killpriv should
be called and I have included a fix for MS_NOSEC handling in this series.
Al, can you please merge the patches? Thanks!

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
