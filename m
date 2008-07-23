Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 04:38:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NBcmsc003445
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 04:38:48 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82D43E8B120
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 04:39:58 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245]) by cuda.sgi.com with ESMTP id 7rh7mHBkTMYulwpl for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 04:39:58 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so543148and.75
        for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 04:39:57 -0700 (PDT)
Message-ID: <2d460de70807230439gd058b9csa6a5e0be5bbadc0d@mail.gmail.com>
Date: Wed, 23 Jul 2008 13:39:57 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <4886790C.7040100@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
	 <1216708397.4499.57.camel@verge.scott.net.au>
	 <48858676.3030105@sgi.com>
	 <2d460de70807220351i7c468de5o33fa5aa5e9ddab99@mail.gmail.com>
	 <4886790C.7040100@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Nathan Scott <nscott@aconex.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 02:19, Timothy Shimmin <tes@sgi.com> wrote:


> Okay, my best guess is that you are trying to restore to a non-xfs
> filesystem. This was fixed again in 2.2.26 so that it would work
> on a non-xfs filesystem.
> Otherwise the xfs ioctl will be being called and get back an EINVAL
> as we saw in the strace.

As I cancelled the first working xfsrestore (kept the strace in the
command), re-mkfs-ed and then restored, there is no way to verify,
but I am _sure_ it was a xfs partition. I did not even know you could
restore to non-xfs so I would never try to do that (not that I would use
anything else, anyway ;)


Thanks for looking into this,
Richard
