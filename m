Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42K0AnJ246532 for <xfs@oss.sgi.com>; Mon, 2 May 2011 15:00:10 -0500
Subject: Re: [PATCH] xfsprogs - resolve Debian readline build issue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <360436721.31453.1304032530041.JavaMail.root@acxmail-au2.aconex.com>
References: <360436721.31453.1304032530041.JavaMail.root@acxmail-au2.aconex.com>
Date: Mon, 2 May 2011 15:03:43 -0500
Message-ID: <1304366623.3077.44.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Nathan Scott <nathans@aconex.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-04-29 at 09:15 +1000, Nathan Scott wrote:
> Address the recently reported build issue with libreadline5/6, via
> the gplv2 route.  Since this appears to be a relatively recent pkg,
> I made its use conditional so the deb build continues to work for
> everyone not running a bleeding edge distro.  Works For Me (tm).
> 
> This addresses Debian bug 553875: libreadline5-dev removal pending

As far as I'm concerned, this looks fine.

I understand the issue, but I'm not really
familiar with the Debian build/dependency
system at work here, so I'm not really a
very qualified reviewer.  But if you're
comfortable with it and get nobody else to
review it, you are welcome to use my sign-off.

Signed-off-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Nathan Scott <nathans@debian.org>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
