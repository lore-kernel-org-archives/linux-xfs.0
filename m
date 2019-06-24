Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37083 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfFXXeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:34:50 -0400
Message-ID: <cca5319857aefccadb64dbcf084185fa8ecf6296.camel@themaw.net>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
From: Ian Kent <raven@themaw.net>
Date: Tue, 25 Jun 2019 07:34:41 +0800
In-Reply-To: <20190624230633.GB5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134510851.2519.2387740442257250106.stgit@fedora-28>
         <20190624172943.GV5387@magnolia>
         <20190624223554.GA7777@dread.disaster.area>
         <20190624230633.GB5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, 2019-06-24 at 16:06 -0700, Darrick J. Wong wrote:
> On Tue, Jun 25, 2019 at 08:35:54AM +1000, Dave Chinner wrote:
> > On Mon, Jun 24, 2019 at 10:29:43AM -0700, Darrick J. Wong wrote:
> > > On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> > > > The mount-api doesn't have a "human unit" parse type yet so
> > > > the options that have values like "10k" etc. still need to
> > > > be converted by the fs.
> > > 
> > > /me wonders if that ought to be lifted to fs_parser.c, or is xfs the
> > > only filesystem that has mount options with unit suffixes?
> > 
> > I've suggested the same thing (I've seen this patchset before :)
> > and ISTR it makes everything easier if we just keep it here for this
> > patchset and then lift it once everything is merged...
> 
> Ok, fair enough. :)

I mentioned it to David after Dave said much the same thing, David said
he had done some work on it but I haven't heard more yet.

> 
> --D
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
