Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4ICVVfF051902 for <xfs@oss.sgi.com>; Tue, 18 May 2010 07:31:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAEFC156A34D
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 05:34:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ErYCKpPI4h8iosr0 for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 05:34:49 -0700 (PDT)
Date: Tue, 18 May 2010 22:33:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Message-ID: <20100518123304.GH2150@dastard>
References: <201005181350.15308@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005181350.15308@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, May 18, 2010 at 01:50:15PM +0200, Michael Monnerie wrote:
> Hello, I'm trying to rsync from an xfs with ACLs set to another server 
> which has an xfs filesystem. I mounted the nfs using 
> rw,noatime,nodiratime,acl,rsize=65536,wsize=65536,nfsvers=3,proto=tcp,mountproto=tcp
> and I get these errors:
> 
> rsync: rsync_xal_set: lsetxattr("anse/Software 
> ANDY/Bfort.exe","trusted.SGI_ACL_FILE") failed: Operation not supported 
> (95)
> rsync: rsync_xal_set: lsetxattr("anse/Software 
> ANDY/CWShredLast.exe","trusted.SGI_ACL_FILE") failed: Operation not 
> supported (95)
> rsync: rsync_xal_set: lsetxattr("anse/Software 
> ANDY/CWSysinfo_130.zip","trusted.SGI_ACL_FILE") failed: Operation not 
> supported (95)
> 
> Does it mean I can't sync ACLs? How could I do it? I need a full backup 
> including ACLs, as I want to move all data and then restore.

NFSv3 doesn't support ACLs, IIRC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
