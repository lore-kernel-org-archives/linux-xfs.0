Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GH4XC5131523 for <xfs@oss.sgi.com>; Sat, 16 May 2009 12:04:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5444C28EA69
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 10:04:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1QZuGQ02hCjA3Kyz for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 10:04:41 -0700 (PDT)
Message-ID: <4A0EF228.3010702@sandeen.net>
Date: Sat, 16 May 2009 12:04:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: quick question about filename length
References: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
In-Reply-To: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
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
To: Chris Walker <christopher.walker@gmail.com>
Cc: xfs@oss.sgi.com

Chris Walker wrote:
> Hello,
> 
> I see that
> #define MAXNAMELEN  256
> 
> Is this the maximum length of the filename with full path?  Or is this
> just the name of the file?
> 
> Many thanks!
> Chris

/*
 * MAXNAMELEN is the length (including the terminating null) of
 * the longest permissible file (component) name.
 */
#define MAXNAMELEN      256

"component" means path component.  So just the name of the file or dir
in the path.

See also how it's used in xfs_vn_lookup() for example:

        if (dentry->d_name.len >= MAXNAMELEN)
                return ERR_PTR(-ENAMETOOLONG);

a dentry is one component of the path, not the entire path.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
