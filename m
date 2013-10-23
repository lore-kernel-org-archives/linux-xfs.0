Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B048C7F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 15:53:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B6BFAC009
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 13:53:12 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	JVSdDRgHcU52VOAe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 13:53:10 -0700 (PDT)
Received: by mail-ie0-f178.google.com with SMTP id x13so2303796ief.37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 13:53:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131023203435.GR1935@sgi.com>
References: <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard>
	<5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>
	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
	<20131023203435.GR1935@sgi.com>
Date: Wed, 23 Oct 2013 18:53:09 -0200
Message-ID: <CAGG-pUS3XKDd7eWYmuQ0cFyMZgvy19u-fqf56OUhtUPk6_XfZg@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, open list <linux-kernel@vger.kernel.org>, kernel-br <kernel-br@googlegroups.com>, XFS FILESYSTEM <xfs@oss.sgi.com>

2013/10/23 Ben Myers <bpm@sgi.com>:
> Hey Geyslan,
>
> On Wed, Oct 23, 2013 at 08:58:51AM -0200, Geyslan Greg=F3rio Bem wrote:
>> - Regarding the "possible new patch" subject, I humbly pass the ball to =
you.
>>
>> Thank you for the attention.
>
> Thank you for the patch.  I would really prefer to commit this showing
> authorship from you, rather than a Reported-by.  Can I mark you down?
>
> Regards,
>         Ben
>
Thank you, Ben. Sure, you can mark me.

> ---
>
> xfs: fix possible NULL dereference in xlog_verify_iclog
>
> In xlog_verify_iclog a debug check of the incore log buffers prints an
> error if icptr is null and then goes on to dereference the pointer
> regardless.  Convert this to an assert so that the intention is clear.
> This was reported by Coverty.
>
> Reported-by: Geyslan G. Bem <geyslan@gmail.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/xfs_log.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> Index: b/fs/xfs/xfs_log.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/fs/xfs/xfs_log.c  2013-10-23 14:52:47.875216875 -0500
> +++ b/fs/xfs/xfs_log.c  2013-10-23 14:53:53.775245830 -0500
> @@ -3714,11 +3714,9 @@ xlog_verify_iclog(
>         /* check validity of iclog pointers */
>         spin_lock(&log->l_icloglock);
>         icptr =3D log->l_iclog;
> -       for (i=3D0; i < log->l_iclog_bufs; i++) {
> -               if (icptr =3D=3D NULL)
> -                       xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> -               icptr =3D icptr->ic_next;
> -       }
> +       for (i=3D0; i < log->l_iclog_bufs; i++, icptr =3D icptr->ic_next)
> +               ASSERT(icptr);
> +
>         if (icptr !=3D log->l_iclog)
>                 xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
>         spin_unlock(&log->l_icloglock);
>

-- =

Regards,

Geyslan G. Bem
hackingbits.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
