Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 06:52:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8ODq5Q3021687
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 06:52:11 -0700
Message-ID: <46F7B8B9.4040707@redhat.com>
Date: Mon, 24 Sep 2007 08:16:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org>
In-Reply-To: <20070924124035.GA4209@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Theodore Tso <tytso@mit.edu>
Cc: Karel Zak <kzak@redhat.com>, Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org, List util-linux-ng <util-linux-ng@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Theodore Tso wrote:
> On Mon, Sep 24, 2007 at 11:25:39AM +0200, Karel Zak wrote:
>>> Nope, there isn't much rationale unless we also split out fsck, so
>>  util-linux-ng is open for fsck :-)
> 
> It's something I'm considering, but at the moment I've got some higher
> priority (ext4) work that I'm focusing on.  
> 
> What would you think about moving libblkid and the libdisk from
> xfsprogs into util-linux-ng?  That's things that I've been batting
> around doing, although that means we end up moving more libraries that
> distros would probably want separated into different packages into
> util-linux-ng....

Heh, sounds a little like a prisoner exchange... "we'll give up libblkid
& libcom_err if you give up libdisk" :)

Seriously, though, that all sounds like a pretty good idea to me,
especially since e2fsprogs has been making noise about utilizing some of
the functionality in xfsprogs (stripe discovery etc).

-Eric
