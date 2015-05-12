Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11EA57F3F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 07:35:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBF43304048
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 05:35:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IAcDvAK9qW4XuDcL for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 05:35:22 -0700 (PDT)
Message-ID: <5551F38A.2050102@sandeen.net>
Date: Tue, 12 May 2015 07:35:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: any chance for xfs shrinking?
References: <5551EBB2.9010508@profihost.ag>
In-Reply-To: <5551EBB2.9010508@profihost.ag>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/12/15 7:01 AM, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> while cloud / vms usage become more and more popular and qemu now also
> offers memory hot add and unplug, cpu hot add and unplug, we still
> suffer from a missing xfs shrink.

Filesystem shrink is a very different scenario than "cloud / vms" needs
for hot memory & cpu plugging, IMHO.

> I would like to continue to use XFS as it is a rock solid base since
> around 10 years for us.
> 
> But one missing piece in variable ressource usage for us is disk
> shrinking. Is there any chance to get an xfs online shrinking?

Under what circumstance does your workflow require a filesystem shrink?

Honest question, I'm not challenging you, but I would like to understand
what it is about shrink that is so critical it may cause you to stop using
XFS.

One thing about shrink - while i.e. ext4 supports it, the end result of
a shrunk filesystem is a scrambled filesystem.  All those heuristics that
made the filesystem reasonably performant as it aged get thrown out the 
window as the fs scavenges for space into which to shrink the filesystem...

That said, another option is to use the dm-thinp target, and allocate /
de-allocate storage resources to the underlying block device as needed.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
