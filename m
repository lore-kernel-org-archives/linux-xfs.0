Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 211527CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 15:40:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0085A304084
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 13:40:20 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	Xjizh3XQhOmevEG5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 13:40:17 -0700 (PDT)
Received: by mail-wi0-f173.google.com with SMTP id hq4so5658499wib.0
	for <xfs@oss.sgi.com>; Wed, 03 Jul 2013 13:40:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Jul 2013 22:40:16 +0200
Message-ID: <CADyPfthesmv4ae0uDevzYQ+7srX26auSJWaB-72=qKrHbTLN4w@mail.gmail.com>
Subject: xfsprogs should provide hook script for initramfs-tools
From: Lubomir Host <lubomir.host@gmail.com>
Content-Type: multipart/mixed; boundary=001a11c2297a235b4904e0a17815
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
To: XFS Development Team <xfs@oss.sgi.com>

--001a11c2297a235b4904e0a17815
Content-Type: multipart/alternative; boundary=001a11c2297a235b4404e0a17813

--001a11c2297a235b4404e0a17813
Content-Type: text/plain; charset=UTF-8

Package: xfsprogs
Version: 3.1.9
Severity: minor
Tags: patch

Dear Maintainer,

If your rootfs is XFS (I hope it is :) ), you should include some XFS tools
into initrd.
It would be handy in emergency situation. E.g. will help you to boot your
domU.

Log from the Xen console:

Begin: Running /scripts/local-bottom ... done.
done.
Begin: Running /scripts/init-bottom ... done.
INIT: version 2.88 booting
[info] Using makefile-style concurrent boot in runlevel S.
[ ok ] Starting the hotplug events dispatcher: udevd.
[ ok ] Synthesizing the initial hotplug events...done.
[ ok ] Waiting for /dev to be fully populated...done.
[ ok ] Activating swap...done.
[....] Checking root file system...fsck from util-linux 2.20.1
fsck: fsck.xfs: not found
fsck: error 2 while executing fsck.xfs for /dev/xvda2
fsck died with exit status 8
failed (code 8).
[....] An automatic file system check (fsck) of the root filesystem failed.
A manual fsck must be performed, then the system restarted. The fsck should
be performed in maintenance mo[FAILth the root filesystem mounted in
read-only mode. ... failed!
[....] The root filesystem is currently mounted in read-only mode. A
maintenance shell will now be started. After performing system maintenance,
press CONTROL-D to terminate the main[warnce shell and restart the system.
... (warning).
Give root password for maintenance
(or type Control-D to continue):


-- System Information:
Debian Release: jessie/sid
  APT prefers unstable
  APT policy: (500, 'unstable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.9-1-amd64 (SMP w/2 CPU cores)
Locale: LANG=sk_SK, LC_CTYPE=sk_SK.UTF-8 (charmap=ANSI_X3.4-1968) (ignored:
LC_ALL set to C)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1     2.20.1-5.4
ii  libc6         2.17-7
ii  libreadline5  5.2+dfsg-2
ii  libuuid1      2.20.1-5.4

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.52-1
pn  attr     <none>
pn  quota    <none>
pn  xfsdump  <none>

-- no debconf information


-- 
http://blog.hostname.sk/ <http://blog.hostname.sk/gmail>debianbug

--001a11c2297a235b4404e0a17813
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Package: xfsprogs</div><div>Version: 3.1.9</div><div>=
Severity: minor</div><div>Tags: patch</div><div><br></div><div>Dear Maintai=
ner,</div><div><br></div><div style>If your rootfs is XFS (I hope it is :) =
), you should include some XFS tools into initrd.</div>
<div style>It would be handy in emergency situation. E.g. will help you to =
boot your domU.</div><div style><br></div><div style>Log from the Xen conso=
le:</div><div style><br></div><div style><div>Begin: Running /scripts/local=
-bottom ... done.<br>
</div><div>done.</div><div>Begin: Running /scripts/init-bottom ... done.</d=
iv><div>INIT: version 2.88 booting</div><div>[info] Using makefile-style co=
ncurrent boot in runlevel S.</div><div>[ ok ] Starting the hotplug events d=
ispatcher: udevd.</div>
<div>[ ok ] Synthesizing the initial hotplug events...done.</div><div>[ ok =
] Waiting for /dev to be fully populated...done.</div><div>[ ok ] Activatin=
g swap...done.</div><div>[....] Checking root file system...fsck from util-=
linux 2.20.1</div>
<div>fsck: fsck.xfs: not found</div><div>fsck: error 2 while executing fsck=
.xfs for /dev/xvda2</div><div>fsck died with exit status 8</div><div>failed=
 (code 8).</div><div>[....] An automatic file system check (fsck) of the ro=
ot filesystem failed. A manual fsck must be performed, then the system rest=
arted. The fsck should be performed in maintenance mo[FAILth the root files=
ystem mounted in read-only mode. ... failed!</div>
<div>[....] The root filesystem is currently mounted in read-only mode. A m=
aintenance shell will now be started. After performing system maintenance, =
press CONTROL-D to terminate the main[warnce shell and restart the system. =
... (warning).</div>
<div>Give root password for maintenance</div><div>(or type Control-D to con=
tinue):</div><div><br></div></div><div style><br></div><div>-- System Infor=
mation:</div><div>Debian Release: jessie/sid</div><div>=C2=A0 APT prefers u=
nstable</div>
<div>=C2=A0 APT policy: (500, &#39;unstable&#39;)</div><div>Architecture: a=
md64 (x86_64)</div><div><br></div><div>Kernel: Linux 3.9-1-amd64 (SMP w/2 C=
PU cores)</div><div>Locale: LANG=3Dsk_SK, LC_CTYPE=3Dsk_SK.UTF-8 (charmap=
=3DANSI_X3.4-1968) (ignored: LC_ALL set to C)</div>
<div>Shell: /bin/sh linked to /bin/dash</div><div><br></div><div>Versions o=
f packages xfsprogs depends on:</div><div>ii =C2=A0libblkid1 =C2=A0 =C2=A0 =
2.20.1-5.4</div><div>ii =C2=A0libc6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.17-7</div=
><div>ii =C2=A0libreadline5 =C2=A05.2+dfsg-2</div>
<div>ii =C2=A0libuuid1 =C2=A0 =C2=A0 =C2=A02.20.1-5.4</div><div><br></div><=
div>xfsprogs recommends no packages.</div><div><br></div><div>Versions of p=
ackages xfsprogs suggests:</div><div>ii =C2=A0acl =C2=A0 =C2=A0 =C2=A02.2.5=
2-1</div><div>pn =C2=A0attr =C2=A0 =C2=A0 &lt;none&gt;</div>
<div>pn =C2=A0quota =C2=A0 =C2=A0&lt;none&gt;</div><div>pn =C2=A0xfsdump =
=C2=A0&lt;none&gt;</div><div><br></div><div>-- no debconf information</div>=
<div><br></div><div><br></div>-- <br><a href=3D"http://blog.hostname.sk/gma=
il" target=3D"_blank">http://blog.hostname.sk/</a>debianbug<br>

</div>

--001a11c2297a235b4404e0a17813--

--001a11c2297a235b4904e0a17815
Content-Type: text/plain; charset=US-ASCII; name="initramfs-tools.hooks.xfsprogs.txt"
Content-Disposition: attachment;
	filename="initramfs-tools.hooks.xfsprogs.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hiozn7t70

IyEvYmluL3NoCgpQUkVSRVE9IiIKCnByZXJlcXMoKQp7CgllY2hvICIkUFJFUkVRIgp9CgpjYXNl
ICQxIGluCnByZXJlcXMpCglwcmVyZXFzCglleGl0IDAKCTs7CmVzYWMKCmlmIFsgISAteCAvc2Jp
bi94ZnNfcmVwYWlyIF07IHRoZW4KCWV4aXQgMApmaQoKLiAvdXNyL3NoYXJlL2luaXRyYW1mcy10
b29scy9ob29rLWZ1bmN0aW9ucwoKZm9yIHggaW4geGZzX2NvcHkgeGZzX2RiIHhmc19hZG1pbiB4
ZnNfY2hlY2sgeGZzX25jaGVjayB4ZnNfbWV0YWR1bXAgeGZzX2VzdGltYXRlIHhmc19mc3IgeGZz
X2dyb3dmcyB4ZnNfaW5mbyB4ZnNfaW8geGZzX2JtYXAgeGZzX2ZyZWV6ZSB4ZnNfbWtmaWxlIHhm
c19sb2dwcmludCB4ZnNfcXVvdGEgeGZzX21kcmVzdG9yZSB4ZnNfcnRjcDsgZG8KCWNvcHlfZXhl
YyAvdXNyL3NiaW4vJHgKZG9uZQpjb3B5X2V4ZWMgL3NiaW4veGZzX3JlcGFpcgpjb3B5X2V4ZWMg
L3NiaW4vbWtmcy54ZnMKCmNwIC1wIC9zYmluL21rZnMueGZzICIke0RFU1RESVJ9L3NiaW4iCmNw
IC1wIC9zYmluL2ZzY2sueGZzICIke0RFU1RESVJ9L3NiaW4iCgpmb3IgeCBpbiBsaWJjcmMzMmMg
eGZzOyBkbwoJbWFudWFsX2FkZF9tb2R1bGVzICR7eH0KZG9uZQo=
--001a11c2297a235b4904e0a17815
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001a11c2297a235b4904e0a17815--
