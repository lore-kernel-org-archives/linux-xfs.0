Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D71007F3F
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 13:21:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56C26AC003
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:21:37 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id xZihrHThxUytKzB3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 11:21:36 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1V3s4c-0002AJ-NZ
	for linux-xfs@oss.sgi.com; Mon, 29 Jul 2013 20:21:34 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:21:34 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:21:34 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Date: Mon, 29 Jul 2013 11:15:41 -0700
Message-ID: <d3oicax1j9.ln2@goaway.wombat.san-francisco.ca.us>
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
	<2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
	<109D380F-F26C-4DA1-87DC-27466198AE22@sandeen.net>
	<2b9hcaxru.ln2@goaway.wombat.san-francisco.ca.us>
	<51F6705E.5040309@sandeen.net>
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
> On 7/28/13 11:57 PM, Keith Keller wrote:
>> 
>> The current stable kernel is 3.10.4.  Let's suppose that 3.10.5 comes
>> out tomorrow with some interesting patches to fs/xfs.  Is it possible
>> using dkms to build the 3.10.5 version of the xfs module for a running
>> 3.10.4 kernel?  
>
> "Probably / Maybe"
>
> It really depends on what changed from 3.10.4 to 3.10.5, but odds are,
> kernel interfaces did not change, so - probably fine.  If not, you
> get to keep all the pieces, etc.

Sure.  :)

>> And if so, is there a way for the module to report its
>> own version?
>
> Say it with me: there is no xfs module version.  :)

Well, wouldn't it be the same as the original kernel from which the code
was ripped?  So in the above hypothetical, one could say that the xfs
"version" is 3.10.5.  It's not *exactly*, of course, but if I were to
say "I'm running kernel 3.10.4 with xfs built from 3.10.5 using DKMS"
you'd probably know what I meant.  You might then choose not to answer
questions because I've gone too far off the reservation.

Or, maybe, a different way of saying this is that the XFS version always
matches the kernel version it comes from.  Then if you use code from one
kernel version in a different version it's at your own risk; one of the
consequences is that you need to document this discrepancy yourself.

> And taking kernel version X's xfs, and applying a bugfix patch, and
> rebuilding it against the same kernel headers should be fine.  Still
> a little wizardry, but not bad for a kernel-savvy person.

Is that all it takes to be considered "wizardry"?  Back In My Day (TM)
you had to mess with .config in order to get anything done!  ;-)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
