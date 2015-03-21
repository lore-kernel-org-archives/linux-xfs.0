Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6A0B7F37
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2015 09:18:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A45C98F8033
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2015 07:18:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QVBD4PHDUVnc06OU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Mar 2015 07:18:56 -0700 (PDT)
Date: Sat, 21 Mar 2015 10:18:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/13] xfs_db: add crc manipulation commands
Message-ID: <20150321141854.GB15941@bfoster.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-4-git-send-email-sandeen@redhat.com>
	<20150319150755.GC11669@laptop.bfoster>
	<550CD7B5.8030507@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <550CD7B5.8030507@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Fri, Mar 20, 2015 at 09:30:13PM -0500, Eric Sandeen wrote:
> On 3/19/15 10:07 AM, Brian Foster wrote:
> > On Tue, Mar 17, 2015 at 03:33:05PM -0500, Eric Sandeen wrote:
> >> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
> ...
> 
> if (argc) while ((c = getopt(argc, argv, "irv")) != EOF) {
> > 
> > The 'if (argc)' thing strikes again. Does this address something I'm not
> > aware of?
> 
> just a dumb/unfortunate cut & paste from elsewhere, I'll fix.
> 
> ...
> 
> >> +		/* Off by one.. */
> >> +		crc = cpu_to_be32(crc + 1);
> >> +		setbitval(iocur_top->data, sfl->offset, bit_length, &crc);
> > 
> > Some comments on the above code would be nice to explain what it's
> > calculating.
> 
> Yeah, wish I'd written them "yonks ago" ;)  I'll reverse engineer my
> patch & add comments.
>  
> >> +		dbprintf(_("Verifying CRC:\n"));
> > 
> > Does the "verify" aspect of this command do anything, or are we just
> > printing the state that was determined from a previous cursor load? If
> > the latter, I wonder if it's worth retaining that option (e.g., just
> > print an inode to see the crc state)..?
> 
> If having a specific CRC handler makes sense (and, maybe it doesn't,
> with the other patch that allows corrupted write), the symmetry seemed
> nice.
> 

It's not really a big deal, it just wasn't quite clear. A comment would
help.

> Given the amount of code this adds, perhaps we should just drop it,
> TBH, and use the "write -c" functionality I added, instead.
> 

Hmm, well personally I'm not against having both. My initial reasoning
was to say that there's a difference between corrupting a structure
field and the crc. Thinking further, I suppose we can use the write -c
mechanism to write to the crc field itself. Given that and the type tree
gymnastics that this implementation has to do, I suppose I could see
leaning in favor of just write -c.

It's your call I guess. Maybe it's not worth it if you have to go back
through the type stuff and remember what it does to document it. :)

Brian

> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
