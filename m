Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2F597F4C
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 22:18:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E0B5AC002
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 20:18:13 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id 67v19pOquefgTcOg for
	<xfs@oss.sgi.com>; Wed, 06 Feb 2013 20:18:10 -0800 (PST)
Message-ID: <58846.75.149.17.233.1360210685.squirrel@secure.skymagik.net>
Date: Wed, 6 Feb 2013 23:18:05 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130206235137.GV2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
	<11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
	<20130205213206.GP2667@dastard>
	<55720.75.149.17.233.1360123732.squirrel@secure.skymagik.net>
	<20130206235137.GV2667@dastard>
MIME-Version: 1.0
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
To: david@fromorbit.com
Cc: storm9c1@skymagik.com, xfs@oss.sgi.com

In a previous message, Dave Chinner wrote:
>
> No need - I can tell you the exact commit in the RHEL 5.9 tree that
> caused this regression:
>
> 11ff4073: [md] Fix reboot stall with raid on megaraid_sas controller
>

Dave,

This is excellent news!  At least we have some answers.


> This really only affects root devices,
> and given that XFs is not supported as a root device on RHEL, it
> isn't in the QE test matrix and so the problem was never noticed.

Well I noticed the problem for the sake of the community and reported
it.  :-)

I am happy that we have some Red Hat folks helping out here.

Thank goodness I do my own regression testing before I roll out a
new release.


>
> Feel free to report this all to the RH bugzilla - depending the
> implications of the regression for supported configurations, it may need
> to be fixed in RHEL anyway.

Yes, I could since I work full-time for a company that has an
extensive (7-figure) RHEL deployment, including XFS use licenses.
However, I'll have to go through an I.T. channel since they hold the
accounts.  I'll investigate whether they will let me do this since
they do not use XFS on root.  I would need them to back me up first.

>
> But now you know the problem, you can probably fix it yourself
> rather than have to wait for RHEL/CentOS product cycle updates...
>

Yes, thank you.


> PS: has the fact I quoted a RHEL5.9 commit id triggered a lightbulb
> moment for you yet?  Hint: my other email address is
> dchinner@redhat.com - this XFS community support effort was brought to
> you by Red Hat.

Indeed.  Again, I appreciate your help.  And from Red Hat, Inc. as well.

-- Tom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
