Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F404F7F4E
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 03:36:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3E7630404E
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 01:36:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EIrq4N3r30F3itPu for
	<xfs@oss.sgi.com>; Mon, 01 Jul 2013 01:36:43 -0700 (PDT)
Date: Mon, 1 Jul 2013 10:36:37 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/3 v2] xfstests: Add support for sections in config file
In-Reply-To: <20130701014944.GD27780@dastard>
Message-ID: <alpine.LFD.2.00.1307011022300.2542@localhost.localdomain>
References: <1372426320-19902-1-git-send-email-lczerner@redhat.com>
	<1372426320-19902-3-git-send-email-lczerner@redhat.com>
	<20130701014944.GD27780@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 1 Jul 2013, Dave Chinner wrote:

> Date: Mon, 1 Jul 2013 11:49:44 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH 3/3 v2] xfstests: Add support for sections in config file
> 
> On Fri, Jun 28, 2013 at 03:32:00PM +0200, Lukas Czerner wrote:
> > This patch add support for sections in the config file. Each section can
> > contain configuration options in the format
> > 
> > OPTION=value
> > 
> > when one section is processed xfstests will proceed to next section
> > until all secitons are processed, or an error occur.
> > 
> > The name of the section can consist of alphanumeric characters + '_',
> > nothing else is allowed. Name of the section is also used to create
> > results subdirectory for each section. After all the sections are
> > processed summary of all runs is printed out.
> > 
> > If the config file does not contain sections, or we're not using config
> > file at all, nothing is changed and xfstests will work the same way as
> > it used to.
> > 
> > This is very useful for testing file system with different options. Here
> > is an example of the config file with sections:
> > 
> > [ext4_4k_block_size]
> > TEST_DEV=/dev/sda
> > TEST_DIR=/mnt/test
> > SCRATCH_DEV=/dev/sdb
> > SCRATCH_MNT=/mnt/test1
> > MKFS_OPTIONS="-q -F -b4096"
> > FSTYP=ext4
> > 
> > [ext4_1k_block_size]
> > MKFS_OPTIONS="-q -F -b1024"
> > 
> > [ext4_nojournal]
> > MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
> > 
> > [ext4_discard_ssd]
> > MKFS_OPTIONS="-q -F -b4096"
> > TEST_DEV=/dev/sdc
> > SCRATCH_DEV=/dev/sdd
> > MOUNT_OPTIONS="-o discard"
> > 
> > Note that once the variable is set it remains set across the sections, so
> > you do not have to specify all the options in all sections. However one
> > have to make sure that unwanted options are not set from previous
> > sections.
> 
> I like the idea, but a lot of this needs to be in the (missing)
> patch 0 description for the series. YOu also need to describe how
> these get invoked, what the output looks like, etc because right now
> I can't work it out from this...

Fair enough, I should probably describe it in the README as well.

> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  check         | 371 +++++++++++++++++++++++++++++++++-------------------------
> >  common/config | 126 ++++++++++++--------
> >  common/rc     |  63 +++++-----
> >  3 files changed, 326 insertions(+), 234 deletions(-)
> 
> This patch probably needs to be broken up, too. A substantial part
> of it is indentation changes, which probably should be split into 2
> parts - factor code into function, then wrap loop around function.
> The change to the summary information should be done as a separate
> patch, too. I suspect many of the common/config changes coul dbe
> split up, too.

Ok, I'll see how can I split it up. Btw, indentation in xfstests is
a mess, because sometimes we're using spaces and sometimes tabs. Is
there any preference ? (I would definitely prefer tabs)

> 
> The changing of the $RESULT_BASE should probably also
> bein a separate patch, because this is something that we'll need to
> discuss as it changes the structure of the output....

I am not sure it should be separate from this patch because the new
structure will only be used if the new config format (with sections)
is used.

> 
> Oh, and why make a distinction between no sections and
> $OPTIONS_HAVE_SECTIONS in the config file? Surely no sections is
> just the same as having 1 section....

Yes, but it's much "nicer" to check boolean option than checking
what is the name of the first section. Really this is just a
workaround, because I did not want to change result structure and
output if one is not using the new config format. It could be done
so that when there are no sections we'll always use "default" section,
not sure what would people prefer.

> 
> > +parse_config_section() {
> > +	SECTION=$1
> > +	if ! $OPTIONS_HAVE_SECTIONS; then
> > +		return 0
> > +	fi
> > +	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
> > +		-e 's/#.*$//' \
> > +		-e 's/[[:space:]]*$//' \
> > +		-e 's/^[[:space:]]*//' \
> > +		-e "s/^\(.*\)=\([^\"']*\)$/export \1=\"\2\"/" \
> > +		< $HOST_OPTIONS \
> > +		| sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`
> > +}
> 
> And line noise like this needs comments explaining the format and
> what it is doing. ;)

Sure I'll add some comments.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
