Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 19:02:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D22Y4p000964
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 19:02:36 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA27880; Thu, 13 Sep 2007 12:02:32 +1000
Message-ID: <46E89A38.4000300@sgi.com>
Date: Thu, 13 Sep 2007 12:02:32 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: compile fails
References: <64de4d610709121638s6a8a92c4qec2c4b70de9d955e@mail.gmail.com>
In-Reply-To: <64de4d610709121638s6a8a92c4qec2c4b70de9d955e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Mullican <kevin@mullican.com>
Cc: xfs@oss.sgi.com

Kevin Mullican wrote:
> Greetings,
> 
> I am attempting to build the XFS kernel, but the compile is failing. I
> downloaded the source from the CVS repository today, and I generated a
> relatively generic .config. I am using gcc-3.2.3-52, libgcc-3.2.3-52,
> and glibc-2.3.2-95.33. During the kernel compile, I am getting the
> following errors:
> 
> make -C xfs
> make[2]: Entering directory `/usr/src/linux-2.4-xfs/fs/xfs'

Hi Kevin,

The linux-2.4 build hasn't been actively maintained in a while.
We have been talking about removing it from cvs because of this.

> xfs_vfs.h:46: syntax error before "bhv_head_t"
 > xfs_vfs.h:46: warning: no semicolon at end of struct or union
 > xfs_vfs.h:55: syntax error before '}' token
 > xfs_vfs.h:55: warning: type defaults to `int' in declaration of `bhv_vfs_t'

These are due to changes made fairly recently.
You may have more luck updating a tree from around the 2007/08/20.

But even without the recent chagnes I'd be suprised if it was building.

Don
