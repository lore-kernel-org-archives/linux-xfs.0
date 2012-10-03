Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q932EgXd123688 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 21:14:42 -0500
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id Xpo0djrN86GyQHJQ for
	<xfs@oss.sgi.com>; Tue, 02 Oct 2012 19:16:06 -0700 (PDT)
Date: Tue, 2 Oct 2012 22:16:04 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1230653317.6074738.1349230564747.JavaMail.root@redhat.com>
In-Reply-To: <506B9D98.6040808@sandeen.net>
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Eric Sandeen <sandeen@sandeen.net>, Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>


----- Original Message -----
> Do you build your own pkgs or use a distro?  IF distro, I'd file a
> bug.
> 
> Agreed that defaulting to on would be nice, but in Fedora & RHEL:
> 
> %configure \
>         --enable-readline=yes	\
> ...
> 
> just FWIW.
> 

$ grep enable-readline xfsprogs/debian/rules 
	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ;


cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
