Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A49CB7F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:15:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84A2C304077
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:15:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GjqlwdsqGSX9vh1k for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:15:46 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:15:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] check: add support for an external test expunging file
Message-ID: <20140416001530.GU15995@dastard>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397530320-20579-1-git-send-email-tytso@mit.edu>
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

On Mon, Apr 14, 2014 at 10:52:00PM -0400, Theodore Ts'o wrote:
> Currently the -X option is intended to specify a set of expunging
> files which are stored in each test/* subdirectory.  As described in
> the commit description for 0b1e8abd4, in order to exclude the test
> generic/280, the -X option is used as follows:
> 
>     $ cat tests/generic/3.0-stable-avoid
>     280
>     $ sudo ./check -X 3.0-stable-avoid generic/280
> 
> However, it is sometimes useful to store the set of expunged tests in
> a single file, outside of tests/* subdirectories.  This commit allows
> the following:
> 
>     $ cat /root/conf/data_journal.exclude
>     generic/068
>     ext4/301
>     $ sudo ./check -X /root/conf/data_journal.exclude -g auto
> 
> If the argument to the -X option is a pathname (that is, includes a
> '/' character), treat it as the latter case.  If it the argument to
> the -X option is just a bare filename (that is, does not include '/'
> character), treat it as the former.

Can you add a new option rather than overloading the existing one
with new meanings and semantics?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
