Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8J3UL9144353 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 13:03:31 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4416522CDF2
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 11:03:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 816VaIA0Zk96Co97 for
	<xfs@oss.sgi.com>; Tue, 08 Nov 2011 11:03:29 -0800 (PST)
Date: Tue, 8 Nov 2011 17:02:12 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs_repair: Add inline function to get avl tree node
Message-ID: <20111108190212.GB21214@andromeda.usersys.redhat.com>
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
	<1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
	<4EB97B53.7080600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EB97B53.7080600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 12:56:19PM -0600, Eric Sandeen wrote:
> On 11/8/11 12:46 PM, Carlos Maiolino wrote:
> > dd get_inode_offset() inline function, which will return the offset
> > of a specific node in the AVL tree avoiding the need to calculate the
> > the offset each time it needs to be used.
> 
> might be good to find the open-coded instances of this, and
> make them use the helper too.
> 
> -Eric
> 
Yep, I can trck down these instances and replace by this function later
with no problem

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
