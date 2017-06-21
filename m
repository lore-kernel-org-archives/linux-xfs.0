Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdFUJo5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 05:44:57 -0400
Date: Wed, 21 Jun 2017 11:44:53 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170621094453.emxjwuwm6s5euycp@eorzea.usersys.redhat.com>
References: <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
 <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
 <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
 <dee0d3cc198663bb850ef2576c84d620@assyoma.it>
 <20170620152858.GA3348@bfoster.bfoster>
 <d30c96bafa9d476e1a381a0aaa1bc285@assyoma.it>
 <20170620170208.GC3348@bfoster.bfoster>
 <18cd5d2398dd1187dd1306cdcee508b7@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18cd5d2398dd1187dd1306cdcee508b7@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

Hi,

> > ISTM you might as well write something in userspace that receives a
> > notification from device-mapper and shuts down or remounts the fs if the
> > volume has gone inactive or hit a watermark. I don't think we'd bury
> > anything in XFS that cuts off and then resumes operations based on
> > underlying device errors like that. That sounds like a very crude
> > approach with a narrow use case.
> 
> Absolutely, crude & ugly...
> 
> > 
> > That said, I don't think I'd be opposed to something in XFS that
> > (optionally) shutdown the fs in response to a similar dm notification
> > provided we know with certainty that the underlying device is inactive
> > (and that it can be accomplished relatively cleanly).
> > 
> 
> This would be a much better approach. Any chances to get it implemented?

I think this is doable, I've been talking with Jeff who is working on an
enhanced writeback error notification for a while, which will be useful for
something like that, or some other type of enhanced communication between
dm-thin and filesystems. 

Such improvements have been in discussion, I believe, since I brought up the
subject in Linux Plumbers 2013, but there are a lot of work to be done yet.


Now I'm quoting your previous email:

>This somewhat scares me. From my understanding, a full thin pool will
>eventually bring XFS to an halt (filesystem shutdown) but, from my testing,
>this can take a fair amount of time/failed writes. During this period, any
>writes will be lost without nobody noticing that. In fact, I opened a similar
>thread on the lvm mailing list discussing this very same problem.

By "eventually", you should say metadata errors, filesystems won't shutdown
during data errors.


>Yeah, lvmthin *will* return appropriate warnings during pool filling. However,
>this require active monitoring which, albeit a great idea and "the right thing
>to do (tm)", it adds complexity and can itself fail.

Well, yes, this is what sysadmins are supposed to do, no? Regarding the
complexity, everything we've been discussing here will also add lots of
complexity to the filesystem/block subsystems, and also, they can fail, like for
example, what I wrote before, one application could shutdown the filesystem and
cause it to be inaccessible by other applications which is usually not what
anybody wants, also, because you don't want to remove the possibility of the
applications to still read their data if such corner case happens (physical
space full, virtual space still available).

>In recent enought
>(experimental) versions, lvmthin can be instructed to execute specific actions
>when data allocation is higher than some threshold, which somewhat addresses
>my concerns at the block layer.

That's good, I didn't know about that, there is a good way to manage such stuff,
like, telling lvm to remount a FS as read-only, after a threshold.

At the end though, I feel that what you are looking for, is a way that the
filesystem/block layer can remove the monitoring job from the sysadmin. Yes,
there are many things that can be done better, yes, there will be lots of
improvements in this area in the near future, but this still won't remove the
responsibility of the sysadmins to monitor their systems and ensure they take
the required actions when needed.

Thin provisioning isn't a new technology, it is in the market for ages,
overprovisioning indeed, and these same problems were expected to happen AFAIK,
and the sysadmin, expected to take the appropriate actions.

It's been too long since I worked with dedicated storages using thin
provisioning, so I don't remember how a dedicated hardware is expected to behave
when the physical space is full, or even if there is any standard to follow on
this situation, but I *think*, the same behavior is expected, data writes
failing, and nobody caring about it other than the userspace application, and
the filesystem not taking any action until some metadata write fail.

But I still think that, if you don't want to risk such situation, the
applications should be doing their job well, the sysadmin monitoring the systems
as required, or not using overprovisioning at all.

But anyway, thanks for such discussion, it brought nice ideas of future
improvements.

Cheers

--
Carlos
