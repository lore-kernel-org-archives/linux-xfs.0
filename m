Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JMW3F1201529 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 17:32:04 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 940A89D31
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 15:32:34 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	DKHClxT2nmiHxw6f for <xfs@oss.sgi.com>;
	Thu, 19 Aug 2010 15:32:34 -0700 (PDT)
Received: by qyk33 with SMTP id 33so2426251qyk.5
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 15:32:34 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Aug 2010 17:32:33 -0500
Message-ID: <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
Subject: Question about XFS recovery and error
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7788163966874095491=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7788163966874095491==
Content-Type: multipart/alternative; boundary=00163630f1d12940dc048e34c2e8

--00163630f1d12940dc048e34c2e8
Content-Type: text/plain; charset=ISO-8859-1

The USB key is mounted automatically at boot and no error report with XFS
recovery.
But when I did a file copy on a USB key which XFS filesystem could be
corrupted by some reason,
I got endless repeat of ERROR message printed on the screen.

Should XFS recovery this at the beginning when mounting?

[42949387.250000] Starting XFS recovery on filesystem: sda (logdev:
internal)
[42949387.330000] Ending XFS recovery on filesystem: sda (logdev: internal)
[42949388.600000] Starting XFS recovery on filesystem: sdb1 (logdev:
internal)
[42949388.640000] Ending XFS recovery on filesystem: sdb1 (logdev: internal)


cp /mnt/USB0disk1/iCarly-4.ts ./iCarly-4-10.ts

[ 3234.740000] Filesystem "sda": XFS internal error xfs_btree_check_sblock
at line 120 of file fs/xfs/xfs_btree.c.  Caller 0x8718e102
[ 3234.740000]
[ 3234.750000] regs can't be NULL.
[ 3234.760000] Filesystem "sda": page discard on page 876a1914, inode 0x91,
offset 91160576.
[ 3235.150000] Filesystem "sda": XFS internal error xfs_btree_check_sblock
at line 120 of file fs/xfs/xfs_btree.c.  Caller 0x8718e102

Thanks,
Mike

--00163630f1d12940dc048e34c2e8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>The USB key is mounted automatically at boot and no error report with =
XFS recovery.</div>But when I did a file copy on a USB key which XFS filesy=
stem could be corrupted by some reason,<div>I got endless repeat of ERROR m=
essage printed on the screen.=A0<br>
<div><br></div><div>Should XFS recovery this at the beginning when mounting=
?=A0</div><div><br></div><div><div>[42949387.250000] Starting XFS recovery =
on filesystem: sda (logdev: internal)</div><div>[42949387.330000] Ending XF=
S recovery on filesystem: sda (logdev: internal)</div>
<div>[42949388.600000] Starting XFS recovery on filesystem: sdb1 (logdev: i=
nternal)</div><div>[42949388.640000] Ending XFS recovery on filesystem: sdb=
1 (logdev: internal)</div></div><div><br></div><div><br></div><div><div>
cp /mnt/USB0disk1/iCarly-4.ts ./iCarly-4-10.ts</div><div><br></div><div>[ 3=
234.740000] Filesystem &quot;sda&quot;: XFS internal error xfs_btree_check_=
sblock at line 120 of file fs/xfs/xfs_btree.c. =A0Caller 0x8718e102</div>
<div>[ 3234.740000]</div><div>[ 3234.750000] regs can&#39;t be NULL.</div><=
div>[ 3234.760000] Filesystem &quot;sda&quot;: page discard on page 876a191=
4, inode 0x91, offset 91160576.</div><div>[ 3235.150000] Filesystem &quot;s=
da&quot;: XFS internal error xfs_btree_check_sblock at line 120 of file fs/=
xfs/xfs_btree.c. =A0Caller 0x8718e102</div>
</div></div><div><br></div><div>Thanks,</div><div>Mike</div>

--00163630f1d12940dc048e34c2e8--


--===============7788163966874095491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7788163966874095491==--
