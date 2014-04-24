Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 330847F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 11:55:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1AE42304043
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 09:55:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DHXhQVBqqpoWEHZP for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 09:55:42 -0700 (PDT)
Message-ID: <5359420F.3020406@sandeen.net>
Date: Thu, 24 Apr 2014 11:55:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Use _require_xfs_io_command() instead of helpers
References: <1398355303-29348-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1398355303-29348-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On 4/24/14, 11:01 AM, Lukas Czerner wrote:
> Number of helpers for checking xfs_io functionality is slowly growing.
> But it's as easy to simply use _require_xfs_io_command() directly and
> just specify the command we want to check. It will also avoid the need
> to create helper every time we need to check a new command in xfs_io.
> 
> Remove all the helpers and use _require_xfs_io_command() in the tests.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I like it.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
