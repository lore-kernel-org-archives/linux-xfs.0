Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHrNin028885 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:53:23 -0600
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.18.15]) by cuda.sgi.com with ESMTP id gbGc8GTSkyoPib6W
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 09:53:21 -0800 (PST)
Message-ID: <4F394E10.9000804@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 18:53:20 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
In-Reply-To: <20120213172937.GA25248@infradead.org>
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

On 02/13/2012 06:29 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 06:26:46PM +0100, Richard Ems wrote:
>> YES. All files (and dirs) that I checked do show something as
>>
>> 0: [0..7]: 18531216..18531223
>>
>> So, what improvements can I expect from a kernel > 3.2 ?
>> Can I read somewhere about the changes/patches introduced?
> =

> On some crazy workloads I've seen speedups up to a factor of 10.000 (5
> orders or magnitude).  You probably won't get that much of a speedup,
> but it will still be significant.
> =

> The patch in mainline for this is:
> =

> commit 859f57ca00805e6c482eef1a7ab073097d02c8ca
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Sat Aug 27 14:45:11 2011 +0000
> =

>     xfs: avoid synchronous transactions when deleting attr blocks
> =

>> Is there another way to mount/create/mkfs the XFS to improve the unlink
>> time for this case?
> =

> Try increasing the inode size during filesystem creating using the
> "-i size=3D512" option or even "-i size=3D1024" if you still have
> out of line attributes.  The should give you even bigger speedups
> for this workload than the patch above.
> =


Ok, Many thanks for this good info!

I will try to install a > 3.2 kernel and will create new XFS partitions
with "-i size=3D1024", since we use ACLs a lot for user access.
Is there a chance to change existing XFS partitions to "-i size=3D1024" ?
I already have 5 big partitions, all full of ACLs and not running
kernels > 3.2 !

Many thanks again,
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
