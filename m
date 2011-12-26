Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBQ3dESF217148 for <xfs@oss.sgi.com>; Sun, 25 Dec 2011 21:39:14 -0600
Received: from ch1outboundpool.messaging.microsoft.com
	(ch1ehsobe002.messaging.microsoft.com [216.32.181.182]) by
	cuda.sgi.com with ESMTP id 2RGZGqP4feCiMORU for
	<xfs@oss.sgi.com>; Sun, 25 Dec 2011 19:39:12 -0800 (PST)
From: Luo Zhenhua-B19537 <B19537@freescale.com>
Subject: RE: [PATCH] xfsprogs: use uid/gid instead of actual name to fix
	install issue
Date: Mon, 26 Dec 2011 03:39:07 +0000
Message-ID: <CA452391058F6D4E9715FB2C29D9312A010BC557@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1324623173-32707-1-git-send-email-b19537@freescale.com>
	<20111223100135.GA12731@dastard>
	<CA452391058F6D4E9715FB2C29D9312A010BC015@039-SN2MPN1-023.039d.mgd.msft.net>
	<20111223210826.GD12731@dastard>
In-Reply-To: <20111223210826.GD12731@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Saturday, December 24, 2011 5:08 AM
> > If the specified user/group is invalid, I think this should be an
> > usage error instead of script error.
> 
> Hold on - how are you getting an invalid uid/gid? Those values are set by the
> configure script to the uid/gid of the builder process, and so should -never- be
> invalid.
[Luo Zhenhua-B19537] The username/group are set by configure script and valid value are used during my install process. 

> Are you building on one machine, rsyncing to another machine with different
> user/groups and then running make install?  If so, you are using make install
> incorrectly. make install is designed to install the binaries on the host that
> they were built, not some other random machine. If you are going to install
> binaries on a different machine to where they were built, you are supposed to
> build a tarball, a .deb or .rpm package and install that. Those targets are
> macine independent and won't have install problems.
[Luo Zhenhua-B19537] I built it only on a host, no other machine is involved. What surprised me is I can run the chmod command successfully, but the same command failed in the install script. After using uid/gid, it can run correctly both in manual way and in the script. The purpose of my patch is to resolve this issue. 

> > Current the problem I met is that, even if I specified a valid
> > user/group of my host, "chown user:group file" failed, after switching
> > to corresponding uid/gid, the script can be executed successfully
> > during the install process.
> 
> I had to manually change the include/builddefs file to have an invalid
> PKG_USER/PKG_GROUP variables to get chown to fail because all my build/test
> machines have consistent uid/gid entries, so even build/rsync/install works
> without fail....
> 
> And if you look at what your change actually does, the script still executes and
> installs -some- stuff, it just doesn't run the chown because _chown() is now not
> passed the correct number of parameters.
> IOWs, the script now fails with a partial install with no indication of what was
> installed or not.
> 
> If you are going to check whether uid/gid exist, you need to exit immediately if
> they don't exist, not allow the script to continue.
[Luo Zhenhua-B19537] Makes sense. 


Best Regards,

Zhenhua

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
