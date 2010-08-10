Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7ANIksX108736 for <xfs@oss.sgi.com>; Tue, 10 Aug 2010 18:18:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EA734A91D7
	for <xfs@oss.sgi.com>; Tue, 10 Aug 2010 16:19:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	2TDE9sv9RlpA9Yu4 for <xfs@oss.sgi.com>;
	Tue, 10 Aug 2010 16:19:09 -0700 (PDT)
Date: Wed, 11 Aug 2010 09:19:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix NIS detection damage
Message-ID: <20100810231905.GJ26402@dastard>
References: <1281057519-24730-1-git-send-email-david@fromorbit.com>
	<F57F2AD357626644AF76410876025D75529750@CGYEX705.encana.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F57F2AD357626644AF76410876025D75529750@CGYEX705.encana.com>
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
To: "Kinzel, David" <David.Kinzel@encana.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 10, 2010 at 07:44:10AM -0600, Kinzel, David wrote:
> Dave Chinner <dchinner@redhat.com> said,
> >
> >NIS detection wasn't tested on machines without NIS enabled, 
> >so many tests are
> >failing on non-NIS machines. the _yp_active function has no 
> >specific return
> >value so always evaluates as 0 (active) and the "_cat_passwd" 
> >function is
> >called from within an awk script which is not valid as the 
> >shell may run with a
> >sanitised environment. Hence the functions do not need 
> >specific export calls,
> >either, as unsanitised subshells will automatically inherit 
> >the parent's
> >environment.
> >
> 
> Is there any reason why getent passwd/group cannot be used for these, as
> it would get local and nss defined accounts? This would add support for
> people using LDAP as well.

If you want your test box to use this stuff, then feel free to
submit patches that support this.

In general, though, I think that running anything other than a
single user account on a filesystem test box is not necessary - you
don't want random users to be able to log in to the machine you are
running potentially destructive tests on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
