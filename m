Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o51NQteH032111 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 18:26:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B4051E038A4
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 16:29:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	dvNL7nG5tWRyv8YN for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 16:29:20 -0700 (PDT)
Date: Wed, 2 Jun 2010 09:29:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs/libhandle : How to get the handle for a symbolic link ?
Message-ID: <20100601232917.GG1395@dastard>
References: <4C04F386.908@cea.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C04F386.908@cea.fr>
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
To: DENIEL Philippe <philippe.deniel@CEA.FR>
Cc: xfs@oss.sgi.com

On Tue, Jun 01, 2010 at 01:48:22PM +0200, DENIEL Philippe wrote:
> Hi,
> 
> I am currently developing a user space nfs server with various
> backends. One of this backend module use xfsprogss's libhandle to
> implement XFS support. I could do almost everything with
> open_by_handle and fd_to_handle, used jointly with ATFILE_SOURCE
> functions, but I do have a problem with symbolic links. To build an
> xfs object's handle, I get its parent handle (now problem to this)
> then I call "openat" to get the fd to the object before calling
> fd_to_handle. This works ok, but not for symbolic link : the openat
> with follow the link. I added the O_NOFOLLOW flag to openat, but now
> openat return ELOOP instead.
> I know there is a readlink_by_handle function in libhandle. How
> could I build the related handle to be used as argument to it (I
> mean, how to build a handle that refers to the symlink itself, not
> the object it points to).

Doesn't path_to_handle() do what you want? From the man page:

	"... If the final component of the path name is a symbolic
	link, the handle returned is that of the link itself."

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
