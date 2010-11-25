Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP6pXI5234144 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 00:51:34 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AB981C701B4
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 22:53:11 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id l4kIMGUm8mxkFgjI
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 22:53:11 -0800 (PST)
Received: by qwj8 with SMTP id 8so122255qwj.26
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 22:53:11 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Nov 2010 12:23:11 +0530
Message-ID: <AANLkTi=3BNqaUJGLuCOipQX_eP07QXa6dCBB-nUqmqG0@mail.gmail.com>
Subject: XFS Direct IO, unaligned block zeroing at 128K boundery
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0636863798217072308=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0636863798217072308==
Content-Type: multipart/alternative; boundary=0016363103052740ab0495db0fbc

--0016363103052740ab0495db0fbc
Content-Type: text/plain; charset=ISO-8859-1

Dear all
I made a simple script that creates a 2MB file using directio write
operation,
The objective was to test with different buffer sizes from 4K-5K-6K..8K, the
buffer was filled with 5,
Than take hexdump of file to check data integrity.

With 4K the file is fine, but with 5K, It can be noticed that

there is zeroing is at 128K boundry further this shift 1K on successive 128K
chunk.
I guess this is a bug.
------------------------------------------------------------------------------------
*****************************
BUFFER SIZE : 4096
*****************************
0000000 0505 0505 0505 0505 0505 0505 0505 0505
*
0200000
*****************************
BUFFER SIZE : 5120
*****************************
0000000 0505 0505 0505 0505 0505 0505 0505 0505
*
001f400 0000 0000 0000 0000 0000 0000 0000 0000
*
0020000 0505 0505 0505 0505 0505 0505 0505 0505
*
002f800 0000 0000 0000 0000 0000 0000 0000 0000
*
0030000 0505 0505 0505 0505 0505 0505 0505 0505
*
003fc00 0000 0000 0000 0000 0000 0000 0000 0000
*
0040000 0505 0505 0505 0505 0505 0505 0505 0505
*
006f400 0000 0000 0000 0000 0000 0000 0000 0000
*
0070000 0505 0505 0505 0505 0505 0505 0505 0505
*
007f800 0000 0000 0000 0000 0000 0000 0000 0000
*
0080000 0505 0505 0505 0505 0505 0505 0505 0505
*
008fc00 0000 0000 0000 0000 0000 0000 0000 0000
*
0090000 0505 0505 0505 0505 0505 0505 0505 0505
*
00bf400 0000 0000 0000 0000 0000 0000 0000 0000
*
00c0000 0505 0505 0505 0505 0505 0505 0505 0505
*
00cf800 0000 0000 0000 0000 0000 0000 0000 0000
*
00d0000 0505 0505 0505 0505 0505 0505 0505 0505
*
00dfc00 0000 0000 0000 0000 0000 0000 0000 0000
*
00e0000 0505 0505 0505 0505 0505 0505 0505 0505
*
010f400 0000 0000 0000 0000 0000 0000 0000 0000
*
0110000 0505 0505 0505 0505 0505 0505 0505 0505
*
011f800 0000 0000 0000 0000 0000 0000 0000 0000
*
0120000 0505 0505 0505 0505 0505 0505 0505 0505
*
012fc00 0000 0000 0000 0000 0000 0000 0000 0000
*
0130000 0505 0505 0505 0505 0505 0505 0505 0505
*
015f400 0000 0000 0000 0000 0000 0000 0000 0000
*
0160000 0505 0505 0505 0505 0505 0505 0505 0505
*
016f800 0000 0000 0000 0000 0000 0000 0000 0000
*
0170000 0505 0505 0505 0505 0505 0505 0505 0505
*
017fc00 0000 0000 0000 0000 0000 0000 0000 0000
*
0180000 0505 0505 0505 0505 0505 0505 0505 0505
*
01af400 0000 0000 0000 0000 0000 0000 0000 0000
*
01b0000 0505 0505 0505 0505 0505 0505 0505 0505
*
01bf800 0000 0000 0000 0000 0000 0000 0000 0000
*
01c0000 0505 0505 0505 0505 0505 0505 0505 0505
*
01cfc00 0000 0000 0000 0000 0000 0000 0000 0000
*
01d0000 0505 0505 0505 0505 0505 0505 0505 0505
*
01ff400

On Wed, Nov 24, 2010 at 10:10 AM, Ajeet Yadav <ajeet.yadav.77@gmail.com>wrote:

> We have backported complete xfs from 2.6.34 to 2.6.30.9, because there were
> many fixes since 2.6.30.9
>   On Tue, Nov 23, 2010 at 6:51 PM, Christoph Hellwig <hch@infradead.org>wrote:
>
>> On Tue, Nov 23, 2010 at 03:50:37PM +0530, Ajeet Yadav wrote:
>> > I have the following backtrace on my ARM target, please have a look
>>
>> Are sure you're on 2.6.34?  Something similar was fixed by commit
>> f1f724e4b523d444c5a598d74505aefa3d6844d2 in 2.6.34.
>>
>>
>

--0016363103052740ab0495db0fbc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear all</div>
<div>I made a simple script that creates a 2MB file using=A0directio write =
operation,</div>
<div>The objective was to test with different buffer sizes from 4K-5K-6K..8=
K, the buffer was filled with 5,</div>
<div>Than take hexdump of file to check data integrity.</div>
<div>=A0</div>
<div>With 4K the file is fine, but with 5K, It can be noticed that </div>
<div>=A0</div>
<div>there=A0is zeroing is at 128K boundry further this shift 1K on success=
ive 128K chunk.</div>
<div>I guess this is a bug.=A0</div>
<div>----------------------------------------------------------------------=
--------------</div>
<div>*****************************<br>BUFFER SIZE : 4096<br>***************=
**************<br>0000000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>0=
200000<br>*****************************<br>BUFFER SIZE : 5120<br>**********=
*******************<br>
0000000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>001f400 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0020000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>002f800 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0030000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>003fc00 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0040000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>006f400 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0070000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>007f800 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0080000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>008fc00 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0090000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>00bf400 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>00c0000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>00cf800 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
00d0000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>00dfc00 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>00e0000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>010f400 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0110000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>011f800 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0120000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>012fc00 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0130000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>015f400 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0160000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>016f800 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
0170000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>017fc00 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>0180000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>01af400 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
01b0000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>01bf800 0000 0000 0=
000 0000 0000 0000 0000 0000<br>*<br>01c0000 0505 0505 0505 0505 0505 0505 =
0505 0505<br>*<br>01cfc00 0000 0000 0000 0000 0000 0000 0000 0000<br>*<br>
01d0000 0505 0505 0505 0505 0505 0505 0505 0505<br>*<br>01ff400<br><br></di=
v>
<div class=3D"gmail_quote">On Wed, Nov 24, 2010 at 10:10 AM, Ajeet Yadav <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:ajeet.yadav.77@gmail.com">ajeet.yadav=
.77@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>We have backported complete xfs from 2.6.34 to 2.6.30.9, because there=
 were many fixes since 2.6.30.9<br></div>
<div>
<div></div>
<div class=3D"h5">
<div class=3D"gmail_quote">On Tue, Nov 23, 2010 at 6:51 PM, Christoph Hellw=
ig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org" target=3D"_bl=
ank">hch@infradead.org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>On Tue, Nov 23, 2010 at 03:50:37PM +0530, Ajeet Yadav wrote:<br>&gt; I=
 have the following backtrace on my ARM target, please have a look<br><br><=
/div>Are sure you&#39;re on 2.6.34? =A0Something similar was fixed by commi=
t<br>
f1f724e4b523d444c5a598d74505aefa3d6844d2 in 2.6.34.<br><br></blockquote></d=
iv><br></div></div></blockquote></div><br>

--0016363103052740ab0495db0fbc--


--===============0636863798217072308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0636863798217072308==--
