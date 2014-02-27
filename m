Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEB6C7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 13:40:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F67C8F8052
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 11:40:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	41n0jOPoVsh9lXkm for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 11:40:39 -0800 (PST)
Date: Fri, 28 Feb 2014 06:40:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mkfs: proto file creation does not set ftype correctly
Message-ID: <20140227194037.GC30131@dastard>
References: <1393494344-30056-1-git-send-email-david@fromorbit.com>
	<1393494344-30056-3-git-send-email-david@fromorbit.com>
	<530F4907.5010808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530F4907.5010808@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 27, 2014 at 08:17:43AM -0600, Eric Sandeen wrote:
> On 2/27/14, 3:45 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Hence running xfs_repair on a ftype enable filesystem that has
> > contents created by a proto file will throw warnings on mismatched
> > ftype entries and correct them. xfs/031 fails due to this problem.
> > 
> > Fix it by settin gup the xname structure with the correct type
> 
> "setting up"
> 
> > fields.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> huh, surprised that hung out there for so long ;)

Just shows how long it took my backlog down far enough to deal with
non-critical xfstests failures on CRC enabled filesystems...

> I guess the root inode is handled by core mkfs code, right?
> (around line 544)

Yes - and the root inode is indexed in a directory (it's indexed by
the superblock), so there's not ftype entry to be set up.

> And I notice that "r" filetypes aren't documented in the
> manpage but that's a different issue.

Patch? ;)

> As long as I'm right about the root inode,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
