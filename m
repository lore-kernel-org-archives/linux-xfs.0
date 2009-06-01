Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51EWW6G011805 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 09:32:32 -0500
Received: from smtprelay10.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBD08148AB52
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 07:39:10 -0700 (PDT)
Received: from smtprelay10.ispgateway.de (smtprelay10.ispgateway.de
	[80.67.31.44]) by cuda.sgi.com with ESMTP id n4NMsecvgKZTHCS5
	for <xfs@oss.sgi.com>; Mon, 01 Jun 2009 07:39:10 -0700 (PDT)
Message-ID: <4A23E68E.6070400@cape-horn-eng.com>
Date: Mon, 01 Jun 2009 16:32:46 +0200
From: Richard Ems <Richard.Ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com>
	<4A181B40.9080608@sandeen.net>	<20090523180721.94212hyfjppuupmo@webmail.df.eu>	<4A1833D7.30608@sandeen.net>	<20090523194552.66062w3zquwvms00@webmail.df.eu>
	<4A1844AF.7030906@sandeen.net> <4A184DAC.8060400@sandeen.net>
In-Reply-To: <4A184DAC.8060400@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> if you growfs to a nr of blocks that is about 55 blocks less than the
> actual device size, it should succeed for you.  There's a case where the
> last AG would be too small and it tries to compensate but there's an
> overflow, I'll send a patch.

Yes, it worked growing to a smaller size.

Thanks again, Richard

-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
