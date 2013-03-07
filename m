Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 258657FAF
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:06:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9170AC004
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 03:06:06 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id V5YC0VKTIjxalmAj for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 03:06:02 -0800 (PST)
Date: Thu, 7 Mar 2013 12:06:01 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests 273: fix a typo
Message-ID: <20130307110600.GJ21081@twin.jikos.cz>
References: <512DAC1A.2040601@gmail.com> <20130306232222.GF21081@twin.jikos.cz>
	<20130307033849.GB6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307033849.GB6369@dastard>
Reply-To: dsterba@suse.cz
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, dsterba@suse.cz, Wang Sheng-Hui <shhuiw@gmail.com>

On Thu, Mar 07, 2013 at 02:38:49PM +1100, Dave Chinner wrote:
> On Thu, Mar 07, 2013 at 12:22:22AM +0100, David Sterba wrote:
> > On Wed, Feb 27, 2013 at 02:47:54PM +0800, Wang Sheng-Hui wrote:
> > > -	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
> > > +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1

This is quote from the mail, but the merged patch does something else.

> >     +./273: line 95: syntax error near unexpected token `&'
> >     +./273: line 95: `  cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>>&1'
> >     +umount: /dev/sda9: not mounted

> that seems rather strange. The patch does this:
> 
> 	....sub_$_suffix >>$seq.full 2>&1

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commitdiff;h=0c5e67e46e476b70290033efc7feb784f7ecbab1;hp=08557e219c12e573be459407033495899f46967a

--- a/273
+++ b/273
@@ -92,7 +92,7 @@ _porter()
                exit
        fi
 
-       cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
+       cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>>&1
        if [ $? -ne 0 ]
        then
                echo "_porter $_suffix not complete"
---

> and the error output you see is
> 
> 	....sub_$_suffix >$seq.full 2>>&1
> 
> So it doesn't look lie you are running with the change that is
> actually in the patch...

There's a difference between the patch in mail and what has been merged, that
can happen, but I wonder why it works on your side.

Minimal reproducer that I used on machines with never bash:
---
touch origin
cp -r origin target >seq.full 2>>&1
---
bash --version: GNU bash, version 4.2.24(1)-release
and fails the same way.

> GNU bash, version 4.2.37(1)-release

I've checked bash sources (no git, just tar + context diff patches), there's no
apparent fix between 24-37 for that.

(Also tried to build a git tree, but filterdiff did not produce 1:1 unified
format of the separate patches and there are lots of conflicts).

If possible, I'd like avoid forcing a minimal version of bash, as the
enterprise distros do not always ship the latest ones, and this break the tests
unnecessarily.


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
