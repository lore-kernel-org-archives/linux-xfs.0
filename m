Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E62257F3F
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 08:38:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D48C28F8050
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 06:38:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jNX5lhAW0wsITa27 for <linux-xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 06:38:39 -0700 (PDT)
Message-ID: <51F6705E.5040309@sandeen.net>
Date: Mon, 29 Jul 2013 08:38:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
	<2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
	<109D380F-F26C-4DA1-87DC-27466198AE22@sandeen.net>
	<2b9hcaxru.ln2@goaway.wombat.san-francisco.ca.us>
In-Reply-To: <2b9hcaxru.ln2@goaway.wombat.san-francisco.ca.us>
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
Cc: linux-xfs@oss.sgi.com

On 7/28/13 11:57 PM, Keith Keller wrote:
> On 2013-07-29, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> In general, no. There are a lot of moving parts that interface with
>> the filesystem - one does not simply drop fs/xfs from, say, kernel
>> 3.2 into a 2.6.32 kernel.
> 
> I apologize for the confusion, this was not what I was implying was
> possible.  Let me try to be more explicit.  Unfortunately, I no longer
> have a history of what I did, because I ultimately abandoned it, so my
> example will be hypothetical.
> 
> The current stable kernel is 3.10.4.  Let's suppose that 3.10.5 comes
> out tomorrow with some interesting patches to fs/xfs.  Is it possible
> using dkms to build the 3.10.5 version of the xfs module for a running
> 3.10.4 kernel?  

"Probably / Maybe"

It really depends on what changed from 3.10.4 to 3.10.5, but odds are,
kernel interfaces did not change, so - probably fine.  If not, you
get to keep all the pieces, etc.

> And if so, is there a way for the module to report its
> own version?

Say it with me: there is no xfs module version.  :)

The "module version" is inherited from the kernel it's built against.

$ modinfo xfs
...
vermagic:       2.6.32-279.22.1.el6.x86_64 SMP mod_unload modversions 

> There should (in theory) be much less wizardry involved in
> this scenario than in the difficult scenario of porting 3.10's xfs back
> to 2.6, and is more along the lines of what I remember doing a short
> time back).  (To be specific, IIRC what I did was took a proposed patch
> against my running kernel version, which had not yet been incorporated
> in the distro kernel, and tested it by replacing the distro kernel's
> module with one I built via DKMS.  But as I mentioned, I have no docs on
> this, so I could be misremembering the process.)

Yeah, short version hops are more likely to be ok.

And taking kernel version X's xfs, and applying a bugfix patch, and
rebuilding it against the same kernel headers should be fine.  Still
a little wizardry, but not bad for a kernel-savvy person.

> I am not intentionally trying to be difficult.  :)  I am genuinely
> just curious about the answer.  If it's "no" (or perhaps, in this
> specific scenario, it's "use the dkms tools"), it still provides me with
> valuable information I did not previously have.

Sure, I don't think you're being difficult.

The further you go off the reservation, the less tested things are, and
the less likely they are to work.  Building a tweaked, same-era module
against a slightly different kernel is likely to be fine; it's when
you get more & more changed / moving parts that it becomes trickier.

But you need to know enough to know what you're changing and/or what
has changed in the kernel, to know if what you're doing is completely
safe, probably safe, or unlikely to be safe...

-Eric

> --keith
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
