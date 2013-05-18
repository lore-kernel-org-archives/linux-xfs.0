Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D22C97F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 01:28:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3D8F304077
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 23:28:23 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	e9D6kL4ex6oT0JKi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 23:28:22 -0700 (PDT)
Received: by mail-ie0-f180.google.com with SMTP id ar20so10539913iec.25
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 23:28:22 -0700 (PDT)
Message-ID: <51971F47.2020905@gmail.com>
Date: Sat, 18 May 2013 02:27:19 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<51969917.2080209@gmail.com> <20130518032507.GA6495@dastard>
	<51970C90.5050005@oracle.com>
In-Reply-To: <51970C90.5050005@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On 05/18/2013 01:07 AM, Jeff Liu wrote:

> Looks our test for 32-bit system is insufficient.  There has another bug
> reports regarding 32-bit yesterday:
> http://oss.sgi.com/archives/xfs/2013-05/msg00494.html

I read this and did not chime in because I don't know about the "no 
space left on device" error.

The first issue the customer had, though, was one I had on a 2.8GHz 
Pentium 4.  The idea of using a tunable to increase vmalloc space made 
me think, "What, am I using FreeBSD or something?  Why didn't Linux 
auto-tune this?" so I dug deeper.  [Disclaimer:  I use FreeBSD and find 
value in it, but it requires at least some sysctl tuning for things that 
Linux will tune automatically.]

Basically, I had vmalloc space to have an environment set up perfectly 
in 768 MB of RAM.  Then I added another 512 MB, and Linux saw only 896 
MB for lack of highmem support.  At that point I enabled highmem 
support, Linux decided to auto-tune my vmalloc space down to 128 MB, 
which was not enough to handle an xfsdump of a 30 GB device-mapper crypt 
partition.  The PC, when left alone, could develop those same oops-y 
messages while doing incremental xfsdumps overnight, and if left alone 
for days, even simple cp commands could cause issues.  My resolution was 
to use the CONFIG_VMSPLIT_2G kernel option and reduce the things 
reported by /proc/vmallocinfo that are vmalloc items.  Some ioremap 
items in /proc/vmallocinfo were removed where convenient.  Despite 
warnings on the Internet like "this breaks ELF" and "this breaks binary 
modules," I've had no issues with it in the nine months in which the 
kernel has operated this way.  [Note: I don't use binary modules.  For 
that matter, only that PC uses modules at all.]  Ultimately, I got rid 
of the crypts as well, but not before verifying that the above setup did 
indeed solve the problem at hand.

It's only my two cents, one person trying to balance Internet research 
against what actually works in testing on one PC.  If the solution is 
sane sane to you, feel free to forward this story to your customer to 
see if anything in it will help.

> So I'm going to setup a 32-bit test environment for such tests together
> with Michael.

Excellent!  Let me know a little about your test environment and whether 
it's a VM or bare metal.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
