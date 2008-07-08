Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 20:07:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6837uDv021065
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 20:07:56 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A80CB2C6840
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 20:09:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yRCKbSk9acAwyN4D for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 20:09:01 -0700 (PDT)
Message-ID: <4872DA4E.3040405@sandeen.net>
Date: Mon, 07 Jul 2008 22:09:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mountpoint UUID code
References: <47D20F78.7000103@sandeen.net> <1205196252.15982.69.camel@edge.scott.net.au> <47D5DE13.8030902@sandeen.net> <34665.192.168.3.1.1205266196.squirrel@mail.aconex.com> <20080312072259.GA26148@infradead.org>
In-Reply-To: <20080312072259.GA26148@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: nscott@aconex.com, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Mar 12, 2008 at 07:09:56AM +1100, nscott@aconex.com wrote:
>> I don't have any immediate plans.  I can imagine it could be used to
>> stitch parts of the namespace together in a filesystem that supports
>> multiple devices (in a chunkfs kinda way) ... or maybe more simply
>> just an in-filesystem auto-mounter.  *shrug*.  But its there, the tools
>> support it (once again, I didn't see a userspace patch - hohum), so I
>> would vote for leaving it in its current form so some enterprising,
>> constructive young coder can try to make something useful from it
>> at some point.  :)
> 
> That kind of automounter really doesn't belong into the low-level
> filesystem.  If we really wanted it it would go into the VFS, storing
> the uuid or other identifier for the mountpoint in an xattr.  This is
> really just dead junk that should go away.

Can I get a yea or nay on this from sgi, then?

Thanks,
-Eric
