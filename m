Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAMNZn3J260487 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 17:35:49 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qKIjTqBvHRkG9sEt for <xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 15:37:59 -0800 (PST)
Date: Fri, 23 Nov 2012 10:37:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
Message-ID: <20121122233757.GY2591@dastard>
References: <50ADB27F.8070806@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50ADB27F.8070806@jp.fujitsu.com>
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

On Thu, Nov 22, 2012 at 02:05:03PM +0900, Satoru Takeuchi wrote:
> Hi,
> 
> Current xfs_quota (I pulled xfsprogs today) seems not be able to the users
> managed by LDAP. There is no patch since I'm not good at LDAP and don't know
> the root cause yet ;-(
> 
> Step to reproduce(in this case, "sat" is the user managed by LDAP):
> ===============================================================================
> # uname -r
> 3.7.0-rc5
> # mount -o loop,usrquota xfs.img mnt
> # xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
> xfs_quota: invalid user name: sat                                          # denied
> # su sat
> $                                                                          # But this user acutally exists.
> ===============================================================================
> 
> The kernel is a bit old, but I suspect this is a userland problem.

Yes, userland.

However, xfs_quota is not supposed to know about LDAP, or NIS, or
any other user database. It uses the getpwnam() to convert the user
name to a UID, and that call is failing to find "sat". This is
supposed to work with LDAP (as mentioned in the man page), and if it
isn't it generally means something is broken with your LDAP setup
(/etc/nsswitch.conf not correct?) rather than there being something
wrong with xfs_quota....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
