Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7F647F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 08:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95387304051
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:38:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YKNDJcptJthbmjdM for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:38:21 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:09:42 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
In-Reply-To: <20140412151935.GA18047@infradead.org>
Message-ID: <alpine.LFD.2.00.1404151457550.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-2-git-send-email-lczerner@redhat.com>
	<20140412151935.GA18047@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sat, 12 Apr 2014, Christoph Hellwig wrote:

> Date: Sat, 12 Apr 2014 08:19:35 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append only
>      file
> 
> On Fri, Apr 11, 2014 at 08:57:43PM +0200, Lukas Czerner wrote:
> >  	/*
> > -	 * It's not possible to punch hole or perform collapse range
> > -	 * on append only file
> > +	 * It's not possible to punch hole, perform collapse range
> > +	 * or zero range on append only file
> >  	 */
> > -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> > +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
> > +		    FALLOC_FL_ZERO_RANGE)
> 
> Might be better to make this a negative test fo the operation that is
> allowed on an appen only file.  That's also much better future proof.
> 

True, it might be better to do it this way:

if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))

this makes FALLOC_FL_NO_HIDE_STALE (reserved, not implemented)
potentially not work on the append only file since it could change
the content of the file.

Will resend.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
