Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 306057F3F
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jul 2013 23:32:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C13FCAC001
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jul 2013 21:32:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MfS127myg6ZtOaVx for <linux-xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 21:32:44 -0700 (PDT)
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
	<2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0 (1.0)
In-Reply-To: <2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
Message-Id: <109D380F-F26C-4DA1-87DC-27466198AE22@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Date: Sun, 28 Jul 2013 23:32:41 -0500
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Jul 28, 2013, at 10:38 PM, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:

> On 2013-07-29, Dave Chinner <david@fromorbit.com> wrote:
>> 
>> The "version" of XFS that you are running is that of the
>> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> 
> Can't you fairly easily replace a kernel module with a different version
> using something like DKMS?  I feel like I did that with xfs a few months
> ago.  If accurate, then it's theoretically possible to run a different
> version of the xfs kernel module than the running kernel version.  (And
> if I'm misremembering then there really is no spoon!)
> 
In general, no.  There are a lot of moving parts that interface with the filesystem - one does not simply drop fs/xfs from, say, kernel 3.2 into a 2.6.32 kernel.

Ninjas like Dave can do it for an enterprise distro kernel if it benefits customers, but the back porting and testing is very much a nontrivial task.

-Eric


> --keith
> 
> -- 
> kkeller@wombat.san-francisco.ca.us
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
