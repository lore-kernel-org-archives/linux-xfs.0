Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAR2tHJ0256590 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 20:55:18 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vGDYPgiPdDsTdiMR for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 18:57:32 -0800 (PST)
Date: Tue, 27 Nov 2012 13:57:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
Message-ID: <20121127025728.GU32450@dastard>
References: <50ADB27F.8070806@jp.fujitsu.com> <20121122233757.GY2591@dastard>
	<50B32CC1.3020907@jp.fujitsu.com> <50B4198E.7080408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B4198E.7080408@jp.fujitsu.com>
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
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: xfs ML <xfs@oss.sgi.com>

On Tue, Nov 27, 2012 at 10:38:22AM +0900, Satoru Takeuchi wrote:
> Hi Dave and all,
> 
> (2012/11/26 17:48), Satoru Takeuchi wrote:
> > (2012/11/23 8:37), Dave Chinner wrote:
> >> On Thu, Nov 22, 2012 at 02:05:03PM +0900, Satoru Takeuchi wrote:
> >>> Hi,
> >>>
> >>> Current xfs_quota (I pulled xfsprogs today) seems not be able to the users
> >>> managed by LDAP. There is no patch since I'm not good at LDAP and don't know
> >>> the root cause yet ;-(
> >>>
> >>> Step to reproduce(in this case, "sat" is the user managed by LDAP):
> >>> ===============================================================================
> >>> # uname -r
> >>> 3.7.0-rc5
> >>> # mount -o loop,usrquota xfs.img mnt
> >>> # xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
> >>> xfs_quota: invalid user name: sat                                          # denied
> >>> # su sat
> >>> $                                                                          # But this user acutally exists.
> >>> ===============================================================================
> >>>
> >>> The kernel is a bit old, but I suspect this is a userland problem.
> >>
> >> Yes, userland.
> >>
> >> However, xfs_quota is not supposed to know about LDAP, or NIS, or
> >> any other user database. It uses the getpwnam() to convert the user
> >> name to a UID, and that call is failing to find "sat". This is
> >> supposed to work with LDAP (as mentioned in the man page), and if it
> >> isn't it generally means something is broken with your LDAP setup
> >> (/etc/nsswitch.conf not correct?) rather than there being something
> >> wrong with xfs_quota....
> > 
> > Probably this behaivor comes from the difference between the test machine
> > and the build machine which I built the upstream xfsprogs.
> > 
> > I made the following simple program which just calls getpwnam().
> > 
> > ===============================================================================
> > #include <sys/types.h>
> > #include <pwd.h>
> > #include <err.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > 
> > int main(void)
> > {
> >         struct passwd *p;
> >         if ((p = getpwnam("sat")) == NULL)
> >                 err(EXIT_FAILURE, "getpwnam() failed.");
> >         printf("name = %s, id = %d\n", p->pw_name, p->pw_uid);
> >         exit(EXIT_SUCCESS);
> > }
> > ===============================================================================
> > 
> > Here is the result of this problem at the test machine.
> > 
> >  - SUCCEEDED: build at the test machine
> >  - FAILED: built at the build machine
> > 
> > I will build xfsprogs at the test machine and confirm whether this behavior
> > (getpwnam() fails) happens or not again.
> 
> I retried the step to reproduce and encountered the anotehr behavior with the
> newest xfsprogs built at the test machine. In this test, getpwnam()
> worked fine, but quota didn't work for LDAP user.
> 
> test result("testquota" is local user and "sat" is LDAP user here):
> ===============================================================================
> # mount -t xfs -o loop,usrquota xfs.img mnt
> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>                         Blocks              
> User ID      Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> root            0      0      0  00 [------]    # There is no limit yet
> 
> # ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M testquota" /dev/loop0
> # echo $?
> 0
> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>                         Blocks              
> User ID      Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> root            0      0      0  00 [------]
> testquota       0    10M    10M  00 [------]     # limit to local user works fine
> # ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
> # echo $?
> 0
> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>                         Blocks              
> User ID      Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> root            0      0      0  00 [------]
> testquota       0    10M    10M  00 [------]      # limit to LDAP user does not work although xfs_quota returns 0
> ===============================================================================
> 
> I tried it with real partition rather than loopback device, but the result
> was the same.

Can you strace the limit set and report of the ldap user and attach
it? that will tell us directly whether xfs_quota saw the ldap user
or not as we'll see a quotactl() being issued.

Also, instead of using a user name, can you  find out the user ID of
"sat" and use "report -U <uid + 1> -h" so avoid the getpwent lookup
and just report raw quota ids?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
