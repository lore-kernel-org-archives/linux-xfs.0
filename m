Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PLIe2f023538 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 16:18:40 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id zQZfGdkeW7ZN4KT1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jun 2012 14:18:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 23:18:34 +0200
From: =?UTF-8?Q?Ingo_J=C3=BCrgensmann?= <ij@2012.bluespice.org>
Subject: Re: mkfs.xfs states log stripe unit is too large
In-Reply-To: <4FE8CEED.7070505@hardwarefreak.com>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<4954261F-D4FB-4589-BE18-2BFCEC05E9B4@2012.bluespice.org>
	<4FE76A50.2010902@hardwarefreak.com>
	<563739BF-6A66-41F0-8EA2-CF2171E85B06@2012.bluespice.org>
	<4FE7918C.5000203@hardwarefreak.com>
	<a0714affeea45c1a62cd2f643f04b07d@muaddib.hro.localnet>
	<4FE8CEED.7070505@hardwarefreak.com>
Message-ID: <356be21697ca60cb8c51b9da3036923b@muaddib.hro.localnet>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On 2012-06-25 22:49, Stan Hoeppner wrote:

> I've never understand exactly what this means, but it's apparently
> involved with some of the arrays you've built with Stable and SID:
>
> "To ensure compatibility with earlier versions, the default when
> Building and array with no persistent metadata is 64KB."
>
> How does one "build an array with no persistent metadata"?  Does this
> simply mean forcing metadata .90 on the command line?

IIRC, the metadata in 1.2 is populated over the RAID whereas in 0.90 it 
was only at the beginning. But take that with care. I've no source for 
that assumption. It's only somewhere in my mind that I think I might 
have read about this somewhere, somewhen...
Someone else will know better and correct me for sure. :-)

>> So, the question is: why did mdadm choose 1.2 format superblock this
>> time? My guess is, that's because of GPT labelled disks instead of 
>> MBR,
>> but it's only a guess. Maybe it's because the new md device is 
>> bigger in
>> size. All of my other md devices on MBR labelled disks do have 0.90
>> format superblock, all md devices on the GPT disks are of 1.2 
>> format.
>> Although it doesn't seem a new default in mdadm for me, your 
>> assumption
>> would still stand if the cause would turn out to be the GPT label. 
>> More
>> and more people will start using GPT labelled disks.
> Ok this is really interesting as this is undocumented behavior, if
> indeed this is occurring.  Would you mind firing up a thread about 
> this
> on the linux-raid list?

I've talked to some guys on #debian.de in the meantime. I don't think 
now that this has anything to do with GPT labels. According to 
#debian.de the default behaviour in mdadm was changed after release of 
Squeeze. Already before Squeeze, metadata format 0.90 was obsolete and 
was only kept for Squeeze for backward compatibility reasons.

So, it's indeed a changed default within Debian, but nothing new for 
upstream mdadm and it's likely that other distros have adopted the 
upstream default way before Debian did.

-- 
Ciao...          //    Fon: 0381-2744150
.     Ingo     \X/     http://blog.windfluechter.net

gpg pubkey: http://www.juergensmann.de/ij_public_key.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
