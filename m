Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 541F27F80
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 18:04:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3365C8F8040
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 16:04:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RaL928Font9WruMv for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2015 16:03:56 -0700 (PDT)
Message-ID: <55722AD9.2080105@sandeen.net>
Date: Fri, 05 Jun 2015 18:03:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard>
In-Reply-To: <20150605222257.GY24666@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Ales Novak <alnovak@suse.cz>
Cc: xfs@oss.sgi.com

On 6/5/15 5:22 PM, Dave Chinner wrote:

> On Fri, Jun 05, 2015 at 03:28:45PM +0200, Ales Novak wrote:
>> However, this rule is only mentioned in the documentation, while it
>> could be checked during the mount.
> 
> Where in the documentation is that mentioned?

Documentation/filesystems/xfs.txt:

  logbsize=value
        Set the size of each in-memory log buffer.  The size may be
        specified in bytes, or in kilobytes with a "k" suffix.
        Valid sizes for version 1 and version 2 logs are 16384 (16k)
        and 32768 (32k).  Valid sizes for version 2 logs also
        include 65536 (64k), 131072 (128k) and 262144 (256k). The
        logbsize must be an integer multiple of the log
        stripe unit configured at mkfs time.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
