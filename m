Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DI6kqk029749 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 12:06:46 -0600
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.94]) by cuda.sgi.com with ESMTP id fRH0nAF0F15hwNxd
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:06:45 -0800 (PST)
Message-ID: <4F395134.8030202@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 19:06:44 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
In-Reply-To: <20120213180220.GA24163@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/13/2012 07:02 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 06:53:20PM +0100, Richard Ems wrote:
>> I will try to install a > 3.2 kernel and will create new XFS partitions
>> with "-i size=3D1024", since we use ACLs a lot for user access.
>> Is there a chance to change existing XFS partitions to "-i size=3D1024" ?
> =

> Unfortunately not.  Note that the speedups in 3.2 only matter for
> out of line attributes - once you store the ACLs inside the inode the
> code that makes it dog slow in old kernels is never used.

Ok, I see, many thanks.

So

1. use kernels > 3.2, if XFS partition was not created using "-i size=3D102=
4"

2. if XFS partition was created using "-i size=3D1024", kernels < 3.2 will
also be fast while unlinking files with out of line attributes

Right?

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
