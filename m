Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGk9Hp174144 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:46:09 -0500
Received: from mailout-sf2p.facebook.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 626693020DD
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:48:14 -0700 (PDT)
Received: from mailout-sf2p.facebook.com (mailout-snc1.facebook.com
	[69.63.179.25]) by cuda.sgi.com with ESMTP id QOAHjf7R7OTEESux
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:48:14 -0700 (PDT)
Received: from mail.thefacebook.com ([192.168.18.104])
	by pp02.snc1.tfbnw.net (8.14.3/8.14.3) with ESMTP id o3UGlcFH020238
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:47:38 -0700
From: Peter Merelis <merelis@facebook.com>
Date: Fri, 30 Apr 2010 09:49:05 -0700
Subject: stripe unit/width, inode64, misc mkfs.xfs params
Message-ID: <133AD8A0-119B-4A41-9AF6-46F43111A941@facebook.com>
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,
 =

Apologies in advance as I imagine this issue is raised frequently, but can =
someone familiar with these sorts of things sanity check my stripe unit/wid=
th settings since the underlying storage controller is not exposing the dat=
a to mkfs.xfs apparently:
 =

12 disk raid6
256k stripe
 =

su=3D256k
sw=3D10
 =

=85which I believe is equivalent to:
 =

sunit=3D512
swidth=3D5120
 =

Is that correct?

Also, does the inode64 option make sense for a filesystem with only a few f=
iles, each around ~100G?

And finally, are 'allocsize=3D1GB,nobarrier,noatime,nodiratime' recommended=
 mount options?
 =

Thanks,
Peter
 =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
