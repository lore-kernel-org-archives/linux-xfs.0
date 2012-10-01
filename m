Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91ERSLt133199 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 09:27:29 -0500
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.31.35]) by cuda.sgi.com with ESMTP id Jvh677haYVAidgT7
	for <xfs@oss.sgi.com>; Mon, 01 Oct 2012 07:28:51 -0700 (PDT)
Message-ID: <5069A8A1.4080404@cape-horn-eng.com>
Date: Mon, 01 Oct 2012 16:28:49 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com> <4F47AA24.8010209@sandeen.net>
In-Reply-To: <4F47AA24.8010209@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 02/24/2012 04:17 PM, Eric Sandeen wrote:
>> *MKFS*
>> > We also heavily use ACLs for almost all of our files. Christoph Hellwig
>> > suggested in a previous mail to use "-i size=3D512" on XFS creation, s=
o my
>> > mkfs.xfs would look something like:
>> > =

>> > mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sd=
X1
> Be sure the stripe geometry matches the way the raid controller is
> set up.
> =

> You know the size of your acls, so you can probably do some testing
> to find out how well 512-byte inodes keep ACLs in-line.


Hi Eric,

This is a reply to an email from you sent 7 months ago ...

How could I do the testing you were proposing? How can I find out if my
512-byte inodes keep our ACLs in-line?

I am going to create a similar new RAID set, and wanted to check this
before on the one already in production.

Thanks,
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
