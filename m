Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U4mHPN259397 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 22:48:18 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF1A6CDA17
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 20:47:36 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id l8WBDR65ZlFH3qMs for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2009 20:47:36 -0800 (PST)
Message-ID: <49828666.7040809@sandeen.net>
Date: Thu, 29 Jan 2009 23:47:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] enable possibility of ALL different atime mount options
References: <200901300322.02079.edvx1@systemanalysen.net>
	<4982854D.8000808@sandeen.net>
In-Reply-To: <4982854D.8000808@sandeen.net>
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
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Roland Eggner wrote:
>> Utako Kusaka has provided this patch
>> http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
>> It works for me GRACEFULLY with ALL different atime mount options: atime|noatime|relatime.
>> Note, the mount options are effective, not only accepted.
>> Prior to this patch, mount option atime has been ignored.
> 
> 
> 
>> Please put the patch to mainline, it would save worries for users, who need the traditional atime
>> bahavior.  Think of some corner cases for desktop usage.
>>
> 
> Which specific problem is this fixing for you?
> 
> you say that atime is ignored; but:

Sorry, I probably replied too quickly.  But I am still curious to know
what problem you are seeing that this patch fixes.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
