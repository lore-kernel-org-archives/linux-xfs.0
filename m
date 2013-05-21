Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BA8F29E0D
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 18:54:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 281988F8040
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 16:54:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JixcDApvCzjhriVU for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 16:54:48 -0700 (PDT)
Date: Wed, 22 May 2013 09:54:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130521235410.GY29466@dastard>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521234016.GB14347@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, May 21, 2013 at 07:40:16PM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 09:34:29AM +1000, Dave Chinner wrote:
>  > On Tue, May 21, 2013 at 06:52:57PM -0400, Dave Jones wrote:
>  > > [  464.210598] XFS: Assertion failed: (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID| ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 719
>  > 
>  > Never seen that fire before, but this is why we have ASSERT()s like
>  > this - we're being handed something by the VFS we don't expect...
>  > 
>  > Can you give me some context of the file permissions before the
>  > syscall and what the syscall parameters are? i.e. is this likely to
>  > be trying to strip SUID/SGID during the truncate operation?
> 
> no idea tbh. Is there something I can add to that assert to dump
> which file it was triggered by ?

Convert the assert to a if (), and then in the body do something
like:

	if (mask & (...) {
		char buf[MAX_PATHLEN];

		d_path(VFS_I(ip)->i_dentry, buf, MAXPATHLEN);
		xfs_warn(mp, "%s: mask 0x%x mismatch on file %s\n",
			 __func__, mask, buf);
		ASSERT(0);
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
