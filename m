Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q491hnRx050469 for <xfs@oss.sgi.com>; Tue, 8 May 2012 20:43:49 -0500
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id cYHNiuGkh5r32UZz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 May 2012 18:43:48 -0700 (PDT)
Received: by werm13 with SMTP id m13so5080002wer.26
	for <xfs@oss.sgi.com>; Tue, 08 May 2012 18:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120508223127.GH5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
	<20120507235955.GE5091@dastard>
	<CAF7KpS_02NjAzY1wOQ9U0kwjKH+SzA0O_3VqSfjJgv0P6Hjk=g@mail.gmail.com>
	<20120508044039.GF5091@dastard>
	<CAF7KpS906EpxfAMjzW1zx8fSdGacoxkg+Fz=P0Sb3yONMhe7gw@mail.gmail.com>
	<20120508054703.GG5091@dastard>
	<CAF7KpS8oyteCDFM9tYWMp1K_vVeD0LTCY+10dSEiM_99KU9sJw@mail.gmail.com>
	<20120508223127.GH5091@dastard>
Date: Wed, 9 May 2012 09:43:47 +0800
Message-ID: <CAF7KpS_yF71A_PVV1L-AzDMsX=kNqbaApaWT=oTh-Y8pw5f-Yg@mail.gmail.com>
Subject: Re: fallocate bug?
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7466340013517504205=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7466340013517504205==
Content-Type: multipart/alternative; boundary=0016e68fa33b5f14a104bf90a234

--0016e68fa33b5f14a104bf90a234
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thank you so much for your kindly help.

best regards,
=E9=9F=A9=E7=AB=B9(Zhu Han)


On Wed, May 9, 2012 at 6:31 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, May 08, 2012 at 11:25:05PM +0800, Zhu Han wrote:
> > On Tue, May 8, 2012 at 1:47 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Tue, May 08, 2012 at 01:10:55PM +0800, Zhu Han wrote:
> > > > On Tue, May 8, 2012 at 12:40 PM, Dave Chinner <david@fromorbit.com>
> > > wrote:
> > > > > On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote:
> > > > > > On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <
> david@fromorbit.com>
> > > > > wrote:
> > > > > > > And so now you've triggered the speculative delayed allocatio=
n
> > > > > > > beyond EOF, which is normal behaviour. Hence there are
> currently
> > > > > > > unused blocks beyond EOF which will get removed either when t=
he
> > > next
> > > > > > > close(fd) occurs on the file or the inode is removed from the
> > > cache.
> > > > > > >
> > > > > >
> > > > > > Close(fd) should be invoked before dd quits. But why the extra
> blocks
> > > > > > beyond EOF are not freed?
> > > > >
> > > > > The removal is conditional on how many times the fd has been clos=
ed
> > > > > with dirty data on the inode.
> > > > >
> > > > > > The only way I found to remove the extra blocks is truncate the
> file
> > > to
> > > > > its
> > > > > > real size.
> > > > >
> > > > > If the close() didn't remove them, they will be removed when the
> > > > > inode ages out of the cache. Why do you even care about them?
> > > >
> > > > Our distributed system depends on the real length of files to
> account the
> > > > space usage.
> > >
> > > That's ..... naive. It's never been valid to assume that the file
> > > size is an accurate reflection of space usage, especially as it will
> > > *always* be wrong for sparse files. In the same light, you also
> > > cannot assume that it is an accurate reflection for non-sparse files
> > > because we can do both explicit and speculative allocation beyond
> > > EOF which only du will show. Not to mention that metadata is not
> > > accounted in the file length, and that can consume a significant
> > > amount of space, too.
> > >
> > > > This behavior make the account inaccurate.
> > >
> > > The block usage reported by XFS is both accurate and correct. The
> > > file size reported by XFS is both accurate and correct. You're
> > > "account inaccuracy" is assuming that they are the same. Perhaps you
> > > should be using quotas for accurate space usage accounting?
> > >
> > > Anyway, if you really want to stop speculative delayed allocation
> > > beyond EOF, then use the allocsize mount option to control it.
> > >
> >
> >
> > Thanks for help.
> >
> > I can control the size of pre-allocation, so no data are written beyond
> the
> > pre-allocated block range, so no speculative allocation is triggered.
> > Besides it, our system can sync the accurate space usage of mount point
> > periodically.
> >
> > Can you give any hints about the most lightweight approach to get the
> > accurate block usage of whole file system?
>
> If you are just after the whole filesystem, then statfs(2) will give
> you blocks used and free. If you are after a finer breakdown, then
> quotas are probably what you want - they can be used for accounting
> separately to the space limiting enforcement. Hence you get
> accurate, up-to-date per user, group or project space accounting
> without actually limiting space usage at all.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e68fa33b5f14a104bf90a234
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thank you so much for your kindly help.<br><br clear=3D"all">best regards,<=
br>
=E9=9F=A9=E7=AB=B9(Zhu Han)<br>
<br><br><div class=3D"gmail_quote">On Wed, May 9, 2012 at 6:31 AM, Dave Chi=
nner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D=
"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On Tue, May 08, 2012 at 11:25:05PM =
+0800, Zhu Han wrote:<br>
&gt; On Tue, May 8, 2012 at 1:47 PM, Dave Chinner &lt;<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Tue, May 08, 2012 at 01:10:55PM +0800, Zhu Han wrote:<br>
&gt; &gt; &gt; On Tue, May 8, 2012 at 12:40 PM, Dave Chinner &lt;<a href=3D=
"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;<br>
&gt; &gt; wrote:<br>
&gt; &gt; &gt; &gt; On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote=
:<br>
&gt; &gt; &gt; &gt; &gt; On Tue, May 8, 2012 at 7:59 AM, Dave Chinner &lt;<=
a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;<br>
&gt; &gt; &gt; &gt; wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; And so now you&#39;ve triggered the speculati=
ve delayed allocation<br>
&gt; &gt; &gt; &gt; &gt; &gt; beyond EOF, which is normal behaviour. Hence =
there are currently<br>
&gt; &gt; &gt; &gt; &gt; &gt; unused blocks beyond EOF which will get remov=
ed either when the<br>
&gt; &gt; next<br>
&gt; &gt; &gt; &gt; &gt; &gt; close(fd) occurs on the file or the inode is =
removed from the<br>
&gt; &gt; cache.<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Close(fd) should be invoked before dd quits. But w=
hy the extra blocks<br>
&gt; &gt; &gt; &gt; &gt; beyond EOF are not freed?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; The removal is conditional on how many times the fd has=
 been closed<br>
&gt; &gt; &gt; &gt; with dirty data on the inode.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; The only way I found to remove the extra blocks is=
 truncate the file<br>
&gt; &gt; to<br>
&gt; &gt; &gt; &gt; its<br>
&gt; &gt; &gt; &gt; &gt; real size.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; If the close() didn&#39;t remove them, they will be rem=
oved when the<br>
&gt; &gt; &gt; &gt; inode ages out of the cache. Why do you even care about=
 them?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Our distributed system depends on the real length of files t=
o account the<br>
&gt; &gt; &gt; space usage.<br>
&gt; &gt;<br>
&gt; &gt; That&#39;s ..... naive. It&#39;s never been valid to assume that =
the file<br>
&gt; &gt; size is an accurate reflection of space usage, especially as it w=
ill<br>
&gt; &gt; *always* be wrong for sparse files. In the same light, you also<b=
r>
&gt; &gt; cannot assume that it is an accurate reflection for non-sparse fi=
les<br>
&gt; &gt; because we can do both explicit and speculative allocation beyond=
<br>
&gt; &gt; EOF which only du will show. Not to mention that metadata is not<=
br>
&gt; &gt; accounted in the file length, and that can consume a significant<=
br>
&gt; &gt; amount of space, too.<br>
&gt; &gt;<br>
&gt; &gt; &gt; This behavior make the account inaccurate.<br>
&gt; &gt;<br>
&gt; &gt; The block usage reported by XFS is both accurate and correct. The=
<br>
&gt; &gt; file size reported by XFS is both accurate and correct. You&#39;r=
e<br>
&gt; &gt; &quot;account inaccuracy&quot; is assuming that they are the same=
. Perhaps you<br>
&gt; &gt; should be using quotas for accurate space usage accounting?<br>
&gt; &gt;<br>
&gt; &gt; Anyway, if you really want to stop speculative delayed allocation=
<br>
&gt; &gt; beyond EOF, then use the allocsize mount option to control it.<br=
>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt; Thanks for help.<br>
&gt;<br>
&gt; I can control the size of pre-allocation, so no data are written beyon=
d the<br>
&gt; pre-allocated block range, so no speculative allocation is triggered.<=
br>
&gt; Besides it, our system can sync the accurate space usage of mount poin=
t<br>
&gt; periodically.<br>
&gt;<br>
&gt; Can you give any hints about the most lightweight approach to get the<=
br>
&gt; accurate block usage of whole file system?<br>
<br>
</div></div>If you are just after the whole filesystem, then statfs(2) will=
 give<br>
you blocks used and free. If you are after a finer breakdown, then<br>
quotas are probably what you want - they can be used for accounting<br>
separately to the space limiting enforcement. Hence you get<br>
accurate, up-to-date per user, group or project space accounting<br>
without actually limiting space usage at all.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br>

--0016e68fa33b5f14a104bf90a234--


--===============7466340013517504205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7466340013517504205==--
