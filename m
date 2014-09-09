Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C0BD7F51
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:06:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59ECB8F8050
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:06:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	T7o6TtrQuPCrZplm for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:06:48 -0700 (PDT)
Date: Wed, 10 Sep 2014 08:06:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted files
Message-ID: <20140909220645.GH20518@dastard>
References: <540F1B01.3020700@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540F1B01.3020700@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 10:21:37AM -0500, Leslie Rhorer wrote:
> 
> Hello,
> 
> 	I have an issue with my primary RAID array.  I have 13T of data on
> the array, and I suffered a major array failure.  I was able to
> rebuild the array, but some data was lost.  Of course I have
> backups, so after running xfs_repair, I ran an rsync job to recover
> the lost data.  Most of it was recovered, but there are several
> files that cannot be read, deleted, or overwritten.  I have tried
> running xfs_repair several times, but any attempt to access these
> files continuously reports "cannot stat XXXXXXXX: Structure needs
> cleaning".  I don't need to try to recover the data directly, as it
> does reside on the backup, but I need to clear the file structure so
> I can write the files back to the filesystem.  How do I proceed?

Fristly, more infomration is required, namely versions and actual
error messages:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

dmesg, in particular, should tell use what the corruption being
encountered is when stat fails.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
