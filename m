Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B14637F53
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 09:18:36 -0600 (CST)
Date: Tue, 29 Jan 2013 09:18:33 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130129151833.GF27055@sgi.com>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

Hey Tom,

On Mon, Jan 28, 2013 at 06:28:18PM -0500, Tom wrote:
> I have been using XFS for many years, starting on IRIX and then on RedHat
> 7.2, and now on CentOS/RHEL and Ubuntu.  Last time I posted to this
> mailing list was 12 years ago.  :-)  I've been a happy customer!

I'm glad to hear it!  ;)

> Much more detail is available here (CentOS bug id 0006217) including steps
> to reproduce the problem.  Also testing with and without md raid.
> http://bugs.centos.org/view.php?id=6217
> 
> The one thing I haven't provided is a traceback.  I can provide that if it
> would be helpful.

I took a brief look at your report.  I think a traceback would be helpful.  

echo t > /proc/sysrq-trigger should do the trick.  You're in the middle of
unmount so you might need to go serial console to capture the output.  Your
report metions freeze/thaw.  This is an area where we've had deadlocks in the
past, so I wouldn't be surprised if that is what you're hitting.  We'll have to
see.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
