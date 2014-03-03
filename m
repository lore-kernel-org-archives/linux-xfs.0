Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 568AA7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 06:16:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39635304032
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 04:16:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o695WONjz6bsJyi8 for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 04:16:26 -0800 (PST)
Date: Mon, 3 Mar 2014 13:16:20 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 5/8] xfstests: Add fallocate zero range operation to
	fsstress
In-Reply-To: <5310C9F8.20009@sandeen.net>
Message-ID: <alpine.LFD.2.00.1403031315280.2258@localhost.localdomain>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-5-git-send-email-lczerner@redhat.com>
	<5310C9F8.20009@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, 28 Feb 2014, Eric Sandeen wrote:

> Date: Fri, 28 Feb 2014 11:40:08 -0600
> From: Eric Sandeen <sandeen@sandeen.net>
> To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 5/8] xfstests: Add fallocate zero range operation to
>     fsstress
> 
> On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> > This commit adds fzero operation support for fsstress, which is meant to
> > exercise fallocate FALLOC_FL_ZERO_RANGE support.
> > 
> > Also reorganise the common fallocate code into a single do_fallocate()
> > function and use flags use the right mode.
> > 
> > Also in order to make more obvious which fallocate mode fsstress is
> > testing translate fallocate flags into human readable strings.
> 
> Can you enhance that so that if it's passed a flag which isn't
> in the known array, it prints the leftover values?  Otherwise
> they are silently dropped, which might be confusing.
> 
> Handling the case where a flag is not in the array would future-proof
> it, I think.
> 
> -Eric

Yes, I can do that. The only reason I've left this out was to force
people to actually update it when they update the test with new
flag.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
