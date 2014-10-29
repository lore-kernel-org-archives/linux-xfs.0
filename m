Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F7E57F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:30:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EEDF304039
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:30:35 -0700 (PDT)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	FP6wc46ljOlkgl9i (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:30:33 -0700 (PDT)
Received: by mail-ob0-f175.google.com with SMTP id wm4so1771030obc.34
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:30:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54506CD9.90403@sandeen.net>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
Date: Wed, 29 Oct 2014 12:30:33 +0800
Message-ID: <CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6371264248086047316=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <xfs@oss.sgi.com>

--===============6371264248086047316==
Content-Type: multipart/alternative; boundary=089e0149cc0c7e41c20506883930

--089e0149cc0c7e41c20506883930
Content-Type: text/plain; charset=UTF-8

both dump and restore with those 2 patches.

2014-10-29 12:28 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:

> On 10/28/14 11:27 PM, Tommy Wu wrote:
> > In "xfsdump not work in 3.17", after apply the 2 patches, xfsdump work
> (won't hang).
> > But xfsrestore can't restore the dump correctly (like the case in this
> email).
> >
> > Is other patch I miss?  I check the thread in Archive again, I don't see
> any patch about the xfsrestore issue.
>
> Was the dump you are restoring created with those 2 patches in place?  Or
> was
> it created with the stock/unpatched 3.17 kernel?
>
> -Eric
>



-- 

Tommy Wu

--089e0149cc0c7e41c20506883930
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">both dump and restore with those 2 patches.<br></div><div =
class=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-10-29 12:28 GMT+0=
8:00 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.n=
et" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span>:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex"><span class=3D"">On 10/28/14 11:27 PM, Tommy Wu wrote:<br>
&gt; In &quot;xfsdump not work in 3.17&quot;, after apply the 2 patches, xf=
sdump work (won&#39;t hang).<br>
&gt; But xfsrestore can&#39;t restore the dump correctly (like the case in =
this email).<br>
&gt;<br>
&gt; Is other patch I miss?=C2=A0 I check the thread in Archive again, I do=
n&#39;t see any patch about the xfsrestore issue.<br>
<br>
</span>Was the dump you are restoring created with those 2 patches in place=
?=C2=A0 Or was<br>
it created with the stock/unpatched 3.17 kernel?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--089e0149cc0c7e41c20506883930--


--===============6371264248086047316==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6371264248086047316==--
