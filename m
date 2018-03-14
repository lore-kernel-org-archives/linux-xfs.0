Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeCNWNp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 18:13:45 -0400
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com [209.85.214.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F3A20779
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 22:13:45 +0000 (UTC)
Received: by mail-it0-f52.google.com with SMTP id u5-v6so6690858itc.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 15:13:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314210145.GH18129@dastard>
References: <20180313205911.26082-1-mcgrof@kernel.org> <20180313213916.GD18129@dastard>
 <20180313235227.GH4449@wotan.suse.de> <20180314035531.GF18129@dastard>
 <20180314171901.GI4449@wotan.suse.de> <20180314210145.GH18129@dastard>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Wed, 14 Mar 2018 15:13:23 -0700
Message-ID: <CAB=NE6VPi1vVNYeaZ2TOEprOWbcubJveY1bKpVyGq6tQpcj0eg@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.com>, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>, Jan Tulak <jtulak@redhat.com>, Tso Ted <tytso@mit.edu>

On Wed, Mar 14, 2018 at 2:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 14, 2018 at 05:19:01PM +0000, Luis R. Rodriguez wrote:
>> On Wed, Mar 14, 2018 at 02:55:31PM +1100, Dave Chinner wrote:
>> > 3. it needs to support more than just boolean options e.g. for
>> > setting a default log size
>>
>> Log size is not part of struct mkfs_default_params, do we reaally
>> want to be able to set that via the configuration file?
>
> I think you're over-complicating/over-thinking this. setting a
> default log size is an /example/, not something we /must do/. I
> could have said "default directory blocksize", which is another
> thing that is not currently in the defaults structure but is also
> something we should also consider as a configurable default because
> there are classes of users that want to use a different default
> value.

Just wanted to be sure.

>> sectorsize and blocksize are though.
>> Then struct mkfs_default_params has a struct sb_feat_args, of
>> which non-bools are (and their corresponding mapping):
>>
>>       int log_version L_VERSION
>>       int attr_version I_ATTR
>>       int dir_version N_VERSION
>>
>> So sure, I can add support for these, and sectorsize and blocksize.  It just
>> didn't seem worth it given most of the others were bool, so if we restrict the
>> parser to bool its much simpler.
>
> Again, you're only looking at the current implementation to support
> what it implements rather than implementing what we need to
> arbitrary config file parameters.

Sure, from my perspective *just* parsing the bools on struct
mkfs_default_params sufficed for my own needs to ensure I can drop in
a new xfsprogs on ancient systems. I understand what you mean now
though, in that the default structure may *very likely* grow later and
we may want to expand on it later. Got it.

> e.g. Look at validate_dirblocksize() - it's default value is hard
> coded into the function, rather than getting it from the defaults
> structure.

If nothing is set it depends if dirblocklog is set. And I guess if
nothing is set dirblocklog is set to XFS_MIN_REC_DIRSIZE, and
dirblocksize would be (1 << XFS_MIN_REC_DIRSIZE).

> Same goes for validate_inodesize(), and so on.

This default value will depends on if crcs_enabled which is already
part of the default struct. If we enable one to set this via the
default struct we'd just have to do similar sanity checks, which I'd
hope we can just share across both files then.

> Those are
> going to need to be pulled up into the default value structure,
> because they are things we're going to want to support changing
> default values for.

Alright...

> Start by looking at all the types we parse on the CLI (bool, flag,
> int, int64, unit suffices, etc) and implementing those, because they
> are all going to be needed to set the value of some default
> parameter....

Last I looked uint64 would suffice for all, modulo we had a few
"strings", an odd one was for N_VERSION where it may be a string with
"ci" in which case we'd set nci=true, otherwise we assume we're
updating the dir_version.

>> BTW I see we have bool parent_pointers, and that maps to setting
>> XFS_SB_VERSION2_PARENTBIT, but we have no respective specific CLI
>> param, so of these:
>
> Again, you're looking at implementation, and asking questions about
> a function that *isn't yet implemented* and so has no valid value
> other than 0. When it's actually implemented, then we'll add it to
> the CLI options and the default parsing into the appropriate
> section. It's not the job of a "introduce config files for defaults"
> patch to implement CLI/default parsing support for features that
> aren't currently implemented.

Great.

>> > There will be other things when I look at the code, but those are
>> > the first ones that come to mind....
>>
>> I can address most of what you describe rather easily, the biggest
>> issue is ensuring that our goal here is only to modify struct
>> mkfs_default_params values, inclusive of what is in struct sb_feat_args.
>>
>> Note that struct mkfs_default_params also has a struct fsxattr... do we
>> want to modify all those (this struct is defined per OS), for Linux we have:
>>
>> struct fsxattr {
>>         __u32           fsx_xflags;     /* xflags field value (get/set) */
>>         __u32           fsx_extsize;    /* extsize field value (get/set)*/
>>         __u32           fsx_nextents;   /* nextents field value (get)   */
>>         __u32           fsx_projid;     /* project identifier (get/set) */
>>         __u32           fsx_cowextsize; /* cow extsize field value (get/set) */
>>         unsigned char   fsx_pad[8];
>> };
>>
>> I didn't enable parsing support for these, do we want to parse each of these
>> as well?
>
> They are set by parsing existing CLI options, so if you enable those
> options in the config file parsing, then this structure will need to
> be updated, too.

I don't have a need for this to support old kernels. I'm perfectly
happy to support only what we have in the defaults structure for now.

 Luis
