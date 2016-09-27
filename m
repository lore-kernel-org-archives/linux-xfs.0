Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF4F17CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 16:41:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B48578F8035
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 14:41:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MRQQRQlIC5eL2qBA for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2016 14:41:32 -0700 (PDT)
Date: Wed, 28 Sep 2016 07:41:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
Message-ID: <20160927214129.GC27872@dastard>
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
	<20160927170443.GR9314@birch.djwong.org>
	<CAOSFFyhP251ifYzWtRfcStxX7oy78EDvqWfi0=2h4GhTv4=pJw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOSFFyhP251ifYzWtRfcStxX7oy78EDvqWfi0=2h4GhTv4=pJw@mail.gmail.com>
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
To: murali krishna <murali.marimekala@gmail.com>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Sep 27, 2016 at 01:27:12PM -0400, murali krishna wrote:
> Hi Darrick,
> 
> Thanks for the response.
> 
> Could you please clarify if there is any strong reason behind in stating to
> use xfs_metadump and xfs_mdrestore as just debugging tools in their
> respective man pages ?

The man page is simply stating the truth - metadump/restore are
debugging tools used by XFS developers for obtaining information
required for forensic analysis of filesystem failures.

What you are wanting to do will not work, is not supported, and you
get to keep all the broken bits to yourself if you try it.
Every XFS developer you ask will say the same thing:
xfsdump/encrypt/mkfs/xfs_restore is the only way to do what you want
to do.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
