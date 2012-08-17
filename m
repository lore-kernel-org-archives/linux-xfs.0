Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HKYnnZ093689 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 15:34:49 -0500
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id oHojFqrgxF0hYiEO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 13:34:48 -0700 (PDT)
Date: Fri, 17 Aug 2012 16:34:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120817203438.GA573@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060110.GA28786@localhost>
	<20120817131558.GA11439@thunk.org>
	<20120817174841.GA4519@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817174841.GA4519@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 hackers <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Aug 17, 2012 at 01:48:41PM -0400, Christoph Hellwig wrote:
> 
> Can you submit this for xfstests?
> 

This is actually something I wanted to ask you guys about.  There are
a series of ext4-specific tests that I could potentially add, but I
wasn't sure how welcome they would be in xfstests.  Assuming that
ext4-specific tests would be welcome, is there a number range for
these ext4-specific tests that I should use?

BTW, we have an extension to xfstests that we've been using inside
Google where Google-internal tests have a "g" prefix (i.e., g001,
g002, etc.).  That way we didn't need to worry about conflicts between
newly added upstream xfstests, and ones which were added internally.
Would it make sense to start using some kind of prefix such as "e001"
for ext2/3/4 specific tests?

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
