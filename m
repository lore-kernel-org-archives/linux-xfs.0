Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B6A37F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 03:35:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08B8F8F8049
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:35:13 -0700 (PDT)
Received: from mail03.lsn.net (mail03.lsn.net [66.90.130.130]) by cuda.sgi.com
	with ESMTP id dErfHiEioO0Jtp6Q for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 01:35:11 -0700 (PDT)
Message-ID: <55ACB2BD.6050601@mygrande.net>
Date: Mon, 20 Jul 2015 03:35:09 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>	<55AAF73A.4040903@mygrande.net>
	<20150719232754.GS7943@dastard> <55ACA615.10501@mygrande.net>
	<55ACABD7.8000500@gmail.com>
In-Reply-To: <55ACABD7.8000500@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Martin Papik <mp6058@gmail.com>
Cc: xfs@oss.sgi.com

On 7/20/2015 3:05 AM, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
>
> Since you've already found one HW related fault, would you consider
> booting into memtest for a couple of passes just to be on the safe
> side.

	I did that after confirming the one stick of memory was bad.  Twice.  I 
got over 20,000 errors on the bad stick, and 0 on the good one.  I also 
swapped the locations on the motherboard, and the bad stick still failed 
while the good one passed 100%.

> And did you by any chance look at SMART if applicable and
> possibly running a test on the drives.

	Yes. SMART found no errors, but think about it.  Every time tar tries 
to create a directory when untarring that file in that location, the 
file system croaks when it tries to create a directory. Not when reading 
and not when writing other than when it creates a directory.  When I 
create the directory manualy, the process quits failing at that point 
and fails later on during a different directory create.  The array 
remains intact when reading, and dmesg shows no drive errors.  I've 
re-synced the array, which reads every byte on all 8 drives without a 
single mismatch - several times.  To my knowledge, no read has ever 
failed except after the filesystem goes offline.  I thought reads were 
failing during the CRC checks, but that was a red herring.

> Another test I sometimes do
> when I'm unsure about disks is "cat /dev/sda > /dev/null" (i.e. a
> whole disk read test)

echo repair > /sys/block/md0/md/sync_action reads not one drive, but 
every byte on all 8 drives.

> and see (dmesg) if any errors show up, unless

	'Nary one, and no mismatches.

> you're willing to run badblocks in a read-write nondestructive mode.
> In my experience the read test or badblocks can be run simultaneously
> with smartctl -t long. But as a start I'd look at smartctl --all
> /dev/sd? and see if there are any bad signs. I hope this helps. Good luck
>
>
> On 07/20/2015 10:41 AM, Leslie Rhorer wrote:
>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>>>
>>>> I found the problem with md5sum (and probably nfs, as well).
>>>> One of the memory modules in the server was bad.  The problem
>>>> with XFS persists.  Every time tar tried to create the
>>>> directory:
>>>
>>> Now you need to run xfs_repair.
>>
>> I do that every time the array implodes.  It makes no difference.
>> It never mentions cleaning the structure tar says needs cleaning,
>> and the next time I run tar on that file, the filesystem craters.
>>
>> _______________________________________________ xfs mailing list
>> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQIcBAEBCgAGBQJVrKuzAAoJELsEaSRwbVYrdjoP/3n1W9YtcpdiDoylp6tDYcjF
> vEVz7IWLv2cOky8Lp+0WAZ4Z0WMhcutFzT571H1Vc+jT/UgO25pQHa3yLYTboPuZ
> +tBidVUycs7ZIr9QCZFs2uPQ/7YstamB+F7paCTMKtOJJr5CZLiYX4iyJ9sFmWVY
> UFPAIhyoqD5CFgoaAkwCmk50kNiT0aPM7egizIUVEt14cWuxZxMN0NIJ5b0WJfAk
> qtNQjstVI/xYDgsImm2ZAm19SfOG9ltm2G9zafRr6lR6rRtXjtZX8zEg0l/o9XUw
> OifghjoSup8OCzvX6+4+Soj/3mCKZv4rkBm3exf4YzfQ9eVG6Ktele2rLIs1sl3O
> hUrZUNEl8hYGJeb5gBHFV/TLWDMMwNde/6JiBVy0V8EbDF1lvR4jYpUwThOE0jyL
> ZbzZe4N/B0qvB1OpLDkHrMVm9NPtDkfXdTtM2kRmo5955xtkK09yHF/v64kz7IKc
> 2rM5pOwTR6HWE8RF2j9UujgPjw6nEUuY01TvIMGYzMfkJTI+sVjeDQfwnPG8tzIa
> x4uLa4vTrBD5IaICjAmQiY69qqmt5Vg42G4latZVTYQLelvWQ774mXZfgfT/GtbT
> RKzVwvYowWr/EBhtp7ix/1rWANTFiX0lxOPnRmUFvu8UJnyZhR0/EYbJYy1+jTt7
> O7hZMfAayQBsnVcSK1JC
> =3Ubd
> -----END PGP SIGNATURE-----
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
