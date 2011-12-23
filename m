Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBNL8j06002729 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 15:08:45 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HCfISXnjMePgDK3N for <xfs@oss.sgi.com>;
	Fri, 23 Dec 2011 13:08:43 -0800 (PST)
Date: Sat, 24 Dec 2011 08:08:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: use uid/gid instead of actual name to fix
	install issue
Message-ID: <20111223210826.GD12731@dastard>
References: <1324623173-32707-1-git-send-email-b19537@freescale.com>
	<20111223100135.GA12731@dastard>
	<CA452391058F6D4E9715FB2C29D9312A010BC015@039-SN2MPN1-023.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA452391058F6D4E9715FB2C29D9312A010BC015@039-SN2MPN1-023.039d.mgd.msft.net>
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
To: Luo Zhenhua-B19537 <B19537@freescale.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Dec 23, 2011 at 02:20:24PM +0000, Luo Zhenhua-B19537 wrote:
> If the specified user/group is invalid, I think this should be an
> usage error instead of script error.

Hold on - how are you getting an invalid uid/gid? Those values are
set by the configure script to the uid/gid of the builder process,
and so should -never- be invalid.

Are you building on one machine, rsyncing to another machine with
different user/groups and then running make install?  If so, you are
using make install incorrectly. make install is designed to install
the binaries on the host that they were built, not some other random
machine. If you are going to install binaries on a different machine
to where they were built, you are supposed to build a tarball, a
.deb or .rpm package and install that. Those targets are macine
independent and won't have install problems.

> Current the problem I met is that, even if I specified a valid
> user/group of my host, "chown user:group file" failed, after
> switching to corresponding uid/gid, the script can be executed
> successfully during the install process. 

I had to manually change the include/builddefs file to have an
invalid PKG_USER/PKG_GROUP variables to get chown to fail because
all my build/test machines have consistent uid/gid entries, so even
build/rsync/install works without fail....

And if you look at what your change actually does, the script still
executes and installs -some- stuff, it just doesn't run the chown
because _chown() is now not passed the correct number of parameters.
IOWs, the script now fails with a partial install with no indication
of what was installed or not.

If you are going to check whether uid/gid exist, you need to exit
immediately if they don't exist, not allow the script to continue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
