Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FA1C7F53
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:20:58 -0500 (CDT)
Date: Fri, 19 Jul 2013 15:20:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_metadump: manpage fix regarding frozen fs
Message-ID: <20130719202055.GH3572@sgi.com>
References: <51E4AD14.7080904@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51E4AD14.7080904@redhat.com>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

Hey Eric,

On Mon, Jul 15, 2013 at 09:16:52PM -0500, Eric Sandeen wrote:
> The xfs_metadump manpage states that metadump works
> on a frozen filesystem; it does not.  In fact, there is
> no way to detect a frozen filesystem, so we can't make it
> work, either.
> 
> So just remove this from the manpage; unmounted or RO
> mounted is what is enforced by xfs_metadump.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I gave this a try and it *seemed* to work fine on a frozen filesystem.
Can you provide a bit of detail about why xfs_metadump doesn't work on
frozen filesystems?  What am I missing?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
