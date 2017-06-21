Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:38353 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdFUKjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 06:39:09 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 5928FD8A011180EC for linux-xfs@vger.kernel.org; Wed, 21 Jun 2017 12:39:07 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Jun 2017 12:39:06 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170621094453.emxjwuwm6s5euycp@eorzea.usersys.redhat.com>
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
 <20170621094453.emxjwuwm6s5euycp@eorzea.usersys.redhat.com>
Message-ID: <8be1535ef59f423d91f7d387127b924f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Il 21-06-2017 11:44 Carlos Maiolino ha scritto:
> 
> I think this is doable, I've been talking with Jeff who is working on 
> an
> enhanced writeback error notification for a while, which will be useful 
> for
> something like that, or some other type of enhanced communication 
> between
> dm-thin and filesystems.
> 
> Such improvements have been in discussion, I believe, since I brought 
> up the
> subject in Linux Plumbers 2013, but there are a lot of work to be done 
> yet.
> 

Hi Carlos, this would be great. Glad to hear it is in 
progress/discussion.

> 
> At the end though, I feel that what you are looking for, is a way that 
> the
> filesystem/block layer can remove the monitoring job from the sysadmin.
> 

No, this is a misunderstanding due to bad communication on my part, 
sorry :)

I don't want to remove part of my job/responsability; rather, as I 
always prepare for the worse (ie: my monitoring failing *while* users 
fill the thin pool), I would like to have a "fail-safe" backup plan. The 
"gold standard" would for thin pools to react as a full filesystem - ie 
you (and the application) get a ENOSPC or "No space available" message.

This would mimic what happens on ZFS world when using sparse volume. 
 From its man page:
"A 'sparse volume' is a volume where the reservation is less then the 
volume size. Consequently, writes to a sparse volume can fail with 
ENOSPC when the pool is low on space."

> 
> Yes,
> there are many things that can be done better, yes, there will be lots 
> of
> improvements in this area in the near future, but this still won't 
> remove the
> responsibility of the sysadmins to monitor their systems and ensure 
> they take
> the required actions when needed.
> 

I agree, absolutely.

> 
> Thin provisioning isn't a new technology, it is in the market for ages,
> overprovisioning indeed, and these same problems were expected to 
> happen AFAIK,
> and the sysadmin, expected to take the appropriate actions.
> 
> It's been too long since I worked with dedicated storages using thin
> provisioning, so I don't remember how a dedicated hardware is expected 
> to behave
> when the physical space is full, or even if there is any standard to 
> follow on
> this situation, but I *think*, the same behavior is expected, data 
> writes
> failing, and nobody caring about it other than the userspace 
> application, and
> the filesystem not taking any action until some metadata write fail.
> 
> But I still think that, if you don't want to risk such situation, the
> applications should be doing their job well, the sysadmin monitoring 
> the systems
> as required, or not using overprovisioning at all.
> 

Overprovision by itself is not my main point: after all, if I blatanly 
lie claiming to have space that I don't really have, some problem can be 
expected ;)

Rather, my main concern is that when using snapshots, even a filesystem 
smaller than thin pool can encounter a "no more data space available", 
simply due to the additional CoW tracking needed to keep the snapshot 
"alive". But hey - this is by itself a form of overprovisioning, after 
all...

> 
> But anyway, thanks for such discussion, it brought nice ideas of future
> improvements.
> 

Thank you (and others) for all the hard work!

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
