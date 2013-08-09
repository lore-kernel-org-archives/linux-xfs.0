Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32C557F9F
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 10:20:01 -0500 (CDT)
Date: Fri, 9 Aug 2013 10:19:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: prjquota not updating used blocks
Message-ID: <20130809151957.GZ3111@sgi.com>
References: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [C]" <WeberC@grc.nia.nih.gov>
Cc: xfs@oss.sgi.com

Hi Charles,

On Fri, Aug 09, 2013 at 10:14:21AM -0400, Weber, Charles (NIH/NIA/IRP) [C] wrote:
> CentOS 6.4 
> Linux niairpfs1.irp.nia.nih.gov 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu May 16 20:59:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> xfsprogs-3.1.1-10.el6_4.1.x86_64
> xfsdump-3.0.4-3.el6.x86_64
> 
> mount
> /dev/mapper/shared1_vg-niairp_lv on /share/niairp type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)
> 
> this is a 63T filesystem
> xfs_quota report
> Project quota on /share/niairp (/dev/mapper/shared1_vg-niairp_lv)
> Project ID   Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> lbnnas          0      0     1T  00 [------]
> lbnnccu         0      0   4.4T  00 [------]
> tgb          1.3T      0     2T  00 [------]
> apps       106.4G      0   150G  00 [------]
> ncts       205.7G      0   250G  00 [------]
> lg           1.4T      0    10T  00 [------]
> 
> Since initializing a project quota, there is no change in used blocks. When I initialize the block count is correct.  If I re-initialize, the used block count is updated properly. 
> 
> I copied 2T last night into the folder referenced by the lg project quota and there is no change in used blocks today.
> What have I missed?

An initial guess is you did not set up the project in xfs_quota using the
'project -s' xfs_quota command.

'project -c' output should look like this:

xfs_quota> project -c testproject  
Checking project testproject (path /mnt/test/testa)...
Checking project testproject (path /mnt/test/testb)...
Processed 2 (/etc/projects and cmdline) paths for project testproject with recursion depth infinite (-1).

But if you don't set up a project you might see something like this:

xfs_quota> project -c testproject
Checking project testproject (path /mnt/test/testa)...
/mnt/test/testa - project identifier is not set (inode=0, tree=33)
/mnt/test/testa - project inheritance flag is not set
/mnt/test/testa/file - project identifier is not set (inode=0, tree=33)
/mnt/test/testa/file - project inheritance flag is not set
Checking project testproject (path /mnt/test/testb)...
/mnt/test/testb - project identifier is not set (inode=0, tree=33)
/mnt/test/testb - project inheritance flag is not set
Processed 2 (/etc/projects and cmdline) paths for project testproject with recursion depth infinite (-1).

And you'd have similar symptoms.  You can also check which project the files
you created are in by using the xfs_io 'lsproj' command.  There is also a
'chproj' command if find that your existing files aren't in the project and
need to add them in.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
