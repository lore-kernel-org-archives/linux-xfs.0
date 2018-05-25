Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46814 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S972019AbeEYAvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 May 2018 20:51:31 -0400
Received: by mail-pg0-f65.google.com with SMTP id a3-v6so1516840pgt.13
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 17:51:31 -0700 (PDT)
Date: Thu, 24 May 2018 17:51:27 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180525005127.GC24593@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
 <20180520001648.GN23861@dastard>
 <20180521153354.GH23858@magnolia>
 <20180521170530.GH24680@garbanzo.do-not-panic.com>
 <20180521221057.GP23861@dastard>
 <80799366-31c1-7f23-7020-80caaf17a80c@sandeen.net>
 <20180522003857.GV23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522003857.GV23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Tue, May 22, 2018 at 10:38:57AM +1000, Dave Chinner wrote:
> On Mon, May 21, 2018 at 05:24:34PM -0500, Eric Sandeen wrote:
> > On 5/21/18 5:10 PM, Dave Chinner wrote:
> > >On Mon, May 21, 2018 at 10:05:30AM -0700, Luis R. Rodriguez wrote:
> > >>On Mon, May 21, 2018 at 08:33:54AM -0700, Darrick J. Wong wrote:
> > >>>On Sun, May 20, 2018 at 10:16:48AM +1000, Dave Chinner wrote:
> > >>>>On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
> > >>>>><shrug> Bikeshedding more, what if either option accepted either an
> > >>>>>absolute path, or a file in $sysconfdir/etc/mkfs.xfs.d/ ?
> > >>>>
> > >>>>I kinda assumed that config files could be located anywhere, but we
> > >>>>only searched the sysconfig path if it didn't point at a local
> > >>>>file...
> > >>>
> > >>><shrug> openat() semantics are fine enough with me, I think.
> > >>
> > >>Well this is a big difference, and I think being clear on this would
> > >>be good. If the user specified:
> > >>
> > >>	-c foo
> > >>	
> > >>and the file 'foo' is present but also exists on
> > >>$sysconfdir/etc/mkfs.xfs.d/foo do we use the local file if the user
> > >>did not pass ./foo ?
> > >
> > >I would have expected "foo" to be considered the same as "./foo".
> > >It's a relative path.
> > 
> > Urgh, so now if foo exists in $PWD /and/ in $sysconfdir/etc/mkfs.xfs.d/foo
> > we have to have a hierarchy between the two?  :/
> 
> Of course there is. The user may not know anything about admin
> configured defaults, and they are well within their rights to have
> their own local files that have names that match global admin
> default files.

Chinner's got a point here. If felt silly to not support this so I just
added support for it.

Will spin out a new set as I think I've taken care of all comments now.

  Luis
