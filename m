Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3CED7F37
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 17:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82CCD8F80AD
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 15:05:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UQ2wEGU29l6nXEqF for <linux-xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 15:05:02 -0700 (PDT)
Date: Wed, 17 Apr 2013 08:05:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair misses an fs error?
Message-ID: <20130416220526.GE13938@destitution>
References: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
	<20130416162557.GD13938@destitution>
	<6qi04axkbr.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6qi04axkbr.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Tue, Apr 16, 2013 at 11:44:54AM -0700, Keith Keller wrote:
> On 2013-04-16, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Not recently. What version of xfs_repair are you using?
> 
> Hmm, perhaps this is a difference.  I believe (though, again I did very
> poor logging, and I apologize) that the initial repair used 3.1.1.  The
> recent successful repair definitely used 3.1.10.  Is it possible 3.1.1
> is old enough that it might not have caught the issues I reported from
> the 3.1.10 log?

Yes - there have been problems like this fixed since 3.1.1...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
