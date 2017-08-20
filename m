Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5868 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752523AbdHTB41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 21:56:27 -0400
Date: Sun, 20 Aug 2017 11:56:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170820015624.GP10621@dastard>
References: <20170818103932.24607-1-jtulak@redhat.com>
 <20170819010300.GM10621@dastard>
 <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 19, 2017 at 08:40:57AM +0200, Jan Tulak wrote:
> On Sat, Aug 19, 2017 at 3:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 18, 2017 at 12:39:32PM +0200, Jan Tulak wrote:
> >> The old name 'defaultval' was misleading - it is not the default value,
> >> but the value the option has when used as a flag by an user.
> >
> > Hmmm - ok, what we have here is the difference between design intent
> > and the current use of the field.
> >
> > The design intent is that the defaultval field can contain the
> > default value for any type of config field. It gets used when a user
> > either doesn't specify the option or doesn't specify a value for the
> > option that is being parsed. The special "need value" value tells
> 
> These are two things that can't be done in one field.

Drop the "doesn't specify the option" part of what I said - it's so
long ago and I've been out of the loop for more than half a year
and I've conflated several different things into one statement
and ended up implying something I shouldn't have.

e.g. I found an note in an old hacked up prototype patch I'd written
and discarded way back in 2013, and it said:

.....
	*
	* If a value is not supplied with an option, the option table entry
	* for that CLI option will tell the parser whether a value is
	* required. If a value is not require, it will contain the default
	* value that should be used for that CLI option.
	*
.....

The "store all defaults in the table" came later - IIRC (*cough*) it
came about from wanting to support config files which needed a store
for all the mkfs default values so they could be overriden by both
config file and CLI options.

As it is, since I originally started this options table rework, we
now store most mkfs defaults in a separate structure:

/*
 * Default values for superblock features
 */
struct sb_feat_args     sb_feat = {
        .finobt = 1,
        .spinodes = 0,
        .log_version = 2,
        .attr_version = 2,
        .dir_version = XFS_DFL_DIR_VERSION,
        .inode_align = XFS_IFLAG_ALIGN,
        .nci = false,
        .lazy_sb_counters = true,
        .projid16bit = false,
        .crcs_enabled = true,
        .dirftype = true,
        .parent_pointers = false,
        .rmapbt = false,
        .reflink = false,
};

Or we calculate them from underlying geometry. Hence the need to
store "if not specified" mkfs defaults in the option table doesn't
exist. It didn't exist years ago when I started on this, it doesn't
exist now and AFAICT it doesn't need to exist in the future to
support config files.

> If it worked
> that way, imagine what would happen with a flag that is disabled by
> default, like -m rmapbt? If you put here the default value for
> "disabled when not specified", you can't enable it with a flag. If you
> put here a value for "enable when used as a flag", you have just
> enabled it by default as well.

The parser and table design is supposed to be flexible enough to
give you enough rope to hang yourself. :)

[....]

> > the code that there isn't a defined default that can be used, so the
> > option must be specified with a value.
> >
> > The current implementation only contains default values for flag
> > fields, but that doesn't mean we can't use it for fields that are
> > not flags. And if that's the case, then renaming the field "flagval"
> > isn't the right thing to do....
> 
> The field is used only when no value is provided, but the option is
> specified --> when the option is used as a flag. So "flagval" sounds
> ok to me.

Again, you're using the implementation details to define a limit
the scope of a variable that was designed to have a very wide
scope and flexible usage.

Let me finish factoring all the code into a set of usable
structures, then we can start looking at the option table and config
files from a fresh perspective. This time, we need to come up with a
clean design and clear direction before any patches are written...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
