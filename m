Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 495367F56
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 08:26:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B2BC304048
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 06:26:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oMTiDwBamPOjNayF for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 06:26:23 -0700 (PDT)
Message-ID: <557ADDFF.8080809@sandeen.net>
Date: Fri, 12 Jun 2015 08:26:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_metadump
References: <51AEB2C95D121A4D983B13981120AC65853860@EX10MBX01.EU.NEC.COM>
In-Reply-To: <51AEB2C95D121A4D983B13981120AC65853860@EX10MBX01.EU.NEC.COM>
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
To: Johannes Weydt <Johannes.Weydt@EMEA.NEC.COM>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "'dwdos@hpce.nec.com'" <dwdos@hpce.nec.com>, Reiter Manuel <manuel.reiter@dwd.de>, =?windows-1252?Q?Fr=FChauf_Andreas?= <Andreas.Fruehauf@dwd.de>

On 6/12/15 7:49 AM, Johannes Weydt wrote:
> Hello SGI,
> =

>  =

> =

> We experienced a I/O error on one of our XFS filesystems, xfs_repair =96n=
 advised to
> =

> =93Please capture the filesystem metadata with xfs_metadump and
> =

> report it to xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>.=94
> before it ended with a Segmentation fault.
> =

> The metadata is almost 3GB big, how do you recommend to transfer the file?

did you try to compress it?

> Do you have an open FTP for us?

> Also attached are some console outputs of first investigation attempts.
> =

> Log of xfs_repair =96n (1^st run)

What version?  Have you tried the latest version?

oh:

> xfsprogs is installed in version:
> =

> root@daw1:/localtmp # rpm -qa |grep xfsprogs
> =

> xfsprogs-3.1.1-10.el6.x86_64

> =

> Can you advise something?

If this is a RHEL6 box, have you contacted Red Hat support?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
