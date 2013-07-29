Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE2B27CBF
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 00:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92448304032
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jul 2013 22:00:42 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id LLJ1zxoeab8AmYXl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 22:00:40 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1V3fZX-0003g8-7h
	for linux-xfs@oss.sgi.com; Mon, 29 Jul 2013 07:00:39 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:00:39 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:00:39 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Date: Sun, 28 Jul 2013 21:57:38 -0700
Message-ID: <2b9hcaxru.ln2@goaway.wombat.san-francisco.ca.us>
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
	<2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
	<109D380F-F26C-4DA1-87DC-27466198AE22@sandeen.net>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2013-07-29, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> In general, no.  There are a lot of moving parts that interface with the filesystem - one does not simply drop fs/xfs from, say, kernel 3.2 into a 2.6.32 kernel.

I apologize for the confusion, this was not what I was implying was
possible.  Let me try to be more explicit.  Unfortunately, I no longer
have a history of what I did, because I ultimately abandoned it, so my
example will be hypothetical.

The current stable kernel is 3.10.4.  Let's suppose that 3.10.5 comes
out tomorrow with some interesting patches to fs/xfs.  Is it possible
using dkms to build the 3.10.5 version of the xfs module for a running
3.10.4 kernel?  And if so, is there a way for the module to report its
own version?  There should (in theory) be much less wizardry involved in
this scenario than in the difficult scenario of porting 3.10's xfs back
to 2.6, and is more along the lines of what I remember doing a short
time back).  (To be specific, IIRC what I did was took a proposed patch
against my running kernel version, which had not yet been incorporated
in the distro kernel, and tested it by replacing the distro kernel's
module with one I built via DKMS.  But as I mentioned, I have no docs on
this, so I could be misremembering the process.)

I am not intentionally trying to be difficult.  :)  I am genuinely
just curious about the answer.  If it's "no" (or perhaps, in this
specific scenario, it's "use the dkms tools"), it still provides me with
valuable information I did not previously have.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
