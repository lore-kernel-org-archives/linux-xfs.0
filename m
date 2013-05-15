Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F5BD7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 18:05:06 -0500 (CDT)
Date: Wed, 15 May 2013 18:04:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: any way to work backwards from xfs_inode_t to a filename?
Message-ID: <20130515230459.GY812@sgi.com>
References: <5194050B.7010401@genband.com> <20130515221000.GX812@sgi.com>
	<51940A08.2040306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51940A08.2040306@sandeen.net>
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
Cc: Chris Friesen <chris.friesen@genband.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Chris,

On Wed, May 15, 2013 at 05:19:52PM -0500, Eric Sandeen wrote:
> On 5/15/13 5:10 PM, Ben Myers wrote:
> >> 1) do_unlinkat() has the filesystem path, but iput() returns void.
> >> Is there any way for me to add instrumentation to xfs_inactive() to
> >> work backwards from the xfs_inode_t pointer to print out a path to
> >> the file being deleted?
> > 
> > Use VFS_I to get to a 'struct inode' and from there you can look at the
> > dentries on i_dentry list and traverse back through the path by looking at
> > d_parent.  Might be easier to just print the path in do_unlinkat?
> 
> or just print out the inode nr (i_ino) and do a find -inum after the fact.  :)

+1

Dave pointed out that you might not be able to get to the inode at this point
in the lifecycle.  Apologies if I posted misinformation.  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
