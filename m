Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 23:01:50 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4Q61km1014658
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 23:01:46 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: TAKE 981875 - xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
References: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com>
	<20080516051048.GB5035@infradead.org>
	<20080520064356.GA8711@infradead.org>
Date: Mon, 26 May 2008 16:02:29 +1000
In-Reply-To: <20080520064356.GA8711@infradead.org> (Christoph Hellwig's
	message of "Tue, 20 May 2008 02:43:56 -0400")
Message-ID: <nccmymdzjpm.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, May 16, 2008 at 01:10:48AM -0400, Christoph Hellwig wrote:
>> On Fri, May 16, 2008 at 02:57:32PM +1000, Lachlan McIlroy wrote:
>> > xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
>> > 
>> > We need a vfsmount pointer in xfs_dm_rdwr() but we are not
>> > provided with one and there's no way to get to it.  So add
>> > a m_vfsmount field to the xfs_mount structure and set it
>> > up at mount time.  We can then access it through the xfs
>> > inode.
>> 
>> Stong NACK for this crap, and double NACK for pushing this towards
>> mainline.
>
> No reply yet.  Folks, you realize this is an instant oops if you perform
> dmapi operations after one fs instance has been unmounted?

This is not going into mainline, but we need it in -dev to make sure we
can still QA DMAPI. We (I should be but flooded with other stuff) are
looking at other solutions to fix the issue the right way.

Cheers,
-- 
Niv Sardi
