Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91EZ2h4133644 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 09:35:02 -0500
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.93]) by cuda.sgi.com with ESMTP id TlMCxyZIMCPjyTeR
	for <xfs@oss.sgi.com>; Mon, 01 Oct 2012 07:36:25 -0700 (PDT)
Message-ID: <5069AA67.5040303@cape-horn-eng.com>
Date: Mon, 01 Oct 2012 16:36:23 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com> <4F47AA24.8010209@sandeen.net>
	<5069A8A1.4080404@cape-horn-eng.com>
In-Reply-To: <5069A8A1.4080404@cape-horn-eng.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 10/01/2012 04:28 PM, Richard Ems wrote:
> On 02/24/2012 04:17 PM, Eric Sandeen wrote:
>>> *MKFS*
>>>> We also heavily use ACLs for almost all of our files. Christoph Hellwig
>>>> suggested in a previous mail to use "-i size=3D512" on XFS creation, s=
o my
>>>> mkfs.xfs would look something like:
>>>>
>>>> mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sd=
X1
>> Be sure the stripe geometry matches the way the raid controller is
>> set up.
>>
>> You know the size of your acls, so you can probably do some testing
>> to find out how well 512-byte inodes keep ACLs in-line.
> =

> =

> Hi Eric,
> =

> This is a reply to an email from you sent 7 months ago ...
> =

> How could I do the testing you were proposing? How can I find out if my
> 512-byte inodes keep our ACLs in-line?
> =

> I am going to create a similar new RAID set, and wanted to check this
> before on the one already in production.
> =

> Thanks,
> Richard
> =


Hi again,

If the "method" is to use "xfs_bmap -a ..." and check for "no extents",
then I found it !

Thanks, sorry for the noise,
Richard

-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
