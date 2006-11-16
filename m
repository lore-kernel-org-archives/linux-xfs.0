Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 14:11:43 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGMBZaG020895
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:11:36 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59D97D1CF292
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:10:47 -0800 (PST)
Message-ID: <455CE1E3.7020703@sandeen.net>
Date: Thu, 16 Nov 2006 16:10:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net>
In-Reply-To: <455CB54F.8080901@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201
> 
> Bugzilla Bug 212201: Cannot build sysem with XFS file system.
> 
> I turned on attr2 in FC6 at nathan's suggestion, for selinux goodness 
> with more efficient xattr space usage.
> 
> But, many reports that this was totally broken in fc6, on x86_64.

ugh.  it's broken on x86 too, so it's not just the alignment/padding,
although that should be fixed for cross-arch mounts.

-Eric
