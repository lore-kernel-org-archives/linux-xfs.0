Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39N70w9229732 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 18:07:00 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ApmuK2ZuY7L0Zx0S
	for <xfs@oss.sgi.com>; Mon, 09 Apr 2012 16:06:59 -0700 (PDT)
Message-ID: <4F836B93.7070903@hardwarefreak.com>
Date: Mon, 09 Apr 2012 18:06:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
	<CAAxjCEyzmbuynT4C=wkL9Dryz1LN95soKgR4cDrZ81c3=8d24g@mail.gmail.com>
In-Reply-To: <CAAxjCEyzmbuynT4C=wkL9Dryz1LN95soKgR4cDrZ81c3=8d24g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: xfs@oss.sgi.com

On 4/9/2012 4:23 AM, Stefan Ring wrote:
>> Or merely a weak/old product.  The P400 was an entry level RAID HBA,
>> HP's first PCIe/SAS RAID card.  It was discontinued quite some time ago.
>>  The use of DDR2/533 memory indicates it's design stage started probably
>> somewhere around 2004, 8 years ago.
> 
> It was what you got when you bought a direct-attach storage blade from
> HP until a few months ago. Apparently, they changed it to P410i very
> recently: <http://h10010.www1.hp.com/wwpc/us/en/sm/WF06a/3709945-3709945-3710114-3722820-3722776-4304942.html?dnr=1>

Nonetheless, it's performance is quite bad with RAID6 (RAID10 as well).
 If you're happy with EXT4 on the P400 based RAID6, you'll be even much
happier with 3-4x more performance using md for the RAID6.  If it was
worth your time to test the XFS concat I would think this test would be
even more so, as it appears you'll be sticking with EXT4.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
