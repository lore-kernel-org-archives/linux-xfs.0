Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q24G9MST001675 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 10:09:23 -0600
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id QRgYBIRhD3Rx3JdG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 08:09:21 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id 7995D7E008
	for <xfs@oss.sgi.com>; Sun,  4 Mar 2012 18:09:19 +0200 (EET)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id jO5UqeUOt5iT for <xfs@oss.sgi.com>;
	Sun,  4 Mar 2012 18:09:17 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id F415A7E008
	for <xfs@oss.sgi.com>; Sun,  4 Mar 2012 18:09:16 +0200 (EET)
Date: Sun, 4 Mar 2012 18:09:12 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: failed to set versionnum in AG 1
Message-ID: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
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
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

On all my older partitions with xfs I have this problem:

# xfs_db -x /dev/sdh1
xfs_db> version
versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
xfs_db> version attr2
writing all SBs
Superblock has mismatched features2 fields, skipping modification
failed to set versionnum in AG 1
versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2

Some does not even has ATTR2 enabled and "version attr2" give the same 
error and ATTR2 get enabled.

Can this error be fixed and how? Should I worry about this?
Thank you.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Tk6gACgkQeWrbH+aEIG5wiwCdF+273blEdosPWCDNblJdvUAv
xqAAnRKt47B8zEbSbXArf3KJJhf1vcyD
=pqqw
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
