Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C5247F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 08:59:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23EB3304051
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 06:59:06 -0800 (PST)
Received: from na01-bn1-obe.outbound.protection.outlook.com
	(mail-bn1blp0189.outbound.protection.outlook.com
	[207.46.163.189]) by cuda.sgi.com with ESMTP id
	A1jochvDTOfqpF0z (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 06:59:01 -0800 (PST)
Message-ID: <52D3FF2E.3010901@pace.com>
Date: Mon, 13 Jan 2014 14:58:54 +0000
From: Muralitharan Perumal <muralitharan.perumal@pace.com>
MIME-Version: 1.0
Subject: kernel 2.6.22 pdflush consumes ~90% cpu
Content-Type: multipart/mixed; boundary="------------060402030301060902010701"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------060402030301060902010701
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I am currently working on an embedded platform involving XFS as the
preferred fs. Earlier, ext3 was used but now replaced with XFS. The unit
is working fine with ext3 but after replacing with XFS, I am seeing a
few issues:

a) Occassionally I am getting the following error when we write files to
the fs:

attempt to access beyond end of device
sda1: rw=3D0, want=3D10487141907480064, limit=3D9766912
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8 =
      ("xfs_trans_read_buf") error 5 buf count 4096
attempt to access beyond end of device
sda1: rw=3D0, want=3D10487141907480064, limit=3D9766912
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8 =
      ("xfs_trans_read_buf") error 5 buf count 4096

b) After running for about 20 to 25 minutes, the pdflush consumes about 90%=
 cpu and stuck there in D state:

Is there any similar issue seen with kernel 2.6.22? Am I missing any XFS pa=
tches that could fix this?

Any pointers would be helpful.

Thanks,
Murali


IMPORTANT NOTICE - this e-mail and any attachments hereto are strictly conf=
idential and intended solely for the addressee. If you are not the intended=
 recipient, please notify the sender to report the error and delete this co=
mmunication immediately. You must not disclose, forward or copy this e-mail=
 or any attachments hereto without the prior consent of the sender.

--------------060402030301060902010701
Content-Type: application/pgp-keys; name="0x1B79B2F8.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0x1B79B2F8.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

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
=TT6G
-----END PGP PUBLIC KEY BLOCK-----

--------------060402030301060902010701
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060402030301060902010701--
