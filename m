Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 394EA7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:55:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18B998F804B
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 13:55:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id c7D2sp4pH6UAHOpR for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 13:55:46 -0700 (PDT)
Message-ID: <53D172D1.2010308@sandeen.net>
Date: Thu, 24 Jul 2014 15:55:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix typo in mkfs.xfs
References: <20140724184748.800975529@sgi.com>
	<20140724184830.434943824@sgi.com>
In-Reply-To: <20140724184830.434943824@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 7/24/14, 1:47 PM, Mark Tinguely wrote:
> Fix typo in xfs.mkfs output.
> =

> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

I can do this one! ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com> =


> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  po/pl.po        |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> =

> Index: b/mkfs/xfs_mkfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -447,7 +447,7 @@ static void blkid_get_topology(
>  out_free_probe:
>  	blkid_free_probe(pr);
>  	fprintf(stderr,
> -		_("warning: unable to probe device toplology for device %s\n"),
> +		_("warning: unable to probe device topology for device %s\n"),
>  		device);
>  }
>  =

> Index: b/po/pl.po
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/po/pl.po
> +++ b/po/pl.po
> @@ -7171,7 +7171,7 @@ msgstr "Mo=C5=BCna u=C5=BCy=C4=87 -f do wymuszenia u
>  =

>  #: .././mkfs/xfs_mkfs.c:450
>  #, c-format
> -msgid "warning: unable to probe device toplology for device %s\n"
> +msgid "warning: unable to probe device topology for device %s\n"
>  msgstr "uwaga: nie uda=C5=82o si=C4=99 odczyta=C4=87 topologii urz=C4=85=
dzenia %s\n"
>  =

>  #: .././mkfs/xfs_mkfs.c:578
> =

> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
