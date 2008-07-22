Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 23:33:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M6Xa7f029244
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:33:36 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F405419166F0
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:34:44 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id 7huxYvGxZq8WlqyV for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:34:44 -0700 (PDT)
Subject: Re: xfsrestore over ssh?
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <48855B16.4050208@sgi.com>
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 22 Jul 2008 16:33:17 +1000
Message-Id: <1216708397.4499.57.camel@verge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Tue, 2008-07-22 at 13:59 +1000, Timothy Shimmin wrote:
> Richard Hartmann wrote:
> > On Mon, Jul 21, 2008 at 22:33, Bill Kendall <wkendall@sgi.com wrote:
> xfsrestore: unable to construct a file system handle for /mnt/sda3:
> > Das Argument ist ung�ltig
> > xfsrestore: Restore Status: ERROR

"unable to construct a file system handle" - theres only one place
in the restore code that can come from - the path_to_fshandle call.
Is there a 32 bit userspace and 64 bit kernel on the machine where
xfsrestore is running?

Its not clear to me what that code in xfsrestore is trying to do,
you may be able to just comment it out...?!?

cheers.

--
Nathan
