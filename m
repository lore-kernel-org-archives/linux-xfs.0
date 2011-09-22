Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MKxGnm259222 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 15:59:16 -0500
Subject: Re: [PATCH 2/2 v2][xfstests] fstrim: Use strtoull instead of strtoul
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315410523-23925-2-git-send-email-lczerner@redhat.com>
References: <1315410523-23925-1-git-send-email-lczerner@redhat.com>
	<1315410523-23925-2-git-send-email-lczerner@redhat.com>
Date: Thu, 22 Sep 2011 15:59:14 -0500
Message-ID: <1316725154.2009.80.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-09-07 at 17:48 +0200, Lukas Czerner wrote:
> When we are parsing input arguments we should really use stroull to get
> unsigned long long numbers, since this is what we can specify on the
> command line. With this fix it should parse long numbers on the 32 bit
> architecture correctly.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

This looks good, and it can be applied independent of the
first patch in this series.  (And at this point I plan to
commit this first rather than wait.)

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
