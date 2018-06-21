Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753972AbeFUTPh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 15:15:37 -0400
Date: Thu, 21 Jun 2018 21:15:35 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180621191535.GI7508@wotan.suse.de>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 02:21:15PM -0500, Eric Sandeen wrote:
> On 6/19/18 11:18 AM, Darrick J. Wong wrote:
> > On Tue, Jun 19, 2018 at 02:27:29PM +0200, swadmin - levigo.de wrote:
> >> Hi @all
> >> I have a problem with mounting a large XFS filesystem which takes about
> >> 8-10 minutes.
> >>
> >>
> >>
> >> :~# df -h /graylog_data
> >> Filesystem                       Size  Used Avail Use% Mounted on
> >> /dev/mapper/vgdata-graylog_data   11T  5.0T  5.1T  50% /graylog_data
> >>
> >> ----
> >>
> >> :~# xfs_info /dev/mapper/vgdata-graylog_data
> >> meta-data=/dev/mapper/vgdata-graylog_data isize=512    agcount=40805,
> >> agsize=65792 blks
> > 
> > 41,000 AGs is a lot of metadata to load.  Did someone growfs a 1G fs
> > into a 11T fs?
> 
> <answer: yes, they did>
> 
> Let me state that a little more clearly: this is a badly mis-administered
> filesystem; 40805 x 256MB AGs is nearly unusable, as you've seen.
> 
> If at all possible I would start over with a rationally-created filesystem
> and migrate the data.

Considering *a lot* of folks may typically follow the above "trap", wouldn't it
be wise for userspace to complain or warn when the user may want to do
something stupid like this? Otherwise I cannot see how we could possibly
conceive that this is badly administered filesystem.

  Luis
