Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9FK38j120595 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 09:20:03 -0600
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	Mf7VzhZa3HZu1Hb2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 07:22:02 -0800 (PST)
Received: by mail-vc0-f181.google.com with SMTP id n11so4122992vch.26
	for <xfs@oss.sgi.com>; Fri, 09 Nov 2012 07:22:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121109104839.GE6434@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
	<20121109104839.GE6434@dastard>
Date: Fri, 9 Nov 2012 07:22:01 -0800
Message-ID: <CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
From: Aaron Goulding <aarongldng@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4822755708599698815=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4822755708599698815==
Content-Type: multipart/alternative; boundary=bcaec50166136c3f8d04ce1183e5

--bcaec50166136c3f8d04ce1183e5
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Nov 9, 2012 at 2:48 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Nov 08, 2012 at 11:28:20PM -0800, Aaron Goulding wrote:
> > On Thu, Nov 8, 2012 at 1:02 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > That seems like way too many to be filesystem metadata hits. I woul
> > > dhave expected the same number of hits as there are AGs in the
> > > filesytem. What you want is the XFSB string in the first 4
> > > bytes of a sector, with the next sector having XAGF as the first
> > > four bytes....
> > >
> >
> > Okay this proved helpful. I ran a check of the first 1024 bytes at each
> of
> > those 19000 results for XAGF, then limited that to results that occurred
> at
> > the 512 byte relative mark. This dropped the results down to  11. I then
> > went and grabbed 8192 bytes starting at each of those 11 points, and
> > attached them.
>
> bad:
>
> 4398367673432.dmp2 - has a headr followed by zeros, then parts of a
> transaction headers, etc. just looks like random bits of filesystem
> metadata record. It's probably the log.
>
> 12094629761024.dmp2 - has the first part of a superblco, but the
> empty part of the sb is not zeroed - looks like a utf8 string?
> Perhaps directory structure? components.ini.new is the repeated
> name... AGI, AGF AGF look intact. Has this fs been grown in the
> past?
>
> 13194139877376.dmp2 - Looks like an empty, pristine AG just freshly
> allocated by mkfs. (AGFL contains only blocks 4,5,6 and 7, and the
> AGF and ABTB block show a single large freespace extent covering the
> entire AG (0x937a4 blocks in size).
>
> So, judging by what I've got here, the file names are the block
> offset of the data and that the offsets start at 0. That gives me
> the headers for AGs 1, 3, 4, (the log in AG 4), 5, 6, 7, 9, 10, 11
> and 12. Missing are 0, 2 and 8.
>
> /me hugs xfs_db
>
> $ xfs_db -c "sb 0" -c p -f 1099514834944.dmp2
> <snip warnings>
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3375866880
> rblocks = 0
> rextents = 0
> uuid = e36d4151-2bf0-4f0e-87e2-c21963022640
> logstart = 1073741828
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 1
> agblocks = 268435455
> agcount = 13
> rbmblocks = 0
> logblocks = 521728
> versionnum = 0xb4b4
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 28
> rextslog = 0
> inprogress = 0
> imax_pct = 5
> icount = 3970688
> ifree = 11
> fdblocks = 260163907
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 1
> features2 = 0xa
> bad_features2 = 0xa
>
> So I now know that there are only 13 AGs (0-12), and you are only
> missing 0, 2 and 8, and that the log starts at 4398046527490 which
> matches with the chunk that I though was a log record. The AGFs
> indicate the sequence numbers are in the correct order and match the
> offsets, so AFAICT you've assembled the array in the right order.
>
> I think the best thing you could do copy the first 512 bytes from
> the 1099514834944.dmp2 to the first sector of the device you dumped
> this from (i.e. offset zero), and then running xfs_repair -n on it
> to see whether it validates it as correct. (save the sector contents
> first, jsut in case).
>
> root@jarvis:~/dump1# dd if=1099514834944.dmp2 of=/dev/md1 bs=512 count=1
1+0 records in
1+0 records out
512 bytes (512 B) copied, 0.0649365 s, 7.9 kB/s
root@jarvis:~/dump1# xfs_i
xfs_info  xfs_io
root@jarvis:~/dump1# xfs_repair -n /dev/md1
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks with
matching geometry !!!

attempting to find secondary superblock...
......................................................................................................................

Hrm I'm guessing that's not a good response, but I'll let it run. If that
doesn't return good results, I'll try xfs_irecover.

-Aaron

--bcaec50166136c3f8d04ce1183e5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, N=
ov 9, 2012 at 2:48 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto=
:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> =
wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex"><div class=3D""><div clas=
s=3D"h5">On Thu, Nov 08, 2012 at 11:28:20PM -0800, Aaron Goulding wrote:<br=
>
&gt; On Thu, Nov 8, 2012 at 1:02 PM, Dave Chinner &lt;<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; That seems like way too many to be filesystem metadata hits. I wo=
ul<br>
&gt; &gt; dhave expected the same number of hits as there are AGs in the<br=
>
&gt; &gt; filesytem. What you want is the XFSB string in the first 4<br>
&gt; &gt; bytes of a sector, with the next sector having XAGF as the first<=
br>
&gt; &gt; four bytes....<br>
&gt; &gt;<br>
&gt;<br>
&gt; Okay this proved helpful. I ran a check of the first 1024 bytes at eac=
h of<br>
&gt; those 19000 results for XAGF, then limited that to results that occurr=
ed at<br>
&gt; the 512 byte relative mark. This dropped the results down to =A011. I =
then<br>
&gt; went and grabbed 8192 bytes starting at each of those 11 points, and<b=
r>
&gt; attached them.<br>
<br>
</div></div>bad:<br>
<br>
4398367673432.dmp2 - has a headr followed by zeros, then parts of a<br>
transaction headers, etc. just looks like random bits of filesystem<br>
metadata record. It&#39;s probably the log.<br>
<br>
12094629761024.dmp2 - has the first part of a superblco, but the<br>
empty part of the sb is not zeroed - looks like a utf8 string?<br>
Perhaps directory structure? components.ini.new is the repeated<br>
name... AGI, AGF AGF look intact. Has this fs been grown in the<br>
past?<br>
<br>
13194139877376.dmp2 - Looks like an empty, pristine AG just freshly<br>
allocated by mkfs. (AGFL contains only blocks 4,5,6 and 7, and the<br>
AGF and ABTB block show a single large freespace extent covering the<br>
entire AG (0x937a4 blocks in size).<br>
<br>
So, judging by what I&#39;ve got here, the file names are the block<br>
offset of the data and that the offsets start at 0. That gives me<br>
the headers for AGs 1, 3, 4, (the log in AG 4), 5, 6, 7, 9, 10, 11<br>
and 12. Missing are 0, 2 and 8.<br>
<br>
/me hugs xfs_db<br>
<br>
$ xfs_db -c &quot;sb 0&quot; -c p -f 1099514834944.dmp2<br>
&lt;snip warnings&gt;<br>
magicnum =3D 0x58465342<br>
blocksize =3D 4096<br>
dblocks =3D 3375866880<br>
rblocks =3D 0<br>
rextents =3D 0<br>
uuid =3D e36d4151-2bf0-4f0e-87e2-c21963022640<br>
logstart =3D 1073741828<br>
rootino =3D 128<br>
rbmino =3D 129<br>
rsumino =3D 130<br>
rextsize =3D 1<br>
agblocks =3D 268435455<br>
agcount =3D 13<br>
rbmblocks =3D 0<br>
logblocks =3D 521728<br>
versionnum =3D 0xb4b4<br>
sectsize =3D 512<br>
inodesize =3D 256<br>
inopblock =3D 16<br>
fname =3D &quot;\000\000\000\000\000\000\000\000\000\000\000\000&quot;<br>
blocklog =3D 12<br>
sectlog =3D 9<br>
inodelog =3D 8<br>
inopblog =3D 4<br>
agblklog =3D 28<br>
rextslog =3D 0<br>
inprogress =3D 0<br>
imax_pct =3D 5<br>
icount =3D 3970688<br>
ifree =3D 11<br>
fdblocks =3D 260163907<br>
frextents =3D 0<br>
uquotino =3D 0<br>
gquotino =3D 0<br>
qflags =3D 0<br>
flags =3D 0<br>
shared_vn =3D 0<br>
inoalignmt =3D 2<br>
unit =3D 0<br>
width =3D 0<br>
dirblklog =3D 0<br>
logsectlog =3D 0<br>
logsectsize =3D 0<br>
logsunit =3D 1<br>
features2 =3D 0xa<br>
bad_features2 =3D 0xa<br>
<br>
So I now know that there are only 13 AGs (0-12), and you are only<br>
missing 0, 2 and 8, and that the log starts at 4398046527490 which<br>
matches with the chunk that I though was a log record. The AGFs<br>
indicate the sequence numbers are in the correct order and match the<br>
offsets, so AFAICT you&#39;ve assembled the array in the right order.<br>
<br>
I think the best thing you could do copy the first 512 bytes from<br>
the 1099514834944.dmp2 to the first sector of the device you dumped<br>
this from (i.e. offset zero), and then running xfs_repair -n on it<br>
to see whether it validates it as correct. (save the sector contents<br>
first, jsut in case).<br>
<br></blockquote><div>root@jarvis:~/dump1# dd if=3D1099514834944.dmp2 of=3D=
/dev/md1 bs=3D512 count=3D1<br>1+0 records in<br>1+0 records out<br>512 byt=
es (512 B) copied, 0.0649365 s, 7.9 kB/s<br>root@jarvis:~/dump1# xfs_i<br>x=
fs_info=A0 xfs_io<br>
root@jarvis:~/dump1# xfs_repair -n /dev/md1<br>Phase 1 - find and verify su=
perblock...<br>couldn&#39;t verify primary superblock - not enough secondar=
y superblocks with matching geometry !!!<br><br>attempting to find secondar=
y superblock...<br>
...........................................................................=
...........................................<br><br>Hrm I&#39;m guessing tha=
t&#39;s not a good response, but I&#39;ll let it run. If that doesn&#39;t r=
eturn good results, I&#39;ll try xfs_irecover.<br>
</div></div><br>-Aaron<br></div>

--bcaec50166136c3f8d04ce1183e5--


--===============4822755708599698815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4822755708599698815==--
