Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FFwJt4196614 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 10:58:19 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E95CE134BB36
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:10:59 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	dTAq7q69mLbOR3Gq for <xfs@oss.sgi.com>;
	Wed, 15 Sep 2010 09:10:59 -0700 (PDT)
Received: by qyk36 with SMTP id 36so3949172qyk.5
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:59:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Sep 2010 10:59:07 -0500
Message-ID: <AANLkTimR-dBLmQQ-Nh0mmjHJMfFidePKxfO6P76y48n8@mail.gmail.com>
Subject: The segment fault with NULL point using when recovering failure
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6960858542468818513=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

--===============6960858542468818513==
Content-Type: multipart/alternative; boundary=00c09fa2185fdb3a3404904e68b4

--00c09fa2185fdb3a3404904e68b4
Content-Type: text/plain; charset=ISO-8859-1

xlog_recover_process_iunlinks(
    xlog_t        *log)
{
                /*
                 * Reacquire the agibuffer and continue around
                 * the loop. This should never fail as we know
                 * the buffer was good earlier on.
                 */
                error = xfs_read_agi(mp, NULL, agno, &agibp);
                ASSERT(error == 0);
                agi = XFS_BUF_TO_AGI(agibp);

}
If no defined DEBUG, ASSERT will not work and agibp could be ZERO if there
is a error in xfs_read_agi.
And the comment shouldn't say it never fail because  xfs_read_agi will
return error in function and it does when there is forced shutdown.

Thanks,
Mike Gao

--00c09fa2185fdb3a3404904e68b4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

xlog_recover_process_iunlinks(<br>=A0=A0=A0 xlog_t=A0=A0 =A0=A0=A0 =A0*log)=
<br>{<br>=A0=A0=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0=A0 /*<br>=A0=A0=A0 =A0=A0 =A0=
=A0=A0 =A0=A0=A0 =A0 * Reacquire the agibuffer and continue around<br>=A0=
=A0=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 * the loop. This should never fail as=
 we know<br>=A0=A0=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 * the buffer was good =
earlier on.<br>
=A0=A0=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 */<br>=A0=A0=A0 =A0=A0 =A0=A0=A0 =
=A0=A0=A0 =A0error =3D xfs_read_agi(mp, NULL, agno, &amp;agibp);<br>=A0=A0=
=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0 =A0ASSERT(error =3D=3D 0);<br>=A0=A0=A0 =A0=
=A0 =A0=A0=A0 =A0=A0=A0 =A0agi =3D XFS_BUF_TO_AGI(agibp);<br>=A0<br>}<br>If=
 no defined DEBUG, ASSERT will not work and agibp could be ZERO if there is=
 a error in xfs_read_agi.<br>
And the comment shouldn&#39;t say it never fail because=A0 xfs_read_agi wil=
l return error in function and it does when there is forced shutdown.<br><b=
r>Thanks,<br>Mike Gao<br><br><br>

--00c09fa2185fdb3a3404904e68b4--


--===============6960858542468818513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6960858542468818513==--
