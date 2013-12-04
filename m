Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BF887F3F
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 13:38:26 -0600 (CST)
Date: Wed, 4 Dec 2013 13:38:22 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_repair: suggest reboot after dangerous repair
Message-ID: <20131204193822.GU1935@sgi.com>
References: <52826206.3080106@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52826206.3080106@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 12, 2013 at 11:14:46AM -0600, Eric Sandeen wrote:
> If a "dangerous" repair (repair of a readonly mounted fs)
> has been done, suggest an immediate reboot upon completion.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> TBH, I don't know how "dangerous" dangerous is.  Is this
> still required?

Was there a crash or something after a repair that led to
this patch?

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
