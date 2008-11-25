Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPLh69K008811 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 15:43:06 -0600
Message-ID: <492C7160.80208@sgi.com>
Date: Wed, 26 Nov 2008 08:42:56 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com>
In-Reply-To: <492C0B3D.3040002@thebarn.com>
Reply-To: markgw@sgi.com
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com



Russell Cattelan wrote:
> Christoph Hellwig wrote:
>> On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
>>
>>> There's a few branches there already:
>>>
>>> 'master'      This will contain all the latest xfs changes not yet pushed
>>>                to mainline.
>>> 'mainline'    This is vanilla mainline and will updated regularly.
>>> 'for-linus'   Our staging branch for pull requests
>>> 'xfs-dev'     This branch will contain KDB and other supporting code for
>>>                development and should be identical to the old CVS tree.
>>>
>>> Feel free to start using it and let us know if you have any issues.
>>>
>> Any chance to have these as separate git trees instead of branches?

Why? Is it just a bandwidth issue with the initial clone, or some
other reason?

>> In either case, do you expect patches against the xfs-dev or the master
>> tree?

I'll let Lachlan reply to that, but normally master I think. One thing that
is important is that any commit against the xfs-dev tree should split out
kdb and dmapi changes into separate commits from changes to fs/xfs.

>  It would also be useful if the trees and which one to be used
>> could be documented on oss.sgi.com/projects/xfs or xfs.org.

yes certainly.

> Specifically this page please.
> http://xfs.org/index.php/Getting_the_latest_source_code

Been waiting for the WIKI on oss to be set up - these two sites
can simply mirror each other I guess for some or all documentation.

> Maybe add a quick tutorial on git branches and how to create tracking
> branches for this tree.

Yes that's a good idea: git remote add ....

> Also can we have something other than "unnamed repository" in the
> description file?

Yep. Niv, can you fix that up please.

> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Russell, would it be possible somehow for this footer to include the URL
of the archive reference for the message containing it?

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
