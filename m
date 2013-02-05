Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4C707F73
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 01:15:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2D95304053
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 23:15:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zA0b20CnHJmUNgrQ for
	<xfs@oss.sgi.com>; Mon, 04 Feb 2013 23:15:00 -0800 (PST)
Date: Tue, 5 Feb 2013 08:14:51 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
	non page aligned ranges
In-Reply-To: <20130204125136.b0926f20.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1302050814250.3225@localhost>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
	<1359715424-32318-11-git-send-email-lczerner@redhat.com>
	<20130201151502.59398b29.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1302041510090.3225@localhost>
	<20130204125136.b0926f20.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1464879651-1360048494=:3225"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1464879651-1360048494=:3225
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 4 Feb 2013, Andrew Morton wrote:

> Date: Mon, 4 Feb 2013 12:51:36 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     xfs@oss.sgi.com, Hugh Dickins <hughd@google.com>
> Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
>     non page aligned ranges
> 
> On Mon, 4 Feb 2013 15:51:19 +0100 (CET)
> Luk____ Czerner <lczerner@redhat.com> wrote:
> 
> > I hope I explained myself well enough :). Are you ok with this king
> > of approach ? If so, I'll resend the patch set without the
> > initialisation-at-declaration.
> 
> uh, maybe.  Next time I'll apply the patch and look at the end result! 
> Try to make it as understandable and (hence) maintainable as possible,
> OK?

Agreed.

Thanks!
-Lukas
--571107329-1464879651-1360048494=:3225
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--571107329-1464879651-1360048494=:3225--
