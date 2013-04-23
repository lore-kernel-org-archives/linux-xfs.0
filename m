Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6719D7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 19:08:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5513D8F8039
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 17:08:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WV1YJ91SuC7XX9lX for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 17:08:37 -0700 (PDT)
Date: Tue, 23 Apr 2013 10:08:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
Message-ID: <20130423000835.GL30622@dastard>
References: <516C89DF.4070904@redhat.com>
 <517596BA.3060408@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <517596BA.3060408@sandeen.net>
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
Cc: Brian Foster <bfoster@redhat.com>, yongtaofu@gmail.com, xfs@oss.sgi.com

On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:
> On 4/15/13 6:14 PM, Brian Foster wrote:
> > Hi,
> > 
> > Thanks for the data in the previous thread:
> > 
> > http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> > 
> > I'm spinning off a new thread specifically for this because the original
> > thread is already too large and scattered to track. As Eric stated,
> > please try to keep data contained in as few messages as possible.
> > 
> 
> Well, it's always simple in the end.  It just took a lot of debugging
> to figure out what was happening - we do appreciate your help with that!
> 
> We were able to create a local reproducer, and it looks like
> this patch fixes things:
> 
> commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Sat Jan 29 18:43:27 2011 +0530
> 
>     fs: Don't allow to create hardlink for deleted file

Good find Eric - great work on the reproducer script.

FWIW, can you confirm that a debug kernel assert fails
with a non-zero link count in xfs_bumplink() with your test case?

int
xfs_bumplink(
        xfs_trans_t *tp,
        xfs_inode_t *ip)
{
        xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);

>>>>>   ASSERT(ip->i_d.di_nlink > 0);
        ip->i_d.di_nlink++;
        inc_nlink(VFS_I(ip));

If it does, we should consider this a in-memory corruption case and
return and trigger a shutdown here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
