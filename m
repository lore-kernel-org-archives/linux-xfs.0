Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG1RUbN024851
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 19:27:30 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F23DB173949D
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 17:27:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id cKnoSyyWfy8Mx80G for <linux-xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 17:27:27 -0800 (PST)
Message-ID: <494703FC.7080203@sandeen.net>
Date: Mon, 15 Dec 2008 19:27:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: Warn if specified non-zero quota will be round
	down to zero.
References: <1229383657-45951-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1229383657-45951-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-xfs@oss.sgi.com

Arkadiusz Miskiewicz wrote:
> User specified quota limit is internally converted to "basic blocks"
> unit (512 bytes in size). Quota value will be silently converted
> to zero when user enters any value lower than 512 bytes.
> =

> Warn in such case:
> =

> : # ./xfs_quota -x -c "limit -u bsoft=3D431 12000" /home
> : xfs_quota: Warning: `431' in quota blocks is 0 (unlimited).


Looks good to me.

-Eric

> ---
>  xfsprogs/po/pl.po     |    5 +++++
>  xfsprogs/quota/edit.c |    2 ++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> =

> diff --git a/xfsprogs/po/pl.po b/xfsprogs/po/pl.po
> index b4e1d76..d13184b 100644
> --- a/xfsprogs/po/pl.po
> +++ b/xfsprogs/po/pl.po
> @@ -3670,6 +3670,11 @@ msgstr "%s: nieprawid
>  msgid "%s: invalid project name: %s\n"
>  msgstr "%s: nieprawid=B3owa nazwa projektu: %s\n"
>  =

> +#: ../quota/edit.c:237
> +#, c-format
> +msgid "%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"
> +msgstr "%s: Uwaga: `%s' w blokach quoty oznacza 0 (nieograniczone).\n"
> +
>  #: ../quota/edit.c:318
>  #, c-format
>  msgid "%s: unrecognised argument %s\n"
> diff --git a/xfsprogs/quota/edit.c b/xfsprogs/quota/edit.c
> index 15c72c4..ce7f7e9 100644
> --- a/xfsprogs/quota/edit.c
> +++ b/xfsprogs/quota/edit.c
> @@ -233,6 +233,8 @@ extractb(
>  		s =3D string + length + 1;
>  		v =3D (__uint64_t)cvtnum(blocksize, sectorsize, s);
>  		*value =3D v >> 9;	/* syscalls use basic blocks */
> +		if (v > 0 && *value =3D=3D 0)
> +			fprintf(stderr, _("%s: Warning: `%s' in quota blocks is 0 (unlimited)=
.\n"), progname, s);
>  		return 1;
>  	}
>  	return 0;
> =

> =

> ------------------------------------------------------------------------
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
