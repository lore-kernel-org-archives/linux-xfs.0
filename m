Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:32:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m764Wc04020419
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:32:38 -0700
Received: from web34502.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 59E6E362848
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 21:33:52 -0700 (PDT)
Received: from web34502.mail.mud.yahoo.com (web34502.mail.mud.yahoo.com [66.163.178.168]) by cuda.sgi.com with SMTP id XJSVaaALqU54sPWi for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 21:33:52 -0700 (PDT)
Date: Tue, 5 Aug 2008 21:33:52 -0700 (PDT)
From: gus3 <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
In-Reply-To: <20080805233956.GI21635@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <510965.21937.qm@web34502.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Karel Zak <kzak@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Jasper Bryant-Greene <jasper@amiton.co.nz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

--- On Tue, 8/5/08, Dave Chinner <david@fromorbit.com> wrote:

> So what is the correct behaviour? Should the filesystem
> *silently
> ignore* unchangable options in the remount command, or
> should it
> fail the remount and warn the user that certain options are
> not
> allowed in remount?

How about a middle ground: ignore, but not silently? Report an error, or send it to the syslog, or both, but ultimately ignore unchangeable options, change what can be changed, and give the user/admin as much as possible.

This can be particularly pertinent for XFS root. If it's mounted RO at first, it may (will?) need to become RW at some later point. Failing the remount could result in a system that requires a rescue CD (or lots of headaches for remote administration).
