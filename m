Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:35:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m764ZBis020859
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:35:12 -0700
Received: from mars.unix.geek.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A416635BE23
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 21:36:25 -0700 (PDT)
Received: from mars.unix.geek.nz ([116.90.133.99]) by cuda.sgi.com with ESMTP id yBFWFKohUfS4rcSY for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 21:36:25 -0700 (PDT)
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
In-Reply-To: <510965.21937.qm@web34502.mail.mud.yahoo.com>
References: <510965.21937.qm@web34502.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 16:36:35 +1200
Message-Id: <1217997395.3456.1.camel@luna.unix.geek.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: MusicMan529@yahoo.com
Cc: Karel Zak <kzak@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Tue, 2008-08-05 at 21:33 -0700, gus3 wrote:
> --- On Tue, 8/5/08, Dave Chinner <david@fromorbit.com> wrote:
> 
> > So what is the correct behaviour? Should the filesystem
> > *silently
> > ignore* unchangable options in the remount command, or
> > should it
> > fail the remount and warn the user that certain options are
> > not
> > allowed in remount?
> 
> How about a middle ground: ignore, but not silently? Report an error, or send it to the syslog, or both, but ultimately ignore unchangeable options, change what can be changed, and give the user/admin as much as possible.

I think the idea is to behave the same as other FS do, not to innovate.

> This can be particularly pertinent for XFS root. If it's mounted RO at first, it may (will?) need to become RW at some later point. Failing the remount could result in a system that requires a rescue CD (or lots of headaches for remote administration).

FWIW, your root filesystem does not need to be rw. I keep mine ro nearly
all the time on my laptop, only mounting rw if I need to install
software that puts files outside /usr or if I need to modify a config
file in /etc.

-jasper
