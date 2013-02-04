Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B55C07F58
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 14:51:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83367304051
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 12:51:39 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	8Wgrbw3JN7HmioiD for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 12:51:38 -0800 (PST)
Date: Mon, 4 Feb 2013 12:51:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
	non page aligned ranges
Message-Id: <20130204125136.b0926f20.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1302041510090.3225@localhost>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
	<1359715424-32318-11-git-send-email-lczerner@redhat.com>
	<20130201151502.59398b29.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1302041510090.3225@localhost>
Mime-Version: 1.0
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
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, 4 Feb 2013 15:51:19 +0100 (CET)
Luk____ Czerner <lczerner@redhat.com> wrote:

> I hope I explained myself well enough :). Are you ok with this king
> of approach ? If so, I'll resend the patch set without the
> initialisation-at-declaration.

uh, maybe.  Next time I'll apply the patch and look at the end result! 
Try to make it as understandable and (hence) maintainable as possible,
OK?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
