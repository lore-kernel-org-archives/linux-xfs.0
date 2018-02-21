Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:40261 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937718AbeBUPXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 10:23:44 -0500
Received: by mail-vk0-f42.google.com with SMTP id o17so1150500vke.7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2018 07:23:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
 <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
From: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>
Date: Wed, 21 Feb 2018 16:23:43 +0100
Message-ID: <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>, linux-xfs@vger.kernel.org

> Also, you are running a very old kernel, so, please make sure you try to run a
> newer xfs_repair.

We installed yesterday 3.10.0-693.17.1.el7. I know that CentOS and RedHat
keep old stable kernel version and backport important stuff: do you think that
upgrading to a more recent kernel (4 and above) would be better,
even if less stable?

> Also, this is more a guess than anything. If you see this happening often (even
> after xfs_repair), you might want to double-check your storage stack and see if
> this is not corrupting anything, bad configured storage stacks in virtual
> environments are very usual culprits on filesystem corruption cases.

How could we check our storage stack and see if it is the one to blame?

Thanks, best regards
