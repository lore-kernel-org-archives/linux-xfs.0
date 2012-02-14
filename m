Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E9mUUC082283 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 03:48:31 -0600
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.18.15]) by cuda.sgi.com with ESMTP id G4MMWiuv1NAvDgCh
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 01:48:28 -0800 (PST)
Message-ID: <4F3A2DE9.5050901@cape-horn-eng.com>
Date: Tue, 14 Feb 2012 10:48:25 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
	<4F395B1A.7010709@cape-horn-eng.com>
	<20120213211654.GA20192@infradead.org>
In-Reply-To: <20120213211654.GA20192@infradead.org>
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

Hi Christoph, hi list,

I don;t have ONE dir with that 11 million files, it's one dir with many
directories and a total of about 11 million files AND dirs! See output
below!

On 02/13/2012 10:16 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 07:48:58PM +0100, Richard Ems wrote:
>> I already updated to 3.2.4 and started the same "find dir" command again
>> that previously took 100 min to run. It has been running now for over 30
>> min ...
>>
>> Should this "find" run time also improve ?
> =

> No, not by that change anyway.

It didn't improve, 100 min again.



>> Or will only unlink run time improve ?
> =

> Yes.

rm took about 110 min.


>> Do I have to mount the XFS partition with some new/old/special option?
> =

> I'd have to look into it in more detail.  IIRC you said you're using
> RAID6 which can be fairly nasty for small reads.  Did you use the
> inode64 mount option on the filesystem?

No, I did not use it, but I was thinking about and ran the script from
http://sandeen.net/misc/summarise_stat.pl and got as an example on /bin:

# /net/c3m/usr/local/software/XFS/summarise_stat.pl /bin/
      9  6.2% are scripts (shell, perl, whatever)
     65 44.8% don't use any stat() family calls at all
     61 42.1% use 32-bit stat() family interfaces only
      9  6.2% use 64-bit stat64() family interfaces only
      1  0.7% use both 32-bit and 64-bit stat() family interfaces

So I was not sure if I should use inode64 or not.



This are the times that the run took yesterday:

Mon Feb 13 19:14:07 CET 2012

+ wc -l
+ find 2012-02-13/
11377443

real    101m30.811s
user    0m17.365s
sys     1m4.632s


Mon Feb 13 20:55:38 CET 2012

+ wc -l
+ find 2012-02-13/ -type d
834591

real    103m52.686s
user    0m11.765s
sys     1m41.018s


+ wc -l
+ find 2012-02-13/ -type f
10539154

real    104m38.421s
user    0m19.905s
sys     1m47.551s


+ /bin/rm -i -rf 2012-02-13/

real    110m55.764s
user    0m13.401s
sys     4m3.115s

Tue Feb 14 02:15:05 CET 2012


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
