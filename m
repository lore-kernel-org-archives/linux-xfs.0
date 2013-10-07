Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 802637F37
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 15:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B71E304039
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 13:09:12 -0700 (PDT)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id hkr11GMiYeSm69x7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Oct 2013 13:09:10 -0700 (PDT)
Received: by mail-we0-f175.google.com with SMTP id t61so7352924wes.20
	for <xfs@oss.sgi.com>; Mon, 07 Oct 2013 13:09:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131004214353.GK4446@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
	<CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
	<20131004214353.GK4446@dastard>
Date: Mon, 7 Oct 2013 13:09:09 -0700
Message-ID: <CAGa4099NNUJV4_JbU0izLf0k3bcj3afHPTXt=HO2263_TESbNA@mail.gmail.com>
Subject: Re: xfs_repair segfault
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6778239272471770529=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6778239272471770529==
Content-Type: multipart/alternative; boundary=f46d043c09329d140404e82c3978

--f46d043c09329d140404e82c3978
Content-Type: text/plain; charset=ISO-8859-1

Thanks. That seemed to fix that bug.

Now I'm getting a lot of this:
xfs_da_do_buf(2): XFS_CORRUPTION_ERROR

fatal error -- can't read block 8388608 for directory inode 8628218

Then xfs_repair exits.

What I've been doing is what I saw in the FAQ where I would use xfs_db and
write core.mode 0 for these inodes. But there are just so many of them. And
is that even the right thing to do?

Thanks


On Fri, Oct 4, 2013 at 2:43 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Oct 04, 2013 at 10:51:50AM -0700, Viet Nguyen wrote:
> > Hi,
> >
> > I was wondering if you got a chance to look at this and if one's
> available,
> > where can I get a patch?
>
> Can you try the patch below?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> libxfs: validity check the directory block leaf entry count
>
> From: Dave Chinner <dchinner@redhat.com>
>
> The directory block format verifier fails to check that the leaf
> entry count is in a valid range, and so if it is corrupted then it
> can lead to derefencing a pointer outside the block buffer. While we
> can't exactly validate the count without first walking the directory
> block, we can ensure the count lands in the valid area within the
> directory block and hence avoid out-of-block references.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_dir2_data.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index 189699f..1b5196b 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -59,6 +59,18 @@ __xfs_dir3_data_check(
>                 btp = xfs_dir2_block_tail_p(mp, hdr);
>                 lep = xfs_dir2_block_leaf_p(btp);
>                 endp = (char *)lep;
> +
> +               /*
> +                * The number of leaf entries is limited by the size of the
> +                * block and the amount of space used by the data entries.
> +                * We don't know how much space is used by the data
> entries yet,
> +                * so just ensure that the count falls somewhere inside the
> +                * block right now.
> +                */
> +               XFS_WANT_CORRUPTED_RETURN(be32_to_cpu(btp->count) >
> +                               ((char *)btp - (char *)p) /
> +                                       sizeof(struct
> xfs_dir2_leaf_entry));
> +
>                 break;
>         case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
>         case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
>

--f46d043c09329d140404e82c3978
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks. That seemed to fix that bug.<div><br></div><div>No=
w I&#39;m getting a lot of this:</div><div><div>xfs_da_do_buf(2): XFS_CORRU=
PTION_ERROR</div><div><br></div><div>fatal error -- can&#39;t read block 83=
88608 for directory inode 8628218</div>
</div><div><br></div><div>Then xfs_repair exits.</div><div><br></div><div>W=
hat I&#39;ve been doing is what I saw in the FAQ where I would use xfs_db a=
nd write core.mode 0 for these inodes. But there are just so many of them. =
And is that even the right thing to do?</div>
<div><br></div><div>Thanks</div></div><div class=3D"gmail_extra"><br><br><d=
iv class=3D"gmail_quote">On Fri, Oct 4, 2013 at 2:43 PM, Dave Chinner <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">d=
avid@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Fri, Oct 04, 2013 at 10=
:51:50AM -0700, Viet Nguyen wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I was wondering if you got a chance to look at this and if one&#39;s a=
vailable,<br>
&gt; where can I get a patch?<br>
<br>
</div>Can you try the patch below?<br>
<div class=3D"im"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
</div>libxfs: validity check the directory block leaf entry count<br>
<br>
From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner@redh=
at.com</a>&gt;<br>
<br>
The directory block format verifier fails to check that the leaf<br>
entry count is in a valid range, and so if it is corrupted then it<br>
can lead to derefencing a pointer outside the block buffer. While we<br>
can&#39;t exactly validate the count without first walking the directory<br=
>
block, we can ensure the count lands in the valid area within the<br>
directory block and hence avoid out-of-block references.<br>
<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchi=
nner@redhat.com</a>&gt;<br>
---<br>
=A0libxfs/xfs_dir2_data.c | 13 +++++++++++++<br>
=A01 file changed, 13 insertions(+)<br>
<br>
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c<br>
index 189699f..1b5196b 100644<br>
--- a/libxfs/xfs_dir2_data.c<br>
+++ b/libxfs/xfs_dir2_data.c<br>
@@ -59,6 +59,18 @@ __xfs_dir3_data_check(<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btp =3D xfs_dir2_block_tail_p(mp, hdr);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lep =3D xfs_dir2_block_leaf_p(btp);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 endp =3D (char *)lep;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The number of leaf entries is limited by=
 the size of the<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* block and the amount of space used by th=
e data entries.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We don&#39;t know how much space is used=
 by the data entries yet,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* so just ensure that the count falls some=
where inside the<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* block right now.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_WANT_CORRUPTED_RETURN(be32_to_cpu(btp-&gt=
;count) &gt;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((char *)btp =
- (char *)p) /<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 sizeof(struct xfs_dir2_leaf_entry));<br>
+<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
=A0 =A0 =A0 =A0 case cpu_to_be32(XFS_DIR3_DATA_MAGIC):<br>
=A0 =A0 =A0 =A0 case cpu_to_be32(XFS_DIR2_DATA_MAGIC):<br>
</blockquote></div><br></div>

--f46d043c09329d140404e82c3978--


--===============6778239272471770529==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6778239272471770529==--
