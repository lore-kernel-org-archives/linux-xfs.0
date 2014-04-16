Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7898F7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:34:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BE2E8F8065
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:34:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GVsl9V3zpJtmpyIv for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:34:31 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:34:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] check: add support for an external test expunging file
Message-ID: <20140416003417.GZ15995@dastard>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
	<20140416001530.GU15995@dastard> <20140416002550.GB12078@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416002550.GB12078@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 08:25:50PM -0400, Theodore Ts'o wrote:
> On Wed, Apr 16, 2014 at 10:15:30AM +1000, Dave Chinner wrote:
> > > If the argument to the -X option is a pathname (that is, includes a
> > > '/' character), treat it as the latter case.  If it the argument to
> > > the -X option is just a bare filename (that is, does not include '/'
> > > character), treat it as the former.
> > 
> > Can you add a new option rather than overloading the existing one
> > with new meanings and semantics?
> 
> If that's your preference, sure.  How does --expunge-list-file strike
> you?  Or would you prefer something else?  I'm easy.  :-)

-E/--expunge-file is fine by me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
