Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7I2iv9W108033 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 21:45:08 -0500
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3D2C1074C4F
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:45:36 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.171]) by cuda.sgi.com with ESMTP id
	7KV2ggosqVwgYVZT for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2009 19:45:36 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so1060533wff.32
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:45:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A85A582.5000701@thebarn.com>
References: <9ee2fe770908131117o5b7ec317me4524d020bbe216b@mail.gmail.com>
	<4A85A582.5000701@thebarn.com>
Date: Mon, 17 Aug 2009 22:39:36 -0400
Message-ID: <9ee2fe770908171939sbc1d311x119762ed55ee095c@mail.gmail.com>
Subject: Re: xfs buffers
From: kanishk rastogi <kanishk.85@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3561923928391313193=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============3561923928391313193==
Content-Type: multipart/alternative; boundary=00504502ceb3e20d550471616d43

--00504502ceb3e20d550471616d43
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

inline...

On Fri, Aug 14, 2009 at 1:57 PM, Russell Cattelan <cattelan@thebarn.com>wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> kanishk rastogi wrote:
> > hi all, I was trying to understand the xfs_buf_t management in XFS.
> >  I was looking at the xfs_bufhash_t which is used to keep the info
> > of buffers which have ongoing transactions. I wanted to know if it
> > uses it for caching these pages.
> >
> > As far as i can see in xfs_buf_relse  calls ::
> >
> > list_del_init(&bp->b_hash_list);
> >
> > if the count drops down to 0 for the buffer...
> >
> > if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) { if
> > (bp->b_relse) { ----->set only in case of error??
> > atomic_inc(&bp->b_hold); spin_unlock(&hash->bh_lock);
> > (*(bp->b_relse)) (bp); } else if (bp->b_flags & XBF_FS_MANAGED) {
> > ----> mostly unset......\
> Indeed. that flag is used on exactly one buffer, the superblock.ode of the
> Basically the superblock is pinned in memory and only flushed by the
> filesystem.
> > spin_unlock(&hash->bh_lock); } else { ASSERT(!(bp->b_flags &
> > (XBF_DELWRI|_XBF_DELWRI_Q))); *list_del_init(&bp->b_hash_list);*
> > spin_unlock(&hash->bh_lock); xfs_buf_free(bp); } }
>


>
> >
> > ---------------
> >
> > CMIIW: So it doesnt keeps buffers if they are not in use....  ??
> buffers are released back to the buf_t  zone when they are done.
>
> zone allocation / free is very fast so managing lists of "free"
> buffers doesn't make a lot of sense.
>

sorry my fault i was asking about the pages these buffers point to? ....
I see them being pickd from the device inode of the monted device...

thankx
kanishk

>
> >
> > I dont think that should be the case...
> >
> > -- regards kanishk
> >
> > ----------------------------------------------------------------------
> >
> >
> > _______________________________________________ xfs mailing list
> > xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iD8DBQFKhaWBNRmM+OaGhBgRAtqgAJ9CZfj0QXz8Yy7P4jYemgEPsvR9pQCfcSWM
> a9OI8A4ckMdOuiXQ60o4PLE=
> =OJAD
> -----END PGP SIGNATURE-----
>
>


-- 
regards
kanishk

--00504502ceb3e20d550471616d43
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

inline...<br><br><div class=3D"gmail_quote">On Fri, Aug 14, 2009 at 1:57 PM=
, Russell Cattelan <span dir=3D"ltr">&lt;<a href=3D"mailto:cattelan@thebarn=
.com">cattelan@thebarn.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt =
0pt 0pt 0.8ex; padding-left: 1ex;">
-----BEGIN PGP SIGNED MESSAGE-----<br>
Hash: SHA1<br>
<div class=3D"im"><br>
kanishk rastogi wrote:<br>
&gt; hi all, I was trying to understand the xfs_buf_t management in XFS.<br=
>
&gt; =A0I was looking at the xfs_bufhash_t which is used to keep the info<b=
r>
&gt; of buffers which have ongoing transactions. I wanted to know if it<br>
&gt; uses it for caching these pages.<br>
&gt;<br>
&gt; As far as i can see in xfs_buf_relse =A0calls ::<br>
&gt;<br>
&gt; list_del_init(&amp;bp-&gt;b_hash_list);<br>
&gt;<br>
&gt; if the count drops down to 0 for the buffer...<br>
&gt;<br>
&gt; if (atomic_dec_and_lock(&amp;bp-&gt;b_hold, &amp;hash-&gt;bh_lock)) { =
if<br>
&gt; (bp-&gt;b_relse) { -----&gt;set only in case of error??<br>
&gt; atomic_inc(&amp;bp-&gt;b_hold); spin_unlock(&amp;hash-&gt;bh_lock);<br=
>
&gt; (*(bp-&gt;b_relse)) (bp); } else if (bp-&gt;b_flags &amp; XBF_FS_MANAG=
ED) {<br>
</div>&gt; ----&gt; mostly unset......\<br>
Indeed. that flag is used on exactly one buffer, the superblock.ode of the<=
br>
Basically the superblock is pinned in memory and only flushed by the<br>
filesystem.<br>
<div class=3D"im">&gt; spin_unlock(&amp;hash-&gt;bh_lock); } else { ASSERT(=
!(bp-&gt;b_flags &amp;<br>
&gt; (XBF_DELWRI|_XBF_DELWRI_Q))); *list_del_init(&amp;bp-&gt;b_hash_list);=
*<br>
&gt; spin_unlock(&amp;hash-&gt;bh_lock); xfs_buf_free(bp); } }</div></block=
quote><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"border-left:=
 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex=
;">
<div class=3D"im"><br>
&gt;<br>
&gt; ---------------<br>
&gt;<br>
&gt; CMIIW: So it doesnt keeps buffers if they are not in use.... =A0??<br>
</div>buffers are released back to the buf_t =A0zone when they are done.<br=
>
<br>
zone allocation / free is very fast so managing lists of &quot;free&quot;<b=
r>
buffers doesn&#39;t make a lot of sense.<br>
<div class=3D"im"></div></blockquote><div><br>sorry my fault i was asking a=
bout the pages these buffers point to? .... <br>I see them being pickd from=
 the device inode of the monted device...<br><br>thankx<br>kanishk <br></di=
v>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
><br>
&gt;<br>
&gt; I dont think that should be the case...<br>
&gt;<br>
&gt; -- regards kanishk<br>
&gt;<br>
</div>&gt; ----------------------------------------------------------------=
------<br>
&gt;<br>
&gt;<br>
&gt; _______________________________________________ xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a> <a href=3D"http=
://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http://oss.sgi.com/m=
ailman/listinfo/xfs</a><br>
<br>
-----BEGIN PGP SIGNATURE-----<br>
Version: GnuPG v1.4.7 (Darwin)<br>
Comment: Using GnuPG with Mozilla - <a href=3D"http://enigmail.mozdev.org" =
target=3D"_blank">http://enigmail.mozdev.org</a><br>
<br>
iD8DBQFKhaWBNRmM+OaGhBgRAtqgAJ9CZfj0QXz8Yy7P4jYemgEPsvR9pQCfcSWM<br>
a9OI8A4ckMdOuiXQ60o4PLE=3D<br>
=3DOJAD<br>
-----END PGP SIGNATURE-----<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>regards<br>kanishk<br>

--00504502ceb3e20d550471616d43--


--===============3561923928391313193==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3561923928391313193==--
