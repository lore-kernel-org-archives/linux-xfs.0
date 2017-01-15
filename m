Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbdAOOKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Jan 2017 09:10:23 -0500
Date: Sun, 15 Jan 2017 09:10:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 4/5] xfs_db: sanitize geometry on load
Message-ID: <20170115141022.GA2703@bfoster.bfoster>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <20170113003201.GC14038@birch.djwong.org>
 <20170113133542.GB22013@bfoster.bfoster>
 <b071967b-e67b-2280-156c-9a5aeaa5d40c@redhat.com>
 <20170114034449.GA29191@bfoster.bfoster>
 <d4731c23-e721-faad-9937-8256840012bb@redhat.com>
 <20170114125346.GA31018@bfoster.bfoster>
 <91a33cde-6300-e84d-f74c-454c129e2669@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91a33cde-6300-e84d-f74c-454c129e2669@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Sat, Jan 14, 2017 at 08:59:00AM -0600, Eric Sandeen wrote:
> On 1/14/17 6:53 AM, Brian Foster wrote:
> >> I do think that mere mortal invocations via xfs_admin need to be
> >> handled in this "ignore agcount" case, though...
> >>
> > We're talking about invocations intended to modify things (i.e., version
> > flags, fs uuid, etc.), right? If so, wouldn't we want those things to
> > fail if the superblock is busted?
> 
> Yes - I'm saying that if xfs_db continues with only 1 ag, those tools
> will not work as expected.  (they normally modify all superblocks).
> 

Right..

> setting exitcode to 1 in the corrupted agcount case would allow
> xfs_admin to return failure as well, for example.
> 

Ok, that makes sense to me. I wasn't sure if by "handled," you meant we
wanted those operations to try and do something useful in this
situation.

Brian

> -Eric
> 
> > Brian
> > 
