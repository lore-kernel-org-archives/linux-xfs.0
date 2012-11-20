Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK6iP9G116156 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 00:44:25 -0600
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id A4NrnsaoR2UBlrl9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Nov 2012 22:46:34 -0800 (PST)
Received: by mail-la0-f53.google.com with SMTP id w12so4647443lag.26
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 22:46:32 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Nov 2012 12:16:32 +0530
Message-ID: <CAJaOQm8YscpdtFcMvU68VuiNH7eOYDsgY5wTTpUX=A_XDk5HCw@mail.gmail.com>
Subject: Available space after enable quota in XFS
From: "geturmaddy@gmail.com" <geturmaddy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4201025044581031806=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4201025044581031806==
Content-Type: multipart/alternative; boundary=f46d040714af2c506904cee79810

--f46d040714af2c506904cee79810
Content-Type: text/plain; charset=ISO-8859-1

Hi all,
I am trying to evaluation XFS for NFS server. We need to configure
directory level quota in order to better manage storage in the server. I
came to know that, we can use project quota which looks similar to
directory level quotas.

I was able to configure project level quota for XFS file system in my
Cent)S 5.7 machine. Below are the details

[root@linux-nfs ~]# cat  /etc/issue
CentOS release 5.6 (Final)
Kernel \r on an \m

[root@linux-nfs ~]# cat /etc/projects
13:/das/myproject1

[root@linux-nfs ~]# cat /etc/projid
myproject1:13

[root@linux-nfs ~]# xfs_quota -xc 'report -p' /das
Project quota on /das (/dev/cciss/c0d0)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
myproject1          0          0     102400     00 [--------]

You can see the hard limit set to 1G. But, when i check directory space
using df -h command. its showing entire file system space in "Avail" column.

[root@linux-nfs ~]# df -h /das/myproject1/
Filesystem            Size  Used *Avail *Use% Mounted on
/dev/cciss/c0d0       100M     0   *13T   *0% /das

Is there a way we can restrict showing entire FS size in Avail column (or
show available space which is left after using the allocated quota i.e,
Avail space = Size - Used) ? This actually cause confusion to end user who
things they still have enough space in the directory.

Thanks in advance
__madhusudhan

--f46d040714af2c506904cee79810
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,<div>I am trying to evaluation XFS for NFS server. We need to config=
ure directory level quota in order to better manage storage in the server. =
I came to know that, we can use project quota which looks similar to direct=
ory level quotas.=A0</div>
<div><br></div><div>I was able to configure project level quota for XFS fil=
e system in my Cent)S 5.7 machine. Below are the details</div><div><br></di=
v><div><div>[root@linux-nfs ~]# cat =A0/etc/issue</div><div>CentOS release =
5.6 (Final)</div>
<div>Kernel \r on an \m</div><div><br></div><div><div>[root@linux-nfs ~]# c=
at /etc/projects=A0</div><div>13:/das/myproject1<br></div><div><br></div><d=
iv>[root@linux-nfs ~]# cat /etc/projid=A0</div><div>myproject1:13<br></div>
</div><div><br></div><div><div>[root@linux-nfs ~]# xfs_quota -xc &#39;repor=
t -p&#39; /das</div><div>Project quota on /das (/dev/cciss/c0d0)</div><div>=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Blocks =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0</div><div>Project ID =A0 =A0 =A0 Use=
d =A0 =A0 =A0 Soft =A0 =A0 =A0 Hard =A0 =A0Warn/Grace =A0 =A0=A0</div>
<div>---------- --------------------------------------------------=A0</div>=
<div>myproject1 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 102400 =
=A0 =A0 00 [--------]</div></div><div><br></div><div>You can see the hard l=
imit set to 1G. But, when i check directory space using df -h command. its =
showing entire file system space in &quot;Avail&quot; column.</div>
<div><br></div><div><div>[root@linux-nfs ~]# df -h /das/myproject1/</div><d=
iv>Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used <b>Avail </b>Use% Mounted=
 on</div><div>/dev/cciss/c0d0 =A0 =A0 =A0 100M =A0 =A0 0 =A0 <b>13T =A0 </b=
>0% /das</div></div><div>
<br></div><div>Is there a way we can restrict showing entire FS size in Ava=
il column (or show available space which is left after using the allocated =
quota i.e, Avail space =3D Size - Used) ? This actually cause confusion to =
end user who things they still have enough space in the directory.=A0</div>
<div><br></div>Thanks in advance</div><div>__madhusudhan</div>

--f46d040714af2c506904cee79810--


--===============4201025044581031806==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4201025044581031806==--
