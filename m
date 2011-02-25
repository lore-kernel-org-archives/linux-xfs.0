Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PKj5Lw222209 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 14:45:05 -0600
Subject: Re: [PATCH 1/2] xfstests: fix fiemap-tester for fewer extents returned
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D66D55E.8070209@redhat.com>
References: <4D66D55E.8070209@redhat.com>
Date: Fri, 25 Feb 2011 14:47:47 -0600
Message-ID: <1298666867.1990.7113.camel@doink>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, 2011-02-24 at 16:02 -0600, Eric Sandeen wrote:
> If the fiemap call returns fewer extents than asked for,
> the fiemap tester gets confused.  If this happens, advance,
> and call fiemap again for the next offset.
> 
> XFS exposed this because if a file is all-delalloc, it was
> only returning 1 mapped extent (this is probably also a buglet).

Looks good.  I presume you mean we should get back
an array of delalloc extents, right?  I started
looking at why only one is returned but haven't
found it yet.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
