Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAB307F55
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 18:13:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 472B0AC001
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 16:13:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	epTWNCM5BmBp4ZOA for <xfs@oss.sgi.com>;
	Mon, 04 May 2015 16:13:23 -0700 (PDT)
Date: Tue, 5 May 2015 09:13:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5 v2 RESEND] fs: Fixes for removing xid bits and
	security labels
Message-ID: <20150504231310.GF21261@dastard>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1425379119-3773-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Tue, Mar 03, 2015 at 11:38:34AM +0100, Jan Kara wrote:
>   Hello,
> 
>   warning in XFS made me look into detail into how clearing of suid / sgid
> bits and security labels is done. And I've spotted a few issues:
> 1) MS_NOSEC handling is broken - we set it after each file_remove_suid() call.
>    However we needn't have removed suid bit simply because we have
>    CAP_SYS_FSID and further writes to the file from processes without this
>    capability still need to clear the suid bit.
> 2) file_remove_suid() is a misnomer since it also handles removing of
>    security labels. It is even more confusing because should_remove_suid()
>    doesn't return whether file_remove_suid() is needed or not.
> 3) On truncate we do clear suid bits but not security labels. According to
>    documentation in include/linux/security.h that's a bug but please correct
>    me if I'm wrong.
> 4) ocfs2 doesn't clear security labels - hard to fix, I left it alone for now.
> 5) XFS didn't provide proper exclusion for clearing mode bits.
> 
>   This series aims at fixing above issues.
> 
>   Since v1 I have removed bogus patch changing inode_set_flags(), I have
> updated changelog of patch 4/5 to better explain why ->inode_killpriv should
> be called and I have included a fix for MS_NOSEC handling in this series.
> Al, can you please merge the patches? Thanks!

Hi Al + Jan,

What's happening with this patchset? If it's not going to be pulled
into the VFS, I'll just pull in a version of the XFS patch that
corrects the locking at this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
