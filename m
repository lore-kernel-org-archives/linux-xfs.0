Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 852847F53
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:07:30 -0600 (CST)
Date: Thu, 14 Feb 2013 16:07:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs_mkfs: Do not discard if '-N' is provided
Message-ID: <20130214220726.GI22182@sgi.com>
References: <1360683870-4874-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360683870-4874-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 12, 2013 at 04:44:30PM +0100, Lukas Czerner wrote:
> When '-N' is specified we really should not write anything to the
> device, neither we should attempt to discard the device.
> 
> This commit fixes xfs_mkfs to not attempt to discard the device in the
> case user specified '-N' flag.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Wow.  That's bad.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks Lukas!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
