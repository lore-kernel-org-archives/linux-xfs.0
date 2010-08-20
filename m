Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7KLrwCP256188 for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 16:53:58 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5660515D7950
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 15:04:00 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	jSNza3im2hxBDlK3 for <xfs@oss.sgi.com>;
	Fri, 20 Aug 2010 15:04:00 -0700 (PDT)
Received: by qyk9 with SMTP id 9so931883qyk.5
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 14:54:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mailman.3.1282323602.244605.xfs@oss.sgi.com>
References: <mailman.3.1282323602.244605.xfs@oss.sgi.com>
Date: Fri, 20 Aug 2010 16:54:28 -0500
Message-ID: <AANLkTi=D=Bh7n7mQX-y-nZgsAtxwPqcDasaeisacQOvx@mail.gmail.com>
Subject: Re: xfs Digest, Vol 24, Issue 44
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4554420473284199582=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4554420473284199582==
Content-Type: multipart/alternative; boundary=0016364ef503c60fb7048e4857dc

--0016364ef503c60fb7048e4857dc
Content-Type: text/plain; charset=ISO-8859-1

The question is "Is there anything else we can do except print these
message?
For example, call a recovery function which already be implemented in user
tools to fix it.
I ask this because if the disk is in customer's side, they may not be able
to format it.

Thanks,
Mike


>
>
>
> ------------------------------
>
> Message: 2
> Date: Thu, 19 Aug 2010 17:32:33 -0500
> From: Mike Gao <ygao.linux@gmail.com>
> Subject: Question about XFS recovery and error
> To: xfs@oss.sgi.com
> Message-ID:
>        <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com<prcC7ky3ikNTJ%2Bpy8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
> >
> Content-Type: text/plain; charset="iso-8859-1"
>
> The USB key is mounted automatically at boot and no error report with XFS
> recovery.
> But when I did a file copy on a USB key which XFS filesystem could be
> corrupted by some reason,
> I got endless repeat of ERROR message printed on the screen.
>
> Should XFS recovery this at the beginning when mounting?
>
> [42949387.250000] Starting XFS recovery on filesystem: sda (logdev:
> internal)
> [42949387.330000] Ending XFS recovery on filesystem: sda (logdev: internal)
> [42949388.600000] Starting XFS recovery on filesystem: sdb1 (logdev:
> internal)
> [42949388.640000] Ending XFS recovery on filesystem: sdb1 (logdev:
> internal)
>
>
> cp /mnt/USB0disk1/iCarly-4.ts ./iCarly-4-10.ts
>
> [ 3234.740000] Filesystem "sda": XFS internal error xfs_btree_check_sblock
> at line 120 of file fs/xfs/xfs_btree.c.  Caller 0x8718e102
> [ 3234.740000]
> [ 3234.750000] regs can't be NULL.
> [ 3234.760000] Filesystem "sda": page discard on page 876a1914, inode 0x91,
> offset 91160576.
> [ 3235.150000] Filesystem "sda": XFS internal error xfs_btree_check_sblock
> at line 120 of file fs/xfs/xfs_btree.c.  Caller 0x8718e102
>
> Thanks,
> Mike
> -------------- next part --------------
> An HTML attachment was scrubbed...
> URL: <
> http://oss.sgi.com/pipermail/xfs/attachments/20100819/62574c74/attachment.html
> >
>
> ------------------------------
>
>
>
> End of xfs Digest, Vol 24, Issue 44
> ***********************************
>

--0016364ef503c60fb7048e4857dc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br>The question is &quot;Is there anything else we can do except print the=
se message?<div>For example, call a recovery function which already be impl=
emented in user tools to fix it.</div><div>I ask this because if the disk i=
s in customer&#39;s side, they may not be able to format it.</div>
<div><br></div><div>Thanks,</div><div>Mike</div><div>=A0=A0=A0<br><div clas=
s=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex;"><br>
<br>
<br>
------------------------------<br>
<br>
Message: 2<br>
Date: Thu, 19 Aug 2010 17:32:33 -0500<br>
From: Mike Gao &lt;<a href=3D"mailto:ygao.linux@gmail.com">ygao.linux@gmail=
.com</a>&gt;<br>
Subject: Question about XFS recovery and error<br>
To: <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
Message-ID:<br>
 =A0 =A0 =A0 =A0&lt;AANLkTi=3D<a href=3D"mailto:prcC7ky3ikNTJ%2Bpy8XnALGf4T=
HSOCUwqYhxaq@mail.gmail.com">prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gma=
il.com</a>&gt;<br>
Content-Type: text/plain; charset=3D&quot;iso-8859-1&quot;<br>
<br>
The USB key is mounted automatically at boot and no error report with XFS<b=
r>
recovery.<br>
But when I did a file copy on a USB key which XFS filesystem could be<br>
corrupted by some reason,<br>
I got endless repeat of ERROR message printed on the screen.<br>
<br>
Should XFS recovery this at the beginning when mounting?<br>
<br>
[42949387.250000] Starting XFS recovery on filesystem: sda (logdev:<br>
internal)<br>
[42949387.330000] Ending XFS recovery on filesystem: sda (logdev: internal)=
<br>
[42949388.600000] Starting XFS recovery on filesystem: sdb1 (logdev:<br>
internal)<br>
[42949388.640000] Ending XFS recovery on filesystem: sdb1 (logdev: internal=
)<br>
<br>
<br>
cp /mnt/USB0disk1/iCarly-4.ts ./iCarly-4-10.ts<br>
<br>
[ 3234.740000] Filesystem &quot;sda&quot;: XFS internal error xfs_btree_che=
ck_sblock<br>
at line 120 of file fs/xfs/xfs_btree.c. =A0Caller 0x8718e102<br>
[ 3234.740000]<br>
[ 3234.750000] regs can&#39;t be NULL.<br>
[ 3234.760000] Filesystem &quot;sda&quot;: page discard on page 876a1914, i=
node 0x91,<br>
offset 91160576.<br>
[ 3235.150000] Filesystem &quot;sda&quot;: XFS internal error xfs_btree_che=
ck_sblock<br>
at line 120 of file fs/xfs/xfs_btree.c. =A0Caller 0x8718e102<br>
<br>
Thanks,<br>
Mike<br>
-------------- next part --------------<br>
An HTML attachment was scrubbed...<br>
URL: &lt;<a href=3D"http://oss.sgi.com/pipermail/xfs/attachments/20100819/6=
2574c74/attachment.html" target=3D"_blank">http://oss.sgi.com/pipermail/xfs=
/attachments/20100819/62574c74/attachment.html</a>&gt;<br>
<br>
------------------------------<br>
<br><br>
<br>
End of xfs Digest, Vol 24, Issue 44<br>
***********************************<br>
</blockquote></div><br></div>

--0016364ef503c60fb7048e4857dc--


--===============4554420473284199582==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4554420473284199582==--
