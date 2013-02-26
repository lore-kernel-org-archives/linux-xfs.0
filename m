Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DD177CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 09:31:03 -0600 (CST)
Message-ID: <512CD577.9090505@sgi.com>
Date: Tue, 26 Feb 2013 09:32:07 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 V2] xfstests: 297: Test that FS sends discard requests
	only on free blocks
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
	<1359886798-8818-3-git-send-email-tracek@redhat.com>
In-Reply-To: <1359886798-8818-3-git-send-email-tracek@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On 02/03/2013 04:19 AM, Tomas Racek wrote:
> V1->V2: Change way of testing suggested by Dave Chinner
> 1. Create image file with FS on it
> 2. Call fstrim to discard free blocks
> 3. Check that every punched hole in the image file is in the area
>     that is marked as free
>
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Looks good.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
