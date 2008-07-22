Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 03:43:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6MAhph7023877
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:43:51 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59604312C62
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:45:00 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.243]) by cuda.sgi.com with ESMTP id wppSLlCTDWFaHCHs for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:45:00 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so456283and.75
        for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:45:00 -0700 (PDT)
Message-ID: <2d460de70807220345i44939565oc703222747705694@mail.gmail.com>
Date: Tue, 22 Jul 2008 12:45:00 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <1216708397.4499.57.camel@verge.scott.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
	 <1216708397.4499.57.camel@verge.scott.net.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Timothy Shimmin <tes@sgi.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 08:33, Nathan Scott <nscott@aconex.com> wrote:

> "unable to construct a file system handle" - theres only one place
> in the restore code that can come from - the path_to_fshandle call.
> Is there a 32 bit userspace and 64 bit kernel on the machine where
> xfsrestore is running?

The dump was created on a 32 bit system, is stored on a 32 bit
system and I am trying to restore on (the first) 32 bit system, again.

Both the backed-up & the storage system have Debian's 2.2.48-1
version of xfsdump.


> Its not clear to me what that code in xfsrestore is trying to do,
> you may be able to just comment it out...?!?

I would like to avoid hacks like this if possible at all. That is asking
for trouble, especially when the root file system is concerned :/



Richard
