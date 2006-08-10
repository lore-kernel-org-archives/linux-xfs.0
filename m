Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 17:14:10 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7B0DbDW004793
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 17:13:37 -0700
Received: by py-out-1112.google.com with SMTP id c39so1077608pyd
        for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 17:13:09 -0700 (PDT)
Message-ID: <6bffcb0e0608101646k4f412e7ave59bc20a038f51fe@mail.gmail.com>
Date: Fri, 11 Aug 2006 01:46:08 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.18-rc4+ext4 oops while mounting xfs
In-Reply-To: <20060811091659.E2596458@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0608100805k42357f5bxa73189c38fb926df@mail.gmail.com>
	 <6bffcb0e0608101608j4fc41945of65173793703a065@mail.gmail.com>
	 <20060811091659.E2596458@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>

Hi Nathan,

On 11/08/06, Nathan Scott <nathans@sgi.com> wrote:
> On Fri, Aug 11, 2006 at 01:08:44AM +0200, Michal Piotrowski wrote:
> > On 10/08/06, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > ...
> > > Aug 10 16:50:53 ltg01-fedora kernel: EFLAGS: 00010002   (2.6.18-rc4 #119)
> > > Aug 10 16:50:53 ltg01-fedora kernel: EIP is at __lock_acquire+0x2ca/0x9b6
> > > Aug 10 16:50:53 ltg01-fedora kernel: Call Trace:
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c0135ccb>]
> > > lock_release_non_nested+0xc5/0x11d
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c0136026>] lock_release+0x12f/0x159
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c02d579e>]
> > > __mutex_unlock_slowpath+0x99/0xff
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c02d580c>] mutex_unlock+0x8/0xa
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c016d3b2>]
> > > generic_shutdown_super+0xbb/0x113
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c016d42a>] kill_block_super+0x20/0x32
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c016d4ea>] deactivate_super+0x5d/0x6f
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c0180336>] mntput_no_expire+0x42/0x72
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c0173147>]
> > > path_release_on_umount+0x15/0x18
> > > Aug 10 16:50:53 ltg01-fedora kernel:  [<c018147c>] sys_umount+0x1e7/0x21b
> > ...
> > It's fixed in latest 2.6.18-rc4-git*.
>
> We've not changed anything mount related in current git* kernels,
> are you sure its fixed (did it happen every time)?  I'm not sure
> how its XFS related too ... looks possibly lockdep related (from
> *non_nested back there?)

You are absolutely right. Oops appears only with CONFIG_DEBUG_LOCKDEP enabled.

> and perhaps an issue with sb->s_lock in
> the kill_block_super unlock_super call?
>
> cheers.
>
> --
> Nathan
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/wiki/)
