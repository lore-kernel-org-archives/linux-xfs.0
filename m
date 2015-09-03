Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA19C7F98
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 14:15:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69FDDAC001
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 12:15:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L2hWyLXlgE4PLK0x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 12:15:05 -0700 (PDT)
Date: Thu, 3 Sep 2015 14:15:01 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 2/3] xfs: create symlink proc/fs/xfs/stat to
	sys/fs/xfs/stats
Message-ID: <20150903191501.GA11440@redhat.com>
References: <1441298187-29064-1-git-send-email-billodo@redhat.com>
	<1441298187-29064-3-git-send-email-billodo@redhat.com>
	<20150903175757.GB10397@birch.djwong.org>
	<55E89239.60305@sandeen.net> <20150903183953.GA9848@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150903183953.GA9848@redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Sep 03, 2015 at 01:39:53PM -0500, Bill O'Donnell wrote:
> On Thu, Sep 03, 2015 at 01:32:25PM -0500, Eric Sandeen wrote:
> > On 9/3/15 12:57 PM, Darrick J. Wong wrote:
> > > On Thu, Sep 03, 2015 at 11:36:26AM -0500, billodo wrote:
> > >> As a part of the work to move xfs global stats from procfs to sysfs,
> > >> this patch creates the symlink from proc/fs/xfs/stat to sys/fs/xfs/stats.
> > >>
> > >> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > >> ---
> > >>  fs/xfs/xfs_stats.c | 8 ++++++--
> > >>  1 file changed, 6 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> > >> index 856cf57..ad435f1 100644
> > >> --- a/fs/xfs/xfs_stats.c
> > >> +++ b/fs/xfs/xfs_stats.c
> > >> @@ -244,9 +244,13 @@ xfs_init_procfs(void)
> > >>  	if (!proc_mkdir("fs/xfs", NULL))
> > >>  		goto out;
> > >>  
> > >> -	if (!proc_create("fs/xfs/stat", 0, NULL,
> > >> -			 &xfs_stat_proc_fops))
> > >> +	if (!proc_symlink("fs/xfs/stat", NULL,
> > >> +			  "/sys/fs/xfs/stats/stats"))
> > > 
> > > Uh.... is it actually guaranteed that sysfs is mounted on /sys now?
> > > 
> > > I sort of recall gregkh grumbling years ago that sysfs can be mounted anywhere,
> > > and that /proc shouldn't hardcode links to it.  But that's just handwaving on
> > > my part.
> > 
> > You can blame me for that idea.  At least one other driver does
> > do it, though; of_core_init():
> > 
> > proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
> > 
> > worst-case scenario, your "legacy" stats file will be a broken symlink...
> > 
> > -Eric
> > 
> 
> I'm still looking for something in documentation that dictates such a requirement
> regarding symlinks to sysfs elements.
> -Bill

I did find this in: https://www.kernel.org/doc/Documentation/sysfs-rules.txt
--------------snip--------------------------
- sysfs is always at /sys
  Parsing /proc/mounts is a waste of time. Other mount points are a
  system configuration bug you should not try to solve. For test cases,
  possibly support a SYSFS_PATH environment variable to overwrite the
  application's behavior, but never try to search for sysfs. Never try
  to mount it, if you are not an early boot script.
-------------snip---------------------------
> 
> > > --D
> > > 
> > >> +	{
> > >> +		printk(KERN_INFO "failed to created fs/xfs/stat symlink\n");
> > >>  		goto out_remove_xfs_dir;
> > >> +	}
> > >> +
> > >>  #ifdef CONFIG_XFS_QUOTA
> > >>  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
> > >>  			 &xqmstat_proc_fops))
> > >> -- 
> > >> 2.4.3
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
