Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934186AbeFNQYW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 12:24:22 -0400
Date: Thu, 14 Jun 2018 18:24:21 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/5] mkfs: move config file enums to config.h
Message-ID: <20180614162421.GC7508@wotan.suse.de>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <152891831888.3968.419374576285554912.stgit@magnolia>
 <ddc1fb00-81e8-6747-bbf9-c74927d82c6f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddc1fb00-81e8-6747-bbf9-c74927d82c6f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 13, 2018 at 09:51:34PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/13/18 2:31 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the config file enums to config.h and make the names distinct from
> > the cli ones.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ok, happy with fixing up the namespace issues / removing the duplicated
> names... 

Chinner had wanted to keep things separate purposely as he indicated we may
diverge eventually. So inclusion of the enums on even mkfs/xfs_mkfs.c seems
not needed but that will depend on your later patches and what the goal is.

  Luis
