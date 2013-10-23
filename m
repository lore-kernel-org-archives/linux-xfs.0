Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 711F67F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 15:34:39 -0500 (CDT)
Date: Wed, 23 Oct 2013 15:34:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131023203435.GR1935@sgi.com>
References: <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard>
	<5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>
	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Alex Elder <elder@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>

Hey Geyslan,

On Wed, Oct 23, 2013 at 08:58:51AM -0200, Geyslan Greg=F3rio Bem wrote:
> - Regarding the "possible new patch" subject, I humbly pass the ball to y=
ou.
> =

> Thank you for the attention.

Thank you for the patch.  I would really prefer to commit this showing
authorship from you, rather than a Reported-by.  Can I mark you down?

Regards,
	Ben

---

xfs: fix possible NULL dereference in xlog_verify_iclog

In xlog_verify_iclog a debug check of the incore log buffers prints an
error if icptr is null and then goes on to dereference the pointer
regardless.  Convert this to an assert so that the intention is clear.
This was reported by Coverty.

Reported-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_log.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/fs/xfs/xfs_log.c	2013-10-23 14:52:47.875216875 -0500
+++ b/fs/xfs/xfs_log.c	2013-10-23 14:53:53.775245830 -0500
@@ -3714,11 +3714,9 @@ xlog_verify_iclog(
 	/* check validity of iclog pointers */
 	spin_lock(&log->l_icloglock);
 	icptr =3D log->l_iclog;
-	for (i=3D0; i < log->l_iclog_bufs; i++) {
-		if (icptr =3D=3D NULL)
-			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
-		icptr =3D icptr->ic_next;
-	}
+	for (i=3D0; i < log->l_iclog_bufs; i++, icptr =3D icptr->ic_next)
+      		ASSERT(icptr);
+
 	if (icptr !=3D log->l_iclog)
 		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
 	spin_unlock(&log->l_icloglock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
