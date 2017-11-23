Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752007AbdKWJ25 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 04:28:57 -0500
Date: Thu, 23 Nov 2017 17:28:55 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 1/3] fstests: filter mount error message for EUCLEAN
 and ESTALE
Message-ID: <20171123092855.GW2749@eguan.usersys.redhat.com>
References: <20171114123310.25286-1-eguan@redhat.com>
 <20171114123310.25286-2-eguan@redhat.com>
 <CAOQ4uxig6TeT62EkHsXFU-2Phstsyd3xiRE5WKmG0hkWu5r5Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxig6TeT62EkHsXFU-2Phstsyd3xiRE5WKmG0hkWu5r5Xw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 23, 2017 at 11:04:57AM +0200, Amir Goldstein wrote:
> On Tue, Nov 14, 2017 at 2:33 PM, Eryu Guan <eguan@redhat.com> wrote:
> > util-linux commit ea848180dd34 ("libmount: add
> > mnt_context_get_excode()") since v2.30 changed the error message on
> > EUCLEAN and ESTALE again (and maybe other errno too):
> >
> >  - mount: <device> on <mountpoint> failed: Structure needs cleaning
> >  + mount: <mountpoint>: mount(2) system call failed: Structure needs cleaning.
> >
> > and it causes xfs/005, overlay/037 to fail (and probably xfs/333 too,
> > but it's always _notrun for now).
> >
> > So let's filter out the changing parts and keep the error message
> > simple.
> >
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  common/filter         | 23 +++++++++++++++++++++++
> >  tests/overlay/037     |  4 ++--
> >  tests/overlay/037.out |  4 ++--
> >  tests/xfs/005         |  7 +------
> >  tests/xfs/333         |  2 +-
> >  tests/xfs/333.out     |  2 +-
> >  6 files changed, 30 insertions(+), 12 deletions(-)
> >
> > diff --git a/common/filter b/common/filter
> > index 0cb458b0051f..d1bb94818e3d 100644
> > --- a/common/filter
> > +++ b/common/filter
> > @@ -390,6 +390,13 @@ _filter_fstrim()
> >         egrep -o "[0-9]+ bytes" | $AWK_PROG '{print $1}'
> >  }
> >
> > +# Remove the ending dot appended to mount error message, util-linux 2.30
> > +# starts to do so.
> > +_filter_ending_dot()
> > +{
> > +       sed -e "s/\.$//"
> > +}
> > +
> >  # Older mount output referred to "block device" when mounting RO devices
> >  # It's gone in newer versions
> >  _filter_ro_mount() {
> > @@ -397,6 +404,22 @@ _filter_ro_mount() {
> >             -e "s/mount: cannot mount block device/mount: cannot mount/g"
> >  }
> >
> > +# Filter a failed mount output, util-linux changed the message several times.
> > +#
> > +# prior to v2.21:
> > +# mount: Structure needs cleaning
> 
> So the mentioned tests are currently also broken with util-linux < v2.21?
> Maybe mention this is commit message.

Yeah, I think so, just v2.21 is pretty old, the affected tests are
usually _notrun on such old distributions that ship util-linux < v2.21,
e.g. RHEL6, so no one noticed it. I'll mention it in commit log.

> 
> > +# v2.21 to v2.29:
> > +# mount: mount <device> on <mountpoint> failed: Structure needs cleaning
> > +# v2.30 and later:
> > +# mount: <mountpoint>: mount(2) system call failed: Structure needs cleaning.
> > +#
> 
> Please document filtered format.

OK.

Thanks,
Eryu
