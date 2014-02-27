Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E5C3E7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:00:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C73858F8073
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:00:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kKuJ3j7Ksius3TUs for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:00:36 -0800 (PST)
Date: Thu, 27 Feb 2014 10:00:05 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
	FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20140227090005.GH32036@x2.net.home>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
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
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Tue, Feb 25, 2014 at 08:08:25PM +0100, Dongsu Park wrote:
> Introduce a new option -c (or --collapse-range) to support a new flag
> FALLOC_FL_COLLAPSE_RANGE for fallocate(2). It will nullify a particular
> range [offset, offset+len] by shifting extents beyond the range to the
> beginning of the hole.
 
 Thanks!

> To test that, it's necessary to apply kernel patches in the patchset
 
 We (util-linux) always waiting for new stuff in Linus tree :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
