Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933527AbdC3N7h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 09:59:37 -0400
Date: Thu, 30 Mar 2017 15:59:34 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170330135934.GH1972@dhcp22.suse.cz>
References: <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
 <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
 <20170329111650.GI27994@dhcp22.suse.cz>
 <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz>
 <CAOi1vP-MV0dX_vogf=+TTqaB8xzDEq2BZQYBM6Uf1quy_MYEQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-MV0dX_vogf=+TTqaB8xzDEq2BZQYBM6Uf1quy_MYEQw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu 30-03-17 15:53:35, Ilya Dryomov wrote:
> On Thu, Mar 30, 2017 at 8:25 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Wed 29-03-17 16:25:18, Ilya Dryomov wrote:
[...]
> >> are you saying it's OK for a block
> >> device to recurse back into the filesystem when doing I/O, potentially
> >> generating more I/O?
> >
> > No, block device has to make a forward progress guarantee when
> > allocating and so use mempools or other means to achieve the same.
> 
> OK, let me put this differently.  Do you agree that a block device
> cannot make _any_ kind of progress guarantee if it does a GFP_KERNEL
> allocation in the I/O path?

yes that is correct. And the same is correct for GFP_NOIO allocations as
well.
-- 
Michal Hocko
SUSE Labs
