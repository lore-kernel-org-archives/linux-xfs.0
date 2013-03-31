Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86ACA7F74
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 20:35:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72E53304043
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 18:35:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HLbwbtXfqsIr6so0 for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 18:35:44 -0700 (PDT)
Date: Sun, 31 Mar 2013 12:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
Message-ID: <20130331013543.GK6369@dastard>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
	<5156DF72.1090703@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5156DF72.1090703@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On Sat, Mar 30, 2013 at 07:49:54AM -0500, Stan Hoeppner wrote:
> On 3/19/2013 5:14 AM, Stan Hoeppner wrote:
> > On 3/19/2013 3:24 AM, Martin Steigerwald wrote:
> ...
> >> Heck, even I was confused at first. Cause the manpage of fsck.ext4 IMHO is 
> >> not really clear about that topic to say the least. I tested it out for a 
> >> reason.
> > 
> > I already contacted Ted off list hoping he can point me to the relevant
> > kernel documentation, so I don't make such a mistake again with EXT.
> 
> Ok, so here's the skinny on the source of our confusion WRT how/when
> EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
> the following.
> 
> The EXT4 kernel module does have code to perform journal replay, but it
> is rarely executed.  The reasons for this are:
> 
> 1.  EXT4 journal replay can take a lot of time (whereas XFS is instant)

19 minutes is my current record for XFS journal replay. 2GB log,
filled full of inode creates, required about 300,000 IOs to complete
recovery.....

> 2.  EXT4 systems tend to have multiple filesystems, often one per drive
>     (whereas XFS systems tend to have few filesystems)

[Citation needed]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
