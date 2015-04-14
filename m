Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A12A7F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 18:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25388AC003
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 16:04:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QUdyV7ZFT0TqdxXx for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 16:04:16 -0700 (PDT)
Date: Wed, 15 Apr 2015 09:03:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: Correctly lock inode when removing suid and
	security marks
Message-ID: <20150414230331.GX15810@dastard>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
	<1425379119-3773-6-git-send-email-jack@suse.cz>
	<552D465F.4010700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <552D465F.4010700@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Tue, Apr 14, 2015 at 11:54:55AM -0500, Eric Sandeen wrote:
> On 3/3/15 4:38 AM, Jan Kara wrote:
> > Currently XFS calls file_remove_privs() without holding i_mutex. This is
> > wrong because that function can end up messing with file permissions and
> > security xattrs for which we need i_mutex held.
> > 
> > Fix the problem by grabbing iolock exclusively when we will need to
> > change anything in permissions / xattrs.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This seems like it stands alone, modulo the file_remove_privs function
> renaming... should it just be pulled into XFS by Dave?  I guess that would
> require the renaming patch to be rebased...

The file_remove_privs() is introduced earlier in the series. With
all the changes pending to xfs_file_aio_write_checks() from the
upcoming VFS merge, the DIo write fixes I'll be pushing, this, and
other problems Al Viro has noticed, I'm probably going to have to
refactor this code for 4.1-rc2 to fix all the bugs we've introduced
during integration of all the changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
