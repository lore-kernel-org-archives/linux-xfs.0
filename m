Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 22:27:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2I5RjlB029324
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 22:27:50 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26A376B3603
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 22:28:17 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id juLOSQleaiEdCOHV for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 22:28:17 -0700 (PDT)
Date: Tue, 18 Mar 2008 01:28:16 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [RFC][PATCH 1/1] XFS: annotate all on-disk structures with
	__ondisk
Message-ID: <20080318052816.GF16500@josefsipek.net>
References: <20080317202853.GC16500@josefsipek.net> <1205800745-9217-1-git-send-email-jeffpc@josefsipek.net> <47DF3861.6020308@sandeen.net> <20080318040903.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318040903.GU155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, tes@sgi.com

On Tue, Mar 18, 2008 at 03:09:03PM +1100, David Chinner wrote:
> On Mon, Mar 17, 2008 at 10:34:57PM -0500, Eric Sandeen wrote:
> > Josef 'Jeff' Sipek wrote:
> > > Currently, the annotation just forces the structures to be packed, and
> > > 4-byte aligned.
> > 
> > Semantic nitpick: in my definition of "annotation" this is more than
> > just an annotation.
> > 
> > An "__ondisk" annotation, to me, would allow something like sparse to
> > verify properly laid out on-disk structures, but would not affect the
> > actual runtime code - I think that would be quite useful.  However, this
> >  change actually impacts the bytecode; it is a functional change.
> 
> Yup - this isn't "annotation"....
 
Ok. I'll redo the comment for the next version of the patch :)

...
> I think you iterated my concerns quite well, Eric.
> 
> The thing I want to see for any sort of change like this is output off all
> the structures and their alignment before the change and their alignment
> after the change. On all supported arches. 'pahole' is the tool you used
> for that, wasn't it, Eric?
 
Ok, next one will include pahole output. (And yes, pahole is the tool Eric
used.)

> The only arch I would expect to see a change in the structures is on ARM; if
> there's anything other than that there there's something wrong. This is going
> to require a lot of validation to ensure that it is correct.....
> 
> Not to mention performance testing on ia64 given the added overhead in
> critical paths.....

Agreed on both accounts.

Josef 'Jeff' Sipek.

-- 
Intellectuals solve problems; geniuses prevent them
		- Albert Einstein
