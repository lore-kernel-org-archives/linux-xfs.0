Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3E7WScB169767 for <xfs@oss.sgi.com>; Sat, 14 Apr 2012 02:32:28 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JRcpnWfrMO5ENeMC
	for <xfs@oss.sgi.com>; Sat, 14 Apr 2012 00:32:27 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id D21E16C0B9
	for <xfs@oss.sgi.com>; Sat, 14 Apr 2012 02:32:26 -0500 (CDT)
Message-ID: <4F892808.2040003@hardwarefreak.com>
Date: Sat, 14 Apr 2012 02:32:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<20120407104912.44881be3@galadriel.home>
	<4F81F5FD.1090809@hardwarefreak.com>
	<20120408234555.695e291f@galadriel.home>
	<4F827341.2000607@hardwarefreak.com>
	<20120409144558.6072c1eb@galadriel.home>
	<CAAxjCEw-WZ9AtEJTZ6eS9+mjm+yh=e_19aJqxUN-ABRp8r3ZyQ@mail.gmail.com>
In-Reply-To: <CAAxjCEw-WZ9AtEJTZ6eS9+mjm+yh=e_19aJqxUN-ABRp8r3ZyQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/13/2012 2:36 PM, Stefan Ring wrote:
>> Let's rerun it with files cached (the machine has 16 GB RAM, so
>> every single file must be cached):
>>
>> # time tar xf test.tar
>>
>> real    0m50.842s
>> user    0m0.809s
>> sys     0m13.767s
> =

> That=92s about the same time I=92m getting on a fresh (non-fragmented)
> file system with the RAID 6 volume.
> =

> Interestingly, the P400=92s successor, the P410 does recognize a setting
> that the P400 lacks, which is called elevatorsort. It sounds like this
> could make all the difference. Unfortunately, the P400 doesn=92t have
> it. I don=92t have a P410 with more than 2 drives to test this, but some
> effect should definitely be measurable.
> =

> Since this finding has piqued my interest again, I=92m willing to invest
> a little more time, but I=92m completely occupied for the next few days,
> so it will have to wait a while.

What configuration are you running right now Stefan?  You said you went
back to XFS due to the EXT4 lockups, but I can't recall what RAID config
you put underneath it this time.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
