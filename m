Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47EF429DF8
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 13:33:15 -0600 (CST)
Date: Thu, 19 Dec 2013 13:33:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] Userspace and xfstests releases
Message-ID: <20131219193314.GX1935@sgi.com>
References: <52B06E51.1020504@sgi.com>
 <52B32CE0.5070701@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B32CE0.5070701@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Rich,

On Thu, Dec 19, 2013 at 11:29:04AM -0600, Rich Johnston wrote:
> On 12/17/2013 09:31 AM, Rich Johnston wrote:
> >I was planning on a xfsdump and xfstests release this week before I go
> >on vacation. Any objections?
> Currently xfstests is not released, should this be changed?
> 
> I will wait until I return on Jan 2 to release xfsprogs.
> 
> >
> >Release versions for xfsprogs are still being discussed. Are there any
> >more comments on this subject?
> Here is one of the threads discussing this.
> 
> http://oss.sgi.com/archives/xfs/2013-10/msg00421.html
> Christoph were you saying you create xfsprogs branches?
> 
> Is there a consensus on version names/branches for xfsprogs?

I suggest a branch directly off of 3.1.11 release, and then we can troll the
log between refs/tags/3.1.11 and master for bugfixes.

e.g. git checkout -b for-3.1.12 refs/tags/3.1.11

And then push it up to oss.

Just my 2c.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
