Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60F7D7F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 03:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FB7F304043
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:05:51 -0700 (PDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id 2a2aE3C1KXTtL3P4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:05:49 -0700 (PDT)
Received: by wgbcc4 with SMTP id cc4so30978678wgb.3
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:05:48 -0700 (PDT)
Message-ID: <55ACABD7.8000500@gmail.com>
Date: Mon, 20 Jul 2015 11:05:43 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>	<55AAF73A.4040903@mygrande.net>
	<20150719232754.GS7943@dastard> <55ACA615.10501@mygrande.net>
In-Reply-To: <55ACA615.10501@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: lrhorer@mygrande.net
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


Since you've already found one HW related fault, would you consider
booting into memtest for a couple of passes just to be on the safe
side. And did you by any chance look at SMART if applicable and
possibly running a test on the drives. Another test I sometimes do
when I'm unsure about disks is "cat /dev/sda > /dev/null" (i.e. a
whole disk read test) and see (dmesg) if any errors show up, unless
you're willing to run badblocks in a read-write nondestructive mode.
In my experience the read test or badblocks can be run simultaneously
with smartctl -t long. But as a start I'd look at smartctl --all
/dev/sd? and see if there are any bad signs. I hope this helps. Good luck


On 07/20/2015 10:41 AM, Leslie Rhorer wrote:
> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>> 
>>> I found the problem with md5sum (and probably nfs, as well).
>>> One of the memory modules in the server was bad.  The problem
>>> with XFS persists.  Every time tar tried to create the
>>> directory:
>> 
>> Now you need to run xfs_repair.
> 
> I do that every time the array implodes.  It makes no difference. 
> It never mentions cleaning the structure tar says needs cleaning,
> and the next time I run tar on that file, the filesystem craters.
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVrKuzAAoJELsEaSRwbVYrdjoP/3n1W9YtcpdiDoylp6tDYcjF
vEVz7IWLv2cOky8Lp+0WAZ4Z0WMhcutFzT571H1Vc+jT/UgO25pQHa3yLYTboPuZ
+tBidVUycs7ZIr9QCZFs2uPQ/7YstamB+F7paCTMKtOJJr5CZLiYX4iyJ9sFmWVY
UFPAIhyoqD5CFgoaAkwCmk50kNiT0aPM7egizIUVEt14cWuxZxMN0NIJ5b0WJfAk
qtNQjstVI/xYDgsImm2ZAm19SfOG9ltm2G9zafRr6lR6rRtXjtZX8zEg0l/o9XUw
OifghjoSup8OCzvX6+4+Soj/3mCKZv4rkBm3exf4YzfQ9eVG6Ktele2rLIs1sl3O
hUrZUNEl8hYGJeb5gBHFV/TLWDMMwNde/6JiBVy0V8EbDF1lvR4jYpUwThOE0jyL
ZbzZe4N/B0qvB1OpLDkHrMVm9NPtDkfXdTtM2kRmo5955xtkK09yHF/v64kz7IKc
2rM5pOwTR6HWE8RF2j9UujgPjw6nEUuY01TvIMGYzMfkJTI+sVjeDQfwnPG8tzIa
x4uLa4vTrBD5IaICjAmQiY69qqmt5Vg42G4latZVTYQLelvWQ774mXZfgfT/GtbT
RKzVwvYowWr/EBhtp7ix/1rWANTFiX0lxOPnRmUFvu8UJnyZhR0/EYbJYy1+jTt7
O7hZMfAayQBsnVcSK1JC
=3Ubd
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
