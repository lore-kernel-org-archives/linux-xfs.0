Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAONM7LF176214 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 17:22:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18659B26F7
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 15:22:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3pcMhhrZCgXTOJuF for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 15:22:33 -0800 (PST)
Message-ID: <4B0C6AB6.60900@sandeen.net>
Date: Tue, 24 Nov 2009 17:22:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Any on-disk format changes recently?
References: <4B0C2E46.1040509@shiftmail.org>
In-Reply-To: <4B0C2E46.1040509@shiftmail.org>
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
To: Asdo <asdo@shiftmail.org>
Cc: xfs@oss.sgi.com

Asdo wrote:
> Dear XFS people
> I am tracking a nasty bug for which I would need to regress the kernel 
> version from 2.6.31 down to 2.6.28 or maybe even 2.6.24.
> I have to do this on an important fileserver full of important data on 
> XFS filesystems which were created on 2.6.31.
> I also need to *write* to the XFS filesystems after regressing the kernel.
> Do you see any problems with this? Have there been on-disk format 
> changes for XFS since 2.6.24 that could trigger data loss? (or with much 
> minor concern, fail the mount?)

Nothing about the xfs disk format should cause problems when bouncing
between .24 and .31

-Eric

> Thank you
> Asdo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
