Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33679 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753189AbeBVKWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 05:22:54 -0500
Received: by mail-wr0-f174.google.com with SMTP id s5so10000771wra.0
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 02:22:53 -0800 (PST)
Date: Thu, 22 Feb 2018 11:22:49 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Message-ID: <20180222102249.kpaqec37ejrrmown@odin.usersys.redhat.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
 <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
 <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
 <20180221175540.618eda28@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180221175540.618eda28@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>, linux-xfs@vger.kernel.org

On Wed, Feb 21, 2018 at 05:55:40PM +0100, Emmanuel Florac wrote:
> Le Wed, 21 Feb 2018 16:23:43 +0100
> Andrea Mazzocchi <mazzocchiandrea24@gmail.com> écrivait:
> 
> > > Also, you are running a very old kernel, so, please make sure you
> > > try to run a newer xfs_repair.  
> > 
> > We installed yesterday 3.10.0-693.17.1.el7. I know that CentOS and
> > RedHat keep old stable kernel version and backport important stuff:
> > do you think that upgrading to a more recent kernel (4 and above)
> > would be better, even if less stable?
> 

Yes, there are several things backported over Enterprise distributed kernels,
but, hte upstream community can't offer support on that, once we can't easily
keep track of what has been backported or not, so, that's why we usually tell
people reporting bugs here, using an enterprise distributed kernel, to report
the bug directly to their support representatives.

> Actually the 3.10 from CentOS 7 has a lot of things backported, for
> instance it supports XFS with crc metadata which was introduced in 3.16.
> 
> However in the recent year I've never met any reason NOT to use a
> recent LTS kernel (like a 4.9 or 4.14). I don't really understand why
> RedHat sticks to these absurdly old kernel releases as a basis (and
> taking the pain of backporting stuff for years and years).

There are several reasons for that, and it is not only Red Hat who does it. One
of the reasons is ABI stability.

> 
> > > Also, this is more a guess than anything. If you see this happening
> > > often (even after xfs_repair), you might want to double-check your
> > > storage stack and see if this is not corrupting anything, bad
> > > configured storage stacks in virtual environments are very usual
> > > culprits on filesystem corruption cases.  
> > 
> > How could we check our storage stack and see if it is the one to
> > blame?
> 


> Hard to say, what KVM disk format are you using? Raw, qcow2, LVM
> volumes? If these are files (raw or qcow2), what kind of filesystem and
> hardware stack are they living on? Are there any error on the hosting
> system?
> 
> At tne VM level, do you see any IO error? Are you using the virtio disk
> driver or something else? 
>

^ Good start, also, what kind of caching policies is a good information,
particularly, using any cache policies for VM disks other than 'None', is a good
way to start having problems per my experience.

Also:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Don't forget xfs_repair :)


> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------



-- 
Carlos
