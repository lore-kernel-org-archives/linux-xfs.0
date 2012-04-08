Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q38KX3GX200369 for <xfs@oss.sgi.com>; Sun, 8 Apr 2012 15:33:03 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qOVpJJyCwIVNHLqM
	for <xfs@oss.sgi.com>; Sun, 08 Apr 2012 13:33:02 -0700 (PDT)
Message-ID: <4F81F5FD.1090809@hardwarefreak.com>
Date: Sun, 08 Apr 2012 15:33:01 -0500
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
In-Reply-To: <20120407104912.44881be3@galadriel.home>
Reply-To: stan@hardwarefreak.com
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On 4/7/2012 3:49 AM, Emmanuel Florac wrote:
> Le Fri, 06 Apr 2012 18:28:37 -0500 vous =E9criviez:
> =

>> Creating four 60 drive RAID10 arrays, let alone 60 drive RAID6
>> arrays, would be silly.
> =

> From my experience, with modern arrays don't make much of a difference.
> I've reached decent IOPS (i. e. about 4000 IOPS) on large arrays of up
> to 46 drives provided there are enough threads -- more threads than
> spindles, preferably.

Are you speaking of a mixed metadata/data heavy IOPS workload similar to
that which is the focus of this thread, or another type of workload?  Is
this 46 drive array RAID10 or RAID6?

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
