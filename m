Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752452AbdK1HwW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 02:52:22 -0500
Date: Tue, 28 Nov 2017 15:52:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4] fstests: filter readonly mount error messages
Message-ID: <20171128075215.GG2749@eguan.usersys.redhat.com>
References: <20171123111031.6550-4-eguan@redhat.com>
 <20171124050144.23549-1-eguan@redhat.com>
 <CAOQ4uxgxRxByGHhePr3b4H+W1zEGxUX6Emj9PBzZpEKEs2iHog@mail.gmail.com>
 <20171124103814.gfvxw3ethkcvm6xa@ws.net.home>
 <CAOQ4uxjbnrgJG3PLVV6TvAS-Fjgskms_jWc5-b4DVmLhbVUdFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjbnrgJG3PLVV6TvAS-Fjgskms_jWc5-b4DVmLhbVUdFg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Karel Zak <kzak@redhat.com>, fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Nov 26, 2017 at 10:56:40AM +0200, Amir Goldstein wrote:
> On Fri, Nov 24, 2017 at 12:38 PM, Karel Zak <kzak@redhat.com> wrote:
> > On Fri, Nov 24, 2017 at 10:04:33AM +0200, Amir Goldstein wrote:
> >> [cc: Karel Zak]
> >>
> >> On Fri, Nov 24, 2017 at 7:01 AM, Eryu Guan <eguan@redhat.com> wrote:
> >> > util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
> >> > write-protected devices") changed the error message on read-only
> >> > block device, and in the failure case printed one line message
> >> > instead of two (for details please see comments in common/filter),
> >> > and this change broke generic/050 and overlay/035.
> >> >
> >> > Fix it by adding more filter rules to _filter_ro_mount and updating
> >> > associated .out files to unify the output from both old and new
> >> > util-linux versions.
> >> >
> >> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> >> > ---
> >> > v4 (also passed with both old & new util-linux):
> >> > - add more comments to explain the output differences between util-linux
> >> >   versions
> >> > - print out message directly instead of using perl variables
> >> > - add word "device" to failed ro mount message
> >>
> >>
> >> Eryu,
> >>
> >> This looks good and you can take it as an ACK on the series.
> >>
> >> I've CC'ed Karel, so maybe he thinks about us fstests guys before making
> >> these sort of changes again...
> >
> > Frankly, we have never promised that things like warning messages (or
> > another messages) are stable interface. It's fragile to depend on this
> > stuff...
> >
> 
> I know. No complains. Just wanted to inform you of the downstream
> ripples.

Agreed.

> 
> >> Thinking out loud, does xfstest even need to use mount program from
> >> util-linux? Do we ever need anything other than the bare libc mount(2)?
> >> We need it for -o loop, but that is the exception to the rule.
> >
> > Well, I don't think that create a parallel universe is the best
> > solution.
> >
> 
> I agree. However, xfstest uses 'mount' is a very particular way:
> - User has to provide both block device and mount point
> - xfstests already checks that those block device and mount point
>   are not in use in /proc/mounts *before* calling 'mount'

The problem is it's not a mount-only issue, outputs from other
util-linux commands and commands from coreutils have been changing over
time too, we really can't "fork" & maintain a local wrapper all the
changing pieces. As long as fstests still go with the 'match golden
image' path, it's not likely to avoid such problems completely. OTOH,
the output changes are not so frequent (such a change per 3-4 years
maybe?), I think the maintain burden of filters is much less than
maintaining local wrappers of such commands.

And commands like mount are fs-related, it's better to get them some
(indirect) test coverage in fstests too, as we test other fs-specific
userspace tools like xfsprogs, e2fsprogs etc.

Thanks,
Eryu
