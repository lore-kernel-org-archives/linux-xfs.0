Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C111C7F56
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 08:58:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28637AC005
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 06:58:58 -0700 (PDT)
Received: from cluster-j.mailcontrol.com (cluster-j.mailcontrol.com
	[85.115.54.190]) by cuda.sgi.com with ESMTP id BHEn5To2X5JwAr0l
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2015 06:58:54 -0700 (PDT)
From: Johannes Weydt <Johannes.Weydt@EMEA.NEC.COM>
Subject: RE: xfs_metadump
Date: Fri, 12 Jun 2015 13:58:48 +0000
Message-ID: <51AEB2C95D121A4D983B13981120AC65853931@EX10MBX01.EU.NEC.COM>
References: <51AEB2C95D121A4D983B13981120AC65853860@EX10MBX01.EU.NEC.COM>
	<557ADDFF.8080809@sandeen.net>
In-Reply-To: <557ADDFF.8080809@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "'dwdos@hpce.nec.com'" <dwdos@hpce.nec.com>, Reiter Manuel <manuel.reiter@dwd.de>, =?iso-8859-1?Q?Fr=FChauf_Andreas?= <Andreas.Fruehauf@dwd.de>

Hello Eric,

Thanks for the fast reply.

It's not yet compressed. But I will do so soon.

Xfs_repair is running in version
root@daw1:~ # xfs_repair -V
xfs_repair version 3.1.1

but I am about to update to 3.1.11, which is the latest available version f=
or our Oracle Enterprise Linux 6.4

I did not yet open a case with oracle, but for sure will do so.
Your email address from the console seemed to be a faster address for suppo=
rt.

Best regards / Mit freundlichen Gr=FC=DFen

Johannes Weydt
System Analyst, HPCE Division
Telefon: 069-8062-2376
Mobile:  01522-2851526
Fax:         069-8062-3267


NEC Deutschland GmbH, Prinzenallee 11,  D-40549 Duesseldorf, Germany
Gesch=E4ftsf=FChrer: Michael St=FCckmann     Handelsregister D=FCsseldorf H=
RB 579413


-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] =

Sent: Friday, June 12, 2015 3:26 PM
To: Johannes Weydt; xfs@oss.sgi.com
Cc: 'dwdos@hpce.nec.com'; Reiter Manuel; Fr=FChauf Andreas
Subject: Re: xfs_metadump

On 6/12/15 7:49 AM, Johannes Weydt wrote:
> Hello SGI,
> =

>  =

> =

> We experienced a I/O error on one of our XFS filesystems, xfs_repair -n a=
dvised to
> =

> "Please capture the filesystem metadata with xfs_metadump and
> =

> report it to xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>."
> before it ended with a Segmentation fault.
> =

> The metadata is almost 3GB big, how do you recommend to transfer the file?

did you try to compress it?

> Do you have an open FTP for us?

> Also attached are some console outputs of first investigation attempts.
> =

> Log of xfs_repair -n (1^st run)

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



 Click https://www.mailcontrol.com/sr/JxHYYzH!zCnGX2PQPOmvUu5zZAYN1Mos9eKHj=
YNtfXrudviIHsJm0HyQQuFuwh!AVNukBLmUyPDUfE+mA+MlhQ=3D=3D  to report this ema=
il as spam.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
