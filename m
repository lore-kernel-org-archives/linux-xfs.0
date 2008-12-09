Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99uI3E013637 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:56:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78D4516109AD
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 01:56:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id i6B9e5FlqAJ2VhyU for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 01:56:17 -0800 (PST)
Date: Tue, 9 Dec 2008 04:55:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsqa: add testcase for ->setattr permission checking
Message-ID: <20081209095546.GB8599@infradead.org>
References: <20081202142039.GA25155@infradead.org> <493CB518.7000001@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493CB518.7000001@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 08, 2008 at 04:48:08PM +1100, Timothy Shimmin wrote:
> 1.
> > +echo "user: chown root owned file to qa_user (should fail)"
> > +su ${qa_user} -c "chown root test.${qa_user}"
> > +
> I think the description and command above don't match.
> I think we have a swap with subtest 4 below.
> Need to either swap descriptions or commands.

Yes, I swapped the descriptions.

> > +#
> > +# Setup a file owned by the qa_user and with the suid bit set.
> > +# A chown by root should not clean the suid bit.
> > +#
> 
> Typos:
> s/clean/clear/
> 
> s/suceed/succeed/ in a couple of places.

Yeah.

> * It looks like you test the clearing of suid/sgid bits
> for setting the mode permission bits and not
> for setting ownership as the description suggests;
> i.e. you test with chmod instead of chown for clearing of suid/sgid bits

Yes, that's also what I intended too, as XFS had some code to clear
the suid bits for changing permissions, but those shouldn't happen
for the restricted_chown case (and don't even happen in the XFS code,
it's just not obvious when reading the old setattr implementation).
While for sgid we want to clear it on mode changes if the gid
is not in the group list.  So what needs fixing here is once again
the comment.

Btw, I just noticed you checked in another testcase as 192.  Do you want
a respin or do you want to fix it up yourself?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
