Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D19CD29DFB
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 11:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C05A5304048
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 09:26:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id p3Cc7eMVUyU5aftf for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 09:26:55 -0700 (PDT)
Message-ID: <5565F04F.3070406@sandeen.net>
Date: Wed, 27 May 2015 11:26:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150526225126.26434.69010.stgit@birch.djwong.org>	<20150526225132.26434.82404.stgit@birch.djwong.org>	<20150527054536.GB10175@birch.djwong.org>	<5565DAA7.4040406@sandeen.net>	<5565DFEB.9040000@sandeen.net>
	<5565E265.5040202@sandeen.net> <5565EB29.4080200@gmail.com>
In-Reply-To: <5565EB29.4080200@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Fanael Linithien <fanael4@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 5/27/15 11:04 AM, Fanael Linithien wrote:
> I'm not entirely sure silently ignoring unknown compat features in
> xfs_repair is a good idea. Consider this ext2 example: xattr support
> is a compat flag. It's okay to rw mount a FS with xattrs on some
> ancient (or non-Linux) kernel without xattr support =97 everything will
> be fine, even though there's no way to access them =97 but if the fsck
> tool doesn't understand them, it wouldn't be able to diagnose xattr
> corruption.

Hm, good point.  We have no "compat" features atm, so it's not really clear;
if nothing else, though, those features will have to go un-checked, if there
is any checking to do.  So yeah, maybe best to keep it as an exclusion.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
