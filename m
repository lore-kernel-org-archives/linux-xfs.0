Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8018E7F9E
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 06:04:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C997304032
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 04:04:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oUxXtNtTqfqAAllu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 04:04:15 -0700 (PDT)
Date: Fri, 10 Apr 2015 07:04:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_metadump requested by xfs_check
Message-ID: <20150410110411.GA44895@bfoster.bfoster>
References: <003f01d0736f$94e082d0$bea18870$@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <003f01d0736f$94e082d0$bea18870$@gmail.com>
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
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Bernard <fred.pa.bernard@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 11:20:26AM +0200, Fr=E9d=E9ric Bernard wrote:
> I run xfs_metadump after having this message
> =

>  =

> =

> corrupt dinode 45102558696, extent total =3D 3, nblocks =3D 1.  This is a=
 bug.
> =

> Please capture the filesystem metadata with xfs_metadump and
> =

> report it to xfs@oss.sgi.com.
> =

> cache_node_purge: refcount was 1, not zero (node=3D0x7f08d5274a10)
> =

>  =

> =

> fatal error -- 117 - couldn't iget disconnected inode
> =

>  =


Are you running xfs_check or xfs_repair? If the former, please try the
latter and see if that corrects your problem. You might also want to
post the full repair output.

> =

> The size of the result dump is 2.9 GB =85
> =

>  =

> =

> How can I send that if you are interested in looking at it ?
> =


You'll want to try and compress it if you haven't already. Otherwise,
you'll need somewhere publicly accessible to upload it (e.g., dropbox,
etc.).

Brian

>  =

> =

> Best regards
> =

>  =

> =

> F.Bernard
> =


> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
