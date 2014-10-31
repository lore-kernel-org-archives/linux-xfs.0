Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 081C17F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 20:51:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A875AC005
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 18:51:29 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id F3j9MkCcQqSEpvUM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Oct 2014 18:51:27 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id u20so4919189oif.22
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 18:51:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141031000954.GL13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard> <20141031000954.GL13323@dastard>
Date: Fri, 31 Oct 2014 09:51:27 +0800
Message-ID: <CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1895636119963389196=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============1895636119963389196==
Content-Type: multipart/alternative; boundary=001a113d10462bf6090506ae3c33

--001a113d10462bf6090506ae3c33
Content-Type: text/plain; charset=UTF-8

After apply this patch, xfsdump will hang again.

the log for xfsdump:
https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds

But 'echo w > /proc/sysrq-trigger' no any blocked task in dmesg.


2014-10-31 8:09 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Fri, Oct 31, 2014 at 10:04:57AM +1100, Dave Chinner wrote:
> > On Thu, Oct 30, 2014 at 04:39:01PM +0800, Tommy Wu wrote:
> > > I'm confusing now...
> > >
> > > in the test VM and one of my machine, rebuild xfsdump/xfsprogs will
> make
> > > the test work.
> >
> > I know why, too.
> >
> > > the xfsdump command I use:
> > > xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump
> > > /mnt/backup > xfsdump.log
> > > the log:
> > >
> https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ
> >
> > This indicates the bulkstat on the dump side was terminated
> > prematurely.
> >
> > > the xfsrestore command I use:
> > > xfsrestore -v debug,tree=nitty -p 300 -J -f test.xfsdump
> /vol/backup/x/ >
> > > xfsrestore.log
> > > the log:
> > >
> https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI
> >
> > And the errors in the restore side are because there are missing
> > directory inodes in the dump, hence orphaning occurs.
> >
> > It might take me a little while to come up with a fix - I've noticed
> > a few things that I need to check out in more detail in tracking
> > this down....
>
> Can you try this patch?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: handle munged bulkstat cookies correctly
>
> From: Dave Chinner <dchinner@redhat.com>
>
> xfsdump munges the last inode cookie that bulkstat passes to
> userspace so subsequent calls can restart at the last inode that
> bulkstat parsed. xfsdump thinks that it needs to decrement the
> cookie so that it catches the last inode, and this affects the
> tree search initialisation code.
>
> By decrementing the lastino cookie, the restart inode number can
> point to non-existent inode number. In 3.16, bulkstat would simply
> increment the cookie until it either found the next valid inode or
> the end of the AG, at which point it would just continue on as
> though nothing had happened. This is a relatively difficult
> situation to contrive so is extremely hard to test for, but is
> likely to occur fairly frequently in the real world.
>
> The current code, however, treats a cookie that points off into the
> weeds as invalid and returns a error. This has the effect of causing
> xfsdump to think it has reached the end of the bulkstat scan, and so
> if it's cookie munging happens just wrong it will cause incomplete
> dumps to occur. These dumps still have all the file data in them,
> just he directory structure is broken and so restore will end up
> with lots and lots of files in the orphanage (i.e. lost+found).
>
> IOWs, we broke xfsdump in a nasty, subtle way that users don't
> notice until they restore a dump.
>
> To fix this, restore the old behaviour of incrementing the inode
> number derived from the cookie when we fail to find a matching inode
> record.
>
> cc: stable@vger.kernel.org
> Reported-by: Tommy Wu <wu.tommy@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_itable.c | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7765ff7..dcc0c99 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -208,6 +208,15 @@ xfs_bulkstat_ichunk_ra(
>   * if we found the chunk.  If the inode was not the last in the chunk and
> there
>   * are some left allocated, update the data for the pointed-to record as
> well as
>   * return the count of grabbed inodes.
> + *
> + * If this is the first lookup in a bulkstat call, we have to be careful
> about
> + * the agino that is passed - it may not point to a valid inode record.
> xfsdump,
> + * in particular, screws with the lastino cookie between bulkstat calls
> and so
> + * can point it off into the weeds. Hence we can't return an error here if
> + * the agino doesn't point to the correct inode chunk. The previous code
> simply
> + * incremented agino and tried again. This will work for xfsdump as the
> next
> + * lookup will either find the correct chunk or the end of the AG, so
> let's just
> + * keep doing that.
>   */
>  STATIC int
>  xfs_bulkstat_grab_ichunk(
> @@ -226,7 +235,7 @@ xfs_bulkstat_grab_ichunk(
>                 return error;
>         if (!stat) {
>                 *icount = 0;
> -               return error;
> +               return 0;
>         }
>
>         /* Get the record, should always work */
> @@ -236,8 +245,11 @@ xfs_bulkstat_grab_ichunk(
>         XFS_WANT_CORRUPTED_RETURN(stat == 1);
>
>         /* Check if the record contains the inode in request */
> -       if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
> -               return -EINVAL;
> +       if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
> +               /* oops, someone is feeding us garbage! */
> +               *icount = -1;
> +               return 0;
> +       }
>
>         idx = agino - irec->ir_startino + 1;
>         if (idx < XFS_INODES_PER_CHUNK &&
> @@ -428,6 +440,17 @@ xfs_bulkstat(
>                         error = xfs_bulkstat_grab_ichunk(cur, agino,
> &icount, &r);
>                         if (error)
>                                 goto del_cursor;
> +                       if (icount < 0) {
> +                               /*
> +                                * A pox be cast over xfsdump!
> +                                *
> +                                * No record containing agino was found.
> Bump
> +                                * it, try again until we find a chunk or
> fall
> +                                * off the end of the AG.
> +                                */
> +                               agino++;
> +                               goto del_cursor;
> +                       }
>                         if (icount) {
>                                 irbp->ir_startino = r.ir_startino;
>                                 irbp->ir_freecount = r.ir_freecount;
> @@ -435,14 +458,17 @@ xfs_bulkstat(
>                                 irbp++;
>                                 agino = r.ir_startino +
> XFS_INODES_PER_CHUNK;
>                         }
> +
>                         /* Increment to the next record */
>                         error = xfs_btree_increment(cur, 0, &tmp);
>                 } else {
>                         /* Start of ag.  Lookup the first inode chunk */
>                         error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE,
> &tmp);
>                 }
> -               if (error)
> +               if (error || tmp == 0) {
> +                       end_of_ag = 1;
>                         goto del_cursor;
> +               }
>
>                 /*
>                  * Loop through inode btree records in this ag,
>



-- 

Tommy Wu

--001a113d10462bf6090506ae3c33
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>After apply this patch, xfsdump will hang again.=
<br><br></div>the log for xfsdump:<br><a href=3D"https://mega.co.nz/#!tUgz3=
QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds">https://mega.co.nz/#!tUgz3=
QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds</a><br><br></div>But &#39;e=
cho w &gt; /proc/sysrq-trigger&#39; no any blocked task in dmesg.<br><br></=
div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-10-31 8:=
09 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fro=
morbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Fri, Oc=
t 31, 2014 at 10:04:57AM +1100, Dave Chinner wrote:<br>
&gt; On Thu, Oct 30, 2014 at 04:39:01PM +0800, Tommy Wu wrote:<br>
&gt; &gt; I&#39;m confusing now...<br>
&gt; &gt;<br>
&gt; &gt; in the test VM and one of my machine, rebuild xfsdump/xfsprogs wi=
ll make<br>
&gt; &gt; the test work.<br>
&gt;<br>
&gt; I know why, too.<br>
&gt;<br>
&gt; &gt; the xfsdump command I use:<br>
&gt; &gt; xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfs=
dump<br>
&gt; &gt; /mnt/backup &gt; xfsdump.log<br>
&gt; &gt; the log:<br>
&gt; &gt; <a href=3D"https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0T=
H5qBghMlKXAmHoWk2iQ" target=3D"_blank">https://mega.co.nz/#!xIhTjD6Y!Gwp_il=
W5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ</a><br>
&gt;<br>
&gt; This indicates the bulkstat on the dump side was terminated<br>
&gt; prematurely.<br>
&gt;<br>
&gt; &gt; the xfsrestore command I use:<br>
&gt; &gt; xfsrestore -v debug,tree=3Dnitty -p 300 -J -f test.xfsdump /vol/b=
ackup/x/ &gt;<br>
&gt; &gt; xfsrestore.log<br>
&gt; &gt; the log:<br>
&gt; &gt; <a href=3D"https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQV=
tWNW90Sar5MZhNzGbYI" target=3D"_blank">https://mega.co.nz/#!oZIFWQST!VUY90E=
Z8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI</a><br>
&gt;<br>
&gt; And the errors in the restore side are because there are missing<br>
&gt; directory inodes in the dump, hence orphaning occurs.<br>
&gt;<br>
&gt; It might take me a little while to come up with a fix - I&#39;ve notic=
ed<br>
&gt; a few things that I need to check out in more detail in tracking<br>
&gt; this down....<br>
<br>
</div></div>Can you try this patch?<br>
<span class=3D""><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
</span>xfs: handle munged bulkstat cookies correctly<br>
<br>
From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner@redh=
at.com</a>&gt;<br>
<br>
xfsdump munges the last inode cookie that bulkstat passes to<br>
userspace so subsequent calls can restart at the last inode that<br>
bulkstat parsed. xfsdump thinks that it needs to decrement the<br>
cookie so that it catches the last inode, and this affects the<br>
tree search initialisation code.<br>
<br>
By decrementing the lastino cookie, the restart inode number can<br>
point to non-existent inode number. In 3.16, bulkstat would simply<br>
increment the cookie until it either found the next valid inode or<br>
the end of the AG, at which point it would just continue on as<br>
though nothing had happened. This is a relatively difficult<br>
situation to contrive so is extremely hard to test for, but is<br>
likely to occur fairly frequently in the real world.<br>
<br>
The current code, however, treats a cookie that points off into the<br>
weeds as invalid and returns a error. This has the effect of causing<br>
xfsdump to think it has reached the end of the bulkstat scan, and so<br>
if it&#39;s cookie munging happens just wrong it will cause incomplete<br>
dumps to occur. These dumps still have all the file data in them,<br>
just he directory structure is broken and so restore will end up<br>
with lots and lots of files in the orphanage (i.e. lost+found).<br>
<br>
IOWs, we broke xfsdump in a nasty, subtle way that users don&#39;t<br>
notice until they restore a dump.<br>
<br>
To fix this, restore the old behaviour of incrementing the inode<br>
number derived from the cookie when we fail to find a matching inode<br>
record.<br>
<br>
cc: <a href=3D"mailto:stable@vger.kernel.org">stable@vger.kernel.org</a><br=
>
Reported-by: Tommy Wu &lt;<a href=3D"mailto:wu.tommy@gmail.com">wu.tommy@gm=
ail.com</a>&gt;<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchi=
nner@redhat.com</a>&gt;<br>
---<br>
=C2=A0fs/xfs/xfs_itable.c | 34 ++++++++++++++++++++++++++++++----<br>
=C2=A01 file changed, 30 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c<br>
index 7765ff7..dcc0c99 100644<br>
--- a/fs/xfs/xfs_itable.c<br>
+++ b/fs/xfs/xfs_itable.c<br>
@@ -208,6 +208,15 @@ xfs_bulkstat_ichunk_ra(<br>
=C2=A0 * if we found the chunk.=C2=A0 If the inode was not the last in the =
chunk and there<br>
=C2=A0 * are some left allocated, update the data for the pointed-to record=
 as well as<br>
=C2=A0 * return the count of grabbed inodes.<br>
+ *<br>
+ * If this is the first lookup in a bulkstat call, we have to be careful a=
bout<br>
+ * the agino that is passed - it may not point to a valid inode record. xf=
sdump,<br>
+ * in particular, screws with the lastino cookie between bulkstat calls an=
d so<br>
+ * can point it off into the weeds. Hence we can&#39;t return an error her=
e if<br>
+ * the agino doesn&#39;t point to the correct inode chunk. The previous co=
de simply<br>
+ * incremented agino and tried again. This will work for xfsdump as the ne=
xt<br>
+ * lookup will either find the correct chunk or the end of the AG, so let&=
#39;s just<br>
+ * keep doing that.<br>
=C2=A0 */<br>
=C2=A0STATIC int<br>
=C2=A0xfs_bulkstat_grab_ichunk(<br>
@@ -226,7 +235,7 @@ xfs_bulkstat_grab_ichunk(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return error;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!stat) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *icount =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Get the record, should always work */<br>
@@ -236,8 +245,11 @@ xfs_bulkstat_grab_ichunk(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 XFS_WANT_CORRUPTED_RETURN(stat =3D=3D 1);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Check if the record contains the inode in re=
quest */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (irec-&gt;ir_startino + XFS_INODES_PER_CHUNK=
 &lt;=3D agino)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (irec-&gt;ir_startino + XFS_INODES_PER_CHUNK=
 &lt;=3D agino) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* oops, someone is=
 feeding us garbage! */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*icount =3D -1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 idx =3D agino - irec-&gt;ir_startino + 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (idx &lt; XFS_INODES_PER_CHUNK &amp;&amp;<br=
>
@@ -428,6 +440,17 @@ xfs_bulkstat(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 error =3D xfs_bulkstat_grab_ichunk(cur, agino, &amp;icount, &amp=
;r);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (error)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto del_cursor;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (icount &lt; 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * A pox be cast over xfsdump!<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * No record containing agino was fou=
nd.=C2=A0 Bump<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * it, try again until we find a chun=
k or fall<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * off the end of the AG.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0agino++;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto del_cursor;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (icount) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 irbp-&gt;ir_startino =3D r.ir_starti=
no;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 irbp-&gt;ir_freecount =3D r.ir_freec=
ount;<br>
@@ -435,14 +458,17 @@ xfs_bulkstat(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 irbp++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 agino =3D r.ir_startino + XFS_INODES=
_PER_CHUNK;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* Increment to the next record */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 error =3D xfs_btree_increment(cur, 0, &amp;tmp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* Start of ag.=C2=A0 Lookup the first inode chunk */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 error =3D xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &amp;tmp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (error)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (error || tmp =
=3D=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0end_of_ag =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto del_cursor;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Loop throug=
h inode btree records in this ag,<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature"><br>Tommy Wu</div>
</div>

--001a113d10462bf6090506ae3c33--


--===============1895636119963389196==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1895636119963389196==--
