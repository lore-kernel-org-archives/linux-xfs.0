Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J14BQm169100 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 19:04:11 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C89D3126213A
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 17:06:27 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id RCD0cFeKGvsrj8GF
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 17:06:27 -0800 (PST)
Received: by qwe5 with SMTP id 5so275250qwe.26
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 17:06:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110118045730.GU28803@dastard>
References: <AANLkTin=nqXCVJRgqBuTDx6nxMx1GLiG2DortJG+pz2L@mail.gmail.com>
	<20110118045730.GU28803@dastard>
Date: Wed, 19 Jan 2011 10:06:26 +0900
Message-ID: <AANLkTikc-_dZvpu6Yb-FNJVVWqhmsC4OgVZ8gj0mRx-y@mail.gmail.com>
Subject: Re: XFS internal error xfs_iformat(realtime) even after xfs_repair.
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1949892817748200024=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1949892817748200024==
Content-Type: multipart/alternative; boundary=0015175cb81860f0eb049a28a0fa

--0015175cb81860f0eb049a28a0fa
Content-Type: text/plain; charset=ISO-8859-1

Please find my response below

On Tue, Jan 18, 2011 at 1:57 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jan 17, 2011 at 09:12:54PM +0900, Ajeet Yadav wrote:
> > Kernel: 2.6.30.9, XFS backported from 2.6.34, xfsprogs-3.0.5
> >
> > I used a script
> > 1. create some file, directories, symlinks
> > 2. unmount the file system
> > 3. run xfs_bd with blocktrash
> > 4. xfs_xfsrepair -L
> > 5. list "ls -lR"
> > 6. remove all file and directory "rm -rf *
>
> OK, so you are effectively corrupting random blocks by introducing
> random bit errors in the blocks. No surprise that some errors are
> not being detected - what is the blocktrash command that you are
> using?
>

xfs_db -x -c blockget -c "blocktrash -s 12345 -n 256 -x 1 -y 1024 -3"
/dev/sda1


>
> > Often during testing I get the below backtrace from kernel during ls, rm
> > even though I already run xfs_repair on it.
> > Is it related to xfsrepair or xfs ?. I think xfs_repair must have
> detected
> > this problem and corrected it.
>
> xfs_repair is not checking the di_flags field in the inode for
> sanity, hence having a wrong flag set is going unnoticed.
>

ok


>
> > There is similar problem already reported by
> > http://oss.sgi.com/archives/xfs/2010-06/msg00349.html
>
> Similar error message (xfs_iformt found an inode corruption), but
> that one is a completely different problem.
>
> Does the patch below (compile tested only) detect the bad inode?
>

Yes I have tested it, It seems to work fine,
I did not find this patch in mainline xfsprogs git, also I need to modify
the patch somewhat.
dino->di_flags  ===================> dinoc->di_flags
because dino is not having any member named di_flags in xfsprogs-3.0.5, so I
used dinoc instead.


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs_repair: validate inode di_flags field
>
> xfs_repair is not validating the di_flags field in the inode for
> sanity. Block fuzzing indicates that we are not picking situations
> like the RT bit being set on filesystems without realtime devices.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.c |   62
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 62 insertions(+), 0 deletions(-)
>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 2fa850d..e05d4e0 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2519,6 +2519,68 @@ process_dinode_int(xfs_mount_t *mp,
>                goto clear_bad_out;
>        }
>
> +       /*
> +        * check that we only have valid flags set, and those that are set
> make
> +        * sense.
> +        */
> +       if (dino->di_flags) {
> +               uint16_t flags = be16_to_cpu(dino->di_flags);
> +
> +               if (flags & ~XFS_DIFLAG_ANY) {
> +                       do_warn(_("Bad flags set in inode %llu"), lino);
> +                       flags &= ~XFS_DIFLAG_ANY;
> +               }
> +
> +               if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
> +                       /* need an rt-dev! */
> +                       if (!rt_name) {
> +                               do_warn(_(
> +       "inode %llu has RT flag set but there is no RT device"), lino);
> +                               flags &= ~(XFS_DIFLAG_REALTIME |
> +                                               XFS_DIFLAG_RTINHERIT);
> +                       }
> +               }
> +               if (flags & XFS_DIFLAG_NEWRTBM_BIT) {
> +                       /* must be a rt bitmap inode */
> +                       if (lino != mp->m_sb.sb_rbmino) {
> +                               do_warn(_("inode %llu not rt bitmap"),
> lino);
> +                               flags &= ~XFS_DIFLAG_NEWRTBM_BIT;
> +                       }
> +               }
> +               if (flags & (XFS_DIFLAG_RTINHERIT |
> +                            XFS_DIFLAG_EXTSZINHERIT |
> +                            XFS_DIFLAG_PROJINHERIT |
> +                            XFS_DIFLAG_NOSYMLINKS)) {
> +                       /* must be a directory */
> +                       if (di_mode && !S_ISDIR(di_mode)) {
> +                               do_warn(_(
> +                       "directory flags set on non-directory inode %llu"),
> +                                       lino);
> +                               flags &= ~(XFS_DIFLAG_RTINHERIT |
> +                                               XFS_DIFLAG_EXTSZINHERIT |
> +                                               XFS_DIFLAG_PROJINHERIT |
> +                                               XFS_DIFLAG_NOSYMLINKS);
> +                       }
> +               }
> +               if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
> +                       /* must be a file */
> +                       if (di_mode && !S_ISREG(di_mode)) {
> +                               do_warn(_(
> +                       "file flags set on non-file inode %llu"), lino);
> +                               flags &= ~(XFS_DIFLAG_REALTIME |
> +                                               XFS_XFLAG_EXTSIZE);
> +                       }
> +               }
> +               if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
> +                       if (!no_modify) {
> +                               do_warn(_(", fixing bad flags.\n"));
> +                               dino->di_flags = cpu_to_be16(flags);
> +                               *dirty = 1;
> +                       } else
> +                               do_warn(_(", would fix bad flags.\n"));
> +               }
> +       }
> +
>        if (verify_mode)
>                return retval;
>
>

--0015175cb81860f0eb049a28a0fa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Please find my response below</div>
<div>=A0</div>
<div class=3D"gmail_quote">On Tue, Jan 18, 2011 at 1:57 PM, Dave Chinner <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.=
com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Mon, Jan 17, 2011 at 09:12:54PM +0900, Ajeet Yadav wro=
te:<br>&gt; Kernel: 2.6.30.9, XFS backported from 2.6.34, xfsprogs-3.0.5<br=
>&gt;<br>&gt; I used a script<br>&gt; 1. create some file, directories, sym=
links<br>
&gt; 2. unmount the file system<br>&gt; 3. run xfs_bd with blocktrash<br>&g=
t; 4. xfs_xfsrepair -L<br>&gt; 5. list &quot;ls -lR&quot;<br>&gt; 6. remove=
 all file and directory &quot;rm -rf *<br><br></div>OK, so you are effectiv=
ely corrupting random blocks by introducing<br>
random bit errors in the blocks. No surprise that some errors are<br>not be=
ing detected - what is the blocktrash command that you are<br>using?<br></b=
lockquote>
<div><span lang=3D"EN"></span>=A0</div>
<div><span lang=3D"EN">xfs_db -x -c blockget -c &quot;blocktrash -s 12345 -=
n 256 -x 1 -y 1024 -3&quot; /dev/sda1</span></div>
<div><span lang=3D"EN">=A0</span></div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im"><br>&gt; Often during testing I get the below backtrace f=
rom kernel during ls, rm<br>&gt; even though I already run xfs_repair on it=
.<br>&gt; Is it related to xfsrepair or xfs ?. I think xfs_repair must have=
 detected<br>
&gt; this problem and corrected it.<br><br></div>xfs_repair is not checking=
 the di_flags field in the inode for<br>sanity, hence having a wrong flag s=
et is going unnoticed.<br></blockquote>
<div>=A0</div>
<div>ok</div>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im"><br>&gt; There is similar problem already reported by<br>=
&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2010-06/msg00349.html" targ=
et=3D"_blank">http://oss.sgi.com/archives/xfs/2010-06/msg00349.html</a><br>=
<br>
</div>Similar error message (xfs_iformt found an inode corruption), but<br>=
that one is a completely different problem.<br><br>Does the patch below (co=
mpile tested only) detect the bad inode?<br></blockquote>
<div>=A0</div>
<div>Yes I have tested it, It seems to work fine,</div>
<div>I did not find this patch in mainline xfsprogs git, also I need to mod=
ify the patch somewhat.</div>
<div>dino-&gt;di_flags=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D&gt; dinoc-&gt;di_flags</div>
<div>because dino is not having any member named di_flags in xfsprogs-3.0.5=
, so I used dinoc instead.</div>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote"><br>Cheers,<br><br>Dave.<br>--<b=
r>Dave Chinner<br><a href=3D"mailto:david@fromorbit.com">david@fromorbit.co=
m</a><br>
<br>xfs_repair: validate inode di_flags field<br><br>xfs_repair is not vali=
dating the di_flags field in the inode for<br>sanity. Block fuzzing indicat=
es that we are not picking situations<br>like the RT bit being set on files=
ystems without realtime devices.<br>
<br>Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">=
dchinner@redhat.com</a>&gt;<br>---<br>=A0repair/dinode.c | =A0 62 +++++++++=
++++++++++++++++++++++++++++++++++++++++++++++<br>=A01 files changed, 62 in=
sertions(+), 0 deletions(-)<br>
<br>diff --git a/repair/dinode.c b/repair/dinode.c<br>index 2fa850d..e05d4e=
0 100644<br>--- a/repair/dinode.c<br>+++ b/repair/dinode.c<br>@@ -2519,6 +2=
519,68 @@ process_dinode_int(xfs_mount_t *mp,<br>=A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0goto clear_bad_out;<br>
=A0 =A0 =A0 =A0}<br><br>+ =A0 =A0 =A0 /*<br>+ =A0 =A0 =A0 =A0* check that w=
e only have valid flags set, and those that are set make<br>+ =A0 =A0 =A0 =
=A0* sense.<br>+ =A0 =A0 =A0 =A0*/<br>+ =A0 =A0 =A0 if (dino-&gt;di_flags) =
{<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 uint16_t flags =3D be16_to_cpu(dino-&gt;=
di_flags);<br>
+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags &amp; ~XFS_DIFLAG_ANY) {<br>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_warn(_(&quot;Bad flags set i=
n inode %llu&quot;), lino);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 flags &amp;=3D ~XFS_DIFLAG_ANY;<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags &amp; (XFS_DIFLAG_REALTIME | X=
FS_DIFLAG_RTINHERIT)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*=
 need an rt-dev! */<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!r=
t_name) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
do_warn(_(<br>
+ =A0 =A0 =A0 &quot;inode %llu has RT flag set but there is no RT device&qu=
ot;), lino);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 flags &amp;=3D ~(XFS_DIFLAG_REALTIME |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_DIFLAG=
_RTINHERIT);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags &amp; XFS_DIFLAG_NEWRT=
BM_BIT) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* must be a rt =
bitmap inode */<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lino !=
=3D mp-&gt;m_sb.sb_rbmino) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_warn(_(&qu=
ot;inode %llu not rt bitmap&quot;), lino);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags &amp;=3D ~XFS_DIFLAG_NEWRTBM_BIT;<br=
>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags &amp; (XFS_DIFLAG_RTIN=
HERIT |<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XFS_DIFLAG_EXTSZIN=
HERIT |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XFS_DIF=
LAG_PROJINHERIT |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0XFS_DIFLAG_NOSYMLINKS)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 /* must be a directory */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (di_mode &amp;&amp; !S_ISD=
IR(di_mode)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 do_warn(_(<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;dire=
ctory flags set on non-directory inode %llu&quot;),<br>+ =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lino);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags &amp;=
=3D ~(XFS_DIFLAG_RTINHERIT |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_DIFLAG_EXTSZINHERIT=
 |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 XFS_DIFLAG_PROJINHERIT |<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 XFS_DIFLAG_NOSYMLINKS);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 if (flags &amp; (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) =
{<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* must be a file */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (di_mode &amp;&amp; !S_ISR=
EG(di_mode)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 do_warn(_(<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;file=
 flags set on non-file inode %llu&quot;), lino);<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags &amp;=3D ~(XFS_DIFLAG_REALTIM=
E |<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 XFS_XFLAG_EXTSIZE);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 if (!verify_mode &amp;&amp; flags !=3D be16_to_cpu(dino-&gt;di_=
flags)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!no_modify) =
{<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_warn(_(&qu=
ot;, fixing bad flags.\n&quot;));<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 dino-&gt;di_flags =3D cpu_to_be16(flags);<br>+ =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *dirty =3D 1;<br>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_warn(_(&qu=
ot;, would fix bad flags.\n&quot;));<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>=
+ =A0 =A0 =A0 }<br>+<br>=A0 =A0 =A0 =A0if (verify_mode)<br>=A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0return retval;<br><br></blockquote></div><br>

--0015175cb81860f0eb049a28a0fa--


--===============1949892817748200024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1949892817748200024==--
