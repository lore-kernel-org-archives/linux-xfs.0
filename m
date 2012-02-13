Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DIn3ej032084 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 12:49:04 -0600
Received: from smtprelay02.ispgateway.de (smtprelay02.ispgateway.de
	[80.67.29.24]) by cuda.sgi.com with ESMTP id ZBPt9B4nQMp72GYj
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:49:02 -0800 (PST)
Message-ID: <4F395B1A.7010709@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 19:48:58 +0100
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
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
In-Reply-To: <20120213181012.GA27962@infradead.org>
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

On 02/13/2012 07:10 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 07:06:44PM +0100, Richard Ems wrote:
>> So
>>
>> 1. use kernels > 3.2, if XFS partition was not created using "-i size=3D=
1024"
> =

> Yes.
> =

>> 2. if XFS partition was created using "-i size=3D1024", kernels < 3.2 wi=
ll
>> also be fast while unlinking files with out of line attributes
> =

> Exactly.
> =

> For workloads like yours creating the large inodes (probably only with
> 512 byte inodes, though) will be preferably if you have a choice, as it
> should be even faster.
> =


I already updated to 3.2.4 and started the same "find dir" command again
that previously took 100 min to run. It has been running now for over 30
min ...

Should this "find" run time also improve ?
Or will only unlink run time improve ?
I expect both of them to change similarly, or not? Wrong assumption?

Do I have to mount the XFS partition with some new/old/special option?

Thanks again,
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
