Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 845927F66
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 07:27:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2224BAC002
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 05:27:54 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jCzt1IOL0MuOEmD7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 05:27:53 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] fs: Fixes for removing xid bits and security labels
Date: Thu,  4 Dec 2014 14:27:34 +0100
Message-Id: <1417699659-14284-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

  Hello,

  warning in XFS made me look into detail into how clearing of suid / sgid
bits and security labels is done. And I've spotted a few issues:
1) file_remove_suid() is a misnomer since it also handles removing of
   security labels. It is even more confusing because should_remove_suid()
   doesn't return whether file_remove_suid() is needed or not.
2) on truncate we do clear suid bits but not security labels. I think that's
   a bug but please correct me if I'm wrong.
3) ocfs2 doesn't clear security labels - hard to fix, I left it alone for now.
4) XFS didn't provide proper exclusion for clearing mode bits.

  This series aims at fixing above issues. The second patch in the series
is unrelated fix to inode_set_mask() which I spotted when playing with the
code.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
