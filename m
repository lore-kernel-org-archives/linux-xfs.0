Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UKsR83021833 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 15:54:27 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5591936A5C
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 13:55:04 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id Rx5dAYyEHUutsg86
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 13:55:04 -0700 (PDT)
Received: by qwe5 with SMTP id 5so5416160qwe.26
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 13:55:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 15:55:02 -0500
Message-ID: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
Subject: What should to do with ASSERT failed
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0678040390082785831=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0678040390082785831==
Content-Type: multipart/alternative; boundary=00c09f899714aba312048f10ad8a

--00c09f899714aba312048f10ad8a
Content-Type: text/plain; charset=ISO-8859-1

xfs_vm_writepage
{
               /*
* A hole may still be marked uptodate because discard_buffer
 * leaves the flag set.
 */
if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
 ASSERT(!buffer_dirty(bh));
 imap_valid = 0;
 continue;
}
}

I met this case that buffer is marked as dirty which make assert failed.
What does this mean and what I can do with it?

Thanks very much,
Mike

--00c09f899714aba312048f10ad8a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">xfs_vm_writep=
age</span></div><div>{<span class=3D"Apple-tab-span" style=3D"white-space:p=
re">		</span></div><div><span class=3D"Apple-tab-span" style=3D"white-space=
:pre"></span>=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 /*</div>
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>* A =
hole may still be marked uptodate because discard_buffer</div><div><span cl=
ass=3D"Apple-tab-span" style=3D"white-space:pre">		</span> * leaves the fla=
g set.</div>
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span> */<=
/div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span=
>if (!buffer_mapped(bh) &amp;&amp; buffer_uptodate(bh)) {</div><div><span c=
lass=3D"Apple-tab-span" style=3D"white-space:pre">		</span><span class=3D"A=
pple-tab-span" style=3D"white-space:pre">	</span>ASSERT(!buffer_dirty(bh));=
</div>
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span><spa=
n class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>imap_valid =3D=
 0;</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</=
span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>conti=
nue;</div>
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>}</d=
iv><div>}</div><div><br></div><div>I met this case that buffer is marked as=
 dirty which make assert failed.=A0</div><div>What does this mean and what =
I can do with it?</div>
<div><br></div><div>Thanks very much,</div><div>Mike</div>

--00c09f899714aba312048f10ad8a--


--===============0678040390082785831==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0678040390082785831==--
