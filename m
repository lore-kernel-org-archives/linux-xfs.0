Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DIGisd040795 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 13:16:54 -0500
Received: from mail-pz0-f200.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 620A33C9411
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 11:17:05 -0700 (PDT)
Received: from mail-pz0-f200.google.com (mail-pz0-f200.google.com
	[209.85.222.200]) by cuda.sgi.com with ESMTP id
	oLllLEAF8gnWfKtn for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 11:17:05 -0700 (PDT)
Received: by pzk38 with SMTP id 38so811149pzk.33
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 11:17:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 13 Aug 2009 23:47:03 +0530
Message-ID: <9ee2fe770908131117o5b7ec317me4524d020bbe216b@mail.gmail.com>
Subject: xfs buffers
From: kanishk rastogi <kanishk.85@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1673999048881020209=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1673999048881020209==
Content-Type: multipart/alternative; boundary=000e0cd5097a444823047109f198

--000e0cd5097a444823047109f198
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hi all,
I was trying to understand the xfs_buf_t management in XFS.
I was looking at the xfs_bufhash_t which is used to keep the info of buffers
which have ongoing transactions.
I wanted to know if it uses it for caching these pages.

As far as i can see in xfs_buf_relse  calls ::

list_del_init(&bp->b_hash_list);

if the count drops down to 0 for the buffer...

if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) {
                if (bp->b_relse) { ----->set only in case of error??
                        atomic_inc(&bp->b_hold);
                        spin_unlock(&hash->bh_lock);
                        (*(bp->b_relse)) (bp);
                } else if (bp->b_flags & XBF_FS_MANAGED) { ----> mostly
unset......
                        spin_unlock(&hash->bh_lock);
                } else {
                        ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
                        *list_del_init(&bp->b_hash_list);*
                        spin_unlock(&hash->bh_lock);
                        xfs_buf_free(bp);
                }
        }

---------------

CMIIW:
So it doesnt keeps buffers if they are not in use....  ??

I dont think that should be the case...

-- 
regards
kanishk

--000e0cd5097a444823047109f198
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hi all,<br>I was trying to understand the xfs_buf_t management in XFS.<br>I=
 was looking at the xfs_bufhash_t which is used to keep the info of buffers=
 which have ongoing transactions.<br>I wanted to know if it uses it for cac=
hing these pages.<br>
<br>As far as i can see in xfs_buf_relse=A0 calls ::<br><br clear=3D"all">l=
ist_del_init(&amp;bp-&gt;b_hash_list);<br><br>if the count drops down to 0 =
for the buffer...<br><br>if (atomic_dec_and_lock(&amp;bp-&gt;b_hold, &amp;h=
ash-&gt;bh_lock)) {<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (bp-&gt;b_relse) { -----&g=
t;set only in case of error??<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 atomic_inc(&amp;bp-&gt;b_hold);<br>=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock(&amp;=
hash-&gt;bh_lock);<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (*(bp-&gt;b_relse)) (bp);<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (bp-&gt;b_flags &am=
p; XBF_FS_MANAGED) { ----&gt; mostly unset......<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock(&amp;hash-&gt;=
bh_lock);<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {<br>=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ASSERT(!=
(bp-&gt;b_flags &amp; (XBF_DELWRI|_XBF_DELWRI_Q)));<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <b>li=
st_del_init(&amp;bp-&gt;b_hash_list);</b><br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock(&amp;hash-&gt;bh_lock);=
<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 x=
fs_buf_free(bp);<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=A0=
=A0=A0=A0=A0=A0=A0 }<br><br>---------------<br>
<br>CMIIW:<br>So it doesnt keeps buffers if they are not in use....=A0 ??<b=
r><br>I dont think that should be the case... <br><br>-- <br>regards<br>kan=
ishk<br>

--000e0cd5097a444823047109f198--


--===============1673999048881020209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1673999048881020209==--
