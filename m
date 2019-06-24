Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46814 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbfFXWhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 18:37:06 -0400
Date: Tue, 25 Jun 2019 08:35:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190624223554.GA7777@dread.disaster.area>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134510851.2519.2387740442257250106.stgit@fedora-28>
 <20190624172943.GV5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624172943.GV5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:29:43AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> 
> /me wonders if that ought to be lifted to fs_parser.c, or is xfs the
> only filesystem that has mount options with unit suffixes?

I've suggested the same thing (I've seen this patchset before :)
and ISTR it makes everything easier if we just keep it here for this
patchset and then lift it once everything is merged...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
