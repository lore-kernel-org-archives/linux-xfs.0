Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A1C27CA0
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2016 09:33:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0C948F8033
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2016 07:33:29 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id 02AHZEIDyTBlDrPy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Apr 2016 07:33:28 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id f105so104371754qge.2
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2016 07:33:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Apr 2016 09:33:27 -0500
Message-ID: <CACo5E_6fz+BV7prpyo35jzH2_dwgswZ4ZkZ26XP9czbdT3g6vw@mail.gmail.com>
Subject: "xfs_log_force: error 5 returned." for drive that was removed.
From: Joe Wendt <wendtwerks@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1457787667490259530=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1457787667490259530==
Content-Type: multipart/alternative; boundary=001a11393a909149e00530af2080

--001a11393a909149e00530af2080
Content-Type: text/plain; charset=UTF-8

Hello! This may be a silly question or an interesting one...

We had a drive fail in a production server, which spawned this error in the
logs:
XFS (sde1): xfs_log_force: error 5 returned.

The dead array was lazy-unmounted, and the drive was hot-swapped, but when
the RAID array was rebuilt, it came online as /dev/sdk instead of /dev/sde.

Now /dev/sde1 doesn't exist in the system, but we still see this message
every 30 seconds. I'm assuming a reboot will clear out whatever is still
trying to access sde1, but I'm trying to avoid that if possible. Could
someone point me in the direction of what XFS might still be trying to do
with that device?

lsof hasn't given me any clues. I can't run xfs_repair on a volume that
isn't there. I haven't been able to find anything similar yet online. Any
help would be greatly appreciated!

Thanks,
Joe

--001a11393a909149e00530af2080
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello! This may be a silly question or an interesting one.=
..<div><br></div><div>We had a drive fail in a production server, which spa=
wned this error in the logs:=C2=A0</div><div>XFS (sde1): xfs_log_force: err=
or 5 returned.</div><div><br></div><div>The dead array was lazy-unmounted, =
and the drive was hot-swapped, but when the RAID array was rebuilt, it came=
 online as /dev/sdk instead of /dev/sde.</div><div><br></div><div>Now /dev/=
sde1 doesn&#39;t exist in the system, but we still see this message every 3=
0 seconds. I&#39;m assuming a reboot will clear out whatever is still tryin=
g to access sde1, but I&#39;m trying to avoid that if possible. Could someo=
ne point me in the direction of what XFS might still be trying to do with t=
hat device?=C2=A0</div><div><br></div><div>lsof hasn&#39;t given me any clu=
es. I can&#39;t run xfs_repair on a volume that isn&#39;t there. I haven&#3=
9;t been able to find anything similar yet online. Any help would be greatl=
y appreciated!</div><div><br></div><div>Thanks,</div><div>Joe</div></div>

--001a11393a909149e00530af2080--


--===============1457787667490259530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1457787667490259530==--
