Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2NG2Ytn168261
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 11:02:54 -0500
Received: from web51309.mail.re2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 04CA313BF496
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:02:21 -0700 (PDT)
Received: from web51309.mail.re2.yahoo.com (web51309.mail.re2.yahoo.com
	[206.190.38.175]) by cuda.sgi.com with SMTP id QXbwc3H28jenuxHF
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:02:21 -0700 (PDT)
Message-ID: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Date: Mon, 23 Mar 2009 09:02:14 -0700 (PDT)
From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: How to configure 36 disks ?
In-Reply-To: <49C7AC2C.9090307@tmr.com>
MIME-Version: 1.0
Reply-To: Jon@eHardcastle.com
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
To: Raz <raziebe@gmail.com>, Bill Davidsen <davidsen@tmr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org


I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'..Be fearful when others are greedy, and be greedy when others are fearful.'
-----------------------


--- On Mon, 23/3/09, Bill Davidsen <davidsen@tmr.com> wrote:

> From: Bill Davidsen <davidsen@tmr.com>
> Subject: Re: How to configure 36 disks ?
> To: "Raz" <raziebe@gmail.com>
> Cc: linux-fsdevel@vger.kernel.org, "Linux RAID Mailing List" <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
> Date: Monday, 23 March, 2009, 3:35 PM
> Raz wrote:
> > Hello
> > I need to configure 3xDAS'es, each with 12 disks.
> > All three DAS'es are connected to a single
> machine.
> > I have the following requirements (in this order of
> importance)
> > from the storage:
> > 
> > 1. redundancy.
> >    having two disks failing in one raid5 breaks the
> entire raid. when
> > you have 30TB storage
> >    it is a disaster.
> > 
> > 2. performance.
> >    My code eliminates Linux raid5/6 write penalty. I
> managed to do by
> >    manipulating xfs and patching linux raid5 a bit.
> > 
> > 3. modularity ( a "grow" and it will be nice
> to have "shrink" )
> >    file system and volume must be able to grow.
> shrinking is possible
> > by unifying multiple file systems
> >    under unionfs or aufs.
> > 
> > 4. Utilize storage size.
> > 
> > I assume each disk is 1TB.
> > 
> >   
> ___ snip ___
> 
> > Any other ideas ?
> 
> Yes, you have the whole solution rotated 90 degrees.
> Consider your original solution #2 below... You have no
> redundancy if one whole DAS box fails, which is certainly a
> possible failure mode. If you put the RAID0 horizontally,
> two arrays size six in each DAS, then RAID6 vertically, if
> one DAS fails completely you still have a functioning
> system, and the failure results for individual drives
> remains about the same, while the rebuild time will be
> longer.
> 
> Solution #2
> 			     raid0
> DAS1: raid6: D,D,D,D,D,D     |
>       raid6: D,D,D,D,D,D     |
>   			      |
> DAS2: raid6: D,D,D,D,D,D     | xfs.
>       raid6: D,D,D,D,D,D     |
>                              |
> DAS3: raid6: D,D,D,D,D,D     |
>       raid6: D,D,D,D,D,D     |
> 
> 
> In addition, you can expand this configuration by adding
> more DAS units. This addresses several of your goals.
> 
> In practice, just to get faster rebuild as the array gets
> larger, I suspect you would find it was worth making the
> horizontal arrays RAID5 instead of RAID0, just to minimize
> time to full performance.
> 
> -- bill davidsen <davidsen@tmr.com>
>  CTO TMR Associates, Inc
> 
> "You are disgraced professional losers. And by the
> way, give us our money back."
>    - Representative Earl Pomeroy,  Democrat of North Dakota
> on the A.I.G. executives who were paid bonuses  after a
> federal bailout.
> 
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
