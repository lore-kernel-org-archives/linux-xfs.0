Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EFoTGY003322 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 10:50:29 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E0BD51BDA84B
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 08:53:51 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id 8pIUkKCP4cNZpg1w
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 08:53:51 -0700 (PDT)
Message-ID: <4DA7182B.8050409@draigBrady.com>
Date: Thu, 14 Apr 2011 16:52:11 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
In-Reply-To: <4DA717B2.3020305@sandeen.net>
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
Cc: linux-ext4@vger.kernel.org, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

On 14/04/11 16:50, Eric Sandeen wrote:
> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>>> Hi P=E1draig,
>>>>>
>>>>> here you go:
>>>>> + filefrag -v unwritten.withdata                                     =
                                                                           =
     =

>>>>> Filesystem type is: ef53                                             =
                                                                           =
     =

>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)   =
                                                                           =
     =

>>>>>  ext logical physical expected length flags                          =
                                                                           =
     =

>>>>>    0       0   274432            2560 unwritten,eof                  =
                                                                           =
     =

>>>>> unwritten.withdata: 1 extent found
>>>>>
>>>>> Please notice that this also happens with ext4 on the same kernel. =

>>>>> Btrfs is fine.
>>>>
>>> `filefrag -vs` fixes the issue on both xfs and ext4.
>>
>> So in summary, currently on (2.6.39-rc3), the following
>> will (usually?) report a single unwritten extent,
>> on both ext4 and xfs
>>
>>   fallocate -l 10MiB -n k
>>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=3Dk
>>   filefrag -v k # grep for an extent without unwritten || fail
> =

> right, that's what I see too in testing.
> =

> But would the coreutils install have done a preallocation of the destinat=
ion file?
> =

> Otherwise this looks like a different bug...
> =

>> This particular issue has been discussed so far at:
>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
>> Note there it was stated there that ext4 had this
>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
> =

> ext4 got a fix, but not xfs, I guess.  My poor brain can't remember, I th=
ink I started looking into it, but it's clearly still broken.
> =

> Still, I don't know for sure what happened to Markus - did something prea=
llocate, in his case?

Well that preallocate test is failing for him
when the source file is either on ext4 or xfs.
He noticed the issue initially on XFS when copying
none preallocated files, so XFS probably just has
the general issue of needing a sync before fiemap,
where as EXT4 just has this preallocate one
(though I've not seen it myself).

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
