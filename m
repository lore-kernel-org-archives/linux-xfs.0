Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 21:26:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N4QFEf021217
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:26:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E49B5191D374
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:27:25 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id bpUU2f1DxbRBb1Mz for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:27:25 -0700 (PDT)
Date: Wed, 23 Jul 2008 14:27:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080723042721.GI5947@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <4886A9A3.8090805@sandeen.net> <4886ADB6.5060109@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4886ADB6.5060109@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 02:04:06PM +1000, Mark Goodwin wrote:
>
> Eric Sandeen wrote:
>> Mark Goodwin wrote:
>> For general algorithm improvements... how do you write a new QA test for
>> "Use the inode tree for finding dirty inodes?"
>
> Case by case basis I guess. e.g. write a test that exercises or stresses
> the changed algorithm or functionality, especially corner cases
> (low space, full AGs, mem pressure, whatever).

Most of these corner cases are already covered by XFSQA.

> Performance regression testing
> is trickier - need access to suitable h/w and the historical data; so it's
> probably best run on dedicated h/w every night against the dev tree.

Performance regressions are something that generally are only
detected some time after the commit occurs - usually when it gets to
the wider community. Once again, it's an argument for further
distributing the QA load by committing quickly.

Indeed, in the case of regressions caused by commmunity
contributions, I think a bugzilla bug needs to be raised to
track it properly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
