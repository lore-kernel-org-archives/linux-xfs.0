Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24F4KEj171923 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 09:04:20 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6986E157FF8B
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 07:07:10 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Vv9SznrQMl1XWBQ2 for <xfs@oss.sgi.com>;
	Fri, 04 Mar 2011 07:07:10 -0800 (PST)
Message-ID: <4D71001D.2040506@sandeen.net>
Date: Fri, 04 Mar 2011 09:07:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
References: <20110302175818.GA8290@schmorp.de>
In-Reply-To: <20110302175818.GA8290@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On 3/2/11 11:58 AM, Marc Lehmann wrote:
> Hi!
> 
> I had a case of filesystem corruption a day ago:
> 

...

> I tried to use xfs_repair on it, but it crashes (and, as I may grudgingly
> add, as usual it crashes because thats what xfsrepair does almost always).
 

If you provide an xfs_metadump image of the filesystem, I'd be
happy to look into the cause of the segfault.

In my experience xfs_repair does not almost always crash, if you
encounter this, please do send mail/file bugs/provide images.

> Any idea on where to go from here? I tried to build the git xfsprogs, but
> they don't build due to missing -fPIC - and as usual, thanks for any help :)

Bug reports on build problems are welcome as well.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
