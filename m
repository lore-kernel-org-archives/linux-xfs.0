Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F70D7F4E
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 02:56:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13380AC003
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 00:56:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UPKUc3BIe39XgnZG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 00:56:33 -0700 (PDT)
Date: Tue, 5 May 2015 09:56:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/5 v2 RESEND] fs: Fixes for removing xid bits and
	security labels
Message-ID: <20150505075631.GB11943@quack.suse.cz>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
	<20150504231310.GF21261@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150504231310.GF21261@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Tue 05-05-15 09:13:10, Dave Chinner wrote:
> On Tue, Mar 03, 2015 at 11:38:34AM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   warning in XFS made me look into detail into how clearing of suid / sgid
> > bits and security labels is done. And I've spotted a few issues:
> > 1) MS_NOSEC handling is broken - we set it after each file_remove_suid() call.
> >    However we needn't have removed suid bit simply because we have
> >    CAP_SYS_FSID and further writes to the file from processes without this
> >    capability still need to clear the suid bit.
> > 2) file_remove_suid() is a misnomer since it also handles removing of
> >    security labels. It is even more confusing because should_remove_suid()
> >    doesn't return whether file_remove_suid() is needed or not.
> > 3) On truncate we do clear suid bits but not security labels. According to
> >    documentation in include/linux/security.h that's a bug but please correct
> >    me if I'm wrong.
> > 4) ocfs2 doesn't clear security labels - hard to fix, I left it alone for now.
> > 5) XFS didn't provide proper exclusion for clearing mode bits.
> > 
> >   This series aims at fixing above issues.
> > 
> >   Since v1 I have removed bogus patch changing inode_set_flags(), I have
> > updated changelog of patch 4/5 to better explain why ->inode_killpriv should
> > be called and I have included a fix for MS_NOSEC handling in this series.
> > Al, can you please merge the patches? Thanks!
> 
> Hi Al + Jan,
> 
> What's happening with this patchset? If it's not going to be pulled
> into the VFS, I'll just pull in a version of the XFS patch that
> corrects the locking at this point...
  I've sent the patches several times but so far they were ignored. Al?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
