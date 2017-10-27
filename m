Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932535AbdJ0T4X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 15:56:23 -0400
Date: Fri, 27 Oct 2017 21:56:19 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] xfs_repair: clear file / directory attribute on symlinks
Message-ID: <20171027195619.GC22894@wotan.suse.de>
References: <20171026225053.10263-1-mcgrof@kernel.org>
 <b52bcf80-6848-c3f3-c8bc-68e69054267c@sandeen.net>
 <20171027001118.GF5483@magnolia>
 <20171027002812.GV17331@wotan.suse.de>
 <7281013b-835e-031c-6ed0-dd0c220b271c@suse.com>
 <20171027170339.GA22894@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027170339.GA22894@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Nikolay Borisov <nborisov@suse.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Laurent Bonnaud <Laurent.Bonnaud@inpg.fr>, Tso Ted <tytso@mit.edu>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Fri, Oct 27, 2017 at 07:03:39PM +0200, Luis R. Rodriguez wrote:
> > > 	file = argv[2];
> > > 
> > > 	fd = open(file, open_flags);
> > > 	if (!fd) {
> > > 		printf("Could not open file for operation: %s\n", cmd_str);
> > > 		usage();
> > > 	}
> 
> This open() will though.

That's because the special mushrooms I took the day I wrote the above
code made me forget to instead check for:

	if (fd < 0)

That will always fail.

So open() on a dangling symlink will fail as well.

So it seems we can't set these attributes via userspace, unless you
use xfs_db and as noted by Darrick that's not a valid use case, it'd
be fuzzing.

  Luis
