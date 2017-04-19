Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764195AbdDSOUm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 10:20:42 -0400
Date: Wed, 19 Apr 2017 16:20:38 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
Message-ID: <20170419142038.n5qj5cxb67dvmifu@eorzea.usersys.redhat.com>
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, mw@dermichi.com

On Wed, Apr 19, 2017 at 04:04:46PM +0200, Carlos Maiolino wrote:
> If I am not blind, the task currently owning the cpu isn't listed there, which I
> suppose to be already running.
> 
> Next time you hit it, could you please paste the stack trace of the task owning
> the cpu? Which I suppose to be xfsaild according to your report.
> 
> A simple `cat /proc/<pid>/stack` is probably enough
> 
> thanks
> 

Btw, I'm not very good at xfs journaling code, but I wonder by the stack traces
you provided, if you don't have a too small journal, which, with your workload,
it might be getting to flush the logs too many times, making the disk too busy
and slowing down the rest of the IO.

Another folks with more knowledge of the journaling code might be able to
confirm or not this, but having too many tasks waiting in:

xlog_grant_head_wait()

actually made me wonder if your journal isn't too small for the FS size and the
current workload you have.

Again, this is just a guess, but maybe somebody else can put one more pair of
eyes on it.

cheers

-- 
Carlos
