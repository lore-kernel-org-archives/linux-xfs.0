Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S1PwBu159928 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 20:25:58 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	IWTvY1s99cACNmgT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 18:27:17 -0700 (PDT)
Received: by vchn11 with SMTP id n11so2838810vch.26
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 18:27:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926061732.GI29154@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
	<CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
	<20120926061732.GI29154@dastard>
Date: Thu, 27 Sep 2012 19:27:16 -0600
Message-ID: <CAHt31__59_XJw9EF7MniiYH5sS6CX44q9gGwxiqxx43k5OFZ4A@mail.gmail.com>
Subject: Re: xfs_repair deleting realtime files.
From: Anand Tiwari <tiwarikanand@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5562686733403418931=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============5562686733403418931==
Content-Type: multipart/alternative; boundary=047d7b86edf6cc149504cab8f458

--047d7b86edf6cc149504cab8f458
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Sep 26, 2012 at 12:17 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 25, 2012 at 09:45:07PM -0600, Anand Tiwari wrote:
> > thanks Dave for prompt reply, I meant to implement option 2 as you
> > explained (option 3).  I will start working on it tomorrow. In the mean
> > time, I also had  to put something in xfs_repair for the files which
> > already exists on the disk. Would you guys willing to review/comment on
> > that ?
>
> Sure.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

following are my changes for xfs_repair. my goal  is to keep changes
minimum as they may not included in upstream. I had to do these changes as
we already have files with extent map not properly aligned.
As we know, this happens only when we are growing a file in a realtime
volume. by keeping this in mind, I am checking if start of a record in
extent map is not aligned, check previous record and if they are
contiguous, we can skip that part of record.

let me know if you any issues with this or if someone has better approach.
I would like to use pointers for prev and irec but again, I wanted to keep
changes minimum

thanks
anand


XFS currently can have records in extent map, which starts from unaligned
block w.r.t rextsize.

--------------------------------------

xfs_repair considers this as a bug (multiple claims for a one real time
extent) and deletes the file.
This patch addresses the issue, by comparing current and previous records
and make sure they are
contiguous and not overlapped.

diff --git a/repair/dinode.c b/repair/dinode.c
index 5a2da39..5537f1c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -406,6 +406,7 @@ verify_agbno(xfs_mount_t *mp,
 static int
 process_rt_rec(
  xfs_mount_t *mp,
+ xfs_bmbt_irec_t *prev,
  xfs_bmbt_irec_t *irec,
  xfs_ino_t ino,
  xfs_drfsbno_t *tot,
@@ -413,8 +414,11 @@ process_rt_rec(
 {
  xfs_dfsbno_t b;
  xfs_drtbno_t ext;
+ xfs_drtbno_t start_block;
+ xfs_filblks_t block_count;
  int state;
  int pwe; /* partially-written extent */
+ int rtext_remainder; /* start block is not aligned w.r.t rextsize */

  /*
  * check numeric validity of the extent
@@ -461,12 +465,32 @@ _("malformed rt inode extent [%" PRIu64 " %" PRIu64
"] (fs rtext size = %u)\n"),
  return 1;
  }

+ /* If we have start of record unaligned w.r.t to rextsize, see
+ * if we are sharing this realtime extent with previous record. sharing is
only
+ * allowed with previous extent. fail otherwise.
+ * Also, if above condition is true, align start block and block count
+ */
+ rtext_remainder = irec->br_startblock % mp->m_sb.sb_rextsize;
+ if (rtext_remainder) {
+ do_warn(
+_("data fork in rt ino %" PRIu64 " has unalinged start block %"PRIu64
"\n"),
+ ino,
+ irec->br_startblock);
+ if ((prev->br_startoff + prev->br_blockcount == irec->br_startoff) &&
+    (prev->br_startblock + prev->br_blockcount == irec->br_startblock)) {
+ start_block = irec->br_startblock + (mp->m_sb.sb_rextsize -
rtext_remainder);
+ block_count = irec->br_blockcount - (mp->m_sb.sb_rextsize -
rtext_remainder);
+ }
+ } else {
+ start_block = irec->br_startblock;
+ block_count = irec->br_blockcount;
+ }
+
  /*
  * set the appropriate number of extents
  * this iterates block by block, this can be optimised using extents
  */
- for (b = irec->br_startblock; b < irec->br_startblock +
- irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
+ for (b = start_block; b < start_block + block_count; b +=
mp->m_sb.sb_rextsize)  {
  ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
  pwe = xfs_sb_version_hasextflgbit(&mp->m_sb) &&
  irec->br_state == XFS_EXT_UNWRITTEN &&
@@ -548,6 +572,7 @@ process_bmbt_reclist_int(
  int check_dups,
  int whichfork)
 {
+ xfs_bmbt_irec_t prev;
  xfs_bmbt_irec_t irec;
  xfs_dfilblks_t cp = 0; /* prev count */
  xfs_dfsbno_t sp = 0; /* prev start */
@@ -574,6 +599,11 @@ process_bmbt_reclist_int(
  else
  ftype = _("regular");

+ prev.br_startoff = 0;
+ prev.br_blockcount = 0;
+ prev.br_startblock = 0;
+ prev.br_state = 0;
+
  for (i = 0; i < *numrecs; i++) {
  libxfs_bmbt_disk_get_all(rp + i, &irec);
  if (i == 0)
@@ -610,12 +640,13 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %"
PRIu64 ") in ino %" PRIu64
  * realtime bitmaps don't use AG locks, so returning
  * immediately is fine for this code path.
  */
- if (process_rt_rec(mp, &irec, ino, tot, check_dups))
+ if (process_rt_rec(mp, &prev, &irec, ino, tot, check_dups))
  return 1;
  /*
  * skip rest of loop processing since that'irec.br_startblock
  * all for regular file forks and attr forks
  */
+ memcpy(&prev, &irec, sizeof(xfs_bmbt_irec_t));
  continue;
  }

--047d7b86edf6cc149504cab8f458
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Wed, Sep 26, 2012 at 12:17 AM, Dave C=
hinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On Tue, Sep 25, 2012 at 09:45:07PM -0600, Anand Tiwari wr=
ote:<br>
&gt; thanks Dave for prompt reply, I meant to implement option 2 as you<br>
&gt; explained (option 3). =A0I will start working on it tomorrow. In the m=
ean<br>
&gt; time, I also had =A0to put something in xfs_repair for the files which=
<br>
&gt; already exists on the disk. Would you guys willing to review/comment o=
n<br>
&gt; that ?<br>
<br>
</div>Sure.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><div>following are my changes for xfs_re=
pair. my goal =A0is to keep changes minimum as they may not included in ups=
tream. I had to do these changes as we already have files with extent map n=
ot properly aligned.</div>
<div>As we know, this happens only when we are growing a file in a realtime=
 volume. by keeping this in mind, I am checking if start of a record in ext=
ent map is not aligned, check previous record and if they are contiguous, w=
e can skip that part of record.=A0</div>
<div><br></div><div>let me know if you any issues with this or if someone h=
as better approach. I would like to use pointers for prev and irec but agai=
n, I wanted to keep changes minimum</div><div><br></div><div>thanks</div>
<div>anand</div><div><br></div><div><br></div><div><div>XFS currently can h=
ave records in extent map, which starts from unaligned block w.r.t rextsize=
.</div><div><br></div><div>--------------------------------------</div>
<div><br></div><div>xfs_repair considers this as a bug (multiple claims for=
 a one real time extent) and deletes the file.</div><div>This patch address=
es the issue, by comparing current and previous records and make sure they =
are</div>
<div>contiguous and not overlapped.</div><div><br></div><div>diff --git a/r=
epair/dinode.c b/repair/dinode.c</div><div>index 5a2da39..5537f1c 100644</d=
iv><div>--- a/repair/dinode.c</div><div>+++ b/repair/dinode.c</div><div>
@@ -406,6 +406,7 @@ verify_agbno(xfs_mount_t<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>*mp,</div><div>=A0static int</div><div>=
=A0process_rt_rec(</div><div>=A0<span class=3D"Apple-tab-span" style=3D"whi=
te-space:pre">	</span>xfs_mount_t<span class=3D"Apple-tab-span" style=3D"wh=
ite-space:pre">		</span>*mp,</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xfs_=
bmbt_irec_t <span class=3D"Apple-tab-span" style=3D"white-space:pre">	</spa=
n>*prev,</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:p=
re">	</span>xfs_bmbt_irec_t <span class=3D"Apple-tab-span" style=3D"white-s=
pace:pre">	</span>*irec,</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xf=
s_ino_t<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>in=
o,</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	<=
/span>xfs_drfsbno_t<span class=3D"Apple-tab-span" style=3D"white-space:pre"=
>		</span>*tot,</div>
<div>@@ -413,8 +414,11 @@ process_rt_rec(</div><div>=A0{</div><div>=A0<span=
 class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xfs_dfsbno_t<sp=
an class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>b;</div><div=
>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xfs_dr=
tbno_t<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>ext=
;</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xfs_=
drtbno_t<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>s=
tart_block;</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:=
pre">	</span>xfs_filblks_t<span class=3D"Apple-tab-span" style=3D"white-spa=
ce:pre">		</span>block_count;</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>in=
t<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>state;<=
/div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</sp=
an>int<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>pw=
e;<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>/* part=
ially-written extent */</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>rtext_re=
mainder;<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/*=
 start block is not aligned w.r.t rextsize */</div>
<div>=A0</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:p=
re">	</span>/*</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-s=
pace:pre">	</span> * check numeric validity of the extent</div><div>@@ -461=
,12 +465,32 @@ _(&quot;malformed rt inode extent [%&quot; PRIu64 &quot; %&q=
uot; PRIu64 &quot;] (fs rtext size =3D %u)\n&quot;),</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>r=
eturn 1;</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:p=
re">	</span>}</div><div>=A0</div><div>+<span class=3D"Apple-tab-span" style=
=3D"white-space:pre">	</span>/* If we have start of record unaligned w.r.t =
to rextsize, see</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * i=
f we are sharing this realtime extent with previous record. sharing is only=
</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</spa=
n> * allowed with previous extent. fail otherwise.</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * A=
lso, if above condition is true, align start block and block count</div><di=
v>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> */</di=
v><div>
+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>rtext_rem=
ainder =3D irec-&gt;br_startblock % mp-&gt;m_sb.sb_rextsize;</div><div>+<sp=
an class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if (rtext_rem=
ainder) {</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>do_=
warn(</div><div>+_(&quot;data fork in rt ino %&quot; PRIu64 &quot; has unal=
inged start block %&quot;PRIu64 &quot;\n&quot;),</div><div>+<span class=3D"=
Apple-tab-span" style=3D"white-space:pre">		</span>ino,</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>ire=
c-&gt;br_startblock);</div><div>+<span class=3D"Apple-tab-span" style=3D"wh=
ite-space:pre">		</span>if ((prev-&gt;br_startoff + prev-&gt;br_blockcount =
=3D=3D irec-&gt;br_startoff) &amp;&amp;</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span> =
=A0 =A0(prev-&gt;br_startblock + prev-&gt;br_blockcount =3D=3D irec-&gt;br_=
startblock)) {</div><div>+<span class=3D"Apple-tab-span" style=3D"white-spa=
ce:pre">			</span>start_block =3D irec-&gt;br_startblock + (mp-&gt;m_sb.sb_=
rextsize - rtext_remainder);</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>bl=
ock_count =3D irec-&gt;br_blockcount - (mp-&gt;m_sb.sb_rextsize - rtext_rem=
ainder);</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre=
">		</span>}</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>} el=
se {</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>start_block =3D irec-&gt;br_startblock;</div><div>+<span class=3D"Ap=
ple-tab-span" style=3D"white-space:pre">		</span>block_count =3D irec-&gt;b=
r_blockcount;</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>}</d=
iv><div>+</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:=
pre">	</span>/*</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-=
space:pre">	</span> * set the appropriate number of extents</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> *=
 this iterates block by block, this can be optimised using extents</div><di=
v>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> */</=
div><div>
-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>for (b =
=3D irec-&gt;br_startblock; b &lt; irec-&gt;br_startblock +</div><div>-<spa=
n class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>irec-&gt;br_=
blockcount; b +=3D mp-&gt;m_sb.sb_rextsize) =A0{</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>for =
(b =3D start_block; b &lt; start_block + block_count; b +=3D mp-&gt;m_sb.sb=
_rextsize) =A0{</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-=
space:pre">		</span>ext =3D (xfs_drtbno_t) b / mp-&gt;m_sb.sb_rextsize;</di=
v>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>p=
we =3D xfs_sb_version_hasextflgbit(&amp;mp-&gt;m_sb) &amp;&amp;</div><div>=
=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">				</span>irec=
-&gt;br_state =3D=3D XFS_EXT_UNWRITTEN &amp;&amp;</div>
<div>@@ -548,6 +572,7 @@ process_bmbt_reclist_int(</div><div>=A0<span class=
=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int<span class=3D"App=
le-tab-span" style=3D"white-space:pre">			</span>check_dups,</div><div>=A0<=
span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int<span cl=
ass=3D"Apple-tab-span" style=3D"white-space:pre">			</span>whichfork)</div>
<div>=A0{</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:pr=
e">	</span>xfs_bmbt_irec_t<span class=3D"Apple-tab-span" style=3D"white-spa=
ce:pre">		</span>prev;</div><div>=A0<span class=3D"Apple-tab-span" style=3D=
"white-space:pre">	</span>xfs_bmbt_irec_t<span class=3D"Apple-tab-span" sty=
le=3D"white-space:pre">		</span>irec;</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xf=
s_dfilblks_t<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</sp=
an>cp =3D 0;<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</sp=
an>/* prev count */</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>xf=
s_dfsbno_t<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span=
>sp =3D 0;<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span=
>/* prev start */</div>
<div>@@ -574,6 +599,11 @@ process_bmbt_reclist_int(</div><div>=A0<span clas=
s=3D"Apple-tab-span" style=3D"white-space:pre">	</span>else</div><div>=A0<s=
pan class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>ftype =3D _=
(&quot;regular&quot;);</div>
<div>=A0</div><div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre=
">	</span>prev.br_startoff =3D 0;</div><div>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>prev.br_blockcount =3D 0;</div><div>+<sp=
an class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>prev.br_start=
block =3D 0;</div>
<div>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>prev=
.br_state =3D 0;</div><div>+</div><div>=A0<span class=3D"Apple-tab-span" st=
yle=3D"white-space:pre">	</span>for (i =3D 0; i &lt; *numrecs; i++) {</div>=
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>l=
ibxfs_bmbt_disk_get_all(rp + i, &amp;irec);</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>i=
f (i =3D=3D 0)</div><div>@@ -610,12 +640,13 @@ _(&quot;zero length extent (=
off =3D %&quot; PRIu64 &quot;, fsbno =3D %&quot; PRIu64 &quot;) in ino %&qu=
ot; PRIu64</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>=
 * realtime bitmaps don&#39;t use AG locks, so returning</div><div>=A0<span=
 class=3D"Apple-tab-span" style=3D"white-space:pre">			</span> * immediatel=
y is fine for this code path.</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>=
 */</div><div>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">			=
</span>if (process_rt_rec(mp, &amp;irec, ino, tot, check_dups))</div><div>+=
<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>if (proc=
ess_rt_rec(mp, &amp;prev, &amp;irec, ino, tot, check_dups))</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">				</span=
>return 1;</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space=
:pre">			</span>/*</div><div>=A0<span class=3D"Apple-tab-span" style=3D"whi=
te-space:pre">			</span> * skip rest of loop processing since that&#39;irec=
.br_startblock</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>=
 * all for regular file forks and attr forks</div><div>=A0<span class=3D"Ap=
ple-tab-span" style=3D"white-space:pre">			</span> */</div><div>+<span clas=
s=3D"Apple-tab-span" style=3D"white-space:pre">			</span>memcpy(&amp;prev, =
&amp;irec, sizeof(xfs_bmbt_irec_t));</div>
<div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:pre">			</span>=
continue;</div><div>=A0<span class=3D"Apple-tab-span" style=3D"white-space:=
pre">		</span>}</div><div>=A0</div><div><br></div></div>

--047d7b86edf6cc149504cab8f458--


--===============5562686733403418931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5562686733403418931==--
