Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 10:50:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JHo0uw029991
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 10:50:03 -0700
Message-ID: <46F16149.8080503@sandeen.net>
Date: Wed, 19 Sep 2007 12:50:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.23
References: <20070918112447.4315C58C4C09@chook.melbourne.sgi.com>
In-Reply-To: <20070918112447.4315C58C4C09@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Tim Shimmin wrote:
> Hi Linus,
> 
> A couple of fixes for potential fs corruption.
> And one fix to ensure that xfs_mru_cache is not
> doing anything unless the cache has active objects.

cc: trimmed...

Seems like you should push the filestreams fix too?

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commitdiff;h=f4b26d9d73e38ff915720440b1c373fb239a4254

Thanks,

-Eric

p.s. just FWIW, here are the patches I'm currently carrying in F8:

linux-2.6-xfs-avoid-replaying-inode-buffer-init.patch	In for-linus
linux-2.6-xfs-filesize-updates.patch			In for-linus
linux-2.6-xfs-filestreams-on-demand-MRU-reaping.patch	In for-linus
linux-2.6-xfs-fix-filestreams-free-func-cast.patch
linux-2.6-xfs-optimize-away-dmapi-tests.patch
linux-2.6-xfs-optimize-away-realtime-tests.patch
linux-2.6-xfs-refactor-xfs_mountfs.patch
linux-2.6-xfs-setfattr-32bit-compat.patch
