Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SBAe0O154881 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 05:10:40 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AAD61DC49A6
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 03:13:05 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	IiCI7BMcxMVDyoDn for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 03:13:05 -0800 (PST)
Received: by qyk12 with SMTP id 12so3489257qyk.5
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 03:13:04 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 20:13:04 +0900
Message-ID: <AANLkTiktigbHHHsYrxRBja6LxQ3N_gAq_KAoLNYGRB=r@mail.gmail.com>
Subject: [patch] xfsprogs: repair pagefault due to missed out sanity NULL check
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Content-Type: multipart/mixed; boundary=0016363b86f06d9a5d049ae626f5
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--0016363b86f06d9a5d049ae626f5
Content-Type: multipart/alternative; boundary=0016363b86f06d9a4c049ae626f3

--0016363b86f06d9a4c049ae626f3
Content-Type: text/plain; charset=ISO-8859-1

libxfs_putbuf() is called with bp = NULL, resulting in pagefault in
libpthread.

Function da_read_buf() allocate array of xfs_buf_t *

   * xfs_buf_t       **bplist;*

*    bplist = calloc(nex, sizeof(*bplist));*

Read and fill it using

*for (i = 0; i < nex; i++) {
    bplist[i] = libxfs_readbuf()*

*    if (!bplist[i]){
        goto failed;
    }  *

*}*

*failed:
        for (i = 0; i < nex; i++)
                libxfs_putbuf(bplist[i]);*

Now assume nex = 10,

1. Will create bplist for 10 array elements.

3. Reading from disk 0,1, 2, 3

4. When reading from disk 4, USB is removed

5. libxfs_readbuf() will at fail, pblist[4] = NULL, goto failed.

6. Since only 4 buffers were read successfully, so only 4 are in lock state.

7.  Error handling will unlock buffer from 1-10

8. Buffer 0-3 were read successfully, hence will have valid pdlist[i]

9. Access pblist[4] == NULL, therefore unlocking will set bp == NULL in
libxfs_putbuf(bp);
10. Page fault in libpthread


Solution patch attached with mail

--0016363b86f06d9a4c049ae626f3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">libxfs_putbuf() is called with=A0bp =3D NULL, resulting in pa=
gefault in libpthread.</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">Function da_read_buf() allocate array of=A0xfs_buf_t *</span>=
</font></div>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">=A0=A0=A0<strong>=A0xfs_buf_t=A0=A0=A0=A0=A0=A0 **bplist;</stro=
ng></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>=A0=A0=A0=A0bplist =3D calloc(nex, sizeof(*bplist));</s=
trong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">Read and fill it using =A0</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>for (i =3D 0; i &lt; nex; i++) {<br>=A0=A0=A0=A0bplist[=
i] =3D libxfs_readbuf()</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>=A0=A0=A0=A0if (!bplist[i]){<br>=A0=A0=A0=A0=A0=A0=A0=
=A0goto failed;<br>=A0=A0=A0=A0}=A0=A0</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>}</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>failed:<br>=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i &lt; n=
ex; i++)<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 libxfs_putbuf(bpl=
ist[i]);</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">Now assume nex =3D 10,</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">1. Will create bplist for 10 array elements.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">3. Reading from disk 0,1, 2, 3</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">4. When reading from disk 4, USB is removed</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">5. libxfs_readbuf() will at fail,=A0pblist[4] =3D NULL, goto fa=
iled.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">6. Since only 4 buffers were read successfully, so only 4 are i=
n lock state.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">7. =A0Error handling=A0will unlock buffer from 1-10</span></fon=
t></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">8. Buffer 0-3 were read successfully, hence will have valid pdl=
ist[i]</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">9. Access=A0pblist[4] =3D=3D NULL, therefore unlocking will set=
 bp =3D=3D NULL in libxfs_putbuf(bp);</span></font></p>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">10. Page fault in libpthread</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">Solution patch attached with mail</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>

--0016363b86f06d9a4c049ae626f3--

--0016363b86f06d9a5d049ae626f5
Content-Type: application/octet-stream;
	name="xfs_repair_da_read_buf_failed_unlock_fix.patch"
Content-Disposition: attachment;
	filename="xfs_repair_da_read_buf_failed_unlock_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjgzulym0

ZGlmZiAtTnVycCB4ZnNwcm9ncy0zLjAuNS9yZXBhaXIvZGlyMi5jIHhmc3Byb2dzLTMuMC41LWRp
cnR5L3JlcGFpci9kaXIyLmMKLS0tIHhmc3Byb2dzLTMuMC41L3JlcGFpci9kaXIyLmMJMjAxMC0w
Ny0xNiAxMzowNzowOS4wMDAwMDAwMDAgKzA5MDAKKysrIHhmc3Byb2dzLTMuMC41LWRpcnR5L3Jl
cGFpci9kaXIyLmMJMjAxMS0wMS0yOCAxODo0OToyMS4wMDAwMDAwMDAgKzA5MDAKQEAgLTExMCw5
ICsxMTAsMTAgQEAgZGFfcmVhZF9idWYoCiAJCWJwbGlzdFtpXSA9IGxpYnhmc19yZWFkYnVmKG1w
LT5tX2RldiwKIAkJCQlYRlNfRlNCX1RPX0RBRERSKG1wLCBibXBbaV0uc3RhcnRibG9jayksCiAJ
CQkJWEZTX0ZTQl9UT19CQihtcCwgYm1wW2ldLmJsb2NrY291bnQpLCAwKTsKLQkJaWYgKCFicGxp
c3RbaV0pCisJCWlmICghYnBsaXN0W2ldKXsKKwkJCW5leCA9IGk7CiAJCQlnb3RvIGZhaWxlZDsK
LQorCQl9CiAJCXBmdHJhY2UoInJlYWRidWYgJXAgKCVsbHUsICVkKSIsIGJwbGlzdFtpXSwKIAkJ
CShsb25nIGxvbmcpWEZTX0JVRl9BRERSKGJwbGlzdFtpXSksCiAJCQlYRlNfQlVGX0NPVU5UKGJw
bGlzdFtpXSkpOwo=
--0016363b86f06d9a5d049ae626f5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--0016363b86f06d9a5d049ae626f5--
