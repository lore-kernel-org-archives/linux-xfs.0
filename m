Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QHEuxo244975 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 12:14:56 -0500
Message-ID: <508AC5DA.2080502@sgi.com>
Date: Fri, 26 Oct 2012 12:18:18 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests 224: test aio hole-fill at 4g
References: <4B633F9A.8000404@sandeen.net>
In-Reply-To: <4B633F9A.8000404@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 01/29/2010 02:05 PM, Eric Sandeen wrote:
> Testcase from Giel de Nijs <giel@vectorwise.com>
> on linux-ext4 list, ""Possible ext4 data corruption
> with large files and async I/O," on 29 Jan 2010
>
> ext4 put byte offsets in a block offset u32 container
> in the endio struct, so 4g wrapped to 0 leading to
> data corruption when the unwritten extent did not
> get converted.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> ---

Hey Eric

Just going through the list trying to clean it up.  Is this patch still 
valid or does one of the other hole tests cover this?

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
