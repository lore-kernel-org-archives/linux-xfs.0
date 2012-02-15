Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FCmwaY177138 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 06:48:59 -0600
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.29.28]) by cuda.sgi.com with ESMTP id 9gRkZplxvPDB4xDw
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 04:48:57 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay03.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RxeI4-0007lS-RJ
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 13:48:56 +0100
Message-ID: <4F3BA9B8.4080204@cape-horn-eng.com>
Date: Wed, 15 Feb 2012 13:48:56 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F3A5B49.6020803@cape-horn-eng.com> <4F3AA191.9030606@mnsu.edu>
	<4F3AA40D.50302@cape-horn-eng.com>
	<20120214190753.GA8383@infradead.org>
In-Reply-To: <20120214190753.GA8383@infradead.org>
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
To: xfs@oss.sgi.com

On 02/14/2012 08:07 PM, Christoph Hellwig wrote:
> On Tue, Feb 14, 2012 at 07:12:29PM +0100, Richard Ems wrote:
>> # /net/c3m/usr/local/software/XFS/summarise_stat.pl /bin/
>>       9  6.2% are scripts (shell, perl, whatever)
>>      65 44.8% don't use any stat() family calls at all
>>      61 42.1% use 32-bit stat() family interfaces only
>>       9  6.2% use 64-bit stat64() family interfaces only
>>       1  0.7% use both 32-bit and 64-bit stat() family interfaces
>>
>> So I was not sure if I should use inode64 or not.
> =

> Are you on a 32-bit system (userspace, kernel doesn't matter)?

No, I have been running on 64-bit systems for years. That output above
is on openSUSE 12.1 64-bit.

> If the system is 64-bit even the plain stat handles 64-bit inodes just
> fine.

With *plain stat* you mean the *32-bit stat* listed above ?
Is it then safe to switch all XFS partitions to be mounted with inode64
on 64-bit systems? Also for NFS v3 exports?
>From the XFS FAQ I read that it should work, also for NFS v3, and that I
can try it and switch back if there are problems, so I will give it a try!

Many thanks again for your time and help!
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
