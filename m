Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQJBraC219558 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 13:11:53 -0600
Received: from relay02.pair.com (relay02.pair.com [209.68.5.16]) by
	cuda.sgi.com with SMTP id JWgjV4DRnHk7lyx6 for
	<xfs@oss.sgi.com>; Mon, 26 Nov 2012 11:14:07 -0800 (PST)
Date: Mon, 26 Nov 2012 14:14:04 -0500
Subject: INTERREUPT Error
From: "J. Ellis" <jellis@dhnet.us>
Message-ID: <CCD929AC.B007C%jellis@dhnet.us>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6036824116139872725=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Trevor Hurst <trev@sgi.com>

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============6036824116139872725==
Content-type: multipart/alternative;
	boundary="B_3436784046_25896892"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3436784046_25896892
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: quoted-printable

Well, looks like the email issue with my login may have been fixed. So
please excuse me if this is a double-post.

This is kind of a bad issue, and I can=B9t see what I'm doing wrong. Any help
would be appreciated.

Best,
J.

> Hi--
>>=20
>> I'm trying to copy one xfs volume to another using xfstools, and this ha=
s
>> always worked before, but I'm now having an issue. I had to reinstall my=
 OS.
>> I'm on Ubuntu 12.10, and just after Install, I updated to the latest xfs=
tools
>> by using the following instructions:
>>=20
>> git clone git://oss.sgi.com/xfs/xfs
>> git clone git://oss.sgi.com/xfs/cmds/xfsprogs
>> apt-get install libtool automake gettext uuid-dev
>> yum install libtool automake gettext uuid-devel
>> git clone git://oss.sgi.com/xfs/cmds/xfsdump
>>=20
>> I then ran the following commands which are part of the instructions to =
copy
>> the volume:
>>=20
>> mkdir /mnt/fap
>> mkdir /mnt/hr20
>> mount -t xfs -o rtdev=3D/dev/sda3 /dev/sda2 /mnt/fap
>> mount -t xfs -o rtdev=3D/dev/sdb3 /dev/sdb2 /mnt/hr20
>> xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fap
>>=20
>> At this point, I'm getting this output:
>>=20
>> xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)
>> xfsdump: ending media file
>> xfsdump: media file size 18874368 bytes
>> xfsdump: dump size (non-dir files) : 13698056 bytes
>> xfsdump: NOTE: dump interrupted: 16 seconds elapsed
>> xfsdump: Dump Status: INTERRUPT
>>=20
>> I have seen reports in the forums where the instructions are that xfstoo=
ls
>> has broken somewhat under 12.10, but I think I might be just doing somet=
hing
>> wrong. Can someone help me?


--B_3436784046_25896892
Content-type: text/html;
	charset="ISO-8859-1"
Content-transfer-encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>INTERREUPT Error</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:11pt=
'>Well, looks like the email issue with my login may have been fixed. So ple=
ase excuse me if this is a double-post.<BR>
<BR>
This is kind of a bad issue, and I can&#8217;t see what I'm doing wrong. An=
y help would be appreciated.<BR>
<BR>
Best,<BR>
J.<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><=
SPAN STYLE=3D'font-size:11pt'>Hi--<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><=
SPAN STYLE=3D'font-size:11pt'><BR>
I'm trying to copy one xfs volume to another using xfstools, and this has a=
lways worked before, but I'm now having an issue. I had to reinstall my OS. =
I'm on Ubuntu 12.10, and just after Install, I updated to the latest xfstool=
s by using the following instructions:<BR>
<BR>
git clone git://oss.sgi.com/xfs/xfs<BR>
git clone git://oss.sgi.com/xfs/cmds/xfsprogs<BR>
apt-get install libtool <U>automake</U> gettext uuid-dev <BR>
yum install libtool automake gettext uuid-devel<BR>
git clone git://oss.sgi.com/xfs/cmds/xfsdump<BR>
</SPAN></FONT><FONT COLOR=3D"#3265BA"><FONT SIZE=3D"2"><FONT FACE=3D"Courier, Cou=
rier New"><SPAN STYLE=3D'font-size:10pt'><BR>
</SPAN></FONT></FONT></FONT><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>I then ran the following commands which are pa=
rt of the instructions to copy the volume:<BR>
<BR>
</SPAN></FONT><FONT SIZE=3D"2"><FONT FACE=3D"Verdana, Helvetica, Arial"><SPAN S=
TYLE=3D'font-size:10pt'>mkdir /mnt/fap<BR>
mkdir /mnt/hr20<BR>
mount -t xfs -o rtdev=3D/dev/sda3 /dev/sda2 /mnt/fap<BR>
mount -t xfs -o rtdev=3D/dev/sdb3 /dev/sdb2 /mnt/hr20<BR>
xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fap<BR>
<BR>
At this point, I'm getting this output:<BR>
<BR>
xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)<BR>
xfsdump: ending media file<BR>
xfsdump: media file size 18874368 bytes<BR>
xfsdump: dump size (non-dir files) : 13698056 bytes<BR>
xfsdump: NOTE: dump interrupted: 16 seconds elapsed<BR>
xfsdump: Dump Status: INTERRUPT<BR>
<BR>
I have seen reports in the forums where the instructions are that xfstools =
has broken somewhat under 12.10, but I think I might be just doing something=
 wrong. Can someone help me?</SPAN></FONT></FONT></BLOCKQUOTE></BLOCKQUOTE>
</BODY>
</HTML>


--B_3436784046_25896892--



--===============6036824116139872725==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6036824116139872725==--
