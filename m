Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43A4mdw009881 for <xfs@oss.sgi.com>; Tue, 3 May 2011 05:04:48 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F11C711C712E
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 03:08:24 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.166.49.3]) by
	cuda.sgi.com with ESMTP id eF91KrUA23M45VJr for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 03:08:24 -0700 (PDT)
Date: Tue, 3 May 2011 20:08:21 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <408615549.38509.1304417301357.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <1304366623.3077.44.camel@doink>
Subject: Re: [PATCH] xfsprogs - resolve Debian readline build issue
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com



----- Original Message -----
> On Fri, 2011-04-29 at 09:15 +1000, Nathan Scott wrote:
> > Address the recently reported build issue with libreadline5/6, via
> > the gplv2 route. Since this appears to be a relatively recent pkg,
> > I made its use conditional so the deb build continues to work for
> > everyone not running a bleeding edge distro. Works For Me (tm).
> >
> > This addresses Debian bug 553875: libreadline5-dev removal pending
> 
> As far as I'm concerned, this looks fine.
> 
> I understand the issue, but I'm not really
> familiar with the Debian build/dependency
> system at work here, so I'm not really a
> very qualified reviewer. But if you're
> comfortable with it and get nobody else to
> review it, you are welcome to use my sign-off.

Thanks!  I'll give it a couple more days then commit it if noone else
has further input.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
