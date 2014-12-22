Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E68429DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:49:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 670A18F8037
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 12:49:05 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qIMj6JmxT12qpzNW for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 12:48:59 -0800 (PST)
Date: Tue, 23 Dec 2014 07:48:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: weird quota issue
Message-ID: <20141222204857.GK24183@dastard>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [E]" <WeberC@grc.nia.nih.gov>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Dec 19, 2014 at 09:26:12PM +0000, Weber, Charles (NIH/NIA/IRP) [E] wrote:
> HI everyone, long time xfs/quota user with new server and problem
> hardware is HP BL460 G7 blade, qlogic fiber channel and 3Par 7200 storage
> 3 16TB vols exported from 3Par to server via FC. These are thin volumes, but plenty of available backing storage.
> 
> Server runs current patched CentOS 6.6
> kernel 2.6.32-504.3.3.el6.x86_64
> xfsprogs 2.1.1-16.el6
> Default mkfs.xfs options for volumes
> 
> mount options for logical volumes  home_lv 39TB imap_lv 4.6TB
> /dev/mapper/irphome_vg-home_lv on /home type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)
> /dev/mapper/irphome_vg-imap_lv on /mail type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)
> 
> Users are from large AD via winbind set to not enumerate. I saw
> the bug with xfs_quota report not listing winbind defined user
> names. Yes this happens to me.

So just enumerate them by uid. (report -un)

> I can assign project quota to smaller volume. xfs_quota will not
> report it. I cannot assign a project quota to larger volume. I get
> this error: xfs_quota: cannot set limits: Function not
> implemented.

You need to be more specific and document all your quota setup.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> xfs_quota -x -c 'report -uh' /mail
> User quota on /mail (/dev/mapper/irphome_vg-imap_lv)
>                         Blocks
> User ID      Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> root         2.2G      0      0  00 [------]
> 
> [xfs_quota -x -c 'report -uh' /home
> 
> nothing is returned
> 
> I can set user and project quotas on /mail but cannot see them. I have not tested them yet.
> I cannot set user or project quotas on /home.
> At one time I could definitely set usr quotas on /home. I did so and verified it worked.
> 
> Any ideas what is messed up on the /home volume?

Not without knowing a bunch more about your project quota setup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
