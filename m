Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 08:39:16 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBGd894031048
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:39:10 -0800
Received: from nz-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F83FB30921
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:39:12 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.237]) by cuda.sgi.com with ESMTP id 71Iumilisj8860sl for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:39:12 -0800 (PST)
Received: by nz-out-0506.google.com with SMTP id x3so810090nzd
        for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:39:06 -0800 (PST)
Message-ID: <cc7060690712110839j46e0928bv4dae1d33bfe5d0dd@mail.gmail.com>
Date: Tue, 11 Dec 2007 22:09:05 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: Zero-copy Block IO with XFS
In-Reply-To: <475E76AB.705@mxtelecom.com>
MIME-Version: 1.0
References: <475E76AB.705@mxtelecom.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Hodgson <matthew@mxtelecom.com>
Cc: xfs@oss.sgi.com

On Dec 11, 2007 5:08 PM, Matthew Hodgson <matthew@mxtelecom.com> wrote:

> Hi all,
>
> I'm experimenting with using XFS with a network block device (DST), and
> have come up against the problem that when writing data to the network,
> it uses kernel_sendpage to hand the page presented at the BIO layer to
> the network stack.  It then completes the block IO request.


 Actually,  you can pass a sendpage  read actor which takes a reference on
the page
 which ensures valid page exists with you. As long as you have ref on the
page and
 no truncate to the same file, you can safely access the file.  Once NIC
sends the
 data over wire, you can do put_page. This should work. By the way, linux
sendfile
 does something similar to the above. Look into read actor of nfs server
sendfile
 usage.

-Cheers,
  Bhagi.

>
>
> The problem arises when XFS proceeds to then reuse that page before the
> NIC actually sends it.  Particularly if TX checksumming or TCP
> segmentation is being offloaded to the NIC, it seems that the NIC will
> try to access to page after the BIO request has returned, and so operate
> on stale data.  I assume the same problem might happen in the case of
> TCP retransmits or similar.  The motivation for using sendpage rather
> than sendmsg (or using sendpage on a copy of the original page) is to
> try to ensure speed by a zero-copy path through the subsystem.
>
> Is there any way at all in which XFS would be able to (theoretically)
> expose an API to allow an underlying block device to retain ownership of
> pages until it's done with them, so as to avoid a potentially needless
> copy?  Or is there another way of achieving this?
>
> thanks in advance,
>
> Matthew.
>
>
> --
> Matthew Hodgson <matthew@mxtelecom.com>
> Media & Systems Project Manager
> Tel: +44 (0) 845 666 7778
> http://www.mxtelecom.com
>
>
>


[[HTML alternate version deleted]]
