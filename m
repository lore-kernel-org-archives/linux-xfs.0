Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 680B829E0E
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:55:59 -0500 (CDT)
Message-ID: <523A135D.7030509@sgi.com>
Date: Wed, 18 Sep 2013 15:55:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: initialize filetype for lost+found creation
References: <52388C61.1000001@sandeen.net>
In-Reply-To: <52388C61.1000001@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 09/17/13 12:07, Eric Sandeen wrote:
> If we create lost+found make sure it's got the proper filetype.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> (sorry, untested, not sure how to force creation when I can't use
> xfs_db to craft a filesystem that needs lost+found)

The {lib}xfs_dir_lookup() doesn't use the field - just like extended 
attributes use xfs_names but it won't use the field entry, but it does 
not hurt to have it initialized to something.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
