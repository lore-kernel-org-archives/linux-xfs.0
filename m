Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbdKWOJ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 09:09:29 -0500
Date: Thu, 23 Nov 2017 22:09:27 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 3/3] fstests: filter readonly mount error messages
Message-ID: <20171123140927.GX2749@eguan.usersys.redhat.com>
References: <20171123111031.6550-1-eguan@redhat.com>
 <20171123111031.6550-4-eguan@redhat.com>
 <CAOQ4uxjg-SYNidgzwpZWxKCWxqzrDEj6TvRK1AWmYQr6fcrPSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjg-SYNidgzwpZWxKCWxqzrDEj6TvRK1AWmYQr6fcrPSQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 23, 2017 at 03:28:58PM +0200, Amir Goldstein wrote:
> On Thu, Nov 23, 2017 at 1:10 PM, Eryu Guan <eguan@redhat.com> wrote:
> > util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
> > write-protected devices") changed the error message on read-only
> > block device, and in the failure case printed one line message
> > instead of two (for details please see comments in common/filter),
> > and this change broke generic/050 and overlay/035.
> >
> > Fix it by adding more filter rules to _filter_ro_mount and updating
> > associated .out files to unify the output from both old and new
> > util-linux versions.
> >
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > v3:
> > - document the filtered format in comments
> > - remove legacy sed filter, the perl filter covers the legacy case well
> > - filter out $SCRATCH_DEV/MNT too and use a consistent output
> > - remove the new filter_mount helper in overlay/035
> >
> >  common/filter         | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  tests/generic/050     |  8 ++++----
> >  tests/generic/050.out |  8 ++++----
> >  tests/overlay/035     |  4 ++--
> >  tests/overlay/035.out |  4 ++--
> >  5 files changed, 58 insertions(+), 14 deletions(-)
> >
> > diff --git a/common/filter b/common/filter
> > index a212c09aa138..6140b331017f 100644
> > --- a/common/filter
> > +++ b/common/filter
> > @@ -399,9 +399,53 @@ _filter_ending_dot()
> >
> >  # Older mount output referred to "block device" when mounting RO devices
> >  # It's gone in newer versions
> > +#
> > +# And util-linux v2.30 changed the output again, e.g.
> > +# for a successful ro mount:
> > +# prior to v2.30:  mount: <device> is write-protected, mounting read-only
> > +# v2.30 and later: mount: <mountpoint>: WARNING: device write-protected, mounted read-only.
> > +#
> > +# a failed ro mount:
> > +# prior to v2.30:
> > +# mount: <device> is write-protected, mounting read-only
> > +# mount: cannot mount <device> read-only
> > +# v2.30 and later:
> > +# mount: <mountpoint>: cannot mount <device> read-only.
> > +#
> > +# a failed rw remount:
> > +# prior to v2.30:  mount: cannot remount <device> read-write, is write-protected
> > +# v2.30 and later: mount: <mountpoint>: cannot remount <device> read-write, is write-protected.
> > +#
> > +# Now use _filter_ro_mount to unify all these differences across old & new
> > +# util-linux versions. So the filtered format would be:
> > +#
> > +# successful ro mount:
> > +# mount: device write-protected, mounting read-only
> > +#
> > +# failed ro mount:
> > +# mount: device write-protected, mounting read-only
> > +# mount: cannot mount read-only
> > +#
> > +# failed rw remount:
> > +# mount: cannot remount device read-write, is write-protected
> >  _filter_ro_mount() {
> > -       sed -e "s/mount: block device/mount:/g" \
> > -           -e "s/mount: cannot mount block device/mount: cannot mount/g"
> > +       perl -ne '
> > +       if (/write-protected, mount.*read-only/) {
> > +               # successful ro mount
> > +               print "mount: device write-protected, mounting read-only\n";
> > +       } elsif (/mount: .*: cannot mount.*read-only/) {
> > +               # filter v2.30 format failed ro mount
> > +               print "mount: device write-protected, mounting read-only\n";
> 
> Leftover copy&paste line?

No, that's intentional. Prior to v2.30, mount printed two-line error
messages, as described in the comments above:

# a failed ro mount:
# prior to v2.30:
# mount: <device> is write-protected, mounting read-only
# mount: cannot mount <device> read-only
# v2.30 and later:
# mount: <mountpoint>: cannot mount <device> read-only.

So this is matching the one-line v2.30 format and converting it to
two-line messages.

> 
> > +               print "mount: cannot mount read-only\n";
> > +       } elsif (/(^mount: cannot mount) .* (read-only$)/) {
> > +               # filter prior to v2.30 format failed ro mount
> > +               print "$1 $2\n";
> 
> Maybe I am missing something, but why are you printing arguments
> when you know what the expected output should be?

No special reason, perhaps that was easier to type :) I'll print the
expected output directly, and change the output to

mount: cannot mount device read-only

as you suggested.

> Also, in what is that match expression different from the v2.30 format?

v2.30 failed ro mount output is a single-line message, with the
"<mountpoint> :" string in between "mount: " and "cannot mount", so I'm
explicitly matching the colon with ".*:".

prior to v2.30, failed ro mount output is two-line message, with the
first line identical to the "successful ro mount" case (maybe I should
have mentioned it too along with the "successful ro mount" comment), so
I'm matching the second line here.

> Can't you merge both cases to use the more generic match expr
> (without .*:) and print the expected result?

Seems no, I need to distinguish the two cases and decide if I should
print out single-line or two-line messages.

It's a bit complicated, maybe I missed some obvious straightforward fix,
that's why I said the following in v1/v2 cover letter :)

"Perhaps there're better and cleaner ways to fix the problems, please
help review and advise"

Thanks,
Eryu

> 
> > +       } elsif (/mount:.* cannot remount .* read-write.*/) {
> > +               # failed rw remount
> > +               print "mount: cannot remount device read-write, is write-protected\n";
> > +       } else {
> > +               print "$_";
> > +       }' | _filter_ending_dot
> >  }
> >
