Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3P5hthX100461 for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 00:43:56 -0500
Received: from nm5-vm2.bullet.mail.ne1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 01BEF4074A0
	for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 22:47:25 -0700 (PDT)
Received: from nm5-vm2.bullet.mail.ne1.yahoo.com
	(nm5-vm2.bullet.mail.ne1.yahoo.com [98.138.90.153]) by
	cuda.sgi.com with SMTP id m00oRiJVFg4W02Ms for
	<xfs@oss.sgi.com>; Sun, 24 Apr 2011 22:47:25 -0700 (PDT)
Message-ID: <658864.45039.qm@web112901.mail.gq1.yahoo.com>
Date: Sun, 24 Apr 2011 22:47:24 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: fs corruption
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5998440342742340897=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============5998440342742340897==
Content-Type: multipart/alternative; boundary="0-933126365-1303710444=:45039"

--0-933126365-1303710444=:45039
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Just to add if it helps- I find this logged by smart array controller:=0ACo=
rrected ECC Error, Status=3D0x00000001 Addr=3D0x060f4e00=0A=A0=0A=A0=0A=0A_=
_______________________________=0AFrom: Leo Davis <leo1783@yahoo.com>=0ATo:=
 Dave Chinner <david@fromorbit.com>=0ACc: xfs@oss.sgi.com=0ASent: Mon, Apri=
l 25, 2011 9:55:02 AM=0ASubject: Re: fs corruption=0A=0A=0AThank you for th=
at :).=0A=0AHowever,I've run into another fs corruption issue on my other s=
erver. I just =0Athought I would use the same thread rather than opening ne=
w.=0A=0AI was troublehooting a weird fiber channel issue ( logins going mis=
sing to my =0Astorage) when I=A0noticed these backtraces in dmesg. =0A=0A=
=0AFilesystem "cciss/c3d1p1": XFS internal error xfs_btree_check_lblock at =
line 186 =0Aof file fs/xfs/xfs_btree.c. Caller 0xffffffff881b92d6=0ACall Tr=
ace:=0A[<ffffffff881bce83>] :xfs:xfs_btree_check_lblock+0xf4/0xfe=0A[<fffff=
fff881b92d6>] :xfs:xfs_bmbt_lookup+0x159/0x420=0A[<ffffffff881b41cc>] :xfs:=
xfs_bmap_add_extent_delay_real+0x62a/0x103a=0A[<ffffffff881a8cfa>] :xfs:xfs=
_alloc_vextent+0x379/0x3ff=0A[<ffffffff881b543a>] :xfs:xfs_bmap_add_extent+=
0x1fb/0x390=0A[<ffffffff881b7f34>] :xfs:xfs_bmapi+0x895/0xe79=0A[<ffffffff8=
81d4082>] :xfs:xfs_iomap_write_allocate+0x201/0x328=0A[<ffffffff881d4b09>] =
:xfs:xfs_iomap+0x22a/0x2a5=0A[<ffffffff881e9ae3>] :xfs:xfs_map_blocks+0x2d/=
0x65=0A[<ffffffff881ea723>] :xfs:xfs_page_state_convert+0x2af/0x544=0A[<fff=
fffff881eab04>] :xfs:xfs_vm_writepage+0xa7/0xdf=0A[<ffffffff8001cef2>] mpag=
e_writepages+0x1bf/0x37d=0A[<ffffffff881eaa5d>] :xfs:xfs_vm_writepage+0x0/0=
xdf=0A[<ffffffff8005b1ea>] do_writepages+0x20/0x2f=0A[<ffffffff8005000e>] _=
_filemap_fdatawrite_range+0x50/0x5b=0A[<ffffffff80050717>] do_fsync+0x2f/0x=
a4=0A[<ffffffff800e1ce9>] __do_fsync+0x23/0x36=0A[<ffffffff8005e116>] syste=
m_call+0x7e/0x83=0AFilesystem "cciss/c3d1p1": XFS internal error xfs_trans_=
cancel at line 1164 of =0Afile fs/xfs/xfs_trans.c. Caller 0xffffffff881d418=
6=0ACall Trace:=0A[<ffffffff881e1b37>] :xfs:xfs_trans_cancel+0x55/0xfa=0A[<=
ffffffff881d4186>] :xfs:xfs_iomap_write_allocate+0x305/0x328=0A[<ffffffff88=
1d4b09>] :xfs:xfs_iomap+0x22a/0x2a5=0A[<ffffffff881e9ae3>] :xfs:xfs_map_blo=
cks+0x2d/0x65=0A[<ffffffff881ea723>] :xfs:xfs_page_state_convert+0x2af/0x54=
4=0A[<ffffffff881eab04>] :xfs:xfs_vm_writepage+0xa7/0xdf=0A[<ffffffff8001ce=
f2>] mpage_writepages+0x1bf/0x37d=0A[<ffffffff881eaa5d>] :xfs:xfs_vm_writep=
age+0x0/0xdf=0A[<ffffffff8005b1ea>] do_writepages+0x20/0x2f=0A[<ffffffff800=
5000e>] __filemap_fdatawrite_range+0x50/0x5b=0A[<ffffffff80050717>] do_fsyn=
c+0x2f/0xa4=0A[<ffffffff800e1ce9>] __do_fsync+0x23/0x36=0A[<ffffffff8005e11=
6>] system_call+0x7e/0x83=0Axfs_force_shutdown(cciss/c3d1p1,0x8) called fro=
m line 1165 of file =0Afs/xfs/xfs_trans.c. Return address =3D 0xffffffff881=
e1b50=0AFilesystem "cciss/c3d1p1": Corruption of in-memory data detected. S=
hutting down =0Afilesystem: cciss/c3d1p1=0APlease umount the filesystem, an=
d rectify the problem(s)=0AFilesystem "cciss/c3d1p1": xfs_log_force: error =
5 returned.=0AFilesystem "cciss/c3d1p1": xfs_log_force: error 5 returned.=
=0A=A0=0A=0AAny thoughts on what the=A0root cause might be?=0A-=A0I've chec=
ked the underlying drives, array controller etc and all looks =0Ahealthy; (=
indicating it is a fs issue for sure?)=0AI did the xfs_repair which correct=
ed the issue but I'm worried as to how=A0fs =0Aended up in this state, this=
 being a production box.=0A=0AThanks in advance.=0A=0A=0A=0A=0A____________=
____________________=0AFrom: Dave Chinner <david@fromorbit.com>=0ATo: Leo D=
avis <leo1783@yahoo.com>=0ACc: xfs@oss.sgi.com=0ASent: Tue, April 12, 2011 =
4:35:32 PM=0ASubject: Re: fs corruption=0A=0AOn Tue, Apr 12, 2011 at 03:51:=
20AM -0700, Leo Davis wrote:=0A> You have a corrupted free space btree.=0A>=
 =0A> Err... apologies for my ignorance, but what is a free space btree?=0A=
=0AA tree that indexes the free space in the filesystem. Every time you=0Aw=
rite a file or remove a file you are allocating or freeing space,=0Aand the=
se tree keep track of that free space.=0A=0AIf you want to know - at a high=
 level - how XFS is structured (good=0Afor understanding what a free space =
tree is), read this paper:=0A=0Ahttp://oss.sgi.com/projects/xfs/papers/xfs_=
usenix/index.html=0A=0AIt's from 1996, but still correct on all the major s=
tructural=0Adetails.=0A=0A> I had serial trace from raid controller which i=
 just checked and=0A> it logged some 'Loose cabling', but this was months b=
ack.....=A0 not=0A> sure whether that can be the cause of this.. strange if=
 that is=0A> the case since it's been a long time=0A=0Ait's possible that i=
t took a couple of months to trip over a random=0Ametadata corruption. I've=
 seen that before in directory trees and=0Ainode clusters where corruption =
is not detected until next time they=0Aare read from disk....=0A=0ACheers,=
=0A=0ADave.=0A-- =0ADave Chinner=0Adavid@fromorbit.com=0A
--0-933126365-1303710444=:45039
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman, new york, times, serif;=
font-size:12pt"><DIV>Just to add if it helps- I find this logged by smart a=
rray controller:</DIV>=0A<DIV><SPAN lang=3DEN>=0A<P>Corrected ECC Error, St=
atus=3D0x00000001 Addr=3D0x060f4e00</P>=0A<P>&nbsp;</P>=0A<P></SPAN><BR>&nb=
sp;</P></DIV>=0A<DIV style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman=
, new york, times, serif">=0A<DIV style=3D"FONT-SIZE: 12pt; FONT-FAMILY: ti=
mes new roman, new york, times, serif"><FONT face=3DTahoma size=3D2>=0A<HR =
SIZE=3D1>=0A<B><SPAN style=3D"FONT-WEIGHT: bold">From:</SPAN></B> Leo Davis=
 &lt;leo1783@yahoo.com&gt;<BR><B><SPAN style=3D"FONT-WEIGHT: bold">To:</SPA=
N></B> Dave Chinner &lt;david@fromorbit.com&gt;<BR><B><SPAN style=3D"FONT-W=
EIGHT: bold">Cc:</SPAN></B> xfs@oss.sgi.com<BR><B><SPAN style=3D"FONT-WEIGH=
T: bold">Sent:</SPAN></B> Mon, April 25, 2011 9:55:02 AM<BR><B><SPAN style=
=3D"FONT-WEIGHT: bold">Subject:</SPAN></B> Re: fs corruption<BR></FONT><BR>=
=0A<DIV style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, t=
imes, serif">=0A<DIV>Thank you for that :).</DIV>=0A<DIV>&nbsp;</DIV>=0A<DI=
V>However,I've run into another fs corruption issue on my other server. I j=
ust thought I would use the same thread rather than opening new.</DIV>=0A<D=
IV>&nbsp;</DIV>=0A<DIV>I was troublehooting a weird fiber channel issue ( l=
ogins going missing to my storage) when I&nbsp;noticed these backtraces in =
dmesg. </DIV>=0A<DIV>&nbsp;</DIV>=0A<DIV><SPAN lang=3DEN>=0A<P>Filesystem "=
cciss/c3d1p1": XFS internal error xfs_btree_check_lblock at line 186 of fil=
e fs/xfs/xfs_btree.c. Caller 0xffffffff881b92d6</P>=0A<P>Call Trace:</P>=0A=
<P>[&lt;ffffffff881bce83&gt;] :xfs:xfs_btree_check_lblock+0xf4/0xfe</P>=0A<=
P>[&lt;ffffffff881b92d6&gt;] :xfs:xfs_bmbt_lookup+0x159/0x420</P>=0A<P>[&lt=
;ffffffff881b41cc&gt;] :xfs:xfs_bmap_add_extent_delay_real+0x62a/0x103a</P>=
=0A<P>[&lt;ffffffff881a8cfa&gt;] :xfs:xfs_alloc_vextent+0x379/0x3ff</P>=0A<=
P>[&lt;ffffffff881b543a&gt;] :xfs:xfs_bmap_add_extent+0x1fb/0x390</P>=0A<P>=
[&lt;ffffffff881b7f34&gt;] :xfs:xfs_bmapi+0x895/0xe79</P>=0A<P>[&lt;fffffff=
f881d4082&gt;] :xfs:xfs_iomap_write_allocate+0x201/0x328</P>=0A<P>[&lt;ffff=
ffff881d4b09&gt;] :xfs:xfs_iomap+0x22a/0x2a5</P>=0A<P>[&lt;ffffffff881e9ae3=
&gt;] :xfs:xfs_map_blocks+0x2d/0x65</P>=0A<P>[&lt;ffffffff881ea723&gt;] :xf=
s:xfs_page_state_convert+0x2af/0x544</P>=0A<P>[&lt;ffffffff881eab04&gt;] :x=
fs:xfs_vm_writepage+0xa7/0xdf</P>=0A<P>[&lt;ffffffff8001cef2&gt;] mpage_wri=
tepages+0x1bf/0x37d</P>=0A<P>[&lt;ffffffff881eaa5d&gt;] :xfs:xfs_vm_writepa=
ge+0x0/0xdf</P>=0A<P>[&lt;ffffffff8005b1ea&gt;] do_writepages+0x20/0x2f</P>=
=0A<P>[&lt;ffffffff8005000e&gt;] __filemap_fdatawrite_range+0x50/0x5b</P>=
=0A<P>[&lt;ffffffff80050717&gt;] do_fsync+0x2f/0xa4</P>=0A<P>[&lt;ffffffff8=
00e1ce9&gt;] __do_fsync+0x23/0x36</P>=0A<P>[&lt;ffffffff8005e116&gt;] syste=
m_call+0x7e/0x83</P>=0A<P>Filesystem "cciss/c3d1p1": XFS internal error xfs=
_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c. Caller 0xffffffff881=
d4186</P>=0A<P>Call Trace:</P>=0A<P>[&lt;ffffffff881e1b37&gt;] :xfs:xfs_tra=
ns_cancel+0x55/0xfa</P>=0A<P>[&lt;ffffffff881d4186&gt;] :xfs:xfs_iomap_writ=
e_allocate+0x305/0x328</P>=0A<P>[&lt;ffffffff881d4b09&gt;] :xfs:xfs_iomap+0=
x22a/0x2a5</P>=0A<P>[&lt;ffffffff881e9ae3&gt;] :xfs:xfs_map_blocks+0x2d/0x6=
5</P>=0A<P>[&lt;ffffffff881ea723&gt;] :xfs:xfs_page_state_convert+0x2af/0x5=
44</P>=0A<P>[&lt;ffffffff881eab04&gt;] :xfs:xfs_vm_writepage+0xa7/0xdf</P>=
=0A<P>[&lt;ffffffff8001cef2&gt;] mpage_writepages+0x1bf/0x37d</P>=0A<P>[&lt=
;ffffffff881eaa5d&gt;] :xfs:xfs_vm_writepage+0x0/0xdf</P>=0A<P>[&lt;fffffff=
f8005b1ea&gt;] do_writepages+0x20/0x2f</P>=0A<P>[&lt;ffffffff8005000e&gt;] =
__filemap_fdatawrite_range+0x50/0x5b</P>=0A<P>[&lt;ffffffff80050717&gt;] do=
_fsync+0x2f/0xa4</P>=0A<P>[&lt;ffffffff800e1ce9&gt;] __do_fsync+0x23/0x36</=
P>=0A<P>[&lt;ffffffff8005e116&gt;] system_call+0x7e/0x83</P>=0A<P>xfs_force=
_shutdown(cciss/c3d1p1,0x8) called from line 1165 of file fs/xfs/xfs_trans.=
c. Return address =3D 0xffffffff881e1b50</P>=0A<P>Filesystem "cciss/c3d1p1"=
: Corruption of in-memory data detected. Shutting down filesystem: cciss/c3=
d1p1</P>=0A<P>Please umount the filesystem, and rectify the problem(s)</P>=
=0A<P>Filesystem "cciss/c3d1p1": xfs_log_force: error 5 returned.</P>=0A<P>=
Filesystem "cciss/c3d1p1": xfs_log_force: error 5 returned.</P>=0A<P>&nbsp;=
</P></SPAN></DIV>=0A<DIV>&nbsp;</DIV>=0A<DIV>Any thoughts on what the&nbsp;=
root cause might be?</DIV>=0A<DIV>-&nbsp;I've checked the underlying drives=
, array controller etc and all looks healthy; (indicating it is a fs issue =
for sure?)</DIV>=0A<DIV>I did the xfs_repair which corrected the issue but =
I'm worried as to how&nbsp;fs ended up in this state, this being a producti=
on box.</DIV>=0A<DIV>&nbsp;</DIV>=0A<DIV>Thanks in advance.<BR></DIV>=0A<DI=
V style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, times, =
serif"><BR>=0A<DIV style=3D"FONT-SIZE: 13px; FONT-FAMILY: arial, helvetica,=
 sans-serif"><FONT face=3DTahoma size=3D2>=0A<HR SIZE=3D1>=0A<B><SPAN style=
=3D"FONT-WEIGHT: bold">From:</SPAN></B> Dave Chinner &lt;david@fromorbit.co=
m&gt;<BR><B><SPAN style=3D"FONT-WEIGHT: bold">To:</SPAN></B> Leo Davis &lt;=
leo1783@yahoo.com&gt;<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Cc:</SPAN></B=
> xfs@oss.sgi.com<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Sent:</SPAN></B> =
Tue, April 12, 2011 4:35:32 PM<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Subj=
ect:</SPAN></B> Re: fs corruption<BR></FONT><BR>On Tue, Apr 12, 2011 at 03:=
51:20AM -0700, Leo Davis wrote:<BR>&gt; You have a corrupted free space btr=
ee.<BR>&gt; <BR>&gt; Err... apologies for my ignorance, but what is a free =
space btree?<BR><BR>A tree that indexes the free space in the filesystem. E=
very time you<BR>write a file or remove a file you are allocating or freein=
g space,<BR>and these tree keep track of that free space.<BR><BR>If you wan=
t to know - at a high level - how XFS is structured (good<BR>for understand=
ing what a free space tree is), read this
 paper:<BR><BR>http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html=
<BR><BR>It's from 1996, but still correct on all the major structural<BR>de=
tails.<BR><BR>&gt; I had serial trace from raid controller which i just che=
cked and<BR>&gt; it logged some 'Loose cabling', but this was months back..=
...&nbsp; not<BR>&gt; sure whether that can be the cause of this.. strange =
if that is<BR>&gt; the case since it's been a long time<BR><BR>it's possibl=
e that it took a couple of months to trip over a random<BR>metadata corrupt=
ion. I've seen that before in directory trees and<BR>inode clusters where c=
orruption is not detected until next time they<BR>are read from disk....<BR=
><BR>Cheers,<BR><BR>Dave.<BR>-- <BR>Dave Chinner<BR><A href=3D"mailto:david=
@fromorbit.com" target=3D_blank rel=3Dnofollow ymailto=3D"mailto:david@from=
orbit.com">david@fromorbit.com</A><BR></DIV></DIV></DIV></DIV></DIV></div><=
/body></html>
--0-933126365-1303710444=:45039--


--===============5998440342742340897==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5998440342742340897==--
