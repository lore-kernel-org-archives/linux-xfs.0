Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDAB27F57
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 01:40:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E3828F8050
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 23:40:32 -0800 (PST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	21UqFa7C4i2HpzQf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jan 2014 23:40:28 -0800 (PST)
Received: by mail-qc0-f171.google.com with SMTP id n7so6514532qcx.2
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 23:40:27 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 31 Jan 2014 08:40:27 +0100
Message-ID: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
Subject: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8379067871079649752=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8379067871079649752==
Content-Type: multipart/alternative; boundary=001a11c3a9849ec13904f13f493e

--001a11c3a9849ec13904f13f493e
Content-Type: text/plain; charset=ISO-8859-1

Hello,

If I understands it correctly XFS don't have a limit to the size of
extended attributes(EA) but Linux impose a limit at 64k.
What I am trying to do is build a backup server that our Apple computers
will use together with rsync to backup files to. The problem I face is that
Apple HFS+ don't have a limit to EA so it has files with more then 64k of
EA in it.

The Linux Kernel has a limit imposed to it in include/linux/limits.h

> #define XATTR_SIZE_MAX 65536    /* size of an extended attribute value
> (64k) */
>
#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist
> (64k) */
>

Changing this values feels unsafe because they will be system wide.

Is the any possibility to combine Linux + XFS to make a backup that works
with EA or is this more a question for kernel.org?

Thanks.

--001a11c3a9849ec13904f13f493e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div>Hello,<br><br></div>If I und=
erstands it correctly XFS don&#39;t have a limit to the size of extended at=
tributes(EA) but Linux impose a limit at 64k. <br></div>What I am trying to=
 do is build a backup server that our Apple computers will use together wit=
h rsync to backup files to. The problem I face is that Apple HFS+ don&#39;t=
 have a limit to EA so it has files with more then 64k of EA in it.<br>
<br></div>The Linux Kernel has a limit imposed to it in include/linux/limit=
s.h<br></div></div><blockquote style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_quote"><div><=
div>
<span class=3D"">#define</span><span class=3D""> XATTR_SIZE_MAX </span><spa=
n class=3D"">65536</span><span class=3D""> =A0 =A0</span><span class=3D"">/=
* size of an extended attribute value (64k) */</span><span class=3D""></spa=
n> <br></div>
</div></blockquote><blockquote style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_quote"><div><=
div><span class=3D"">#define</span><span class=3D""> XATTR_LIST_MAX </span>=
<span class=3D"">65536</span><span class=3D""> =A0 =A0</span><span class=3D=
"">/* size of extended attribute namelist (64k) */</span><span class=3D""><=
/span></div>
</div></blockquote><br></div><div>Changing this values feels unsafe because=
 they will be system wide.<br></div><div><br>Is the any possibility to comb=
ine Linux + XFS to make a backup that works with EA or is this more a quest=
ion for <a href=3D"http://kernel.org">kernel.org</a>?<br>
<br></div>Thanks.</div>

--001a11c3a9849ec13904f13f493e--


--===============8379067871079649752==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8379067871079649752==--
