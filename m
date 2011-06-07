Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57C5t7l023690 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 07:05:55 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AF2B1ED523F
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 05:05:54 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id KEMlQswfAnXA91uj
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2011 05:05:54 -0700 (PDT)
Message-ID: <4DEE1422.7060902@hardwarefreak.com>
Date: Tue, 07 Jun 2011 07:05:54 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Defragging XFS File Systems
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
In-Reply-To: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
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
To: Kenneth Emerson <kenneth.emerson@gmail.com>
Cc: xfs@oss.sgi.com

On 6/6/2011 10:52 PM, Kenneth Emerson wrote:
> I hadn't given much thought to fragmentation of my TV recordings volume
> (XFS) until reading through some MythTV-users threads recently that
> mentioned how fragmented an XFS file system could become.  After running
> xfs_db, I found out that my fs appeared to be quite bad:
> 
> $ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv
>  actual 1138668, ideal 11023, fragmentation factor 99.03%
> 
> I then ran xfs_fsr with all defaults (ran for two hours) and then re-ran

>From man xfs_fsr:

       It runs for up to two hours after which it records the
       filesystem where it left off, so it can start there the next
       time.  This  information  is stored in the file
       /var/tmp/.fsrlast_xfs.  If the information found here is somehow
       inconsistent or out of date it is ignored and reorganization
       starts at the beginning of the first filesystem found in
       /etc/mtab.

If xfs_fsr stopped at 2 hours, multiple additional runs will likely be
required to get good defragmentation.

> xfs_db and got the following results:
> 
> $ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv

The -r above suggests you created a large realtime section for your
MythTV storage.  It may be helpful for you to provide xfs_info output
for the heavily fragmented filesystem.

> invalid numrecs (27111) in bmapbtd block
> invalid numrecs (4716) in bmapbtd block
> invalid numrecs (58978) in bmapbtd block

I'll leave these errors for one of the devs to tackle.

> actual 1034793, ideal 11024, fragmentation factor 98.93%
> 
> The fragmentation level was reduced, 

It was likely reduced much more than this.  Dropping caches or
unmounting and remounting the filesystem is often necessary after
running xfs_fsr in order to show the actual fragmentation level.  Try:

# echo 3 > /proc/sys/vm/drop_caches

and then run xfs_db again.

> but I was concerned about the error
> messages.  Before I go any further, am I corrupting my file system with the
> defragging or are these "invalid numrecs" messages unimportant?

Run 'xfs_check' or 'xfs_repair -n' and post the results.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
