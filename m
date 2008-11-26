Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ10m5a023348 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:00:49 -0600
Message-ID: <492C9FB9.3090204@sgi.com>
Date: Wed, 26 Nov 2008 12:00:41 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
In-Reply-To: <20081125081644.GA20644@infradead.org>
Reply-To: lachlan@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
>> There's a few branches there already:
>>
>> 'master'      This will contain all the latest xfs changes not yet pushed
>>                to mainline.
>> 'mainline'    This is vanilla mainline and will updated regularly.
>> 'for-linus'   Our staging branch for pull requests
>> 'xfs-dev'     This branch will contain KDB and other supporting code for
>>                development and should be identical to the old CVS tree.
>>
>> Feel free to start using it and let us know if you have any issues.
> 
> Any chance to have these as separate git trees instead of branches?
That was the original plan.  Not sure why that got changed.  If there is
good reason for it we can change it.

> 
> In either case, do you expect patches against the xfs-dev or the master
> tree?  It would also be useful if the trees and which one to be used
> could be documented on oss.sgi.com/projects/xfs or xfs.org.
We would prefer patches based on the master branch but patches can be
against the mainline, master or xfs-dev branches.  If a patch against
mainline or xfs-dev doesn't apply cleanly to the master branch we may
ask the author to rebase that patch against the master branch.  If a
patch to the master branch needs auxillary changes to files that only
exist in the xfs-dev branch (ie xfsidbg stuff) we may ask for an
additional patch from the author.

We'll update the docs, thanks for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
